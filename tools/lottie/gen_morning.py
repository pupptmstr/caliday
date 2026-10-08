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
from frontview import (FARM, HIP_DX, K, ORDER_CAPS, SHIN_LEN, STAND_ANKLE_Y,  # noqa: E402
                       THIGH_LEN, TORSO_H, UARM, Animation, elbow_of, figure)
from goro_rig import (_rc, _single, add, ang_of, dirv, hold_ramp as ramp,  # noqa: E402
                      mul, rot, write)
from topview import CHEST, DARK as TDARK  # noqa: E402
import goro_rig as gr  # noqa: E402
from gen_supp import raised_foot  # noqa: E402
from gen_evening import LEG_LIGHT  # noqa: E402

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


# ── Front-view helpers ───────────────────────────────────────────────────────

# Hands behind the head: the head covers the fists and the ends of the forearms.
HEAD_OVER_HANDS = ['head', 'crown'] + ORDER_CAPS[:8] + ORDER_CAPS[9:]

def straight(sh, a, length=ARM):
    """A straight arm from shoulder ``sh`` at world angle ``a`` (0 = down,
    +90 = out to the left of the picture), ``length`` foreshortened when the
    arm points towards the camera: ``(wrist, bend, elbow)`` for ``figure``."""
    d = dirv(a)
    return (add(sh, mul(d, length)), (0, 1), add(sh, mul(d, UARM * length / ARM)))


def bent_leg(sx, hips, ankle, bend, near=1.0, **kw):
    """A leg dict whose knee is solved by IK (lunges: the knee goes out over
    the toes)."""
    hip = (hips[0] + sx * HIP_DX, hips[1])
    knee, ankle = elbow_of(hip, ankle, bend, THIGH_LEN, SHIN_LEN)
    return dict(knee=knee, ankle=ankle, near=near, **kw)


def lerp_keys(keys, v):
    """Piecewise-linear blend of key tuples (each a tuple of points / numbers)
    at ``v`` in 0..len(keys)-1."""
    i = min(int(v), len(keys) - 2)
    f = v - i
    out = []
    for a, b in zip(keys[i], keys[i + 1]):
        out.append(mix(a, b, f) if isinstance(a, tuple) else a + (b - a) * f)
    return out


def clasped(sh, c, s=0):
    """Hands together in front of the chest (balance in lunges and squats)."""
    out = {}
    for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
        out['arm_' + side] = ((c[0] + s * 2 + sx * 3, sh[i][1] + 42), (0, 1),
                              add(sh[i], (sx * 12, 32)))
    return out


# ── warmup_morning_stretch_up ────────────────────────────────────────────────
# Breathing in, both straight arms rise through the sides to a V overhead and
# Goro rises onto his toes (the body goes up, the feet stand taller); breathing
# out, heels and arms come down.

def stretch_up():
    T = 48

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (20, 1), (28, 1), (44, 0), (48, 0)])
        rise = 8 * ramp(t, [(0, 0), (10, 0), (20, 1), (28, 1), (38, 0), (48, 0)])
        hips = (200.0, 288 - rise)
        legs = {}
        for side, sx in (('l', -1), ('r', 1)):
            ankle = (200 + sx * 15, STAND_ANKLE_Y - rise)
            legs['leg_' + side] = dict(knee=(200 + sx * 14.5, ankle[1] - SHIN_LEN), ankle=ankle,
                                       foot_off=(0, (5 + rise) / 2),
                                       foot_scale=(1 - 0.012 * rise, (13 + rise) / 13))
        ts = (1.0, 1 + 0.03 * u)
        c = add(hips, (0, -51))
        sh = shoulder_points(c, 0, ts)
        arms = {f'arm_{side}': straight(sh[i], -sx * (6 + 158 * u))
                for i, (side, sx) in enumerate((('l', -1), ('r', 1)))}
        return figure(hips=hips, torso_scale=ts, head=(0, -2 * u, 0), **legs, **arms)

    return Animation('warmup_morning_stretch_up', T, pose)


# ── morning_spine_s1_side_bend ───────────────────────────────────────────────
# One arm rises through the side and curves over the head while the torso leans
# the other way; the other hand slides down the thigh. Back up, other side.

