#!/usr/bin/env python3
"""Adds a sway about a contact point to an existing (nearly still) animation.

Usage: python3 tools/lottie/enliven.py [--out DIR] [--src DIR] [name ...]

Some original files are balance holds that move 2 px per loop (the designer's
"breathing" is a rigid bob of the whole figure, hands and feet included). A free
handstand or a one-leg stand should wobble, and the brief (tz_designer.md block F)
even says so. This keeps the original drawing and replaces the bob by a sway: every
figure layer is rotated about the contact point (hands / standing foot) by a small
oscillating angle, so the contact stays put and the far end moves. Props (floor,
wall, bar) stay still.

The first keyframe of each layer is taken as its pose, so the old bob is dropped; the
sway is zero in the first frame, so running the tool again on its own output gives the
same result.
"""

import argparse
import copy
import json
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from goro_rig import _prop  # noqa: E402

ROOT = os.path.join(os.path.dirname(__file__), '..', '..')
ASSETS = os.path.join(ROOT, 'assets', 'animations')

PROPS = ('floor', 'wall', 'bar', 'bracket', 'post')


def first(prop):
    """Pose value of a Lottie property: the first keyframe, or the constant."""
    k = prop['k']
    if prop.get('a') == 1:
        return list(k[0]['s'])
    return list(k) if isinstance(k, list) else [k]


def rot(p, pivot, deg):
    r = math.radians(deg)
    c, s = math.cos(r), math.sin(r)
    x, y = p[0] - pivot[0], p[1] - pivot[1]
    return (pivot[0] + x * c - y * s, pivot[1] + x * s + y * c)


def sway(t, n, amplitude, phase=0.0):
    """One slow cycle per loop with a little second harmonic, so it does not look
    like a metronome; exactly periodic."""
    w = 2 * math.pi * t / n
    return amplitude * (math.sin(w + phase) + 0.25 * math.sin(2 * w + 1.3 + phase))


def rock(t, n, amplitude):
    """One slow forward lean (a rock): 0 -> amplitude -> 0, always the same way."""
    return amplitude * (0.5 - 0.5 * math.cos(2 * math.pi * t / n))


def enliven(src, pivot, amplitude, phase=0.0, mode='sway', step=2):
    data = copy.deepcopy(src)
    n = data['op']
    times = list(range(0, n + 1, step))
    if times[-1] != n:
        times.append(n)
    for layer in data['layers']:
        if any(layer['nm'].startswith(p) or p in layer['nm'] for p in PROPS):
            continue
        ks = layer['ks']
        p0, r0 = first(ks['p']), first(ks['r'])[0]
        pos, rots = [], []
        for t in times:
            if mode == 'rock':
                th = rock(t, n, amplitude)
            else:
                th = sway(t, n, amplitude, phase) - sway(0, n, amplitude, phase)
            q = rot(p0, pivot, th)
            pos.append(q + tuple(p0[2:]))
            rots.append((r0 + th,))
        ks['p'] = _prop(times, pos)
        ks['r'] = _prop(times, rots)
    return data


# name -> (pivot, amplitude in degrees, phase, mode). The pivot is the contact point;
# mode 'sway' oscillates both ways, 'rock' leans one way and comes back.
CONFIG = {
    # one-leg stand: sways about the standing foot
    'bal_s1_one_leg_stand': ((188, 372), 1.6, 0.0, 'sway'),
    # free handstand: wobbles about the hands
    'bal_s6_free_hs': ((257, 372), 2.4, 0.4, 'sway'),
    # crow prep: the weight rocks forward over the hands until the heels start to lift
    'bal_s3_crow_prep': ((235, 372), 5.0, 0.0, 'rock'),
    # crow: balancing with both feet off the floor, a small wobble about the hands
    'bal_s4_crow_pose': ((235, 372), 1.5, 1.0, 'sway'),
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--src', default=ASSETS,
                    help='folder with the original files (default: assets/animations)')
    ap.add_argument('--out', default=ASSETS)
    ap.add_argument('names', nargs='*')
    args = ap.parse_args()
    for name in args.names or list(CONFIG):
        pivot, amp, phase, mode = CONFIG[name]
        with open(os.path.join(args.src, name + '.json')) as f:
            src = json.load(f)
        out = enliven(src, pivot, amp, phase, mode)
        path = os.path.join(args.out, name + '.json')
        with open(path, 'w') as f:
            json.dump(out, f, separators=(',', ':'))
        print(path)


if __name__ == '__main__':
    main()
