#!/usr/bin/env python3
"""Generates the Morning Routine exercise animations (assets/animations/morning_*.json).

Usage: python3 tools/lottie/gen_morning.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Every pose of the course is standing. Front views (``frontview.py``): torso
twist, windmill, knee circles, speed skater. ``compose`` takes the legs of one
``figure`` and the upper body of another, so the torso can be placed apart from
the hip joints (a fold towards the camera); ``with_back_copies`` adds a second
copy of a leg drawn behind the other leg, cross-faded, for a foot that steps
behind the standing leg on one side and in front of it on the other.
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from frontview import (FARM, HIP_DX, K, STAND_ANKLE_Y, TORSO_H, UARM,  # noqa: E402
                       Animation, figure)
from goro_rig import (_rc, _single, add, ang_of, dirv, hold_ramp as ramp,  # noqa: E402
                      mul, rot, write)
from topview import CHEST, DARK as TDARK  # noqa: E402

HIPS = (200.0, 288.0)
ARM = UARM + FARM                 # a straight arm
UPPER = ('body', 'head', 'crown', 'cap_l', 'cap_r', 'uarm_l', 'uarm_r',
         'farm_l', 'farm_r', 'hand_l', 'hand_r')
ARMS = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r', 'cap_l', 'cap_r']
LEGS = ['knee_l', 'knee_r', 'thigh_l', 'thigh_r', 'shin_l', 'shin_r', 'foot_l', 'foot_r']
# Standing, the torso over the legs: in a fold towards the camera it comes in
# front of the thighs.
ORDER_FOLD = ARMS + ['head', 'crown', 'body'] + LEGS


def mix(a, b, u):
    return tuple(x + (y - x) * u for x, y in zip(a, b))


def compose(legs, upper):
    """The legs of one ``figure`` and the upper body of another."""
    out = dict(legs)
    for k in UPPER:
        out[k] = upper[k]
    return out


def hips_for(c, lean=0.0):
    """The ``hips`` argument of ``figure`` that puts the torso centre at ``c``."""
    return add(c, rot((0, TORSO_H / 2), lean))


def leg(sx, ankle, hips=HIPS, knee=None, near=1.0, **kw):
    """A leg dict for ``figure``: the knee on the hip–ankle line (at the
    thigh / shin ratio) unless given."""
    hip = (hips[0] + sx * HIP_DX, hips[1])
    if knee is None:
        knee = mix(hip, ankle, 46 / 84)
    return dict(knee=knee, ankle=ankle, near=near, **kw)


def shoulder_points(c, lean=0.0, scale=(1.0, 1.0)):
    """Default (left, right) shoulder points of a torso centred at ``c``."""
    return tuple(add(c, rot((sx * 36 * scale[0], -41 * scale[1]), lean))
                 for sx in (-1, 1))


def with_back_copies(pose_fn, names, front):
    """Adds ``<name>@b`` copies of ``names`` (drawn lower in the order) and
    cross-fades: ``front(t)`` = 1 shows the normal layers, 0 the copies."""
    def fn(t):
        out = pose_fn(t)
        a = front(t)
        for n in names:
            out[n + '@b'] = dict(out[n], o=100 * (1 - a))
            out[n] = dict(out[n], o=100 * a)
        return out
    return fn


# ── morning_spine_s2_torso_twist ─────────────────────────────────────────────
# Feet apart, hips square, the arms loose. The upper body turns from side to
# side and the arms swing round it: one wraps across the belly, the other goes
# behind the back (drawn behind the torso — the arm layers have copies under
# the body, swapped while the arms hang at the sides). The torso narrows, its
# chest patch (a layer of its own) slides towards the side it turns to and the
# head turns with it.

def twist_shapes(name):
    if name == 'body':
        return [_single('torso', _rc(130, 170, (0, 0), 14), TDARK, 1)]
    if name == 'chest':
        return [_single('chest', _rc(116, 30, (0, -52), 8), CHEST, 1),
                _single('abs', _rc(96, 16, (0, 10), 6), CHEST, 2)]
    return None


def torso_twist():
    T = 36
    turn = 55

    def pose(t):
        th = math.radians(turn * math.sin(2 * math.pi * t / T))
        si, co = math.sin(th), math.cos(th)
        w = round(si / math.sin(math.radians(turn)), 9)   # -1..1
        d = 1 if w >= 0 else -1                     # the side it turns to
        ts = 1 - 0.28 * abs(si)
        c = (200 + 3 * si, 237)
        sh_def = shoulder_points(c, 0, (ts, 1))
        arms, offs = {}, {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            sh = (200 + sx * 36 * co + 3 * si, 196)
            offs['sh_' + side] = (sh[0] - sh_def[i][0], 0)
            hang = ((sh[0] + sx * 8, 236), (sh[0] + sx * 13, 268))
            if sx == -d:                            # wraps across the belly
                tgt = ((200 - d * 4, 238), (200 + d * 38, 266))
            else:                                   # goes behind the back
                tgt = ((200 + d * 31, 242), (200 + d * 4, 262))
            a = abs(w)
            elbow, wrist = mix(hang[0], tgt[0], a), mix(hang[1], tgt[1], a)
            arms['arm_' + side] = (wrist, (0, 1), elbow)
        legs = figure(leg_l=leg(-1, (174, STAND_ANKLE_Y)),
                      leg_r=leg(1, (226, STAND_ANKLE_Y)))
        upper = figure(hips=hips_for(c), torso_scale=(ts, 1),
                       head=(12 * si, 0, 0), head_scale=(1 - 0.08 * abs(si), 1),
                       **offs, **arms)
        out = compose(legs, upper)
        cx = ts * (1 - 0.25 * abs(si))
        out['chest'] = dict(p=(c[0] + 14 * si, c[1]), r=0, s=(K * 100 * cx, K * 100))
        # front copies while the arm is in front, the copies under the body
        # while it is behind
        for side, sx in (('l', -1), ('r', 1)):
            front = 100 if w * -sx >= 0 else 0
            for part in ('hand_', 'farm_', 'uarm_'):
                n = part + side
                out[n + '@b'] = dict(out[n], o=100 - front)
                out[n] = dict(out[n], o=front)
        return out

    arms_b = [n + '@b' for n in ARMS[:6]]
    order = ARMS[:6] + ['head', 'crown', 'chest', 'body'] + arms_b + LEGS
    return Animation('morning_spine_s2_torso_twist', T, pose, order=order,
                     shapes_fn=twist_shapes)


# ── morning_spine_s5_windmill ────────────────────────────────────────────────
# Feet wide, arms out to the sides. Bend forward and turn: one hand goes down to
# the opposite foot, the other arm points at the ceiling; up to the T, then the
# other side. Seen from the front the arms turn like the sails of a windmill:
# the shoulder line goes from horizontal to vertical while the torso, folded
# towards the camera, shortens behind the head (whose crown now faces us).

def windmill():
    T = 108
    feet = 52

    def pose(t):
        ua = ramp(t, [(0, 0), (4, 0), (26, 1), (32, 1), (54, 0)])
        ub = ramp(t, [(54, 0), (58, 0), (80, 1), (86, 1), (108, 0)])
        s, u = (1, ua) if t < 54 else (-1, ub)
        lean = -s * 90 * u
        ts = (1.0, 1 - 0.7 * u)
        c = mix((200, 237), (200 + s * 20, 262), u)
        sh = shoulder_points(c, lean, ts)
        arms = {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            a = ang_of(*rot((sx, 0), lean))   # straight, in line with the shoulders
            if sx == -s:                       # the hand that goes to the foot
                foot = (200 + s * (feet - 4), 352)
                to_foot = ang_of(foot[0] - sh[i][0], foot[1] - sh[i][1])
                a += ((to_foot - a + 180) % 360 - 180) * u
            d = dirv(a)
            arms['arm_' + side] = (add(sh[i], mul(d, ARM)), (0, 1),
                                   add(sh[i], mul(d, UARM)))
        legs = figure(leg_l=leg(-1, (200 - feet, STAND_ANKLE_Y)),
                      leg_r=leg(1, (200 + feet, STAND_ANKLE_Y)))
        crown = min(1.0, max(0.0, (u - 0.35) / 0.4))
        upper = figure(hips=hips_for(c, lean), lean=lean, torso_scale=ts,
                       head=(s * 12 * u, 36 * u, s * 90 * u), crown=crown, **arms)
        return compose(legs, upper)

    return Animation('morning_spine_s5_windmill', T, pose, order=ORDER_FOLD)


# ── morning_joints_s1_knee_circles ───────────────────────────────────────────
# Feet together, knees bent, leaning forward with the hands just above the
# knees. The knees draw circles: two one way, two the other. The side-to-side
# part is plain; the forward part shows as the knee caps growing (towards the
# camera) and the knees rising a little.

def knee_circles():
    T = 48
    hips = (200.0, 304.0)
    c = (200.0, 304.0 - 34)                    # folded torso sits on the hips
    fold = 0.55

    def pose(t):
        phi = 2 * math.pi * t / 24 if t < 24 else -2 * math.pi * (t - 24) / 24
        dx, fwd = 15 * math.cos(phi), math.sin(phi)
        hx = hips[0] - 0.3 * dx
        hp = (hx, hips[1])
        knees = {}
        for side, sx in (('l', -1), ('r', 1)):
            knee = (200 + sx * 10 + dx, 334 - 3 * fwd)
            knees['leg_' + side] = leg(sx, (200 + sx * 9, STAND_ANKLE_Y), hips=hp,
                                       knee=knee, near=1.15 + 0.12 * fwd)
        legs = figure(hips=hp, **knees)
        arms = {}
        for side, sx in (('l', -1), ('r', 1)):
            k = knees['leg_' + side]['knee']
            arms['arm_' + side] = ((k[0] + sx * 3, k[1] - 16), (sx, 0))
        cc = (c[0] - 0.2 * dx, c[1])
        upper = figure(hips=hips_for(cc), torso_scale=(1 + 0.08 * fold, 1 - 0.5 * fold),
                       head=(0, 60 * fold, 0), head_scale=(1, 1 - 0.1 * fold),
                       arm_len=(UARM * 1.08, FARM * 1.08), **arms)
        return compose(legs, upper)

    return Animation('morning_joints_s1_knee_circles', T, pose, order=ORDER_FOLD)


# ── morning_energy_s4_speed_skater ───────────────────────────────────────────
# A skater's step without the hop: standing on one bent leg, the other foot
# crossed behind it, the opposite arm swinging across the body. The back foot
# steps out wide to the other side, the weight moves over, and the first foot
# sweeps behind the new standing leg; then back. The foot that goes behind is
# drawn behind the standing leg: the left leg has a copy below the right one,
# swapped in while the feet are apart.

def speed_skater():
    T = 48
    stand_x, behind_x = 46, 56                 # ankle x from the axis
    hips_y, hips_y_up = 310.0, 292.0
    lean_k = 7                                 # torso tilts over the standing leg

    def state(s):
        """Ankles by side and hips x with the weight on side ``s``."""
        ankles = {s: (200 + s * stand_x, STAND_ANKLE_Y),
                  -s: (200 + s * behind_x, STAND_ANKLE_Y - 12)}   # behind, past it
        return ankles, 200 + s * 34

    def arms_for(sh, c, s, w):
        """Arms with the weight on side ``s`` (``w`` 0..1 from hanging)."""
        out = {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            shoulder = sh[i]
            hang_e = add(shoulder, (sx * 4, 40))
            hang_w = add(shoulder, (sx * 6, 72))
            if sx == -s:                       # swings across, low
                e = add(shoulder, (s * 10, 36))
                wr = (c[0] + s * 36, shoulder[1] + 66)
            else:                              # swings back and out
                e = add(shoulder, (sx * 24, 26))
                wr = add(shoulder, (sx * 44, 44))
            out['arm_' + side] = (mix(hang_w, wr, w), (0, 1), mix(hang_e, e, w))
        return out

    def pose(t):
        # 0..24: weight on the left (-1) -> right (+1); 24..48: back again.
        if t < 24:
            s0, s1, u = -1, 1, t / 24
        else:
            s0, s1, u = 1, -1, (t - 24) / 24
        a0, hx0 = state(s0)
        a1, hx1 = state(s1)
        step = ramp(u, [(0, 0), (0.12, 0), (0.55, 1), (1, 1)])    # the back foot steps out
        sweep = ramp(u, [(0, 0), (0.45, 0), (0.88, 1), (1, 1)])   # the other sweeps behind
        shift = ramp(u, [(0, 0), (0.2, 0), (0.75, 1), (1, 1)])
        ank = {}
        for sx, k in ((-s0, step), (s0, sweep)):
            p = mix(a0[sx], a1[sx], k)
            ank[sx] = (p[0], p[1] - 12 * math.sin(math.pi * k))
        hx = hx0 + (hx1 - hx0) * shift
        hy = hips_y - (hips_y - hips_y_up) * math.sin(math.pi * shift)
        hp = (hx, hy)
        legs_kw = {}
        for side, sx in (('l', -1), ('r', 1)):
            hip = (hx + sx * HIP_DX, hy)
            ankle = ank[sx]
            # weight on this leg: knee bent out and towards the camera
            load = (1 - shift) if sx == s0 else shift
            knee = add(mix(hip, ankle, 46 / 84), (sx * 6 * load, -5 * load))
            legs_kw['leg_' + side] = dict(knee=knee, ankle=ankle, near=1.0 + 0.3 * load)
        legs = figure(hips=hp, **legs_kw)
        lean = lean_k * (s0 * (1 - shift) + s1 * shift)
        c = add(hp, rot((0, -51 + 6), lean))
        ts = (1, 0.88)
        sh = shoulder_points(c, lean, ts)
        w = abs(math.cos(math.pi * u))         # arms pass by hanging mid-step
        s_arm = s0 if u < 0.5 else s1
        upper = figure(hips=hips_for(c, lean), lean=lean, torso_scale=ts,
                       head=(0, 8, 0), **arms_for(sh, c, s_arm, w))
        return compose(legs, upper)

    def front(t):
        # the left leg is in front while it stands (weight on -1) or steps out
        # to the left; behind while it sweeps behind the right leg.
        if t < 24:
            return 1.0 if t < 12 else 0.0
        return 0.0 if t < 36 else 1.0

    order = ARMS + ['head', 'crown', 'body', 'knee_l', 'thigh_l', 'shin_l', 'foot_l',
                    'knee_r', 'thigh_r', 'shin_r', 'foot_r',
                    'knee_l@b', 'thigh_l@b', 'shin_l@b', 'foot_l@b']
    names = ['knee_l', 'thigh_l', 'shin_l', 'foot_l']
    return Animation('morning_energy_s4_speed_skater', T,
                     with_back_copies(pose, names, front), order=order)


ANIMATIONS = {
    'morning_spine_s2_torso_twist': torso_twist,
    'morning_spine_s5_windmill': windmill,
    'morning_joints_s1_knee_circles': knee_circles,
    'morning_energy_s4_speed_skater': speed_skater,
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
