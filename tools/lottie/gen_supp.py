#!/usr/bin/env python3
"""Generates the supplementary-pool exercise animations (assets/animations/supp_*.json).

Usage: python3 tools/lottie/gen_supp.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

``supp_wrist_circles`` has no file of its own: the catalog reuses the existing
front-view ``warmup_wrist_circles.json``.
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from goro_rig import (P, Spec, add, align, head_pos, joint_of, mk,  # noqa: E402
                      plant, rot, write)
from topview import oblique_crunch  # noqa: E402

FLOOR = 376
ALL_FK = {'leg_n': 'fk', 'leg_f': 'fk', 'arm_n': 'fk', 'arm_f': 'fk'}
ARMS_ABOVE_HEAD = ['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r',
                   'body', 'thigh_l', 'shin_l', 'foot_l', 'uarm_l', 'farm_l']


# ── supp_oblique_crunch ──────────────────────────────────────────────────────
# Drawn from above (tools/lottie/topview.py): in a side view the elbows of a
# twisting crunch tangle, from above the elbow reaching the opposite knee is
# obvious.

# ── supp_russian_twists ──────────────────────────────────────────────────────
# V-sit, torso leaned back, feet off the floor, hands clasped. In a side view a
# twist is faked by moving the two shoulders in opposite directions along the
# torso and by foreshortening the arms as they swing towards / away from us.

def russian_twists():
    hips = (190, 366)
    base = P(hip_n=8, hip_f=2, leg_n=(258, 330), leg_f=(252, 332),
             foot_n=(3, -3, -40), foot_f=(3, -3, -40))

    def pose(sh_n, sh_f, arms, **kw):
        return mk(base, hips, -36, ht=30, sh_n=sh_n, sh_f=sh_f,
                  arm_n=arms[0], arm_f=arms[1], **kw)

    squeeze = dict(sc_uarm_n=0.8, sc_farm_n=0.6, sc_uarm_f=0.8, sc_farm_f=0.6,
                   sc_torso=1.25)
    centre = pose(3, 3, ((-40, -135), (-44, -135)))
    near = pose(-12, 18, ((-10, -92), (-14, -88)), **squeeze)
    # Far side: the arms swing out in front of the chest from behind the torso.
    far = pose(18, -12, ((-78, -100), (-82, -100)), sc_torso=1.25)

    def front(t):  # near arm pair drawn over the torso ...
        if t <= 24:
            return 100
        return max(0, 100 - 25 * (t - 24)) if t < 28 else (
            0 if t < 44 else min(100, 25 * (t - 44)))

    def behind(t):  # ... and the same pair under it for the far-side twist
        return 100 - front(t)

    return Spec(
        'supp_russian_twists', 48,
        [(0, centre, 'smooth'), (12, near, 'smooth'), (24, centre, 'smooth'),
         (36, far, 'smooth'), (48, centre, 'smooth')],
        modes={'arm_n': 'fk', 'arm_f': 'fk'},
        bends={'leg_n': (0, -1), 'leg_f': (0, -1)},
        order=['head', 'uarm_r', 'farm_r', 'thigh_r', 'shin_r', 'foot_r',
               'body', 'uarm_r@b', 'farm_r@b', 'thigh_l', 'shin_l', 'foot_l',
               'uarm_l', 'farm_l'],
        fade={'uarm_r': front, 'farm_r': front,
              'uarm_r@b': behind, 'farm_r@b': behind})


# ── supp_side_plank ──────────────────────────────────────────────────────────
# Forearm side plank held in a straight line; the hips breathe up and down a
# little. The supporting forearm points at the viewer (foreshortened).

def side_plank():
    base = P(hip_n=8, hip_f=2, leg_n=(303, 373), leg_f=(303, 375),
             foot_n=(5, -2, 16), foot_f=(5, -2, 16))
    a = mk(base, (219, 351), -74, ht=38, arm_n=(0, 0), arm_f=(180, 180),
           sc_farm_n=0.3)
    b = mk(base, (219, 347), -77, ht=34, arm_n=(0, 0), arm_f=(176, 178),
           sc_farm_n=0.3)
    return Spec(
        'supp_side_plank', 48,
        [(0, a, 'smooth'), (24, b, 'smooth'), (48, a, 'smooth')],
        modes={'arm_n': 'fk', 'arm_f': 'fk'},
        bends={'leg_n': (0, 1), 'leg_f': (0, 1)})


# ── supp_standing_calf_raise / supp_single_leg_calf_raise ────────────────────

def raised_foot(toe_x, phi):
    """Foot pivoting on the ball of the foot: (ankle target, foot offset)."""
    r = math.radians(phi)
    centre = (toe_x - 12 * math.cos(r), FLOOR - 12 * math.sin(r))
    ankle = add(centre, rot((-6, -4), phi))
    return ankle, (centre[0] - ankle[0], centre[1] - ankle[1], phi)


def calf_pose(phi, single, sway=0.0):
    toe_n, toe_f = 226, 220
    ankle_n, foot_n = raised_foot(toe_n, phi)
    kw = dict(leg_n=ankle_n, foot_n=foot_n)
    if single:
        # Free leg: knee slightly forward, foot lifted behind.
        kw.update(leg_f=(-4, 105), foot_f=(0, 0, 20),
                  arm_n=(35, -80), arm_f=(30, -85))
    else:
        ankle_f, foot_f = raised_foot(toe_f, phi)
        kw.update(leg_f=ankle_f, foot_f=foot_f,
                  arm_n=(-5, -5), arm_f=(-8, -6))
    return mk(P(hip_n=8, hip_f=2), (200, ankle_n[1] - 83.9), sway, **kw)


def calf_raise(name, single):
    rest = calf_pose(0, single)
    up = calf_pose(45, single)
    keys = [(0, rest, 'smooth'), (4, rest, 'smooth'), (18, up, 'smooth')]
    if single:
        keys += [(22, calf_pose(45, True, 1.2), 'smooth'),
                 (26, up, 'smooth')]
    else:
        keys += [(26, up, 'smooth')]
    keys += [(42, rest, 'smooth'), (48, rest, 'smooth')]
    return Spec(
        name, 48, keys,
        modes={'leg_f': 'fk' if single else 'ik', 'arm_n': 'fk', 'arm_f': 'fk'})


def standing_calf_raise():
    return calf_raise('supp_standing_calf_raise', False)


def single_leg_calf_raise():
    return calf_raise('supp_single_leg_calf_raise', True)


# ── supp_dead_bug ────────────────────────────────────────────────────────────
# Lying on the back, arms to the ceiling, knees at 90°. The near arm goes
# overhead while the far leg extends, then the other diagonal.

def dead_bug():
    base = P(hip_n=8, hip_f=2, foot_n=(3, -5, -75), foot_f=(3, -5, -75))
    hips = (225, 348)
    legs_up, leg_out = (180, -90), (274, -86)
    arm_up, arm_over = (180, 180), (80, 85)

    def pose(**over):
        limbs = dict(arm_n=arm_up, arm_f=arm_up, leg_n=legs_up, leg_f=legs_up)
        limbs.update(over)
        return mk(base, hips, -90, **limbs)

    rest = pose()
    one = pose(arm_n=arm_over, leg_f=leg_out)
    two = pose(arm_f=arm_over, leg_n=leg_out)
    return Spec(
        'supp_dead_bug', 60,
        [(0, rest, 'smooth'), (4, rest, 'smooth'), (16, one, 'smooth'),
         (20, one, 'smooth'), (30, rest, 'smooth'), (34, rest, 'smooth'),
         (46, two, 'smooth'), (50, two, 'smooth'), (60, rest, 'smooth')],
        modes=ALL_FK, order=ARMS_ABOVE_HEAD)


# ── supp_bird_dog ────────────────────────────────────────────────────────────
# All fours (Goro's arms are longer than his legs, so the back slopes up to the
# head). Opposite arm and leg extend in line with the back, then swap.

def bird_dog():
    base = P(hip_n=8, hip_f=2)
    hips = (125, 308)
    kneel, back, forward = (0, 90), (70, 70), (-106, -106)

    def pose(near_arm, far_arm, near_leg, far_leg):
        p = mk(base, hips, 70, ht=-8,
               leg_n=back if near_leg else kneel,
               leg_f=back if far_leg else kneel,
               foot_n=(-8, 2, -20) if near_leg else (-10, 3, 0),
               foot_f=(-8, 2, -20) if far_leg else (-10, 3, 0))
        for side, out in (('n', near_arm), ('f', far_arm)):
            limb = 'arm_' + side
            if out:
                p[limb] = forward
            else:
                shoulder = joint_of(p, limb)
                p = plant(p, limb, (shoulder[0] + (4 if side == 'n' else -2),
                                    362))
        return p

    rest = pose(False, False, False, False)
    one = pose(True, False, False, True)
    two = pose(False, True, True, False)
    return Spec(
        'supp_bird_dog', 64,
        [(0, rest, 'smooth'), (3, rest, 'smooth'), (12, one, 'smooth'),
         (22, one, 'smooth'), (31, rest, 'smooth'), (35, rest, 'smooth'),
         (44, two, 'smooth'), (54, two, 'smooth'), (64, rest, 'smooth')],
        modes=ALL_FK, order=ARMS_ABOVE_HEAD)


# ── supp_neck_isometrics ─────────────────────────────────────────────────────
# Standing; the near palm presses the forehead, then the temple, then the back
# of the head. Each hold has a small press to show the resisted effort.

def neck_isometrics():
    base = P(hip_n=8, hip_f=2, leg_n=(208, 372), leg_f=(202, 372),
             foot_n=(5, 4, 0), foot_f=(5, 4, 0), arm_f=(-4, -4))
    hips = (200, 288)

    def pose(fist, wrist_off, bend, press=(0, 0)):
        p = mk(base, hips, 0)
        wrist = add(add(head_pos(p), fist), wrist_off)
        return plant(p, 'arm_n', add(wrist, press), bend)

    forehead = pose((26, -10), (0, 6), (1, 0.5))
    forehead_p = pose((26, -10), (0, 6), (1, 0.5), (-2.5, 0))
    temple = pose((0, -2), (0, 6), (1, 0.3))
    temple_p = pose((0, -2), (0, 6), (1, 0.3), (-1.5, 0))
    back = pose((-30, -4), (6, 0), (0.3, -1))
    back_p = pose((-30, -4), (6, 0), (0.3, -1), (2.5, 0))
    # The hand travels over the top of the head between the positions.
    over = pose((-10, -34), (0, 6), (0.3, -1))
    # IK angles can differ by 360 between neighbours: keep each hop short.
    temple = align(temple, forehead, 'arm_n')
    temple_p = align(temple_p, forehead, 'arm_n')
    over = align(over, temple, 'arm_n')
    back = align(back, over, 'arm_n')
    back_p = align(back_p, over, 'arm_n')
    return Spec(
        'supp_neck_isometrics', 64,
        [(0, forehead, 'smooth'), (6, forehead_p, 'smooth'),
         (12, forehead, 'smooth'), (20, temple, 'smooth'),
         (26, temple_p, 'smooth'), (32, temple, 'smooth'),
         (38, over, 'smooth'), (44, back, 'smooth'),
         (50, back_p, 'smooth'), (56, back, 'smooth'),
         (60, over, 'smooth'), (64, forehead, 'smooth')],
        modes={'arm_n': 'fk', 'arm_f': 'fk'}, order=ARMS_ABOVE_HEAD)


ANIMATIONS = {
    'supp_oblique_crunch': oblique_crunch,
    'supp_russian_twists': russian_twists,
    'supp_side_plank': side_plank,
    'supp_standing_calf_raise': standing_calf_raise,
    'supp_single_leg_calf_raise': single_leg_calf_raise,
    'supp_dead_bug': dead_bug,
    'supp_bird_dog': bird_dog,
    'supp_neck_isometrics': neck_isometrics,
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