def side_bend():
    T = 96

    def pose(t):
        ua = ramp(t, [(0, 0), (2, 0), (22, 1), (28, 1), (48, 0)])
        ub = ramp(t, [(48, 0), (50, 0), (70, 1), (76, 1), (96, 0)])
        s, u = (1, ua) if t < 48 else (-1, ub)      # s: the side it bends to
        lean = s * 20 * u
        hips = (200 - s * 4 * u, 288.0)
        c = add(hips, rot((0, -51), lean))
        sh = shoulder_points(c, lean)
        arms = {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            if sx == -s:                            # raised, over the head
                a1 = -sx * (6 + 160 * u) + lean
                a2 = a1 - sx * 62 * u
                elbow = add(sh[i], mul(dirv(a1), UARM))
                arms['arm_' + side] = (add(elbow, mul(dirv(a2), FARM)), (0, 1), elbow)
            else:                                   # hangs along the thigh
                arms['arm_' + side] = straight(sh[i], -sx * 6)
        legs = figure(leg_l=leg(-1, (185, STAND_ANKLE_Y)), leg_r=leg(1, (215, STAND_ANKLE_Y)))
        upper = figure(hips=hips_for(c, lean), lean=lean, **arms)
        return compose(legs, upper)

    return Animation('morning_spine_s1_side_bend', T, pose)


# ── morning_joints_s2_open_the_gate ──────────────────────────────────────────
# Hands on the hips. One knee comes up in front (the thigh foreshortens, the
# knee cap grows), swings out to the side (the thigh at full length) and the
# foot comes down; then the other leg.

def open_the_gate():
    T = 64

    def moving_leg(sx, v):
        hx = 200 + sx * HIP_DX
        keys = [((hx + sx * 0.5, 334.0), (hx + sx, 372.0), 1.0),
                ((hx + sx * 2, 291.0), (hx + sx * 3, 329.0), 1.32),
                ((hx + sx * 44, 281.0), (hx + sx * 46, 319.0), 1.0),
                ((hx + sx * 0.5, 334.0), (hx + sx, 372.0), 1.0)]
        knee, ankle, near = lerp_keys(keys, v)
        return dict(knee=knee, ankle=ankle, near=near)

    def pose(t):
        sx = 1 if t < 32 else -1
        v = ramp(t % 32, [(0, 0), (2, 0), (9, 1), (11, 1), (19, 2), (21, 2), (29, 3), (32, 3)])
        w = min(1.0, v, 3 - v)
        hips = (200 - sx * 4 * w, 288 - 2 * w)
        legs = {f'leg_{"r" if sx > 0 else "l"}': moving_leg(sx, v)}
        arms = {f'arm_{side}': ((hips[0] + k * 36, hips[1] - 22), (k, 0))
                for side, k in (('l', -1), ('r', 1))}
        return figure(hips=hips, **legs, **arms)

    return Animation('morning_joints_s2_open_the_gate', T, pose)


# ── morning_joints_s4_side_lunge ─────────────────────────────────────────────
# Hands together at the chest. One foot steps wide to the side and the hips sit
# back over it (that knee bends out over the toes, the other leg straight);
# push back to standing, then the other side.

def side_lunge():
    T = 72

    def pose(t):
        s = 1 if t < 36 else -1
        v = ramp(t % 36, [(0, 0), (2, 0), (6, 1), (10, 2), (16, 3), (20, 3), (26, 2), (30, 1), (34, 0), (36, 0)])
        keys = [((200.0, 288.0), (200 + s * 20, 372.0)),
                ((200 + s * 14, 294.0), (200 + s * 60, 356.0)),
                ((200 + s * 36, 306.0), (200 + s * 100, 372.0)),
                ((200 + s * 56, 318.0), (200 + s * 100, 372.0))]
        hips, out_ankle = lerp_keys(keys, v)
        depth = max(0.0, v - 1) / 2
        side_out = 'r' if s > 0 else 'l'
        side_in = 'l' if s > 0 else 'r'
        out_leg = (bent_leg(s, hips, out_ankle, (s, -0.5), near=1 + 0.12 * depth) if v > 1e-6
                   else leg(s, out_ankle, hips=hips))
        legs = {'leg_' + side_out: out_leg,
                'leg_' + side_in: leg(-s, (200 - s * 20, STAND_ANKLE_Y), hips=hips)}
        ts = (1.0, 1 - 0.06 * depth)
        lean = s * 5 * depth
        c = add(hips, rot((0, -51 * ts[1]), lean))
        sh = shoulder_points(c, lean, ts)
        upper = figure(hips=hips_for(c, lean), lean=lean, torso_scale=ts, **clasped(sh, c))
        return compose(figure(hips=hips, **legs), upper)

    return Animation('morning_joints_s4_side_lunge', T, pose)


# ── morning_joints_s5_cossack_squat ──────────────────────────────────────────
# Feet very wide. The hips sink deep over one leg (its knee out over the toes)
# while the other leg stays straight with the toes turned up; through the middle
# to the other side and back.

def cossack_squat():
    T = 64
    feet = 56

    def pose(t):
        x = ramp(t, [(0, 0), (4, 0), (18, 1), (24, 1), (48, -1), (54, -1), (64, 0)])
        d = abs(x)
        s = 1 if x >= 0 else -1
        hips = (200 + x * 32, 300 + 32 * d)
        legs = {}
        for side, sx in (('l', -1), ('r', 1)):
            ankle = (200 + sx * feet, STAND_ANKLE_Y)
            if sx == s and d > 0:                   # the bent leg
                legs['leg_' + side] = bent_leg(sx, hips, ankle, (sx, -0.7), near=1 + 0.15 * d)
            else:                                   # straight, toes turning up
                k = d
                legs['leg_' + side] = leg(sx, ankle, hips=hips, foot_rot=90 * k,
                                          foot_scale=(1.0, 1 - 0.15 * k), foot_off=(sx * 5 * k, 4 - 16 * k))
        ts = (1.0, 1 - 0.08 * d)
        lean = -x * 5
        c = add(hips, rot((0, -51 * ts[1]), lean))
        sh = shoulder_points(c, lean, ts)
        upper = figure(hips=hips_for(c, lean), lean=lean, torso_scale=ts, **clasped(sh, c))
        return compose(figure(hips=hips, **legs), upper)

    return Animation('morning_joints_s5_cossack_squat', T, pose)


# ── morning_arms_s1_arm_swings ───────────────────────────────────────────────
# Arms open wide (the chest opens), then swing in to a hug, the hands at the
# opposite shoulders; open again and hug with the other arm on top (the left arm
# has copies under the right one for the second hug).

def arm_swings():
    T = 64

    def pose(t):
        h1 = ramp(t, [(0, 0), (4, 0), (16, 1), (20, 1), (32, 0)])
        h2 = ramp(t, [(32, 0), (36, 0), (48, 1), (52, 1), (64, 0)])
        top, u = (-1, h1) if t < 32 else (1, h2)
        c = (200.0, 237.0)
        sh = shoulder_points(c)
        arms, offs = {}, {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            open_e, open_w = add(sh[i], (sx * 42, -8)), add(sh[i], (sx * 76, -16))
            on_top = sx == top
            hug_e = (200 + sx * 12, 234.0 if on_top else 240.0)
            hug_w = (200 - sx * 30, 204.0 if on_top else 212.0)
            arms['arm_' + side] = (mix(open_w, hug_w, u), (0, 1), mix(open_e, hug_e, u))
            offs['sh_' + side] = (sx * 3 * (1 - u) - sx * 4 * u, 2 * u)
        out = figure(head=(0, 3 * u - 2 * (1 - u), 0), **offs, **arms)
        front = 0 if 32 <= t < 64 else 100
        for part in ('hand_l', 'farm_l', 'uarm_l'):
            out[part + '@b'] = dict(out[part], o=100 - front)
            out[part] = dict(out[part], o=front)
        return out

    order = ['hand_l', 'farm_l', 'uarm_l', 'hand_r', 'farm_r', 'uarm_r',
             'hand_l@b', 'farm_l@b', 'uarm_l@b', 'cap_l', 'cap_r'] + ORDER_CAPS[8:]
    return Animation('morning_arms_s1_arm_swings', T, pose, order=order)


# ── morning_arms_s2_y_raises ─────────────────────────────────────────────────
# Leaning forward from the hips (the torso foreshortens towards the camera),
# the straight arms rise from hanging to a Y, the shoulders squeeze back, and
# lower again.

def y_raises():
    T = 44
    k = 0.55

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (17, 1), (23, 1), (38, 0), (44, 0)])
        hips = (200.0, 292.0)
        legs = figure(hips=hips, leg_l=leg(-1, (184, STAND_ANKLE_Y), hips=hips, near=1.1),
                      leg_r=leg(1, (216, STAND_ANKLE_Y), hips=hips, near=1.1))
        ts = (1 + 0.08 * k, 1 - 0.55 * k)
        c = (200.0, hips[1] - 51 * ts[1])
        sh = shoulder_points(c, 0, ts)
        arms, offs = {}, {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            arms['arm_' + side] = straight(sh[i], -sx * (4 + 146 * u), ARM * (1 - 0.15 * u))
            offs['sh_' + side] = (-sx * 3 * u, -2 * u)
        upper = figure(hips=hips_for(c), torso_scale=ts, head=(0, 74 * k, 0),
                       head_scale=(1 + 0.04 * k, 1 - 0.14 * k), **offs, **arms)
        return compose(legs, upper)

    return Animation('morning_arms_s2_y_raises', T, pose, order=ORDER_CAPS)


# ── morning_arms_s3_cactus_arms ──────────────────────────────────────────────
# Upper arms out at shoulder height, forearms up like a cactus. The forearms
# turn forward and down (pointing at the camera half-way: a short stub and a
# bigger fist) until they point at the floor, then back up.

def cactus_arms():
    T = 48

    def pose(t):
        phi = math.radians(180 * ramp(t, [(0, 0), (6, 0), (20, 1), (26, 1), (40, 0), (48, 0)]))
        c = (200.0, 237.0)
        sh = shoulder_points(c)
        arms, offs = {}, {}
        up = 1 - phi / math.pi
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            elbow = add(sh[i], (sx * UARM, 0))
            # the forearm swings a little outwards while it points at the
            # camera, so it turns through the side instead of flipping
            arms['arm_' + side] = ((elbow[0] + sx * 24 * math.sin(phi), elbow[1] - FARM * math.cos(phi)),
                                   (0, 1), elbow)
            offs['sh_' + side] = (-sx * 2 * up, -1.5 * up)
        out = figure(**offs, **arms)
        grow = 1 + 0.35 * math.sin(phi)
        for side in ('l', 'r'):
            out['hand_' + side] = dict(out['hand_' + side], s=(K * 100 * grow, K * 100 * grow))
        return out

    return Animation('morning_arms_s3_cactus_arms', T, pose, order=ORDER_CAPS)


# ── morning_energy_s1_step_jacks ─────────────────────────────────────────────
# Jumping jacks without the jump: one foot steps out to the side as both
# straight arms swing up to a V; back together; then the other foot.

def step_jacks():
    T = 60

    def pose(t):
        s = 1 if t < 30 else -1
        u = ramp(t % 30, [(0, 0), (14, 1), (28, 0), (30, 0)])
        hips = (200 + s * 4 * u, 288 + 8 * u)
        lift = 10 * math.sin(math.pi * u)
        out_side, in_side = ('r', 'l') if s > 0 else ('l', 'r')
        legs = {'leg_' + out_side: leg(s, (200 + s * (15 + 33 * u), STAND_ANKLE_Y - lift), hips=hips),
                'leg_' + in_side: leg(-s, (200 - s * 15, STAND_ANKLE_Y), hips=hips, near=1 + 0.08 * u)}
        c = add(hips, (0, -51))
        sh = shoulder_points(c)
        arms = {f'arm_{side}': straight(sh[i], -sx * (8 + 140 * u))
                for i, (side, sx) in enumerate((('l', -1), ('r', 1)))}
        return figure(hips=hips, **legs, **arms)

    return Animation('morning_energy_s1_step_jacks', T, pose)


# ── morning_energy_s3_cross_crunch ───────────────────────────────────────────
# Hands behind the head, elbows wide. One knee comes up towards the camera and
# across while the opposite elbow comes down to meet it (that shoulder drops
# and turns in, the torso narrows); then the other side.

def cross_crunch():
    T = 48

    def pose(t):
        s = 1 if t < 24 else -1                     # the knee that lifts
        u = ramp(t % 24, [(0, 0), (1, 0), (11, 1), (13, 1), (23, 0), (24, 0)])
        hips = (200 + s * 2 * u, 288 - 2 * u)
        knee_side = 'r' if s > 0 else 'l'
        hx = hips[0] + s * HIP_DX
        # the knee comes up towards the camera to hip height (never past the
        # hip joint, or the foreshortened thigh would flip)
        lifted = dict(knee=(hx - s * 8 * u, 334 - 44 * u), ankle=(hx - s * 4 * u, 372 - 40 * u),
                      near=1 + 0.4 * u) if u > 1e-6 else None
        legs = figure(hips=hips, **{'leg_' + knee_side: lifted})
        ts = (1 - 0.12 * u, 1 - 0.1 * u)
        lean = s * 6 * u
        c = add(hips, rot((0, -51 * ts[1]), lean))
        sh_def = shoulder_points(c, lean, ts)
        head_c = add(c, (s * 6 * u, -54 * ts[1] - 36 + 8 * u))
        arms, offs = {}, {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            crunching = sx == -s                    # the elbow that goes to the knee
            off = (s * 14 * u, 12 * u) if crunching else (0, -2 * u)
            offs['sh_' + side] = off
            shp = add(sh_def[i], off)
            wrist = (head_c[0] + sx * 14, head_c[1] - 4)
            rest_e = elbow_of(shp, wrist, (sx, -0.4))[0]
            if crunching:
                # the upper arm turns down to the knee by its angle
                tgt = (hx - s * 10, 262.0)
                a0 = ang_of(rest_e[0] - shp[0], rest_e[1] - shp[1])
                a1 = ang_of(tgt[0] - shp[0], tgt[1] - shp[1])
                delta = (a1 - a0) % 360           # always round the outside
                if sx < 0:
                    delta -= 360
                a = a0 + delta * u
                r0, r1 = math.dist(rest_e, shp), math.dist(tgt, shp)
                elbow = add(shp, mul(dirv(a), r0 + (r1 - r0) * u))
                arms['arm_' + side] = (wrist, (0, 1), elbow)
            else:
                arms['arm_' + side] = (wrist, (sx, -0.4))
        upper = figure(hips=hips_for(c, lean), lean=lean, torso_scale=ts,
                       head=(s * 6 * u, 8 * u, s * 4 * u), **offs, **arms)
        return compose(legs, upper)

    # hands behind the head: the head is drawn over the fists and forearms
    return Animation('morning_energy_s3_cross_crunch', T, pose, order=HEAD_OVER_HANDS)


# ── cooldown_shake_out ───────────────────────────────────────────────────────
# Standing loose: the hands and forearms shake, the knees bounce softly; the
# shaking fades into one deep breath (the shoulders rise and fall). Sampled
# every frame: the shake is faster than the usual 2-frame keys.

def shake_out():
    T = 48

    def pose(t):
        env = ramp(t, [(0, 0), (4, 1), (32, 1), (38, 0), (48, 0)])
        breath = ramp(t, [(0, 0), (36, 0), (42, 1), (48, 0)])
        bounce = 3 * abs(math.sin(math.pi * t / 4)) * env
        hips = (200.0, 288 + bounce)
        legs = {f'leg_{side}': leg(sx, (200 + sx * 16, STAND_ANKLE_Y), hips=hips, near=1 + 0.02 * bounce)
                for side, sx in (('l', -1), ('r', 1))}
        c = add(hips, (0, -51))
        sh = shoulder_points(c)
        arms, offs = {}, {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            ph = math.pi * t / 2 + (0 if sx < 0 else math.pi / 2)
            shake = (5 * math.sin(ph) * env, 3 * math.cos(ph * 1.5) * env)
            elbow = add(sh[i], (sx * 8, 42))
            wrist = add(add(sh[i], (sx * 12, 74)), shake)
            arms['arm_' + side] = (wrist, (0, 1), add(elbow, mul(shake, 0.3)))
            offs['sh_' + side] = (0, -5 * breath)
        return figure(hips=hips, head=(0, -2 * breath + 1.5 * math.sin(math.pi * t / 4) * env, 0),
                      **offs, **legs, **arms)

    return Animation('cooldown_shake_out', T, pose, step=1, order=ORDER_CAPS)


# ── Side views (goro_rig) ────────────────────────────────────────────────────

SIDE_BASE = gr.P(hip_n=8, hip_f=2, foot_n=(5, 4, 0), foot_f=(5, 4, 0))
SIDE_FK = {'leg_n': 'fk', 'leg_f': 'fk', 'arm_n': 'fk', 'arm_f': 'fk'}
# Three-part spine instead of the body (the roll-down), as the cat-cow.
SPINE_ORDER = ['head', 'uarm_r', 'farm_r', 'thigh_r', 'shin_r', 'foot_r',
               'sp_chest', 'sp_mid', 'sp_pelvis', 'thigh_l', 'shin_l', 'foot_l',
               'uarm_l', 'farm_l']
# Hands on the floor: the head hangs ahead of the arms.
FLOOR_ORDER = ['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r', 'body',
               'thigh_l', 'shin_l', 'foot_l', 'uarm_l', 'farm_l']
PLANK_BR = 62.5          # the body line of a plank: shoulders 80 px over the hands
# A near leg drawn over the body (knee to the chest) in a lighter tone, as in
# Evening Stretch, so it does not merge with the torso.
NEAR_LEG_LIGHT = {'thigh_r': LEG_LIGHT, 'shin_r': LEG_LIGHT, 'foot_r': LEG_LIGHT}


def smooth01(x):
    x = min(1.0, max(0.0, x))
    return x * x * (3 - 2 * x)


def placed(pose, limb, at):
    """``pose`` moved so the joint of ``limb`` (e.g. the near shoulder or hip)
    is at ``at``."""
    cur = gr.joint_of(pose, limb)
    pose = dict(pose)
    pose['cx'] += at[0] - cur[0]
    pose['cy'] += at[1] - cur[1]
    return pose


def floor_arm(pose, side, hand):
    """Plant a hand with the elbow always on the same side of the arm (no
    IK flips while the shoulder travels)."""
    sh = gr.joint_of(pose, 'arm_' + side)
    d = (hand[0] - sh[0], hand[1] - sh[1])
    n = math.hypot(*d) or 1.0
    return gr.plant(pose, 'arm_' + side, hand, (-d[1] / n, d[0] / n))


def mix_angles(a, b, u):
    return tuple(x + (y - x) * u for x, y in zip(a, b))


# ── morning_spine_s3_good_morning ────────────────────────────────────────────
# Hands behind the head (the elbows point forward past the face), knees soft.
# The hips push back and the torso hinges forward with a flat back to about
# 70 degrees, then stands tall again.

def good_morning():
    T = 48
    base = gr.P(SIDE_BASE, leg_n=(208, 372), leg_f=(200, 372))

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (20, 1), (26, 1), (42, 0), (48, 0)])
        br = 70 * u
        return gr.mk(base, (200 - 18 * u, 289 + 4 * u), br, ht=-14 * u,
                     arm_n=(245 + br, 124 + br), arm_f=(240 + br, 120 + br))

    return gr.Spec('morning_spine_s3_good_morning', T, gr.sampled(T, pose),
                   modes={'arm_n': 'fk', 'arm_f': 'fk'})


# ── morning_spine_s4_roll_down ───────────────────────────────────────────────
# Chin to the chest first, then the spine curls down part by part (chest, the
# middle, the pelvis last) while the arms hang towards the floor and the knees
# soften; rolling back up the head comes last. Three-part spine as the cat-cow.

def roll_down():
    T = 80
    base = gr.P(SIDE_BASE, leg_n=(210, 372), leg_f=(202, 372))

    def stage(u, a, b):
        return smooth01((u - a) / (b - a))

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (36, 1), (44, 1), (76, 0), (80, 0)])
        head = stage(u, 0.0, 0.3)
        chest = 128 * stage(u, 0.1, 0.7)
        mid = 78 * stage(u, 0.25, 0.85)
        pel = 34 * stage(u, 0.5, 1.0)
        knees = stage(u, 0.55, 1.0)
        p = gr.P(base, cx=0.0, cy=0.0, br=chest, spine=(mid - chest, pel - mid),
                 ht=36 * head, arm_n=(3, 3), arm_f=(-2, -2))
        return placed(p, 'leg_n', (206 - 12 * knees, 290 + 8 * knees))

    return gr.Spec('morning_spine_s4_roll_down', T, gr.sampled(T, pose),
                   modes={'arm_n': 'fk', 'arm_f': 'fk'}, order=SPINE_ORDER)


