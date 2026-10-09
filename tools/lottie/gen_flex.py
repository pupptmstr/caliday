#!/usr/bin/env python3
"""Generates the Flex-branch exercise animations (assets/animations/flex_*.json).

Usage: python3 tools/lottie/gen_flex.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

``flex_s3_hip_9090`` is a front view a little from above (``frontview.py``,
legs solved in 3D): in profile the legs merge into the torso (2026-10-06).
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from goro_rig import P, Spec, hold_ramp, mk, plant, write  # noqa: E402


# ── flex_s1_hip_flexor_stretch ───────────────────────────────────────────────
# Half-kneeling lunge. Hips sink forward over the planted back knee while the
# arms sweep from the hips to overhead.

def hip_flexor():
    base = P(hip_n=18, hip_f=-20,
             leg_n=(270, 376), leg_f=(110, 366),
             foot_n=(5, 0, 0), foot_f=(-8, 4, 0))
    a = P(base, cx=208.6, cy=287.1, br=6,
          arm_n=(25, -60), arm_f=(25, -60))
    b = P(base, cx=208.3, cy=294.8, br=-6, ht=-4,
          arm_n=(-158, -162), arm_f=(-158, -162))
    # Sink a little deeper while holding the stretch.
    c = P(b, cx=209.5, cy=298.0, br=-9, ht=-6)
    return Spec(
        'flex_s1_hip_flexor_stretch', 48,
        [(0, a, 'smooth'), (6, a, 'smooth'), (22, b, 'smooth'),
         (34, c, 'smooth'), (48, a, 'smooth')],
        modes={'arm_n': 'fk', 'arm_f': 'fk'},
        bends={'leg_f': (0, 1)},
        order=['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r',
               'body', 'thigh_l', 'shin_l', 'foot_l', 'uarm_l', 'farm_l'])


# ── flex_s2_worlds_greatest_stretch ──────────────────────────────────────────
# Runner's lunge with both hands on the floor, then the near arm sweeps up to
# the ceiling while the chest opens (torso rises, head follows the hand).

def worlds_greatest():
    base = P(hip_n=12, hip_f=-12, leg_n=(236, 376), leg_f=(91, 351),
             foot_n=(5, 0, 0), foot_f=(7, 10, 55))
    a = mk(base, (178, 336), 52, ht=14, arm_f=(246, 362))
    a = plant(a, 'arm_n', (258, 362))
    c = mk(base, (180, 344), 44, ht=-28, arm_f=(246, 362),
           arm_n=(-168, -172))
    return Spec(
        'flex_s2_worlds_greatest_stretch', 60,
        [(0, a, 'smooth'), (6, a, 'smooth'), (26, c, 'smooth'),
         (40, c, 'smooth'), (60, a, 'smooth')],
        modes={'arm_n': 'fk'},
        # The back knee bends towards the floor; (0, -1) hyperextended it.
        bends={'leg_f': (0, 1)})


# ── flex_s4_thoracic_bridge ──────────────────────────────────────────────────
# Seated, hands behind. Hips lift into a reverse tabletop, then the near arm
# sweeps up over the chest and the head follows it.

def thoracic_bridge():
    base = P(hip_n=8, hip_f=2, leg_n=(276, 376), leg_f=(272, 376),
             foot_n=(5, 0, 0), foot_f=(5, 0, 0))
    hand_n, hand_f = (172, 364), (166, 364)
    a = mk(base, (215, 370), -20, ht=-6, arm_f=hand_f)
    a = plant(a, 'arm_n', hand_n)
    b = mk(base, (235, 334), -62, ht=-4, arm_f=hand_f)
    b = plant(b, 'arm_n', hand_n)
    c = mk(base, (237, 330), -68, ht=-30, arm_f=hand_f, arm_n=(-176, -176))
    d = mk(base, (238, 328), -70, ht=-36, arm_f=hand_f, arm_n=(-178, -180))
    return Spec(
        'flex_s4_thoracic_bridge', 66,
        [(0, a, 'smooth'), (10, a, 'smooth'), (22, b, 'smooth'),
         (36, c, 'smooth'), (44, d, 'smooth'), (54, b, 'smooth'),
         (66, a, 'smooth')],
        modes={'arm_n': 'fk'},
        bends={'leg_n': (0, -1), 'leg_f': (0, -1), 'arm_n': (-1, 0),
               'arm_f': (-1, 0)})


# ── flex_s5_deep_squat_hold ──────────────────────────────────────────────────
# Held deep squat, hands in prayer position pressing the knees open; the hips
# sink and the chest lifts in a slow breathing rhythm.

def deep_squat():
    base = P(hip_n=8, hip_f=2, leg_n=(218, 376), leg_f=(212, 376),
             foot_n=(5, 0, 0), foot_f=(5, 0, 0))
    a = mk(base, (186, 352), 20, ht=-18, arm_n=(258, 292), arm_f=(252, 294))
    b = mk(base, (182, 359), 9, ht=-8, arm_n=(268, 302), arm_f=(262, 304))
    return Spec(
        'flex_s5_deep_squat_hold', 48,
        [(0, a, 'smooth'), (24, b, 'smooth'), (48, a, 'smooth')],
        bends={'leg_n': (1, -1), 'leg_f': (1, -1), 'arm_n': (0, 1),
               'arm_f': (0, 1)})


# ── flex_s6_pike_stretch ─────────────────────────────────────────────────────
# Seated with straight legs, toes up. Starts sitting tall with the hands on the
# shins, then folds forward from the hips and reaches for the toes.

def pike():
    base = P(hip_n=8, hip_f=2, leg_n=(240, 364), leg_f=(236, 366),
             foot_n=(3, -5, -72), foot_f=(3, -5, -72))
    a = mk(base, (156, 366), 10, ht=-6, arm_n=(206, 352), arm_f=(200, 356))
    b = mk(base, (150, 366), 46, ht=8, arm_n=(244, 350), arm_f=(238, 354))
    return Spec(
        'flex_s6_pike_stretch', 48,
        [(0, a, 'smooth'), (6, a, 'smooth'), (22, b, 'smooth'),
         (38, b, 'smooth'), (48, a, 'smooth')],
        bends={'arm_n': (0, -1), 'arm_f': (0, -1), 'leg_n': (0, -1),
               'leg_f': (0, -1)})


# ── flex_s3_hip_9090 ─────────────────────────────────────────────────────────
# The 90/90 switch from the front and a little above (the owner's reference,
# 2026-10-09): sitting, leaning back on the hands behind the hips, the feet
# planted wide. The knees start up, both lower to Goro's left side into the
# 90/90 (the near thigh across in front, the far one out to the side), hold,
# come up and lower to the other side. The legs are solved in 3D: each knee
# turns about the line from its hip to its planted foot, then everything is
# projected for a camera 12 degrees above the floor. Goro's legs are a third
# longer here than standing (the segments stretch): with his own short legs the
# knees stayed under his belly and the pose did not read.

def hip_9090():
    from frontview import Animation, HIP_DX, figure
    T = 96
    HY = 349.0                       # hip joints on screen
    E = math.radians(12)             # camera elevation
    THIGH_LEN, SHIN_LEN = 62.0, 50.0
    TURN = math.radians(78)          # knees lowered nearly to the floor

    def proj(p):
        x, y, z = p
        return (200 + x, HY - y * math.cos(E) + z * math.sin(E))

    def knee_of(hip, ankle, phi):
        d = [a - h for a, h in zip(ankle, hip)]
        dist = math.sqrt(sum(c * c for c in d))
        u = [c / dist for c in d]
        a = (THIGH_LEN ** 2 - SHIN_LEN ** 2 + dist ** 2) / (2 * dist)
        r = math.sqrt(max(0.0, THIGH_LEN ** 2 - a * a))
        v = [-u[1] * u[0], 1 - u[1] * u[1], -u[1] * u[2]]   # up, square to u
        n = math.sqrt(sum(c * c for c in v))
        v = [c / n for c in v]
        w = [v[1] * u[2] - v[2] * u[1], v[2] * u[0] - v[0] * u[2],
             v[0] * u[1] - v[1] * u[0]]                     # towards screen right
        return tuple(h + u[k] * a + r * (v[k] * math.cos(phi) + w[k] * math.sin(phi))
                     for k, h in enumerate(hip))

    def pose(t):
        side = hold_ramp(t, [(0, 0), (4, 0), (18, 1), (38, 1), (48, 0),
                             (52, 0), (66, -1), (86, -1), (T, 0)])
        held = abs(side) > 0.98
        phi = TURN * side * (1 + 0.04 * math.sin(2 * math.pi * t / 20) * held)
        legs = {}
        for key, sx in (('leg_l', -1), ('leg_r', 1)):
            hip = (sx * HIP_DX, 0.0, 0.0)
            ankle = (sx * 46, -8.0, 34.0)
            knee = knee_of(hip, ankle, phi)
            # A thigh pointing at the camera looks short and its knee is the
            # nearest point: the cap grows and hides the stub of the thigh,
            # which turns fast as the knee passes in front of the hip.
            short = 1 - math.dist(proj(hip), proj(knee)) / THIGH_LEN
            legs[key] = dict(knee=proj(knee), ankle=proj(ankle),
                             near=1.05 + 0.55 * short, foot_rot=-sx * 20 * side,
                             foot_scale=(0.8, 1.3), foot_off=(0, 3))
        arms = {key: ((200 + sx * 74, HY - 2), (sx, 0))
                for key, sx in (('arm_l', -1), ('arm_r', 1))}
        return figure(hips=(200, HY), lean=-3 * side, head=(0, 2, 3 * side),
                      torso_scale=(1, 0.68), **legs, **arms)

    # The hands are behind the body and the legs in front of it.
    order = ['head', 'crown', 'foot_l', 'foot_r', 'shin_l', 'shin_r',
             'knee_l', 'knee_r', 'thigh_l', 'thigh_r', 'body', 'hand_l',
             'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r']
    return Animation('flex_s3_hip_9090', T, pose, order=order)


ANIMATIONS = {
    'flex_s1_hip_flexor_stretch': hip_flexor,
    'flex_s2_worlds_greatest_stretch': worlds_greatest,
    'flex_s3_hip_9090': hip_9090,
    'flex_s4_thoracic_bridge': thoracic_bridge,
    'flex_s5_deep_squat_hold': deep_squat,
    'flex_s6_pike_stretch': pike,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=os.path.join(
        os.path.dirname(__file__), '..', '..', 'assets', 'animations'))
    ap.add_argument('names', nargs='*')
    args = ap.parse_args()
    names = args.names or list(ANIMATIONS)
    for n in names:
        print(write(ANIMATIONS[n](), args.out))


if __name__ == '__main__':
    main()
