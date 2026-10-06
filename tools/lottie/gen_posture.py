#!/usr/bin/env python3
"""Generates the Posture-branch exercise animations (assets/animations/posture_*.json).

Usage: python3 tools/lottie/gen_posture.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Not generated here: ``posture_s2_dead_bug`` reuses ``supp_dead_bug.json`` and
``posture_s5_kneeling_lunge`` reuses ``flex_s1_hip_flexor_stretch.json`` (the
catalog points at those files). ``posture_s6_pigeon_pose`` deliberately has no
animation: the shin across the body points at the camera in profile and a front
view hides it (owner decision 2026-10-06). ``posture_s4_hip_march`` is a front
view built on ``frontview.py``.
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from frontview import Animation, figure  # noqa: E402
from goro_rig import (P, SHIN, Spec, THIGH, WAIST, add, joint_of,  # noqa: E402
                      plant, rot, write)

FLOOR = 376
# Lying on the back the hip joints sit low in the pelvis (towards the floor).
LYING_HIPS = dict(hip_n=-6, hip_f=-12)
ALL_FK = {'leg_n': 'fk', 'leg_f': 'fk', 'arm_n': 'fk', 'arm_f': 'fk'}
# Layer order for split-torso poses: 'body' is replaced by torso_u + pelvis.
SPLIT_ORDER = ['head', 'uarm_r', 'farm_r', 'thigh_r', 'shin_r', 'foot_r',
               'torso_u', 'pelvis', 'thigh_l', 'shin_l', 'foot_l', 'uarm_l',
               'farm_l']


def smoothstep(u):
    u = min(1.0, max(0.0, u))
    return u * u * (3 - 2 * u)


def sampled(frames, pose_fn, step=2):
    """Dense linear keys: the pose is computed exactly every ``step`` frames,
    so poses that depend on a pinned contact never drift between key poses."""
    ts = list(range(0, frames + 1, step))
    if ts[-1] != frames:
        ts.append(frames)
    return [(t, pose_fn(t), 'linear') for t in ts]


# ── posture_s1_pelvic_tilt ───────────────────────────────────────────────────
# Lying on the back, knees bent, feet flat. The torso is split at the waist:
# at rest the lower back is arched off the floor (a gap under the waist); in the
# tilt the pelvis rolls, the tailbone curls up and the lumbar spine presses flat.

LYING_DX = 20                       # centres the lying figure in the frame
TORSO_CENTER = (175.0 + LYING_DX, 348.0)   # flat: spans x 145..245, y 320..376
HEAD_LYING = (1, -83)


def lying_pose(base, alpha, pel=None, **kw):
    """Back on the floor with the upper torso lifted ``alpha`` degrees at the
    waist. ``pel`` None = pelvis lowered until it touches the floor again (the
    arch); otherwise an explicit pelvis rotation (negative = tailbone up)."""
    pivot = (TORSO_CENTER[0] - 50, FLOOR)            # head-end back corner
    br = -90 - alpha
    c = add(pivot, rot((50, -28), -alpha))
    if pel is None:
        w = add(c, rot(WAIST, br))
        # Find the pelvis angle that puts its back/hip-end corner on the floor.
        lo, hi = 0.0, 40.0
        for _ in range(40):
            mid = (lo + hi) / 2
            corner = add(w, rot(rot((-28, 50 - WAIST[1]), br + mid), 0))
            if corner[1] > FLOOR:
                hi = mid
            else:
                lo = mid
        pel = (lo + hi) / 2
    return P(base, cx=c[0], cy=c[1], br=br, pel=pel, head=HEAD_LYING, **kw)


def hold_ramp(t, points):
    """Piecewise 0..1 curve from (frame, value) points, eased between them."""
    for (t0, v0), (t1, v1) in zip(points, points[1:]):
        if t0 <= t <= t1:
            return v0 + (v1 - v0) * smoothstep((t - t0) / (t1 - t0))
    return points[-1][1]


def pelvic_tilt():
    base = P(**LYING_HIPS, arm_n=(-90, -90), arm_f=(-90, -90),
             foot_n=(5, 4, 0), foot_f=(5, 4, 0))
    # Feet stay planted: knees bent, shins close to vertical.
    feet = {'leg_n': (262 + LYING_DX, 366), 'leg_f': (270 + LYING_DX, 366)}
    ALPHA, TAIL = 5.0, -7.0

    def pose(u):
        """u = 0: lower back arched off the floor, u = 1: pressed flat."""
        alpha = ALPHA * (1 - u)
        arch_pel = lying_pose(base, alpha)['pel']
        p = lying_pose(base, alpha, arch_pel * (1 - u) + TAIL * u)
        for limb, target in feet.items():
            p = plant(p, limb, target, (0, -1))
        return p

    curve = [(0, 0), (8, 0), (22, 1), (40, 1), (54, 0), (60, 0)]
    return Spec(
        'posture_s1_pelvic_tilt', 60,
        sampled(60, lambda t: pose(hold_ramp(t, curve))),
        modes=ALL_FK, order=SPLIT_ORDER)


# ── posture_s3_glute_bridge ──────────────────────────────────────────────────
# Lying, feet flat. The hips rise until shoulder, hip and knee are in one line
# (shoulders stay on the floor), a short squeeze at the top, then back down.

def bridge_pose(base, theta, foot_x):
    pivot = (TORSO_CENTER[0] - 50, FLOOR)
    c = add(pivot, rot((50, -28), -theta))
    br = -90 - theta
    # The head stays where it lay, face up: counter-rotate it against the torso.
    head_world = (TORSO_CENTER[0] - 83, TORSO_CENTER[1] - 1)
    local = rot((head_world[0] - c[0], head_world[1] - c[1]), -br)
    p = P(base, cx=c[0], cy=c[1], br=br, head=local, ht=theta)
    p = plant(p, 'leg_n', (foot_x, 366), (0, -1))
    p = plant(p, 'leg_f', (foot_x + 6, 366), (0, -1))
    shoulder = joint_of(p, 'arm_n')
    p = plant(p, 'arm_n', (shoulder[0] + 76, 365), (0, -1))
    shoulder = joint_of(p, 'arm_f')
    p = plant(p, 'arm_f', (shoulder[0] + 80, 365), (0, -1))
    return p


def glute_bridge():
    base = P(**LYING_HIPS, foot_n=(5, 4, 0), foot_f=(5, 4, 0))
    top = 30.0
    foot_x = 252 + LYING_DX

    def pose(u):
        return bridge_pose(base, top * u, foot_x)

    curve = [(0, 0), (6, 0), (26, 1), (30, 1.06), (38, 1.06), (44, 1),
             (56, 0), (60, 0)]
    return Spec(
        'posture_s3_glute_bridge', 60,
        sampled(60, lambda t: pose(hold_ramp(t, curve))),
        modes=ALL_FK)


# ── posture_s4_hip_march ─────────────────────────────────────────────────────
# Front view (frontview.py). Standing tall, hands on the hips; one knee comes up
# towards the camera to hip height (the thigh foreshortens to a stub with the
# knee cap on top, the shin hangs below, the foot leaves the floor), then down,
# then the other side.

def hip_march():
    hips = (200.0, 288.0)

    def pose(t):
        # right side of the picture first, then the left; 24 frames per rep
        up_r = hold_ramp(t, [(0, 0), (3, 0), (10, 1), (15, 1), (22, 0), (48, 0)])
        up_l = hold_ramp(t, [(0, 0), (27, 0), (34, 1), (39, 1), (46, 0), (48, 0)])
        shift = 3.0 * (up_r - up_l)          # weight moves over the standing leg

        def leg(side, up):
            hip_x = hips[0] + side * 14 - shift * 0.0
            ph = math.radians(88 * up)       # thigh elevation from vertical
            knee = (hip_x + side * 2 * up,
                    hips[1] + THIGH * math.cos(ph) + 3 * math.sin(ph))
            ankle = (knee[0] + side * 1.5 * up, knee[1] + SHIN * (1 - 0.1 * up))
            if up < 0.001:
                return None
            return dict(knee=knee, ankle=ankle, near=1 + 0.22 * up)

        h = (hips[0] - shift, hips[1] - 2.0 * max(up_l, up_r))
        arms = {}
        for side, key in ((-1, 'arm_l'), (1, 'arm_r')):
            arms[key] = ((h[0] + side * 30, h[1] - 22), (side, 0))
        return figure(hips=h, **arms, leg_l=leg(-1, up_l), leg_r=leg(1, up_r))

    return Animation('posture_s4_hip_march', 48, pose)


ANIMATIONS = {
    'posture_s1_pelvic_tilt': pelvic_tilt,
    'posture_s3_glute_bridge': glute_bridge,
    'posture_s4_hip_march': hip_march,
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