# ── morning_joints_s3_knee_hug ───────────────────────────────────────────────
# Both hands pull one knee to the chest while the standing foot rises onto its
# toes; down, then the other leg (behind the body).

def knee_hug():
    T = 56

    def pose(t):
        near = t < 28
        u = ramp(t % 28, [(0, 0), (2, 0), (10, 1), (18, 1), (26, 0), (28, 0)])
        lift, stand = ('n', 'f') if near else ('f', 'n')
        toe = {'n': 228, 'f': 222}
        ankle_s, foot_s = raised_foot(toe[stand], 30 * u)
        hips = (200 + 2 * u, ankle_s[1] - 83.9)
        p = gr.mk(gr.P(SIDE_BASE), hips, -4 * u, ht=-6 * u, **{'foot_' + stand: foot_s,
                                                                'foot_' + lift: raised_foot(toe[lift], 0)[1]})
        p = gr.plant(p, 'leg_' + stand, ankle_s, (1, -1))
        rest_ankle = (toe[lift] - 18, 372.0)
        rest = gr.ik_to_fk(p, 'leg_' + lift, rest_ankle, (1, -1))
        p['leg_' + lift] = mix_angles(rest, (-142, 6), u)
        hip = gr.joint_of(p, 'leg_' + lift)
        a1, a2 = p['leg_' + lift]
        knee = add(hip, mul(dirv(a1), gr.THIGH))
        shin_pt = add(knee, mul(dirv(a2), 14))
        for side, dx in (('n', 3), ('f', -3)):
            hug = gr.ik_to_fk(p, 'arm_' + side, (shin_pt[0] + dx, shin_pt[1]), (0, 1))
            p['arm_' + side] = mix_angles((3 if side == 'n' else -2,) * 2, hug, u)
        return p

    return gr.Spec('morning_joints_s3_knee_hug', T, gr.sampled(T, pose), modes=SIDE_FK,
                   tint=NEAR_LEG_LIGHT)


