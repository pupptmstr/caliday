#!/usr/bin/env python3
"""Generates the Evening Stretch exercise animations (assets/animations/evening_*.json,
cooldown_lying_relaxation.json).

Usage: python3 tools/lottie/gen_evening.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Seated front views (``frontview.py``, ``ORDER_SEATED``): butterfly, straddle
fold, self-hug, overhead triceps, eagle arms. Seen from behind (``view='back'``):
cow face arms, where the hands meet on the back.
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from frontview import (ORDER_BACK, ORDER_SEATED, SEAT_HIPS, Animation,  # noqa: E402
                       butterfly_legs, cross_legs, figure, fold_toward,
                       rest_arm, straddle_legs, swing_arm)
from goro_rig import hold_ramp as ramp, write  # noqa: E402

HX, HY = SEAT_HIPS
SH_Y = HY - 51 - 41          # shoulder height when sitting upright (260)
HEAD_Y = HY - 51 - 54 - 36   # head centre when sitting upright (211)


def breath(t, period=24, amount=1.0):
    return amount * math.sin(2 * math.pi * t / period)


def into_hold(t, T, start=6, settle=22, leave=12):
    """0 -> 1 -> 0 over the loop: ease in, hold, ease out."""
    return ramp(t, [(0, 0), (start, 0), (start + settle, 1),
                    (T - leave, 1), (T - 2, 0), (T, 0)])


def hands_on_knees(legs):
    """Resting wrists just inside the knees."""
    out = {}
    for key, sx in (('arm_l', -1), ('arm_r', 1)):
        knee = legs['leg_' + key[-1]]['knee']
        out[key] = ((knee[0] - sx * 8, knee[1] - 6), (sx, 0))
    return out


def mix(a, b, u):
    return (a[0] + (b[0] - a[0]) * u, a[1] + (b[1] - a[1]) * u)


# ── evening_hips_s4_butterfly ────────────────────────────────────────────────
# Soles together, hands on the feet. The knees sink towards the floor, the
# back stays tall and leans in a little at the end; a slow breath in the hold.

def butterfly():
    T = 60

    def pose(t):
        k = into_hold(t, T)
        hold = ramp(t, [(0, 0), (28, 0), (32, 1), (T - 14, 1), (T - 10, 0), (T, 0)])
        knees_up = 1 - 0.8 * k + 0.08 * hold * (0.5 + 0.5 * breath(t, 16))
        legs = butterfly_legs(knees_up=knees_up)
        arms = {key: ((HX + sx * 13, 360), (sx, 0))
                for key, sx in (('arm_l', -1), ('arm_r', 1))}
        return figure(**fold_toward(0.22 * k), **legs, **arms)

    return Animation('evening_hips_s4_butterfly', T, pose, order=ORDER_SEATED)


# ── evening_folds_s4_straddle_fold ───────────────────────────────────────────
# Legs wide apart; the hands walk forward on the floor and the body folds
# towards the camera between the legs, holds, and comes back up.

def straddle_fold():
    T = 72

    def pose(t):
        k = into_hold(t, T, start=6, settle=26, leave=14)
        k = k * (1 + 0.04 * breath(t) * (k > 0.95))
        legs = straddle_legs()
        arms = {key: ((HX + sx * (30 + 22 * k), 358 + 26 * k), (sx, 0))
                for key, sx in (('arm_l', -1), ('arm_r', 1))}
        return figure(**fold_toward(k), **legs, **arms)

    return Animation('evening_folds_s4_straddle_fold', T, pose, order=ORDER_SEATED)


# ── evening_shoulders_s1_self_hug ────────────────────────────────────────────
# Cross-legged. The arms wrap round the body, hands on the opposite shoulder
# blades; the upper back rounds (shoulders come in, the chin drops) and
# breathes, then the arms open back to the knees.

def self_hug():
    T = 60

    def pose(t):
        k = into_hold(t, T)
        legs = cross_legs()
        rest = hands_on_knees(legs)
        hug = {'arm_l': ((HX + 30, SH_Y + 4), (0, 1)),
               'arm_r': ((HX - 30, SH_Y + 12), (0, 1))}
        arms = {key: (mix(rest[key][0], hug[key][0], k), hug[key][1] if k > 0.5 else rest[key][1])
                for key in rest}
        b = breath(t) * k
        return figure(hips=SEAT_HIPS, torso_scale=(1 - 0.04 * k + 0.015 * b, 1 - 0.04 * k),
                      sh_l=(5 * k, 2 * k), sh_r=(-5 * k, 2 * k),
                      head=(0, 7 * k, 0), head_scale=(1, 1 - 0.07 * k), **legs, **arms)

    return Animation('evening_shoulders_s1_self_hug', T, pose, order=ORDER_SEATED)


# ── evening_shoulders_s2_triceps_stretch ─────────────────────────────────────
# Cross-legged. One arm goes up, the elbow bends and the hand drops behind the
# neck (the forearm behind the head); the elbow eases back, the head tilts a
# little away from it. The other hand rests on the knee.

TRICEPS_ORDER = ['hand_l', 'farm_l', 'uarm_l', 'uarm_r', 'head', 'foot_l',
                 'foot_r', 'shin_l', 'shin_r', 'knee_l', 'knee_r', 'thigh_l',
                 'thigh_r', 'body', 'hand_r', 'farm_r']


def shoulder_of(sx):
    return (HX + sx * 36, SH_Y)


def triceps_stretch():
    T = 96

    def pose(t):
        up = ramp(t, [(0, 0), (6, 0), (26, 1), (T - 20, 1), (T - 2, 0), (T, 0)])
        bend = ramp(t, [(0, 0), (26, 0), (40, 1), (T - 34, 1), (T - 20, 0), (T, 0)])
        ease = ramp(t, [(0, 0), (42, 0), (50, 1), (T - 44, 1), (T - 36, 0), (T, 0)])
        legs = cross_legs()
        rest = hands_on_knees(legs)
        rest_r = rest_arm(shoulder_of(1), rest['arm_r'][0], (1, 0))
        raised = ((HX + 44, HEAD_Y - 4), (HX + 42, HEAD_Y - 44))
        folded = ((HX + 26 - 3 * ease, HEAD_Y - 18 - 3 * ease), (HX + 4, HEAD_Y + 12))
        if bend > 0:
            arm_r = swing_arm(raised, folded, bend, -1)
        else:
            arm_r = swing_arm(rest_r, raised, up, -1, shoulder_of(1), -1)
        return figure(hips=SEAT_HIPS, head=(-1.5 * ease, 0, -5 * ease),
                      sh_r=(0, -4 * up), arm_l=rest['arm_l'], arm_r=arm_r, **legs)

    return Animation('evening_shoulders_s2_triceps_stretch', T, pose, order=TRICEPS_ORDER)


# ── evening_shoulders_s3_eagle_arms ──────────────────────────────────────────
# Cross-legged. The elbows come together in front of the chest while the
# forearms swing up and cross, palms meeting in front of the face; the elbows
# lift to shoulder height, hold, and the arms unwind.

def eagle_arms():
    T = 72

    def pose(t):
        k = into_hold(t, T, start=6, settle=20, leave=14)
        lift = ramp(t, [(0, 0), (24, 0), (34, 1), (T - 18, 1), (T - 12, 0), (T, 0)])
        lift *= 1 + 0.08 * breath(t, 20)
        legs = cross_legs()
        rest = hands_on_knees(legs)
        ey = SH_Y + 34 - 18 * lift
        wy = HEAD_Y + 38 - 14 * lift
        end = {'arm_l': ((HX + 4, ey), (HX - 5, wy)),
               'arm_r': ((HX - 4, ey + 9), (HX + 5, wy + 2))}
        arms = {}
        for key, sx in (('arm_l', -1), ('arm_r', 1)):
            start = rest_arm(shoulder_of(sx), rest[key][0], (sx, 0))
            arms[key] = swing_arm(start, end[key], k, -1 if sx < 0 else 1)
        rot = 90 * k
        return figure(hips=SEAT_HIPS, hand_rot=(rot, -rot), **legs, **arms)

    return Animation('evening_shoulders_s3_eagle_arms', T, pose, order=ORDER_SEATED)


# ── evening_shoulders_s5_cow_face_arms ───────────────────────────────────────
# Seen from behind, cross-legged: one arm goes up and the hand drops down the
# spine, the other comes up behind the back, and the fingers hook between the
# shoulder blades; hold, then let go.

def cow_face_arms():
    T = 96

    def pose(t):
        up = ramp(t, [(0, 0), (6, 0), (26, 1), (T - 20, 1), (T - 2, 0), (T, 0)])
        fold = ramp(t, [(0, 0), (26, 0), (42, 1), (T - 36, 1), (T - 20, 0), (T, 0)])
        low = ramp(t, [(0, 0), (14, 0), (42, 1), (T - 36, 1), (T - 8, 0), (T, 0)])
        hook = ramp(t, [(0, 0), (42, 0), (46, 1), (T - 40, 1), (T - 36, 0), (T, 0)])
        legs = cross_legs()
        meet_y = SH_Y + 18 - 3 * hook
        hang = {sx: rest_arm(shoulder_of(sx), (HX + sx * 40, SH_Y + 66), (sx, 0))
                for sx in (-1, 1)}
        raised = ((HX + 44, HEAD_Y - 4), (HX + 42, HEAD_Y - 44))
        folded = ((HX + 30, HEAD_Y - 12), (HX + 3, meet_y - 4))
        if fold > 0:
            arm_r = swing_arm(raised, folded, fold, -1)
        else:
            arm_r = swing_arm(hang[1], raised, up, -1, shoulder_of(1), -1)
        behind = ((HX - 44, SH_Y + 48), (HX - 3, meet_y + 6))
        arm_l = swing_arm(hang[-1], behind, low, 1)
        return figure(hips=SEAT_HIPS, sh_r=(0, -3 * up), head=(0, 2 * fold, 0),
                      arm_l=arm_l, arm_r=arm_r, **legs)

    return Animation('evening_shoulders_s5_cow_face_arms', T, pose,
                     order=ORDER_BACK, view='back')


ANIMATIONS = {
    'evening_hips_s4_butterfly': butterfly,
    'evening_folds_s4_straddle_fold': straddle_fold,
    'evening_shoulders_s1_self_hug': self_hug,
    'evening_shoulders_s2_triceps_stretch': triceps_stretch,
    'evening_shoulders_s3_eagle_arms': eagle_arms,
    'evening_shoulders_s5_cow_face_arms': cow_face_arms,
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
