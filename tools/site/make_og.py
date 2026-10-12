#!/usr/bin/env python3
"""Draw the link-preview cards of the landing page: site/og-<lang>.png.

    python3 tools/site/make_og.py [--chrome PATH]

One 1200 × 630 card per language in site/strings/ (the image a messenger or
a search result shows next to a link): the hero gradient, Goro's face, the
name and the page's tagline. Rendered by headless Chrome from a page this
script writes into a temporary folder. Run it again after changing a
tagline or adding a language.
"""

import argparse
import html
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SITE = ROOT / 'site'
CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'

CARD = """<!doctype html>
<html><head><meta charset="utf-8"><style>
html, body {{ margin: 0; width: 1200px; height: 630px; overflow: hidden; }}
body {{
  font-family: -apple-system, BlinkMacSystemFont, "SF Pro Display", "Segoe UI", Roboto, sans-serif;
  background: linear-gradient(135deg, #4DA6FF 0%, #1A5FA8 100%); color: #fff;
  display: flex; align-items: center; gap: 64px; padding: 0 80px; box-sizing: border-box;
  position: relative;
}}
body::before {{
  content: ""; position: absolute; width: 760px; height: 760px; right: -220px; top: -260px; border-radius: 50%;
  background: radial-gradient(circle, rgba(255,255,255,.18), rgba(255,255,255,0) 70%);
}}
.face {{ width: 380px; height: 380px; border-radius: 96px; flex: none; box-shadow: 0 24px 60px rgba(8, 36, 84, .35); position: relative; }}
h1 {{ margin: 0; font-size: 112px; font-weight: 900; letter-spacing: -3px; line-height: 1; }}
p {{ margin: 22px 0 0; font-size: 44px; font-weight: 800; line-height: 1.15; max-width: 620px; }}
.chips {{ display: flex; gap: 12px; margin-top: 34px; flex-wrap: wrap; }}
.chip {{ padding: 10px 18px; border-radius: 18px; font-size: 24px; font-weight: 800;
  background: rgba(255,255,255,.16); border: 2px solid rgba(255,255,255,.3); }}
</style></head><body>
<img class="face" src="{face}">
<div style="position:relative">
  <h1>CaliDay</h1>
  <p>{tagline}</p>
  <div class="chips"><span class="chip">{free}</span><span class="chip">{noads}</span><span class="chip">{noaccount}</span></div>
</div>
</body></html>
"""


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    ap.add_argument('--chrome', default=CHROME)
    args = ap.parse_args()
    face = (ROOT / 'assets' / 'goro' / 'goro_face_happy.svg').as_uri()
    with tempfile.TemporaryDirectory() as tmp:
        for strings in sorted((SITE / 'strings').glob('*.json')):
            code = strings.stem
            s = json.loads(strings.read_text(encoding='utf-8'))
            page = Path(tmp) / f'og-{code}.html'
            page.write_text(CARD.format(
                face=face,
                tagline=html.escape(s['tagline']),
                free=html.escape(s['chip_free']),
                noads=html.escape(s['chip_noads']),
                noaccount=html.escape(s['chip_noaccount']),
            ), encoding='utf-8')
            out = SITE / f'og-{code}.png'
            subprocess.run([
                args.chrome, '--headless=new', '--hide-scrollbars', '--force-device-scale-factor=1',
                '--window-size=1200,630', f'--screenshot={out}', '--allow-file-access-from-files',
                page.as_uri(),
            ], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            print(f'{out.relative_to(ROOT)}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