# ── morning_energy_s2_butt_kicks ─────────────────────────────────────────────
# On the spot, one heel kicks up to the glutes while the other foot stays on the
# floor; the bent arms swing the other way, as in running. Quiet: no flight.

def butt_kicks():
    T = 40

    def pose(t):
        kn = ramp(t, [(0, 0), (9, 1), (18, 0), (40, 0)])
        kf = ramp(t, [(0, 0), (20, 0), (29, 1), (38, 0), (40, 0)])
        hips = (200.0, 288 - 2 * max(kn, kf))
        p = gr.mk(gr.P(SIDE_BASE), hips, 5)
        for side, k, ankle in (('n', kn, (206, 372)), ('f', kf, (200, 372))):
            rest = gr.ik_to_fk(p, 'leg_' + side, ankle, (1, -1))
            p['leg_' + side] = mix_angles(rest, (14, 168), k)
            p['foot_' + side] = (5 - 9 * k, 4 - 8 * k, 150 * k)
        for side, sw in (('n', kf - kn), ('f', kn - kf)):
            a1 = 30 * sw
            p['arm_' + side] = (a1, a1 - 95)
        return p

    return gr.Spec('morning_energy_s2_butt_kicks', T, gr.sampled(T, pose), modes=SIDE_FK)


# ── Planks ───────────────────────────────────────────────────────────────────

