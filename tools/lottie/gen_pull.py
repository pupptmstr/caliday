#!/usr/bin/env python3
"""Generates the redrawn Pull-branch animations (assets/animations/pull_*.json, warmup_dead_hang.json).

Usage: python3 tools/lottie/gen_pull.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Front view on ``frontview.py`` in the dark paper-doll style of the original
files. The bar is drawn in front of the head and torso (the athlete faces it)
but under the fists, so "chin over the bar" is visible. Arms are 85 px long
(the original files' length) instead of the 78 px of the profile rig.
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from frontview import ORDER_CAPS, Animation, figure  # noqa: E402
from goro_rig import (P, Spec, bar, disc, hold_ramp as ramp, joint_of,  # noqa: E402
                      plant, rot, sampled, write)

BAR_Y = 96
GRIP_Y = BAR_Y - 2                 # fists sit on top of the bar
ARM = (47.0, 38.0)                 # upper arm, forearm: 85 px like the old files
# Arms (and fists) drawn over the head: they reach up past the face.
ARMS_ABOVE_HEAD = ['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r',
                   'body', 'thigh_l', 'shin_l', 'foot_l', 'uarm_l', 'farm_l']
BAR_COL = [0.314, 0.365, 0.451, 1.0]
BAR_HI = [0.392, 0.451, 0.549, 1.0]
HANG_Y = GRIP_Y + sum(ARM) - 6     # shoulder height hanging with slightly bent arms
TOP_Y = GRIP_Y + 32                # shoulder height at the top (the head lifts to clear the bar)


def bar_props(frames):
    """Pull-up bar with its two brackets (sizes of the original files)."""
    return [bar('bar_hi', 200, BAR_Y - 3, 140, 4, BAR_HI, frames, 4, 52),
            bar('bar', 200, BAR_Y, 160, 14, BAR_COL, frames, 7, 53),
            bar('bracket_l', 124, BAR_Y - 18, 8, 28, BAR_COL, frames, 5, 54),
            bar('bracket_r', 276, BAR_Y - 18, 8, 28, BAR_COL, frames, 5, 55)]


def hanging(u, grip=54, sway=0.0, head_up=None, shoulders=None, kick=0.0):
    """A body hanging from the bar, ``u`` = 0 (dead hang) .. 1 (chin over bar).

    ``grip`` is the distance of each fist from the body axis, ``shoulders`` an
    optional (left_dy, right_dy) offset of the shoulders (a one-sided pull),
    ``kick`` bends the knees (a quick step up)."""
    y_s = HANG_Y + (TOP_Y - HANG_Y) * u
    hips = (200 + sway, y_s + 92)
    # The head sinks between the shoulders when hanging and lifts to clear the bar.
    lift = (18 * (1 - u) - 14 * u) if head_up is None else head_up
    sh_l, sh_r = shoulders or ((0, 0), (0, 0))
    arms = {}
    for side, key in ((-1, 'arm_l'), (1, 'arm_r')):
        wrist = (200 + side * grip, GRIP_Y)
        arms[key] = (wrist, (side * 0.6, 1))
    legs = {}
    for side, key in ((-1, 'leg_l'), (1, 'leg_r')):
        hip_x = hips[0] + side * 14
        knee = (hip_x + side * 1, hips[1] + 46 - 14 * kick)
        ankle = (knee[0], knee[1] + 38 - 10 * kick)
        legs[key] = dict(knee=knee, ankle=ankle)
    return figure(hips=hips, head=(0, lift, 0), arm_len=ARM, sh_l=sh_l, sh_r=sh_r,
                  **arms, **legs)


def anim(name, frames, u_fn, **kw):
    def pose(t):
        return hanging(u_fn(t), **kw)
    return Animation(name, frames, pose, props=bar_props, props_index=2,
                     style='paper', floor=False)


# ── pull_s3_pullup ───────────────────────────────────────────────────────────
# Dead hang, pull until the chin is over the bar, short pause, lower under control.

def pullup():
    curve = [(0, 0), (4, 0), (18, 1), (24, 1), (40, 0), (48, 0)]
    return anim('pull_s3_pullup', 48, lambda t: ramp(t, curve))


# ── pull_s2_negative ─────────────────────────────────────────────────────────
# Starts at the top, lowers very slowly (about 3 s), then a quick step-up
# (knees tuck) back to the top for the next rep.

def negative():
    T = 72
    curve = [(0, 1), (8, 1), (52, 0), (56, 0), (66, 1), (72, 1)]

    def pose(t):
        u = ramp(t, curve)
        kick = ramp(t, [(0, 0), (56, 0), (61, 1), (66, 0), (72, 0)])
        return hanging(u, kick=kick)

    return Animation('pull_s2_negative', T, pose, props=bar_props, props_index=2,
                     style='paper', floor=False)


# ── pull_s5_archer ───────────────────────────────────────────────────────────
# Wide grip. One arm pulls and bends while the other stays straight and slides
# along the bar; the body goes up and over to the working side, chin to the
# hand; then the other side.

def archer():
    T = 96
    wide = 78

    def pose(t):
        # +1: pulling on the right of the picture, -1: on the left
        right = ramp(t, [(0, 0), (4, 0), (20, 1), (28, 1), (44, 0), (48, 0)])
        left = ramp(t, [(48, 0), (52, 0), (68, 1), (76, 1), (92, 0), (96, 0)])
        side = right - left
        w = abs(side)
        y_s = HANG_Y + (TOP_Y - HANG_Y) * w
        hips = (200 + side * 26, y_s + 92)
        lift = 18 * (1 - w) - 14 * w
        arms = {}
        for sgn, key in ((-1, 'arm_l'), (1, 'arm_r')):
            working = side * sgn > 0
            grip = wide - (4 if working else 0)
            wrist = (200 + sgn * grip, GRIP_Y)
            arms[key] = (wrist, (sgn * (0.6 if working else 0.0), 1))
        legs = {}
        for sgn, key in ((-1, 'leg_l'), (1, 'leg_r')):
            hip_x = hips[0] + sgn * 14
            knee = (hip_x, hips[1] + 46)
            legs[key] = dict(knee=knee, ankle=(knee[0], knee[1] + 38))
        return figure(hips=hips, lean=side * 4, head=(side * 10 * w, lift, side * 6 * w),
                      arm_len=ARM, **arms, **legs)

    return Animation('pull_s5_archer', T, pose, props=bar_props, props_index=2,
                     style='paper', floor=False)


# ── pull_s6_one_arm ──────────────────────────────────────────────────────────
# One hand on the bar over the body axis, the other arm hangs at the side. The
# body stays square (no rotation) while it goes up until the chin is over the bar.

def one_arm():
    shift = 16                       # the body hangs a little under the working hand

    def pose(t):
        u = ramp(t, [(0, 0), (6, 0), (26, 1), (34, 1), (54, 0), (60, 0)])
        y_s = HANG_Y + 6 + (TOP_Y + 4 - HANG_Y - 6) * u
        hips = (200 + shift, y_s + 92)
        lift = 18 * (1 - u) - 12 * u
        # the free arm hangs along the body (slightly away from it)
        sh_free = (hips[0] - 36, y_s)
        free = ((sh_free[0] - 8, sh_free[1] + 80), (-1, 0))
        wrist = (hips[0] + 36, GRIP_Y)     # hand straight over the working shoulder
        legs = {}
        for sgn, key in ((-1, 'leg_l'), (1, 'leg_r')):
            hip_x = hips[0] + sgn * 14
            knee = (hip_x, hips[1] + 46)
            legs[key] = dict(knee=knee, ankle=(knee[0], knee[1] + 38))
        return figure(hips=hips, head=(0, lift, 0), arm_len=ARM, arm_l=free,
                      arm_r=(wrist, (1, 0.3)), **legs)

    return Animation('pull_s6_one_arm', 60, pose, props=bar_props, props_index=2,
                     style='paper', floor=False)


# ── warmup_dead_hang ─────────────────────────────────────────────────────────
# Passive hang (shoulders up by the ears), then the shoulders pull down and the
# grip wakes up (active hang), then relax again. Small swing of the legs.

def dead_hang():
    T = 60

    def pose(t):
        active = ramp(t, [(0, 0), (8, 0), (24, 1), (40, 1), (54, 0), (60, 0)])
        swing = 3 * math.sin(2 * math.pi * t / T)
        # passive: the shoulders sag up around the ears (body lower); active:
        # the shoulders are pulled down and the body rises a little.
        y_s = HANG_Y + 8 - 12 * active
        sh = (0, -9 * (1 - active))
        hips = (200 + swing, y_s + 92)
        arms = {}
        for sgn, key in ((-1, 'arm_l'), (1, 'arm_r')):
            arms[key] = ((200 + sgn * 46, GRIP_Y), (sgn * 0.6, 1))
        legs = {}
        for sgn, key in ((-1, 'leg_l'), (1, 'leg_r')):
            hip_x = hips[0] + sgn * 14
            knee = (hip_x + 0.5 * swing, hips[1] + 46)
            legs[key] = dict(knee=knee, ankle=(knee[0] + 0.8 * swing, knee[1] + 38))
        return figure(hips=hips, head=(0, 18 - 8 * active, 0), arm_len=ARM,
                      sh_l=sh, sh_r=sh, **arms, **legs)

    return Animation('warmup_dead_hang', T, pose, props=bar_props, props_index=2,
                     style='paper', floor=False, order=ORDER_CAPS)


# ── pull_s4_close_grip ───────────────────────────────────────────────────────
# Side view (the brief asks for side + a close-up of the hands). The bar is seen
# end-on; the athlete hangs, pulls the chin over the bar with the elbows tucked
# in front of the ribs. A small inset shows the narrow grip: two fists side by
# side on the bar.

def close_grip():
    bar_x, bar_y = 254.0, 98.0
    base = P(hip_n=8, hip_f=2, foot_n=(5, 6, 0), foot_f=(5, 6, 0))
    dark = [0.259, 0.259, 0.345, 1.0]

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (18, 1), (24, 1), (40, 0), (48, 0)])
        # shoulder joint: hangs behind the bar, rises towards it
        target = (206 + 22 * u, 176 - 72 * u)
        p = P(base, cx=0.0, cy=0.0, br=-8 * u, ht=-14 * u)
        sh = joint_of(p, 'arm_n')
        p['cx'], p['cy'] = target[0] - sh[0], target[1] - sh[1]
        for limb, dx in (('leg_n', 3), ('leg_f', -2)):
            h = joint_of(p, limb)
            p = plant(p, limb, (h[0] + dx - 4 * u, h[1] + 82 - 10 * u), (1, -1))
        p = plant(p, 'arm_n', (bar_x, bar_y), (0.2, 1))
        p = plant(p, 'arm_f', (bar_x - 3, bar_y), (0.2, 1))
        return p

    def props(frames):
        # inner items first (they are drawn on top), the frame last
        inset = [disc('inset_fist_l', 63, 54, 20, dark, frames, 56),
                 disc('inset_fist_r', 85, 54, 20, dark, frames, 55),
                 bar('inset_arm_l', 63, 86, 14, 44, dark, frames, 6, 57),
                 bar('inset_arm_r', 85, 86, 14, 44, dark, frames, 6, 57),
                 bar('inset_bar_hi', 74, 49, 100, 3, BAR_HI, frames, 2, 58),
                 bar('inset_bar', 74, 52, 104, 12, BAR_COL, frames, 6, 59),
                 bar('inset', 74, 78, 120, 80, [0.1, 0.14, 0.23, 1.0], frames, 9, 60),
                 bar('inset_border', 74, 78, 124, 84, [0.227, 0.314, 0.502, 1.0],
                     frames, 10, 61)]
        return [disc('bar_hi', bar_x, bar_y, 8, BAR_HI, frames, 62),
                disc('bar', bar_x, bar_y, 28, BAR_COL, frames, 63)] + inset

    return Spec('pull_s4_close_grip', 48, sampled(48, pose),
                modes={'arm_n': 'fk', 'arm_f': 'fk', 'leg_n': 'fk', 'leg_f': 'fk'},
                order=ARMS_ABOVE_HEAD, props=props)


ANIMATIONS = {
    'pull_s2_negative': negative,
    'pull_s4_close_grip': close_grip,
    'pull_s3_pullup': pullup,
    'pull_s5_archer': archer,
    'pull_s6_one_arm': one_arm,
    'warmup_dead_hang': dead_hang,
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
