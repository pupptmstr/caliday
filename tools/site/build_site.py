#!/usr/bin/env python3
"""Assemble the TreniDay landing page (`site/`) into a folder ready to serve.

    python3 tools/site/build_site.py OUT_DIR [--url https://example.org/]

`site/template.html` is rendered once per language in `site/strings/`
(`{{key}}` → the string, HTML-escaped): English at the root, the others in
`<code>/`. The app's languages are the site's languages — a new ARB file in
`l10n/` wants a `site/strings/<code>.json` with the same keys as `en.json`
(the build fails on a missing key). The script also adds what the site
shares with the app instead of keeping copies of it: the characters' SVGs,
a few exercise animations with their crops, the icons and the favicon; and
it writes `sitemap.xml`. The public address goes in with `--url`, so a
custom domain is one argument away.

CI (`.github/workflows/web.yml`) runs it into `_site/`, next to the legal
docs and the web app in `_site/app/`. Locally:

    python3 tools/site/build_site.py build/site_preview

and the `treniday-site` server of `.claude/launch.json` serves that folder
(the app link points at `app/`, which only the deployed site has).
"""

import argparse
import html
import json
import re
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SITE = ROOT / 'site'
ASSETS = ROOT / 'assets'
CROPS = ROOT / 'lib' / 'data' / 'static' / 'animation_crops.dart'

# The public address of the landing page (GitHub Pages of pupptmstr/treniday).
DEFAULT_URL = 'https://pupptmstr.github.io/treniday/'

# The page languages in menu order; the first one lives at the root.
LANGS = ['en', 'ru', 'de', 'es']

# Files of site/ that are sources, not output.
SOURCES = {'template.html', 'strings'}

# Art the pages show, copied as is from assets/ into img/.
ART = [
    'goro/goro_face_happy.svg',
    'goro/goro_idle_v2.svg',
    'goro/goro_flex_v2.svg',
    'goro/goro_pose_one_arm_handstand.svg',
    'hosts/raffi_idle.svg',
    'hosts/miso_idle.svg',
    'hosts/aurora_idle.svg',
    'hosts/luna_idle.svg',
    'skala/skala_neutral.svg',
]

# Exercise animations played on the page (lottie-web, see site/site.js).
ANIMATIONS = [
    'push_s3_full_pushup',
    'pull_s3_pullup',
    'bal_s6_free_hs',
    'yoga_standing_s3_warrior_2',
    'cardio_s3_squat_jumps',
    'evening_hips_s4_butterfly',
    'core_s2_plank',
]

PLACEHOLDER = re.compile(r'\{\{(\w+)\}\}')


def lang_path(code: str) -> str:
    return '' if code == LANGS[0] else f'{code}/'


def load_strings() -> dict[str, dict[str, str]]:
    strings = {code: json.loads((SITE / 'strings' / f'{code}.json').read_text(encoding='utf-8'))
               for code in LANGS}
    reference = set(strings[LANGS[0]])
    for code, table in strings.items():
        missing = reference - set(table)
        extra = set(table) - reference
        if missing or extra:
            sys.exit(f'site/strings/{code}.json: missing {sorted(missing)}, extra {sorted(extra)}')
    return strings


def json_ld(code: str, s: dict[str, str], url: str) -> str:
    page = url + lang_path(code)
    data = [
        {
            '@context': 'https://schema.org',
            '@type': 'WebSite',
            'name': 'TreniDay',
            'url': url,
            'inLanguage': code,
        },
        {
            '@context': 'https://schema.org',
            '@type': 'SoftwareApplication',
            'name': 'TreniDay',
            'url': page,
            'description': s['app_desc'],
            'applicationCategory': 'HealthApplication',
            'applicationSubCategory': 'Fitness',
            'operatingSystem': 'Web, iOS, Android',
            'inLanguage': LANGS,
            'image': url + 'img/icon.png',
            'isAccessibleForFree': True,
            'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'},
            'sameAs': ['https://github.com/pupptmstr/treniday'],
        },
    ]
    return json.dumps(data, ensure_ascii=False, indent=2).replace('</', '<\\/')