def plank(shoulder, br=PLANK_BR, ht=-18.0):
    """A plank pose with the near shoulder at ``shoulder`` (legs set by the
    caller)."""
    p = gr.P(SIDE_BASE, cx=0.0, cy=0.0, br=br, ht=ht)
    return placed(p, 'arm_n', shoulder)


def plank_toes(shoulder):
    """Where the feet of a straight plank land (the ankle) for a shoulder."""
    d = dirv(PLANK_BR)
    return add(shoulder, mul(d, 89 + 84))


# ── morning_energy_s5_mountain_climbers ──────────────────────────────────────
# A plank on straight arms; one knee drives forward under the chest and goes
# back, then the other. Slow, no jumping between the feet.

def mountain_climbers():
    T = 40
    sh = (276.0, 290.0)
    hands = {'n': (279.0, 368.0), 'f': (273.0, 368.0)}
    straight_leg = (PLANK_BR, PLANK_BR)

    def pose(t):
        kn = ramp(t, [(0, 0), (1, 0), (9, 1), (19, 0), (40, 0)])
        kf = ramp(t, [(0, 0), (21, 0), (29, 1), (39, 0), (40, 0)])
        p = plank(sh)
        for side, k in (('n', kn), ('f', kf)):
            p['leg_' + side] = tuple(lerp_keys([straight_leg, (-5.0, 100.0), (-78.0, 42.0)], 2 * k))
            p['foot_' + side] = (2, -3, 62 - 50 * k)
        for side in ('n', 'f'):
            p = floor_arm(p, side, hands[side])
        return p

    return gr.Spec('morning_energy_s5_mountain_climbers', T, gr.sampled(T, pose),
                   modes=SIDE_FK, order=FLOOR_ORDER, tint=NEAR_LEG_LIGHT)


