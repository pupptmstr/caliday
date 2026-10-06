#!/usr/bin/env python3
"""Sanity checks for generated Lottie animations: jumps and loop closure.

Usage: python3 tools/lottie/check_anim.py [--pos PX] [--rot DEG] file-or-name ...

A name without ``.json`` is looked up in assets/animations/. For every layer the
position / rotation / scale is sampled at every frame; the script reports

* jumps: a layer that moves more than ``--pos`` pixels or turns more than
  ``--rot`` degrees between two consecutive frames (a flipped limb shows up as
  a rotation jump of 100+ degrees),
* loop seams: the last frame must equal the first one (the animation loops).

Exits non-zero when anything is reported.
"""

import argparse
import json
import math
import os
import sys

ANIMATIONS = os.path.join(os.path.dirname(__file__), '..', '..', 'assets',
                          'animations')


def sample(prop, t):
    """Value of a Lottie property (static or linear-keyframed) at frame ``t``."""
    if not prop.get('a'):
        k = prop['k']
        return list(k) if isinstance(k, list) else [k]
    kfs = prop['k']
    if t <= kfs[0]['t']:
        return list(kfs[0]['s'])
    for a, b in zip(kfs, kfs[1:]):
        if a['t'] <= t <= b['t']:
            u = (t - a['t']) / (b['t'] - a['t'])
            return [x + (y - x) * u for x, y in zip(a['s'], b['s'])]
    return list(kfs[-1]['s'])


def check(path, max_pos, max_rot):
    with open(path) as f:
        data = json.load(f)
    n = data['op']
    problems = []
    biggest = (0.0, 0.0)
    for layer in data['layers']:
        ks = layer['ks']
        frames = [(sample(ks['p'], t), sample(ks['r'], t)[0],
                   sample(ks['s'], t), sample(ks['o'], t)[0])
                  for t in range(n + 1)]
        for t in range(n):
            (p0, r0, s0, _), (p1, r1, s1, _) = frames[t], frames[t + 1]
            dp = math.hypot(p1[0] - p0[0], p1[1] - p0[1])
            dr = abs(r1 - r0)
            biggest = (max(biggest[0], dp), max(biggest[1], dr))
            if dp > max_pos or dr > max_rot:
                problems.append('%s: frame %d->%d moves %.1f px / %.1f deg' % (
                    layer['nm'], t, t + 1, dp, dr))
        first, last = frames[0], frames[-1]
        seam_p = math.hypot(first[0][0] - last[0][0], first[0][1] - last[0][1])
        seam_r = abs((first[1] - last[1] + 180) % 360 - 180)
        seam_s = max(abs(a - b) for a, b in zip(first[2], last[2]))
        if seam_p > 0.05 or seam_r > 0.05 or seam_s > 0.05 or \
                abs(first[3] - last[3]) > 0.05:
            problems.append('%s: loop seam %.2f px / %.2f deg' % (
                layer['nm'], seam_p, seam_r))
    return data['nm'], n, biggest, problems


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--pos', type=float, default=22.0)
    ap.add_argument('--rot', type=float, default=30.0)
    ap.add_argument('files', nargs='+')
    args = ap.parse_args()
    bad = 0
    for name in args.files:
        path = name if name.endswith('.json') else os.path.join(
            ANIMATIONS, name + '.json')
        nm, frames, biggest, problems = check(path, args.pos, args.rot)
        status = 'FAIL' if problems else 'ok'
        print('%-34s %3d frames  max step %5.1f px %5.1f deg  %s' % (
            nm, frames, biggest[0], biggest[1], status))
        for p in problems[:12]:
            print('   ', p)
        bad += bool(problems)
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
