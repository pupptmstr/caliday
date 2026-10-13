#!/usr/bin/env python3
"""Goro's art for the native home-screen widgets.

    python3 tools/characters/export_widget_art.py [--chrome PATH] [--size PX]

The native widgets cannot draw the app's SVGs, so this renders Goro's faces
(the moods of the Goro widget), his fun poses (the pose of the day) and the
flex pose (after a workout) to PNG with headless Chrome: the blue tile of each
file left out (the widget draws its own background), cropped to the figure as
a square with a little air, transparent round it. It writes

    ios/TreniDayWidget/Assets.xcassets/<name>.imageset/<name>.png
    android/app/src/main/res/drawable-nodpi/<name>.png

Run it again after redrawing any of them (`gen_goro.py` writes the poses; the
faces and the flex pose are the designer's files). The names are the ones
`WidgetState.swift` and `WidgetState.kt` ask for.
"""

import argparse
import json
import pathlib
import re
import subprocess
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[2]
GORO = ROOT / 'assets' / 'goro'
IOS = ROOT / 'ios' / 'TreniDayWidget' / 'Assets.xcassets'
ANDROID = ROOT / 'android' / 'app' / 'src' / 'main' / 'res' / 'drawable-nodpi'
CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'

# Widget image name → the app's SVG.
ART = {
    **{f'goro_face_{m}': f'goro_face_{m}.svg'
       for m in ('happy', 'sad', 'angry', 'sleeping', 'supportive')},
    **{f'goro_pose_{p}': f'goro_pose_{p}.svg'
       for p in ('one_arm_handstand', 'flag', 'one_arm_pullup', 'barbell', 'lotus', 'banana')},
    'goro_flex': 'goro_flex_v2.svg',
}

PAGE = '''<!doctype html><html><head><style>
html,body{margin:0;background:transparent;overflow:hidden}
svg{width:1024px;height:1024px;display:block}
</style></head><body>%(svg)s<script>
// The box of what is drawn (at 1 px per unit): every shape with an area, so
// an empty placeholder path ("M0,0") does not pull the box to the corner.
const svg = document.querySelector('svg');
const o = svg.getBoundingClientRect();
let x0 = 1e9, y0 = 1e9, x1 = -1e9, y1 = -1e9;
for (const el of svg.querySelectorAll('path,rect,circle,ellipse,polygon,polyline,line,text,use')) {
  if (el.closest('defs')) continue;
  const r = el.getBoundingClientRect();
  if (r.width * r.height < 4) continue;
  x0 = Math.min(x0, r.left - o.left); y0 = Math.min(y0, r.top - o.top);
  x1 = Math.max(x1, r.right - o.left); y1 = Math.max(y1, r.bottom - o.top);
}
const side = Math.max(x1 - x0, y1 - y0) * 1.04;
svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');
svg.setAttribute('viewBox',
  `${(x0 + x1) / 2 - side / 2} ${(y0 + y1) / 2 - side / 2} ${side} ${side}`);
svg.style.width = svg.style.height = '%(size)dpx';
</script></body></html>'''


def cutout(path):
    """The SVG without its tile: the rounded square and the glow behind Goro."""
    s = path.read_text(encoding='utf-8')
    s = re.sub(r'<rect[^>]*fill="url\(#bgGrad\)"[^>]*/>', '', s)
    s = re.sub(r'<circle[^>]*fill="url\(#glow\)"[^>]*/>', '', s)
    return re.sub(r'(<svg[^>]*?)\swidth="1024" height="1024"', r'\1', s, count=1)


def render(chrome, svg, size, out):
    with tempfile.TemporaryDirectory() as tmp:
        page = pathlib.Path(tmp) / 'art.html'
        page.write_text(PAGE % {'size': size, 'svg': svg}, encoding='utf-8')
        subprocess.run(
            [chrome, '--headless=new', '--disable-gpu', '--hide-scrollbars',
             '--default-background-color=00000000', '--force-device-scale-factor=1',
             f'--window-size={size},{size}', '--virtual-time-budget=2000',
             f'--screenshot={out}', page.as_uri()],
            capture_output=True, check=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--chrome', default=CHROME)
    ap.add_argument('--size', type=int, default=384,
                    help='pixels of the square (384 = the large widget\'s 128 pt at @3x)')
    args = ap.parse_args()
    ANDROID.mkdir(parents=True, exist_ok=True)
    for name, source in ART.items():
        png = ANDROID / f'{name}.png'
        render(args.chrome, cutout(GORO / source), args.size, png)
        imageset = IOS / f'{name}.imageset'
        imageset.mkdir(exist_ok=True)
        (imageset / f'{name}.png').write_bytes(png.read_bytes())
        (imageset / 'Contents.json').write_text(json.dumps({
            'images': [{'filename': f'{name}.png', 'idiom': 'universal'}],
            'info': {'author': 'xcode', 'version': 1},
        }, indent=2) + '\n')
        print(f'{name}: {png.stat().st_size // 1024} KB')


if __name__ == '__main__':
    main()