# ── morning_arms_s5_plank_to_dog ─────────────────────────────────────────────
# From a plank the hips push up and back into an upside-down V (the arms and
# the back in one line, the legs straight, the heels lowering), then back.
# Goro's legs are short, so the V is steep on the leg side.

def plank_to_dog():
    T = 52
    sh0 = (276.0, 290.0)
    hands = {'n': (279.0, 368.0), 'f': (273.0, 368.0)}
    toes = plank_toes(sh0)

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (20, 1), (30, 1), (46, 0), (52, 0)])
        # the legs turn about the feet from the plank line to almost vertical
        a_leg = PLANK_BR + (14 - PLANK_BR) * u
        hips = add(toes, mul(dirv(a_leg), -84))
        to_hands = (hands['n'][0] - hips[0], hands['n'][1] - hips[1])
        dog_br = math.degrees(math.atan2(to_hands[0], -to_hands[1]))
        br = PLANK_BR + (dog_br - PLANK_BR) * u
        p = gr.mk(gr.P(SIDE_BASE), hips, br, ht=-18 + 40 * u)
        for side in ('n', 'f'):
            p['leg_' + side] = (a_leg, a_leg)
            p['foot_' + side] = (2, -3 + 5 * u, 62 * (1 - u))
            p = floor_arm(p, side, hands[side])
        return p

    return gr.Spec('morning_arms_s5_plank_to_dog', T, gr.sampled(T, pose),
                   modes=SIDE_FK, order=FLOOR_ORDER)


