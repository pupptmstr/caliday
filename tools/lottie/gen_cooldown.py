#!/usr/bin/env python3
"""Generates the redrawn cooldown animations (assets/animations/cooldown_*.json).

Usage: python3 tools/lottie/gen_cooldown.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

``cooldown_cat_cow`` replaces the old one (the torso hardly bent) and ``cooldown_quad_stretch``
the old file whose grabbed foot was a blue chevron (the stretched leg keeps the original blue).
``cooldown_downward_dog`` is not redrawn here: Goro's limbs are too short for a deep V (the
hips would rise only 10 px above the shoulders), so the designer's drawing is patched by
``patch_old.py`` instead.

Side view, on all fours. The torso is a three-part spine (goro_rig: ``spine``
pose key, layers ``sp_chest`` / ``sp_mid`` / ``sp_pelvis``): the hips stay above
the knees, the hands stay planted, and the spine bends from a hollow back (cow:
belly down, chest and tailbone up, chin up) to a rounded back (cat: back
arched, chin and tailbone tucked).
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from goro_rig import (FARM, P, THIGH, UARM, Spec, add, ang_of,  # noqa: E402
                      hold_ramp, ik2, joint_of, mk, plant, sampled, write)

ALL_FK = {'leg_n': 'fk', 'leg_f': 'fk', 'arm_n': 'fk', 'arm_f': 'fk'}
# Arms in front of the head (it hangs ahead of the hands), spine instead of body.
ORDER = ['head', 'uarm_r', 'farm_r', 'thigh_r', 'shin_r', 'foot_r',
         'sp_chest', 'sp_mid', 'sp_pelvis', 'thigh_l', 'shin_l', 'foot_l',
         'uarm_l', 'farm_l']

STRETCH_BLUE = [0.12, 0.52, 1.0, 1.0]    # highlight of the stretched leg
HIP = (150.0, 319.0)         # near hip joint: above the knees, never moves
HAND_X = 232.0               # planted hands
SHOULDER_Y = 283.0           # straight arms keep the shoulders at this height
KNEE_Y = 365.0
# Where along the spine (hip joint -> shoulder joint, length 89) the pelvis,
# mid and chest parts sit; a bend of ``delta`` turns each by delta * (0.5 - m).
MID = (13 / 89, 44 / 89, 75.5 / 89)
COW, CAT = -85.0, 75.0       # total spine bend at the two ends of the loop


def spine_pose(base, delta):
    """Pose with the spine bent by ``delta`` degrees in total (positive: rounded
    back), hip joint pinned at HIP and shoulder joint at SHOULDER_Y."""
    def build(phi0):
        phi_p, phi_m, phi_c = (phi0 + delta * (0.5 - m) for m in MID)
        p = P(base, cx=0.0, cy=0.0, br=90 - phi_c,
              spine=(phi_c - phi_m, phi_m - phi_p))
        hip = joint_of(p, 'leg_n')
        p['cx'], p['cy'] = HIP[0] - hip[0], HIP[1] - hip[1]
        return p

    lo, hi = -20.0, 70.0                       # slope of the chord, solved so
    for _ in range(50):                        # the shoulders keep their height
        mid = (lo + hi) / 2
        if joint_of(build(mid), 'arm_n')[1] > SHOULDER_Y:
            lo = mid
        else:
            hi = mid
    return build((lo + hi) / 2)


def cat_cow():
    base = P(hip_n=8, hip_f=2, foot_n=(-10, 3, 0), foot_f=(-10, 3, 0))
    T = 60

    def pose(t):
        delta = hold_ramp(t, [(0, COW), (4, COW), (26, CAT), (34, CAT),
                              (56, COW), (60, COW)])
        p = spine_pose(base, delta)
        # Head tilt as an absolute angle: chin up in the cow, tucked in the cat.
        head_abs = -28 + (delta - COW) / (CAT - COW) * 98
        p['ht'] = head_abs - p['br']
        # Knees on the floor: the near thigh is vertical, the far one hangs from
        # its own hip; the shins lie back along the floor.
        for limb, side in (('leg_n', 'n'), ('leg_f', 'f')):
            hip = joint_of(p, limb)
            knee = (hip[0], KNEE_Y if side == 'n' else hip[1] + THIGH)
            d = (knee[0] - hip[0], knee[1] - hip[1])
            p[limb] = (ang_of(*d), 90)
            p['sc_thigh_' + side] = math.hypot(*d) / THIGH
        p = plant(p, 'arm_n', (HAND_X + 2, 362), (-1, 0))
        p = plant(p, 'arm_f', (HAND_X - 4, 362), (-1, 0))
        return p

    return Spec('cooldown_cat_cow', T, sampled(T, pose), modes=ALL_FK, order=ORDER)


# ── cooldown_quad_stretch ────────────────────────────────────────────────────
# Standing on the far leg; the near knee points to the floor, the shin folds back
# and the near hand holds the ankle. A slow pull brings the heel closer to the
# glutes while the standing leg wobbles a little.

def quad_stretch():
    base = P(hip_n=8, hip_f=2, foot_n=(-4, 2, 20), foot_f=(6, 4, 0),
             leg_f=(204, 372))
    hips = (196.0, 288.0)
    # Goro's arms (80 px) are shorter than shoulder-to-hip (89 px), so to reach the
    # heel behind him they are drawn 18 % longer in this one animation.
    reach = 1.18

    def pose(t):
        pull = hold_ramp(t, [(0, 0), (10, 1), (38, 1), (48, 0)])
        wobble = 0.5 * math.sin(2 * math.pi * t / 48)
        # near leg: the thigh hangs down and a little back, the shin folds up
        thigh = 8 + 8 * pull
        shin = 132 + 20 * pull
        p = mk(base, (hips[0] + wobble, hips[1]), 3 + 2 * pull, ht=-2,
               leg_n=(thigh, shin), arm_f=(8, 16), sc_uarm_n=reach, sc_farm_n=reach)
        hip = joint_of(p, 'leg_n')
        knee = add(hip, (-math.sin(math.radians(thigh)) * THIGH,
                         math.cos(math.radians(thigh)) * THIGH))
        ankle = add(knee, (-math.sin(math.radians(shin)) * 38,
                           math.cos(math.radians(shin)) * 38))
        # the near hand holds the ankle behind the body
        shoulder = joint_of(p, 'arm_n')
        p['arm_n'] = ik2(shoulder, add(ankle, (3, -3)), UARM * reach,
                         FARM * reach, (1, 0.3))
        return p

    # the stretched leg is highlighted in the blue of the original file
    tint = {n: STRETCH_BLUE for n in ('thigh_r', 'shin_r', 'foot_r')}
    return Spec('cooldown_quad_stretch', 48, sampled(48, pose),
                modes={'leg_n': 'fk', 'leg_f': 'ik', 'arm_n': 'fk', 'arm_f': 'fk'},
                bends={'leg_f': (1, -1)}, tint=tint)


ANIMATIONS = {
    'cooldown_cat_cow': cat_cow,
    'cooldown_quad_stretch': quad_stretch,
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
