#!/usr/bin/env python3
"""Generates the Evening Stretch exercise animations (assets/animations/evening_*.json,
cooldown_lying_relaxation.json).

Usage: python3 tools/lottie/gen_evening.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Seated front views (``frontview.py``, ``ORDER_SEATED``): butterfly, straddle
fold, self-hug, overhead triceps, eagle arms. Seen from behind (``view='back'``):
cow face arms, where the hands meet on the back. Side views (``goro_rig.py``):
lying on the back (relaxation, knees to chest, happy baby, legs up the wall,
the towel stretch), on the stomach (sphinx, cobra), kneeling (child's pose,
puppy) and seated (head-to-knee).
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from frontview import (ORDER_BACK, ORDER_SEATED, SEAT_HIPS, Animation,  # noqa: E402
                       butterfly_legs, cross_legs, figure, fold_toward,
                       rest_arm, straddle_legs, swing_arm)
from goro_rig import (FARM, P, SHIN, THIGH, UARM, WAIST, Spec, _layer,  # noqa: E402
                      _prop, _rc, _single, _unwrap, add, ang_of, at_hips, dirv,
                      hold_ramp as ramp, ik2, joint_of, mk, mul, plant, rot,
                      sampled, solve, write)
from goro_rig import bar, WALL  # noqa: E402

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


# ── evening_hips_s5_frog ─────────────────────────────────────────────────────
# Front view, the head towards the camera: on the forearms, knees wide out to
# the sides on the floor behind, feet turned out. The torso runs away from the
# camera (drawn upside down and foreshortened: hips far and high, shoulders and
# head near and low). The hips ease back (the torso lengthens), hold, return.

FROG_ORDER = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'head', 'uarm_l', 'uarm_r',
              'body', 'knee_l', 'knee_r', 'thigh_l', 'thigh_r', 'shin_l',
              'shin_r', 'foot_l', 'foot_r']


def frog():
    T = 72

    def pose(t):
        k = ramp(t, [(0, 0), (6, 0), (28, 1), (T - 14, 1), (T - 2, 0), (T, 0)])
        k *= 1 + 0.04 * breath(t, 24) * (k > 0.98)
        hips = (200, 300 - 10 * k)
        legs = {}
        for key, sx in (('leg_l', -1), ('leg_r', 1)):
            knee = (200 + sx * (78 + 10 * k), 344 - 4 * k)
            ankle = (200 + sx * (92 + 10 * k), 326 - 4 * k)
            legs[key] = dict(knee=knee, ankle=ankle, near=0.9, foot_rot=60,
                             foot_scale=(0.8, 0.8), foot_off=(sx * 6, -8))
        arms = {}
        for key, sx in (('arm_l', -1), ('arm_r', 1)):
            elbow = (200 + sx * 40, 368)
            arms[key] = ((200 + sx * 30, 384), (sx, 0), elbow)
        return figure(hips=hips, lean=180, torso_scale=(1.0, 0.42 + 0.1 * k),
                      head=(0, -22, 180), head_scale=(1.0, 0.95), **legs, **arms)

    return Animation('evening_hips_s5_frog', T, pose, order=FROG_ORDER)


# ══ Side views (goro_rig) ════════════════════════════════════════════════════

ALL_FK = {'leg_n': 'fk', 'leg_f': 'fk', 'arm_n': 'fk', 'arm_f': 'fk'}
LIE_Y = 348.0                       # torso centre lying on the floor (56 thick)
LYING = dict(br=-90, hip_n=-6, hip_f=-12, head=(1, -83))   # on the back, head left
FEET_UP = (4, -10, -80)             # lying on the back, toes to the ceiling
TOWEL = [0.86, 0.80, 0.64, 1.0]


def supine(cx, **kw):
    """On the back, head to the left, torso centre at ``(cx, LIE_Y)``."""
    kw.setdefault('foot_n', FEET_UP)
    kw.setdefault('foot_f', FEET_UP)
    kw.setdefault('cy', LIE_Y)
    return P(cx=cx, **LYING, **kw)


def lerp_angles(a, b, u):
    """Joint angles from ``a`` to ``b`` the short way round."""
    return tuple(x + (((y - x + 180) % 360) - 180) * u for x, y in zip(a, b))


def leg_points(p, side):
    """Hip, knee and ankle of an FK leg."""
    hip = joint_of(p, 'leg_' + side)
    a1, a2 = p['leg_' + side]
    knee = add(hip, mul(dirv(a1), THIGH * p['sc_thigh_' + side]))
    return hip, knee, add(knee, mul(dirv(a2), SHIN * p['sc_shin_' + side]))


def fist_of(layers, side='r'):
    f = layers['farm_' + side]
    return add(f['p'], mul(dirv(f['r'] - 180), FARM * f['s'][1] / 200))


def with_segment(spec, after, name, ends, width, color):
    """Builds ``spec`` and inserts a strap layer (a towel) between two points
    given per frame by ``ends(layers) -> (a, b)``, right below layer ``after``."""
    data = spec.build() if hasattr(spec, 'build') else None
    if data is None:
        from goro_rig import build
        data = build(spec)
    times = list(range(0, spec.frames + 1, spec.step))
    if times[-1] != spec.frames:
        times.append(spec.frames)
    pos, rots, scl = [], [], []
    for t in times:
        a, b = ends(solve(spec, spec.pose_at(t)))
        d = (b[0] - a[0], b[1] - a[1])
        pos.append(((a[0] + b[0]) / 2, (a[1] + b[1]) / 2))
        rots.append(ang_of(*d))
        scl.append((100, 100 * max(1.0, (d[0] ** 2 + d[1] ** 2) ** 0.5)))
    layer = _layer(name, 90, spec.frames, [_single('strap', _rc(width, 1, (0, 0), 0), color)],
                   _prop(times, pos), _prop(times, [(r,) for r in _unwrap(rots)]),
                   _prop(times, scl), {"a": 0, "k": [100]})
    idx = [l['nm'] for l in data['layers']].index(after) + 1
    data['layers'].insert(idx, layer)
    for i, l in enumerate(data['layers'], start=1):
        l['ind'] = i
    return data


class Built:
    """A finished Lottie dict that ``write`` can save."""

    def __init__(self, name, data):
        self.name, self.data = name, data

    def build(self):
        return self.data


# ── cooldown_lying_relaxation ────────────────────────────────────────────────
# Flat on the back, arms by the sides, legs long, feet falling out. Only the
# breath moves: the chest rises and falls, slowly.

def lying_relaxation():
    T = 60
    rest_arm = (-86, -90)

    def pose(t):
        b = 0.5 - 0.5 * math.cos(2 * math.pi * t / T)
        return supine(200, cy=LIE_Y - 1.8 * b, sc_torso=1 + 0.065 * b,
                      leg_n=(-87, -90), leg_f=(-88, -91),
                      arm_n=rest_arm, arm_f=rest_arm, ht=-2 * b)

    return Spec('cooldown_lying_relaxation', T, sampled(T, pose), modes=ALL_FK)


# ── evening_hips_s1_knees_to_chest ───────────────────────────────────────────
# On the back, knees bent and feet on the floor; the arms hug both knees to the
# chest, then a slow rock (the hug tightens and eases), then let go.

def knees_to_chest():
    T = 72
    cx = 196

    def pose(t):
        k = ramp(t, [(0, 0), (6, 0), (22, 1), (T - 14, 1), (T - 2, 0), (T, 0)])
        rock = math.sin(2 * math.pi * (t - 22) / 25) * ramp(
            t, [(0, 0), (22, 0), (26, 1), (T - 18, 1), (T - 14, 0), (T, 0)])
        curl = at_hips((cx + 50, LIE_Y), -90 + 6 * k)
        p = P(supine(cx, arm_n=(-86, -90), arm_f=(-86, -90)), **curl)
        feet = plant(plant(p, 'leg_n', (cx + 108, 366), (0, -1)), 'leg_f', (cx + 114, 366), (0, -1))
        hug_n, hug_f = (168 + 4 * rock, -112 + 4 * rock), (164 + 4 * rock, -116 + 4 * rock)
        for side, hug in (('n', hug_n), ('f', hug_f)):
            p['leg_' + side] = lerp_angles(feet['leg_' + side], hug, k)
        p['foot_n'] = p['foot_f'] = (4, -4 - 4 * k, -20 - 40 * k)
        for side in ('n', 'f'):
            _, knee, ankle = leg_points(p, side)
            grip = add(knee, mul((ankle[0] - knee[0], ankle[1] - knee[1]), 0.25))
            held = plant(p, 'arm_' + side, add(grip, (0, 2)), (0, 1))['arm_' + side]
            p['arm_' + side] = lerp_angles((-86, -90), held, k)
        p['ht'] = -10 * k
        return p

    return Spec('evening_hips_s1_knees_to_chest', T, sampled(T, pose), modes=ALL_FK)


# ── evening_hips_s3_happy_baby ───────────────────────────────────────────────
# On the back: the knees come up, the shins stand vertical with the soles to
# the ceiling and the hands take the feet; the knees are drawn down towards the
# armpits, a gentle rock, then back.

def happy_baby():
    T = 84
    cx = 196

    def pose(t):
        up = ramp(t, [(0, 0), (6, 0), (22, 1), (T - 18, 1), (T - 2, 0), (T, 0)])
        pull = ramp(t, [(0, 0), (22, 0), (34, 1), (T - 30, 1), (T - 18, 0), (T, 0)])
        rock = math.sin(2 * math.pi * (t - 34) / 20) * ramp(
            t, [(0, 0), (34, 0), (38, 1), (T - 34, 1), (T - 30, 0), (T, 0)])
        p = supine(cx, arm_n=(-86, -90), arm_f=(-86, -90))
        feet = plant(plant(p, 'leg_n', (cx + 108, 366), (0, -1)), 'leg_f', (cx + 114, 366), (0, -1))
        thigh = 168 - 36 * pull + 4 * rock
        baby = {'n': (thigh, 180), 'f': (thigh - 6, 176)}
        for side in ('n', 'f'):
            p['leg_' + side] = lerp_angles(feet['leg_' + side], baby[side], up)
        p['foot_n'] = p['foot_f'] = (-5 * up, -4 * up, 0)
        for side in ('n', 'f'):
            _, _, ankle = leg_points(p, side)
            held = plant(p, 'arm_' + side, add(ankle, (-2, 4)), (0, 1))['arm_' + side]
            reach = min(1.0, up * 1.4)
            p['arm_' + side] = lerp_angles((-86, -90), held, reach)
        p['sc_uarm_n'] = p['sc_farm_n'] = p['sc_uarm_f'] = p['sc_farm_f'] = 1 + 0.12 * up
        p['ht'] = -4 * up
        return p

    return Spec('evening_hips_s3_happy_baby', T, sampled(T, pose), modes=ALL_FK)


# ── evening_folds_s1_legs_up_wall ────────────────────────────────────────────
# On the back with the hips close to a wall and the straight legs resting up
# along it. The breath moves the chest; the knees soften and lengthen, the feet
# flex and relax.

def legs_up_wall():
    T = 60
    cx = 160
    wall_x = cx + 50 + 16

    def pose(t):
        b = 0.5 - 0.5 * math.cos(2 * math.pi * t / T)
        soft = 0.5 - 0.5 * math.cos(2 * math.pi * t / (T / 2))
        return supine(cx, cy=LIE_Y - 1.5 * b, sc_torso=1 + 0.05 * b,
                      leg_n=(178 - 3 * soft, 182 + 3 * soft),
                      leg_f=(176 - 3 * soft, 180 + 3 * soft),
                      foot_n=(-5, -3, -8 * soft), foot_f=(-5, -3, -8 * soft),
                      arm_n=(-80, -84), arm_f=(-82, -86))

    return Spec('evening_folds_s1_legs_up_wall', T, sampled(T, pose), modes=ALL_FK,
                props=lambda n: [bar('wall', wall_x + 10, 200, 20, 400, WALL, n, 4, 90)])


# ── evening_folds_s2_towel_hamstring ─────────────────────────────────────────
# On the back, a towel round the near foot. The straight leg rises to vertical,
# the hands draw it a little closer with the towel, hold, and it lowers again.
# The other leg stays long on the floor.

def towel_hamstring():
    T = 72
    cx = 190

    def pose(t):
        k = ramp(t, [(0, 0), (6, 0), (26, 1), (T - 12, 1), (T - 2, 0), (T, 0)])
        pull = ramp(t, [(0, 0), (28, 0), (36, 1), (T - 20, 1), (T - 14, 0), (T, 0)])
        a = -130 - 48 * k - 8 * pull
        p = supine(cx, leg_n=(a, a), leg_f=(-88, -91), foot_n=(0, 0, 0))
        _, _, ankle = leg_points(p, 'n')
        sole = add(ankle, mul(dirv(a), 6))
        p['foot_n'] = (*mul(dirv(a), 6), a + 90)
        for side, off in (('n', 0), ('f', -4)):
            shoulder = joint_of(p, 'arm_' + side)
            d = (sole[0] - shoulder[0], sole[1] - shoulder[1])
            ln = math.hypot(*d)
            grip = add(shoulder, mul(d, (60 - 6 * pull) / ln))
            p = plant(p, 'arm_' + side, add(grip, (off, 0)), (0, 1))
        p['ht'] = -3 * pull
        return p

    spec = Spec('evening_folds_s2_towel_hamstring', T, sampled(T, pose), modes=ALL_FK)

    def ends(layers):
        foot = layers['foot_r']['p']
        return fist_of(layers, 'r'), add(foot, mul(dirv(layers['foot_r']['r'] - 90), 6))

    return Built(spec.name, with_segment(spec, 'farm_r', 'towel', ends, 6, TOWEL))


# ── On the stomach and kneeling: a three-part spine ──────────────────────────

SPINE_ORDER = ['head', 'uarm_r', 'farm_r', 'thigh_r', 'shin_r', 'foot_r',
               'sp_chest', 'sp_mid', 'sp_pelvis', 'thigh_l', 'shin_l', 'foot_l',
               'uarm_l', 'farm_l']
# Arms reaching past the head on the floor: the near arm in front of it.
SPINE_ARMS_OVER = ['uarm_r', 'farm_r', 'head'] + SPINE_ORDER[3:]
_PROBE = Spec('probe', 1, [(0, P(), 'linear')], modes=ALL_FK)


def spine_at(base, chest, s1, s2, anchor, at, **kw):
    """Pose with the chest part at angle ``chest`` and the spine bends
    ``(s1, s2)`` (pelvis angle = chest + s1 + s2), moved so that ``anchor``
    ('pelvis' = centre of the pelvis part, 'hip' = near hip joint) is at ``at``."""
    p = P(base, cx=0.0, cy=0.0, br=chest, spine=(s1, s2), **kw)
    if anchor == 'hip':
        cur = joint_of(p, 'leg_n')
    else:
        cur = solve(_PROBE, p)['sp_pelvis']['p']
    p['cx'], p['cy'] = at[0] - cur[0], at[1] - cur[1]
    return p


def floor_elbow(shoulder, reach=UARM, y=368.0):
    """Elbow on the floor in front of (or under) the shoulder."""
    dy = min(reach - 0.5, max(0.0, y - shoulder[1]))
    return (shoulder[0] + math.sqrt(reach * reach - dy * dy), y)


def fk_to(p_from, p_to):
    """FK angles of the segment ``p_from -> p_to``."""
    return ang_of(p_to[0] - p_from[0], p_to[1] - p_from[1])


PRONE = dict(hip_n=10, hip_f=14, foot_n=(-6, 4, 75), foot_f=(-6, 4, 75),
             leg_n=(90, 90), leg_f=(91, 91))


# ── evening_back_s4_sphinx ───────────────────────────────────────────────────
# On the stomach, legs long. The forearms set down in front, then the chest
# lifts onto them (elbows under the shoulders, hips stay down) and the gaze
# comes forward; a breath, and the chest lowers again.

def sphinx():
    T = 72
    pelvis_at = (170, LIE_Y)

    def pose(t):
        k = ramp(t, [(0, 0), (8, 0), (28, 1), (T - 14, 1), (T - 2, 0), (T, 0)])
        k *= 1 + 0.06 * breath(t, 24) * (k > 0.98)
        lift = 28 * k
        p = spine_at(P(**PRONE), 90 - lift, lift / 2, lift / 2, 'pelvis', pelvis_at)
        for side in ('n', 'f'):
            sh = joint_of(p, 'arm_' + side)
            el = floor_elbow(sh)
            p['arm_' + side] = (fk_to(sh, el), -88)
        p['ht'] = (55 - 50 * k) - p['br']
        return p

    return Spec('evening_back_s4_sphinx', T, sampled(T, pose), modes=ALL_FK,
                order=SPINE_ORDER)


# ── evening_back_s5_cobra ────────────────────────────────────────────────────
# On the stomach, hands under the shoulders. The arms press the chest up as far
# as the lower back lets it (hips stay on the floor), the head lifts with it;
# hold, breathe, and lower.

def cobra():
    T = 72
    pelvis_at = (160, LIE_Y)

    def flat_hand(side):
        p = spine_at(P(**PRONE), 90, 0, 0, 'pelvis', pelvis_at)
        sh = joint_of(p, 'arm_' + side)
        return (sh[0] - (24 if side == 'n' else 30), 366)

    hands = {'n': flat_hand('n'), 'f': flat_hand('f')}

    def pose(t):
        k = ramp(t, [(0, 0), (8, 0), (30, 1), (T - 14, 1), (T - 2, 0), (T, 0)])
        k *= 1 + 0.05 * breath(t, 24) * (k > 0.98)
        lift = 46 * k
        p = spine_at(P(**PRONE), 90 - lift, lift * 0.45, lift * 0.55, 'pelvis', pelvis_at)
        for side in ('n', 'f'):
            p = plant(p, 'arm_' + side, hands[side], (-0.6, -1 + 0.7 * k))
        p['ht'] = (60 - 62 * k) - p['br']
        return p

    return Spec('evening_back_s5_cobra', T, sampled(T, pose), modes=ALL_FK,
                order=SPINE_ORDER)


# ── evening_back_s2_childs_pose ──────────────────────────────────────────────
# Kneeling, sitting on the heels with the hands on the thighs; the body folds
# forward over the knees, the back rounds, the arms reach far ahead on the
# floor and the forehead comes down. The back rises and falls with the breath.

KNEE = (178.0, 366.0)
HEEL_ANKLE = (136.0, 368.0)
SIT_HIP = (134.0, 337.0)


def kneel_legs(p, hip_side='n'):
    """Thighs from the hips to the knees on the floor, shins back along it."""
    for side, dx in (('n', 0), ('f', -4)):
        hip = joint_of(p, 'leg_' + side)
        knee = (KNEE[0] + dx, KNEE[1])
        ankle = (HEEL_ANKLE[0] + dx, HEEL_ANKLE[1])
        p['leg_' + side] = (fk_to(hip, knee), fk_to(knee, ankle))
        p['sc_thigh_' + side] = math.dist(hip, knee) / THIGH
        p['sc_shin_' + side] = math.dist(knee, ankle) / SHIN
    p['foot_n'] = p['foot_f'] = (-8, 4, 180)
    return p


def childs_pose():
    T = 84

    def pose(t):
        k = ramp(t, [(0, 0), (6, 0), (30, 1), (T - 26, 1), (T - 4, 0), (T, 0)])
        b = breath(t, 24) * (k > 0.98)
        chest = 104 * k
        bend = -24 * k - 3 * b
        p = spine_at(P(hip_n=8, hip_f=2), chest, bend, bend, 'hip', SIT_HIP)
        p = kneel_legs(p)
        rest = (-6, -40)                       # hands resting on the thighs
        reach = (-88, -90)                     # far ahead on the floor
        for side in ('n', 'f'):
            p['arm_' + side] = lerp_angles(rest, reach, k)
        p['ht'] = (-4 + 150 * k) - p['br']
        return p

    return Spec('evening_back_s2_childs_pose', T, sampled(T, pose), modes=ALL_FK,
                order=SPINE_ARMS_OVER)


# ── evening_shoulders_s4_puppy_pose ──────────────────────────────────────────
# On all fours; the hands walk forward and the chest melts towards the floor
# while the hips stay above the knees, arms long, forehead down; the breath
# moves the back; then the hands walk back.

PUPPY_HIP = (150.0, 319.0)


def puppy_pose():
    T = 72

    def pose(t):
        k = ramp(t, [(0, 0), (6, 0), (30, 1), (T - 14, 1), (T - 2, 0), (T, 0)])
        b = breath(t, 24) * (k > 0.98)
        chest = 70 + 44 * k
        sag = 10 * k + 2 * b
        p = spine_at(P(hip_n=8, hip_f=2), chest, -sag, -sag, 'hip', PUPPY_HIP)
        for side, dx in (('n', 0), ('f', -4)):
            hip = joint_of(p, 'leg_' + side)
            knee = (hip[0] + dx, 365.0)
            p['leg_' + side] = (fk_to(hip, knee), 90)
            p['sc_thigh_' + side] = math.dist(hip, knee) / THIGH
        p['foot_n'] = p['foot_f'] = (-10, 3, 0)
        hand_x = 232 + 96 * k
        p = plant(p, 'arm_n', (hand_x + 2, 364), (-1, 0))
        p = plant(p, 'arm_f', (hand_x - 4, 364), (-1, 0))
        p['ht'] = (-10 + 120 * k) - p['br']
        return p

    return Spec('evening_shoulders_s4_puppy_pose', T, sampled(T, pose), modes=ALL_FK,
                order=SPINE_ARMS_OVER)


# ── evening_folds_s3_head_to_knee ────────────────────────────────────────────
# Seated, the near leg long, the far one bent with its foot at the inner thigh
# (behind, foreshortened). Sit tall, then fold forward over the straight leg,
# hands sliding to the foot; hold, and come back up.

def head_to_knee():
    T = 72
    base = P(hip_n=8, hip_f=2, leg_n=(240, 364), foot_n=(3, -5, -72),
             leg_f=(-60, 110), sc_thigh_f=0.7, sc_shin_f=0.75, foot_f=(0, 0, 40))

    def pose(t):
        k = ramp(t, [(0, 0), (6, 0), (28, 1), (T - 14, 1), (T - 2, 0), (T, 0)])
        k *= 1 + 0.05 * breath(t, 24) * (k > 0.98)
        hips = (156 - 6 * k, 366)
        p = mk(base, hips, 8 + 42 * k, ht=-6 + 16 * k)
        foot = (232 + 12 * k, 352 + 2 * k)
        p = plant(p, 'arm_n', foot, (0, -1))
        p = plant(p, 'arm_f', add(foot, (-6, 4)), (0, -1))
        return p

    return Spec('evening_folds_s3_head_to_knee', T, sampled(T, pose),
                modes={'arm_n': 'fk', 'arm_f': 'fk', 'leg_f': 'fk'},
                bends={'leg_n': (0, -1)})


# ══ Top views (topview.py): lying on the back, seen from above ═══════════════

TOP_DY = -40                       # the whole figure higher: straight legs fit the mat
TOP_HIP_Y = 262 + TOP_DY
TOP_SH_Y = 175 + TOP_DY
TOP_HEAD_Y = 118 + TOP_DY
TOP_ORDER = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r', 'head',
             'knee_l', 'knee_r', 'thigh_r', 'thigh_l', 'shin_r', 'shin_l',
             'foot_l', 'foot_r', 'body', 'mat']


def top_parts(head_rot=0.0, arms=None, legs=None, torso_rot=0.0):
    """Layer transforms of Goro on his back from above. ``arms[side]`` =
    (elbow, wrist), ``legs[side]`` = (knee, ankle); sides by screen (l, r)."""
    from topview import K as TK, _segment
    parts = {'body': dict(p=(200, 216 + TOP_DY), r=torso_rot, s=(TK * 100, TK * 100)),
             'head': dict(p=(200, TOP_HEAD_Y), r=head_rot, s=(TK * 100, TK * 100))}
    for side, sx in (('l', -1), ('r', 1)):
        sh = (200 + sx * 36, TOP_SH_Y)
        elbow, wrist = arms[side]
        parts['uarm_' + side] = _segment(sh, elbow, 'uarm')
        parts['farm_' + side] = _segment(elbow, wrist, 'farm')
        parts['hand_' + side] = dict(p=wrist, r=0, s=(TK * 100, TK * 100))
        hip = (200 + sx * 22, TOP_HIP_Y)
        knee, ankle = legs[side]
        parts['thigh_' + side] = _segment(hip, knee, 'thigh')
        parts['shin_' + side] = _segment(knee, ankle, 'shin')
        parts['knee_' + side] = dict(p=knee, r=0, s=(TK * 100, TK * 100))
        parts['foot_' + side] = dict(p=add(ankle, (0, 4)), r=0, s=(TK * 100, TK * 100))
    return parts


def mixp(a, b, u):
    return (a[0] + (b[0] - a[0]) * u, a[1] + (b[1] - a[1]) * u)


STRAIGHT = {'l': ((178, TOP_HIP_Y + 70), (176, TOP_HIP_Y + 140)),
            'r': ((222, TOP_HIP_Y + 70), (224, TOP_HIP_Y + 140))}
T_ARMS = {'l': ((200 - 79, TOP_SH_Y + 2), (200 - 114, TOP_SH_Y + 4)),
          'r': ((200 + 79, TOP_SH_Y + 2), (200 + 114, TOP_SH_Y + 4))}


# ── evening_back_s3_supine_twist ─────────────────────────────────────────────
# From above, on the back, arms out in a T. One knee bends up, then drops
# across the body to the floor on the other side while the head turns away;
# the shoulders stay down. Hold, breathe, and come back.

def bezier2(a, c, b, u):
    """A point on the quadratic curve a -> b bent towards c."""
    return mixp(mixp(a, c, u), mixp(c, b, u), u)


def supine_twist():
    from topview import TopViewAnimation
    T = 96

    def pose(t):
        bend = ramp(t, [(0, 0), (6, 0), (22, 1), (T - 14, 1), (T - 2, 0), (T, 0)])
        drop = ramp(t, [(0, 0), (22, 0), (42, 1), (T - 34, 1), (T - 14, 0), (T, 0)])
        b = breath(t, 24) * (drop > 0.98)
        up = ((240, TOP_HIP_Y - 26), (232, TOP_HIP_Y + 64))      # knee up, foot planted
        across = ((150 - 2 * b, TOP_HIP_Y + 34), (190, TOP_HIP_Y + 66))
        # the knee swings out to the side on the way up, and over the body
        # (not through the hip) on the way across
        knee = (bezier2(STRAIGHT['r'][0], (262, TOP_HIP_Y + 40), up[0], bend) if drop == 0
                else bezier2(up[0], (196, TOP_HIP_Y - 36), across[0], drop))
        ankle = mixp(mixp(STRAIGHT['r'][1], up[1], bend), across[1], drop)
        legs = {'l': STRAIGHT['l'], 'r': (knee, ankle)}
        return top_parts(head_rot=28 * drop, arms=T_ARMS, legs=legs, torso_rot=-4 * drop)

    return TopViewAnimation('evening_back_s3_supine_twist', T, pose, TOP_ORDER)


# ── evening_hips_s2_figure_four ──────────────────────────────────────────────
# From above, on the back, knees bent. One ankle crosses over the other knee
# (that knee opens out to the side), the hands reach behind the supporting
# thigh and draw it towards the chest; hold, then release.

def figure_four():
    from topview import TopViewAnimation
    T = 84
    hy = TOP_HIP_Y
    bent = {'l': ((162, hy + 30), (174, hy + 82)),
            'r': ((238, hy + 30), (226, hy + 82))}
    side_arms = {'l': ((200 - 50, TOP_SH_Y + 34), (200 - 64, TOP_SH_Y + 66)),
                 'r': ((200 + 50, TOP_SH_Y + 34), (200 + 64, TOP_SH_Y + 66))}

    def pose(t):
        cross = ramp(t, [(0, 0), (6, 0), (24, 1), (T - 10, 1), (T - 2, 0), (T, 0)])
        open_ = ramp(t, [(0, 0), (24, 0), (40, 1), (T - 24, 1), (T - 10, 0), (T, 0)])
        b = breath(t, 24) * (open_ > 0.98)
        lk = mixp(bent['l'][0], (166, hy + 22), open_)
        la = mixp(bent['l'][1], (172, hy + 70), open_)
        rk = mixp(bent['r'][0], (262 + 8 * open_ + 2 * b, hy + 46 + 6 * open_), cross)
        ra = mixp(bent['r'][1], add(lk, (8, -4)), cross)
        legs = {'l': (lk, la), 'r': (rk, ra)}
        return top_parts(arms=side_arms, legs=legs, head_rot=0)

    return TopViewAnimation('evening_hips_s2_figure_four', T, pose, TOP_ORDER)


ANIMATIONS = {
    'evening_hips_s4_butterfly': butterfly,
    'evening_folds_s4_straddle_fold': straddle_fold,
    'evening_shoulders_s1_self_hug': self_hug,
    'evening_shoulders_s2_triceps_stretch': triceps_stretch,
    'evening_shoulders_s3_eagle_arms': eagle_arms,
    'evening_shoulders_s5_cow_face_arms': cow_face_arms,
    'cooldown_lying_relaxation': lying_relaxation,
    'evening_hips_s1_knees_to_chest': knees_to_chest,
    'evening_hips_s3_happy_baby': happy_baby,
    'evening_folds_s1_legs_up_wall': legs_up_wall,
    'evening_folds_s2_towel_hamstring': towel_hamstring,
    'evening_back_s2_childs_pose': childs_pose,
    'evening_back_s4_sphinx': sphinx,
    'evening_back_s5_cobra': cobra,
    'evening_shoulders_s4_puppy_pose': puppy_pose,
    'evening_folds_s3_head_to_knee': head_to_knee,
    'evening_back_s3_supine_twist': supine_twist,
    'evening_hips_s2_figure_four': figure_four,
    'evening_hips_s5_frog': frog,
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