# ── morning_arms_s4_inchworm ─────────────────────────────────────────────────
# Standing at the left of the frame: fold forward, hands to the floor, walk the
# hands out (near, far, near, far) to a plank, walk them back and roll up.

def inchworm():
    T = 116
    feet = (114.0, 368.0)                     # the feet stay put (ankle on the toes)
    plank_sh = add(feet, mul(dirv(PLANK_BR), -(89 + 84)))
    a_fold, a_plank = 6.0, PLANK_BR           # leg angle (hip -> ankle) at both ends
    fold_br = 118.0
    first_x = feet[0] + 100                   # where the hands first touch
    last_x = plank_sh[0] + 3
    steps = [first_x + (last_x - first_x) * k / 2 for k in range(3)]

    def hand_at(h, side):
        """Hand along the walk ``h`` (0..1): the near hand moves in quarters
        0 and 2, the far one in 1 and 3, each lifting a little."""
        q = h * 4
        moves = (0, 2) if side == 'n' else (1, 3)
        done = sum(1 for m in moves if q >= m + 1)
        moving = next((m for m in moves if m < q < m + 1), None)
        x, lift = steps[done], 0.0
        if moving is not None:
            f = smooth01(q - moving)
            x = steps[done] + (steps[done + 1] - steps[done]) * f
            lift = 10 * math.sin(math.pi * f)
        return x + (2 if side == 'n' else -4), 368.0 - lift

    def pose(t):
        # f: stand -> fold (0..1); h: the hands walk out (0..1) and back
        f = ramp(t, [(0, 0), (4, 0), (24, 1), (92, 1), (112, 0), (116, 0)])
        h = ramp(t, [(0, 0), (24, 0), (52, 1), (64, 1), (92, 0), (116, 0)])
        g = smooth01(h) ** 1.5                # the hips stay high early in the walk
        a_leg = a_fold + (a_plank - a_fold) * g
        stand_hips = (feet[0] + 4, 288.0)
        arc_hips = add(feet, mul(dirv(a_leg), -84))
        hips = mix(stand_hips, arc_hips, f) if h <= 0 else arc_hips
        br = fold_br * f + (PLANK_BR - fold_br) * g
        p = gr.mk(gr.P(SIDE_BASE), hips, br, ht=24 * f - 40 * g)
        ankle_y = 372 - 4 * g
        for side, dx in (('n', 3), ('f', -3)):
            p = gr.plant(p, 'leg_' + side, (feet[0] + dx, ankle_y), (1, -1))
            p['foot_' + side] = (5 - 3 * g, 4 - 7 * g, 62 * g)
            shoulder = gr.joint_of(p, 'arm_' + side)
            hang = (shoulder[0] + 3, shoulder[1] + 78)
            target = hand_at(h, side)
            if h <= 0:
                target = mix(hang, target, smooth01(f * 1.4 - 0.4))
            p = floor_arm(p, side, target)
        return p

    return gr.Spec('morning_arms_s4_inchworm', T, gr.sampled(T, pose),
                   modes=SIDE_FK, order=FLOOR_ORDER)


ANIMATIONS = {
    'warmup_morning_stretch_up': stretch_up,
    'morning_spine_s1_side_bend': side_bend,
    'morning_joints_s2_open_the_gate': open_the_gate,
    'morning_joints_s4_side_lunge': side_lunge,
    'morning_joints_s5_cossack_squat': cossack_squat,
    'morning_arms_s1_arm_swings': arm_swings,
    'morning_arms_s2_y_raises': y_raises,
    'morning_arms_s3_cactus_arms': cactus_arms,
    'morning_energy_s1_step_jacks': step_jacks,
    'morning_energy_s3_cross_crunch': cross_crunch,
    'cooldown_shake_out': shake_out,
    'morning_spine_s3_good_morning': good_morning,
    'morning_spine_s4_roll_down': roll_down,
    'morning_joints_s3_knee_hug': knee_hug,
    'morning_energy_s2_butt_kicks': butt_kicks,
    'morning_energy_s5_mountain_climbers': mountain_climbers,
    'morning_arms_s5_plank_to_dog': plank_to_dog,
    'morning_arms_s4_inchworm': inchworm,
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
