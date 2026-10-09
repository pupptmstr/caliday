#!/usr/bin/env python3
"""Contact sheet of Lottie frames as inline SVG, to look at poses frame by
frame without a player (no dependencies).

Usage: python3 tools/lottie/frame_sheet.py OUT.html [--count N | --every N |
       --at 0,12,30] [--size PX] [--crop X,Y,W,H] FILE.json ...

Draws what the generated files contain: shape layers of groups with rect /
ellipse + fill, linear keyframes on position / rotation / scale / opacity
(designer files with paths are not drawn). Write OUT under build/ and open it
through the ``lottie-sheets`` server of .claude/launch.json
(http://localhost:8098/<file>); ``--crop`` zooms into a part of the 400x400
canvas.
"""
import json
import math
import os
import sys


def sample(prop, t):
    if not prop.get('a'):
        return prop['k']
    ks = prop['k']
    if t <= ks[0]['t']:
        return ks[0]['s']
    for a, b in zip(ks, ks[1:]):
        if a['t'] <= t <= b['t']:
            u = (t - a['t']) / ((b['t'] - a['t']) or 1)
            return [x + (y - x) * u for x, y in zip(a['s'], b['s'])]
    return ks[-1]['s']


def col(c):
    return 'rgb(%d,%d,%d)' % tuple(int(255 * v) for v in c[:3])


def group_svg(g):
    shape = next(i for i in g['it'] if i['ty'] in ('rc', 'el', 'gr'))
    fill = next((i for i in g['it'] if i['ty'] == 'fl'), None)
    if shape['ty'] == 'gr':
        return ''.join(group_svg(x) for x in reversed(g['it']) if x['ty'] == 'gr')
    if fill is None:
        # farm style: several shapes + one fill
        fill = g['it'][-2]
    c = col(fill['c']['k'])
    out = []
    for it in g['it']:
        if it['ty'] == 'rc':
            w, h = it['s']['k']
            x, y = it['p']['k']
            r = it['r']['k']
            out.append(f'<rect x="{x - w / 2:.1f}" y="{y - h / 2:.1f}" width="{w}" height="{h}" rx="{min(r, w / 2, h / 2)}" fill="{c}"/>')
        elif it['ty'] == 'el':
            w, h = it['s']['k']
            x, y = it['p']['k']
            out.append(f'<ellipse cx="{x}" cy="{y}" rx="{w / 2}" ry="{h / 2}" fill="{c}"/>')
    return ''.join(reversed(out))


def frame_svg(data, t, size, crop=(0, 0, 400, 400)):
    parts = []
    for layer in reversed(data['layers']):
        ks = layer['ks']
        p = sample(ks['p'], t)
        r = sample(ks['r'], t)
        r = r[0] if isinstance(r, list) else r
        s = sample(ks['s'], t)
        o = sample(ks['o'], t)
        o = o[0] if isinstance(o, list) else o
        if o <= 0.5:
            continue
        inner = ''.join(group_svg(g) for g in reversed(layer['shapes']))
        parts.append(f'<g opacity="{o / 100:.2f}" transform="translate({p[0]:.2f},{p[1]:.2f}) rotate({r:.2f}) scale({s[0] / 100:.4f},{s[1] / 100:.4f})">{inner}</g>')
    x0, y0, w, h = crop
    return (f'<svg viewBox="{x0} {y0} {w} {h}" width="{size}" height="{size * h / w:.0f}" style="background:#e9edf5">'
            + ''.join(parts) + '</svg>')


def main():
    args = sys.argv[1:]
    out = args.pop(0)
    every, count, size, crop, at = None, 8, 150, (0, 0, 400, 400), None
    files = []
    while args:
        a = args.pop(0)
        if a == '--every':
            every = int(args.pop(0))
        elif a == '--count':
            count = int(args.pop(0))
        elif a == '--crop':
            crop = tuple(float(x) for x in args.pop(0).split(','))
        elif a == '--at':
            at = [int(x) for x in args.pop(0).split(',')]
        elif a == '--size':
            size = int(args.pop(0))
        else:
            files.append(a)
    rows = []
    for f in files:
        with open(f, encoding='utf-8') as fh:
            data = json.load(fh)
        op = data['op']
        ts = at or (list(range(0, op, every)) if every else [round(op * i / count) for i in range(count)])
        cells = ''.join(f'<div class="c">{frame_svg(data, t, size, crop)}<span>{t}</span></div>' for t in ts)
        rows.append(f'<h3>{os.path.basename(f)} · {op} fr</h3><div class="r">{cells}</div>')
    html = ('<!doctype html><meta charset="utf-8"><style>body{font:12px sans-serif;margin:8px;background:#fff}'
            '.r{display:flex;flex-wrap:wrap;gap:4px}.c{display:flex;flex-direction:column;align-items:center}'
            'h3{margin:6px 0 2px}</style>' + ''.join(rows))
    with open(out, 'w', encoding='utf-8') as f:
        f.write(html)
    print(out)


if __name__ == '__main__':
    main()