def render(code: str, strings: dict[str, dict[str, str]], url: str) -> str:
    s = strings[code]
    base = '' if code == LANGS[0] else '../'
    hreflang = [f'<link rel="alternate" hreflang="{c}" href="{url}{lang_path(c)}">' for c in LANGS]
    hreflang.append(f'<link rel="alternate" hreflang="x-default" href="{url}">')
    menu = []
    for c in LANGS:
        href = (base + lang_path(c)) or './'
        current = ' aria-current="page"' if c == code else ''
        menu.append(f'            <li><a href="{href}" hreflang="{c}" lang="{c}"{current}>'
                    f'{html.escape(strings[c]["lang_name"])}</a></li>')

    values = {k: html.escape(v) for k, v in s.items()}
    values.update({
        'lang': code,
        'base': base,
        'page_url': url + lang_path(code),
        'app_url': base + 'app/',
        'hreflang': '\n'.join(hreflang),
        'lang_menu': '\n'.join(menu),
        'jsonld': json_ld(code, s, url),
    })

    template = (SITE / 'template.html').read_text(encoding='utf-8')
    unknown = sorted(set(PLACEHOLDER.findall(template)) - set(values))
    if unknown:
        sys.exit(f'site/template.html: no string for {unknown}')
    page = PLACEHOLDER.sub(lambda m: values[m.group(1)], template)
    return page.replace('%SITE_URL%', url)


def sitemap(url: str) -> str:
    alternates = ''.join(
        f'\n    <xhtml:link rel="alternate" hreflang="{c}" href="{url}{lang_path(c)}"/>' for c in LANGS)
    entries = ''.join(f'\n  <url>\n    <loc>{url}{lang_path(c)}</loc>{alternates}\n  </url>' for c in LANGS)
    return ('<?xml version="1.0" encoding="UTF-8"?>\n'
            '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" '
            f'xmlns:xhtml="http://www.w3.org/1999/xhtml">{entries}\n</urlset>\n')


def crops() -> dict[str, list[int]]:
    found = {m.group(1): [int(m.group(2)), int(m.group(3)), int(m.group(4)), int(m.group(4))]
             for m in re.finditer(r"'assets/animations/(\w+)\.json': \((-?\d+), (-?\d+), (\d+)\)",
                                  CROPS.read_text(encoding='utf-8'))}
    missing = [a for a in ANIMATIONS if a not in found]
    if missing:
        sys.exit(f'{CROPS.relative_to(ROOT)}: no crop for {missing} (run tools/lottie/thumb_crops.py)')
    return {a: found[a] for a in ANIMATIONS}


def build(out: Path, url: str) -> None:
    if not url.endswith('/'):
        url += '/'
    out.mkdir(parents=True, exist_ok=True)
    # Written into an existing folder without clearing it: in CI `_site/`
    # already holds the legal docs.
    for src in SITE.rglob('*'):
        rel = src.relative_to(SITE)
        if src.is_dir() or rel.parts[0] in SOURCES:
            continue
        dst = out / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)

    strings = load_strings()
    for code in LANGS:
        page = out / lang_path(code) / 'index.html'
        page.parent.mkdir(parents=True, exist_ok=True)
        page.write_text(render(code, strings, url), encoding='utf-8')
    (out / 'sitemap.xml').write_text(sitemap(url), encoding='utf-8')

    img = out / 'img'
    img.mkdir(exist_ok=True)
    for rel in ART:
        shutil.copy2(ASSETS / rel, img / Path(rel).name)
    shutil.copy2(ASSETS / 'icon' / 'icon.png', img / 'icon.png')
    shutil.copy2(ROOT / 'web' / 'icons' / 'Icon-192.png', img / 'icon-192.png')
    shutil.copy2(ROOT / 'web' / 'favicon.png', out / 'favicon.png')

    anim = out / 'anim'
    anim.mkdir(exist_ok=True)
    for name in ANIMATIONS:
        shutil.copy2(ASSETS / 'animations' / f'{name}.json', anim / f'{name}.json')
    (anim / 'crops.json').write_text(json.dumps(crops()), encoding='utf-8')


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('out', type=Path, help='folder to write the site into')
    ap.add_argument('--url', default=DEFAULT_URL, help='public address of the site')
    args = ap.parse_args()
    build(args.out, args.url)
    print(f'site → {args.out}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
