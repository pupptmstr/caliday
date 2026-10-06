#!/usr/bin/env python3
"""Generates the Neck-branch exercise animations (assets/animations/warmup_neck_rolls.json,
neck_s*.json).

Usage: python3 tools/lottie/gen_neck.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Front views (``frontview.py``): neck rolls, neck tilts, shoulder circles, doorway stretch.
Side views (``goro_rig.py``): chest opener, wall angels. The doorway stretch is a
front view too (arms on both posts).
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from frontview import ORDER_CAPS, Animation, figure  # noqa: E402
from goro_rig import (P, POST_DARK, Spec, WALL, bar, door_post,  # noqa: E402
                      hold_ramp as ramp, mk, sampled, write)

FLOOR = 376
ALL_FK = {'arm_n': 'fk', 'arm_f': 'fk'}
# Arms drawn over the head (they reach beside / above it).
ARMS_ABOVE_HEAD = ['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r',
                   'body', 'thigh_l', 'shin_l', 'foot_l', 'uarm_l', 'farm_l']


# ── warmup_neck_rolls ────────────────────────────────────────────────────────
# Half circles from side to side through the front: ear to the right shoulder,
# chin to the chest, ear to the left shoulder, chin to the chest, ... (never
# back). One loop is one full side-to-side cycle.

def neck_rolls():
    T = 48

    def pose(t):
        w = 2 * math.pi * t / T
        tilt = 26 * math.cos(w)
        down = math.sin(w) ** 2                   # 0 at the sides, 1 in the middle
        return figure(head=(0, 5 * down, tilt), head_scale=(1, 1 - 0.1 * down))

    return Animation('warmup_neck_rolls', T, pose)


# ── neck_s1_neck_tilt ────────────────────────────────────────────────────────
# Ear towards the shoulder, held, the opposite shoulder sinks a little; back to
# centre, then the other side. The hands just hang.

def neck_tilt():
    T = 72
    sweep = [(0, 0), (8, 0), (20, 1), (32, 1), (42, 0), (44, 0)]

    def pose(t):
        a = ramp(t, sweep)                         # first side, 0..44
        b = ramp(t - 28, sweep) if t >= 28 else 0.0   # second side, 28..72
        side = a - b                               # +1: right, -1: left
        tilt = 30 * side
        breath = 1 + 0.06 * math.sin(math.pi * 2 * t / 24) * abs(side)
        # the shoulder on the side away from the ear sinks
        sh_l = (0, 3.5 * max(side, 0))
        sh_r = (0, 3.5 * max(-side, 0))
        return figure(head=(0, 1.5 * abs(side), tilt * breath),
                      sh_l=sh_l, sh_r=sh_r)

    return Animation('neck_s1_neck_tilt', T, pose, order=ORDER_CAPS)


# ── neck_s3_shoulder_roll ────────────────────────────────────────────────────
# Big slow shoulder circles: one forward, then one backward. The shoulders go
# up, close in as they come forward, drop, and spread as they go back.

def shoulder_roll():
    T = 72

    def offsets(phi, direction):
        up = -(6.5 + 6.5 * math.cos(phi))          # 0 (down) .. -13 (up)
        close = 6 * math.sin(phi) * direction      # forward: in, back: out
        return up, close

    def pose(t):
        if t < 36:
            phi, direction = 2 * math.pi * t / 36, 1
        else:
            phi, direction = 2 * math.pi * (t - 36) / 36, -1
        up, close = offsets(phi, direction)
        return figure(sh_l=(close, up), sh_r=(-close, up),
                      head=(0, 0.3 * up, 0))

    return Animation('neck_s3_shoulder_roll', T, pose, order=ORDER_CAPS)


# ── neck_s2_chest_opener ─────────────────────────────────────────────────────
# Side view, standing tall, hands clasped behind the back. The straight arms
# lift backwards, the shoulder blades squeeze together (the shoulders move back
# on the torso), the chest comes forward and the chin lifts a little.

def chest_opener():
    base = P(hip_n=8, hip_f=2, foot_n=(6, 4, 0), foot_f=(6, 4, 0),
             leg_n=(206, 372), leg_f=(196, 372))
    hips = (200, 288)

    def pose(t):
        k = ramp(t, [(0, 0), (6, 0), (26, 1), (30, 1.08), (36, 1), (40, 1),
                     (54, 0), (60, 0)])
        a = 14 + 38 * k                       # arms swing back (0 = straight down)
        return mk(base, hips, -5 * k, ht=-9 * k, sh_n=3 - 7 * k, sh_f=3 - 7 * k,
                  arm_n=(a, a - 3), arm_f=(a - 5, a - 8))

    return Spec('neck_s2_chest_opener', 60, sampled(60, pose),
                modes=ALL_FK, order=ARMS_ABOVE_HEAD)


# ── neck_s4_wall_angel ───────────────────────────────────────────────────────
# Side view, back, head and arms against a wall. In the picture the arms are a
# vertical bar pressed to the wall: they slide up from the "goal post" position
# (forearm up, elbow at shoulder height) to straight overhead and back down.

def wall_angel():
    wall_x = 182                              # wall surface
    hips = (wall_x + 28, 291)                 # back of the torso touches it
    base = P(hip_n=8, hip_f=2, foot_n=(6, 4, 0), foot_f=(6, 4, 0),
             head=(1, -83), sh_n=-20, sh_f=-20,
             leg_n=(hips[0] + 18, 372), leg_f=(hips[0] + 12, 372),
             arm_n=(180, 180), arm_f=(180, 180))

    def pose(t):
        up = ramp(t, [(0, 0), (6, 0), (28, 1), (34, 1), (56, 0), (60, 0)])
        phi = math.radians(8 + 82 * up)      # upper arm: sideways -> overhead
        s = math.sin(phi)
        return mk(base, hips, 0, sc_uarm_n=s, sc_uarm_f=s)

    return Spec('neck_s4_wall_angel', 60, sampled(60, pose),
                modes=ALL_FK, bends={'leg_n': (1, -1), 'leg_f': (1, -1)},
                order=ARMS_ABOVE_HEAD,
                props=lambda n: [bar('wall', wall_x - 10, 200, 20, 400, WALL, n,
                                     4, 90)])


# ── neck_s5_doorway_stretch ──────────────────────────────────────────────────
# Front view. Goro stands in a door frame with both forearms on the posts
# ("goal post" arms, elbows at shoulder height). Leaning through the door shows
# as the chest and head coming towards the camera (they grow a little) while
# the hands stay on the posts; then back.

def doorway_stretch():
    T = 60
    arm_dx, post_dx = 82, 91                  # elbow / post centre from the axis
    elbow_y, hand_y = 203, 168

    def pose(t):
        lean = ramp(t, [(0, 0), (8, 0), (28, 1), (46, 1), (58, 0), (60, 0)])
        grow = 1 + 0.12 * lean
        arms = {}
        for side, key in ((-1, 'arm_l'), (1, 'arm_r')):
            x = 200 + side * arm_dx
            arms[key] = ((x, hand_y), (side, 0), (x, elbow_y))
        return figure(hips=(200, 288 + 4 * lean), torso_scale=(grow, 1.0 + 0.05 * lean),
                      head=(0, 9 * lean, 0), head_scale=(grow, grow), **arms)

    def props(frames):
        left, right = door_post('post_l', 200 - post_dx, 96, frames), \
            door_post('post_r', 200 + post_dx, 96, frames)
        lintel = bar('lintel', 200, 103, 2 * post_dx + 20, 14, POST_DARK, frames, 3, 52)
        return left + right + [lintel]

    return Animation('neck_s5_doorway_stretch', T, pose, order=ORDER_CAPS,
                     props=props)


ANIMATIONS = {
    'warmup_neck_rolls': neck_rolls,
    'neck_s1_neck_tilt': neck_tilt,
    'neck_s2_chest_opener': chest_opener,
    'neck_s3_shoulder_roll': shoulder_roll,
    'neck_s4_wall_angel': wall_angel,
    'neck_s5_doorway_stretch': doorway_stretch,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=os.path.join(
        os.path.dirname(__file__), '..', '..', 'assets', 'animations'))
    ap.add_argument('names', nargs='*')
    args = ap.parse_args()
    for n in args.names or list(ANIMATIONS):
        print(write(ANIMATIONS[n](), args.out))


if __name__ == '__main__':
    main()
