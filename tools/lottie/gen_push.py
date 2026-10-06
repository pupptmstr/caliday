#!/usr/bin/env python3
"""Generates the redrawn Push variations (assets/animations/push_s4..s7_*.json).

Usage: python3 tools/lottie/gen_push.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Profile view in the style of the original push_s1..s3 (``pushup.py`` reuses
their shapes). The variations differ in the hands / elbows, which a side view
cannot show, so the narrow, wide and archer ones carry a small top-down inset.
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import pushup as pu  # noqa: E402
from goro_rig import bar, hold_ramp as ramp, oval, rbar, write  # noqa: E402

FOOT = (65.0, 372.0)
HAND = (265.0, 375.0)
TOP_Y, BOTTOM_Y = 299.0, 355.0       # shoulder height at the top / bottom


def shoulder_at(y_s, foot=FOOT):
    """Shoulder on the straight body line from ``foot`` at height ``y_s``."""
    sin_t = (foot[1] - y_s) / pu.BODY
    return (foot[0] + pu.BODY * math.sqrt(1 - sin_t * sin_t), y_s)


# ── insets: the hands seen from above ────────────────────────────────────────

INSET = (74.0, 78.0)                       # centre of the corner panel
PANEL_BG = [0.1, 0.14, 0.23, 1.0]
PANEL_EDGE = [0.227, 0.314, 0.502, 1.0]
BODY_COL = [0.22, 0.22, 0.298, 1.0]
ARM_COL = [0.36, 0.36, 0.48, 1.0]
HAND_COL = [0.659, 0.847, 1.0, 1.0]        # the headband blue marks the hands


def _arm(name, a, b, frames, ind):
    """A rounded bar from point a to point b (panel coordinates)."""
    d = (b[0] - a[0], b[1] - a[1])
    return rbar(name, (a[0] + b[0]) / 2, (a[1] + b[1]) / 2, math.hypot(*d) + 4, 7,
                math.degrees(math.atan2(d[1], d[0])), ARM_COL, frames, 3, ind)


def top_inset(frames, left, right, diamond=False, left_elbow=None, right_elbow=None):
    """Corner panel with a top-down Goro (head up) and his hands; ``left`` /
    ``right`` are the hand positions, optionally with an elbow each."""
    cx, cy = INSET
    sh_l, sh_r = (cx - 24, cy - 6), (cx + 24, cy - 6)

    def ox(p):
        return (cx + p[0], cy + p[1])

    layers = []
    for nm, hand, elbow, sh in (('l', left, left_elbow, sh_l), ('r', right, right_elbow, sh_r)):
        h = ox(hand)
        layers.append(oval('inset_hand_' + nm, h[0], h[1], 15, 11, HAND_COL, frames, 40))
        if elbow:
            e = ox(elbow)
            layers.append(_arm('inset_fore_' + nm, e, h, frames, 41))
            layers.append(_arm('inset_upper_' + nm, sh, e, frames, 42))
        else:
            layers.append(_arm('inset_arm_' + nm, sh, h, frames, 41))
    if diamond:   # the gap between thumbs and index fingers
        mid = ox(((left[0] + right[0]) / 2, (left[1] + right[1]) / 2 + 1))
        layers.append(rbar('inset_diamond_hole', mid[0], mid[1], 6, 6, 45, PANEL_BG,
                           frames, 1, 38))
        layers.append(rbar('inset_diamond', mid[0], mid[1], 12, 12, 45, HAND_COL,
                           frames, 2, 39))
    layers += [rbar('inset_body', cx, cy - 4, 52, 20, 0, BODY_COL, frames, 8, 43),
               oval('inset_head', cx, cy - 22, 21, 21, BODY_COL, frames, 44),
               bar('inset_bg', cx, cy, 120, 80, PANEL_BG, frames, 9, 45),
               bar('inset_edge', cx, cy, 124, 84, PANEL_EDGE, frames, 10, 46)]
    return layers


# ── the shared push-up cycle ─────────────────────────────────────────────────

def cycle(t, period=48):
    """0 = top, 1 = chest to the floor: lower, brief pause, push up, pause."""
    p = period / 48.0
    return ramp(t, [(0, 0), (4 * p, 0), (22 * p, 1), (26 * p, 1), (40 * p, 0),
                    (48 * p, 0)])


def shoulder_for(low):
    return shoulder_at(TOP_Y + (BOTTOM_Y - TOP_Y) * low)


# ── push_s4_diamond_pushup ───────────────────────────────────────────────────
# Hands together under the chest (the diamond is in the inset); the elbows stay
# tucked along the ribs, so the chest comes down onto the hands.

def diamond():
    def frame(t):
        low = cycle(t)
        return pu.pose(FOOT, shoulder_for(low), (262.0, 375.0), (262.0, 375.0),
                       bend=(-1.0, 0.25))
    return pu.Animation('push_s4_diamond_pushup', 48, frame,
                        props=lambda n: top_inset(n, (-13, 24), (13, 24), diamond=True))


# ── push_s5_wide_pushup ──────────────────────────────────────────────────────
# Hands wide of the shoulders: the elbows flare towards the viewer, so the upper
# arms shorten as the chest lowers and the forearms stay vertical.

def wide():
    def frame(t):
        low = cycle(t)
        S = shoulder_for(low)
        near, far = (272.0, 375.0), (270.0, 375.0)
        elbows = []
        for hand, sh in ((near, S), (far, (S[0] - 10, S[1] + 3))):
            straight = (sh[0] + (hand[0] - sh[0]) * 0.437,
                        sh[1] + (hand[1] - sh[1]) * 0.437)
            flared = (hand[0] - 5, hand[1] - 42)     # forearm vertical, elbow out
            k = low * low * (3 - 2 * low)
            elbows.append((straight[0] + (flared[0] - straight[0]) * k,
                           straight[1] + (flared[1] - straight[1]) * k))
        return pu.pose(FOOT, S, near, far, elbows=tuple(elbows))
    return pu.Animation('push_s5_wide_pushup', 48, frame,
                        props=lambda n: top_inset(n, (-46, 22), (46, 22)))


# ── push_s6_archer_pushup ────────────────────────────────────────────────────
# One arm bends and pulls the body over it, the other stays straight to the
# side. Seen from the side: first the near arm works while the far arm is a
# straight, foreshortened line; then the far arm works (the near arm is the
# straight one, the body is lower on the far side).

def archer():
    T = 96

    def frame(t):
        near = ramp(t, [(0, 0), (4, 0), (22, 1), (26, 1), (40, 0), (48, 0)])
        far = ramp(t - 48, [(0, 0), (4, 0), (22, 1), (26, 1), (40, 0), (48, 0)]) \
            if t >= 48 else 0.0
        low = max(near * 0.95, far * 0.6)
        S = shoulder_for(low)
        far_drop = far * (BOTTOM_Y - S[1] + 4)       # the working far shoulder drops
        return pu.pose(FOOT, S, (266.0, 375.0), (266.0, 375.0), bend=(-1.0, 0.0),
                       far_shoulder=(S[0] - 10, S[1] + 3 + far_drop),
                       straight=(far > 0.01, near > 0.01 and far <= 0.01))

    return pu.Animation('push_s6_archer_pushup', T, frame,
                        props=lambda n: top_inset(
                            n, (-46, 20), (30, 26), right_elbow=(40, 8)))


# ── push_s7_handstand_pushup ─────────────────────────────────────────────────
# Back to the wall: the wall is behind Goro (on the left), the heels rest on it, the
# body is a straight inverted line leaning a little towards the wall. The head hangs
# on the same line, face away from the wall (to the right), and goes down until it
# almost touches the floor ahead of the hands.

HAND_X = 208.0
WALL_SURFACE = HAND_X - 40          # the wall face the heels touch
WALL_COL = [0.165, 0.22, 0.35, 1.0]


def handstand():
    foot_x = WALL_SURFACE + 4
    hand = (HAND_X, 375.0)

    def frame(t):
        low = cycle(t)
        s_y = 299 + (319 - 299) * low
        s_x = HAND_X - 3 + 9 * low
        f_y = s_y - math.sqrt(pu.BODY ** 2 - (s_x - foot_x) ** 2)
        d = pu.norm(pu.sub((s_x, s_y), (foot_x, f_y)))     # feet -> shoulders (down)
        head = pu.add(pu.add((s_x, s_y), pu.mul(d, 31)), (9 * low + 15, 0))
        return pu.pose((foot_x, f_y), (s_x, s_y), hand, (hand[0] - 2, 375.0),
                       head=head, flip=True, bend=(-1.0, 0.0),
                       foot=(5.0, -2.0, 90.0), head_tilt=4.0)

    return pu.Animation('push_s7_handstand_pushup', 48, frame,
                        props=lambda n: [bar('wall', WALL_SURFACE - 10, 200, 20, 400,
                                             WALL_COL, n, 4, 90)])


ANIMATIONS = {
    'push_s4_diamond_pushup': diamond,
    'push_s5_wide_pushup': wide,
    'push_s6_archer_pushup': archer,
    'push_s7_handstand_pushup': handstand,
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
