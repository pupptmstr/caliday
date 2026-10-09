#!/usr/bin/env python3
"""Generates the Yoga exercise animations (assets/animations/yoga_*.json).

Usage: python3 tools/lottie/gen_yoga.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Front views (``frontview.py``): the half moon (the torso tips sideways in the
picture plane while one leg rises to the other side) and the eagle (one leg
wraps over the standing thigh and hooks behind its calf: the hooked shin has a
copy under the standing shin, cross-faded once it is across). Side views
(``goro_rig.py``) on the three-part spine: the camel, the wheel and the sun
salutation, a chain of key poses given as parameters (hip, spine, head, arms,
feet) with the hands and feet re-planted by IK in every frame.
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from frontview import (HIP_DX, SHIN_LEN, STAND_ANKLE_Y, THIGH_LEN, Animation,  # noqa: E402
                       figure, rest_arm, swing_arm)
from goro_rig import add, ang_of, dirv, hold_ramp as ramp, mul, rot, write  # noqa: E402
import goro_rig as gr  # noqa: E402
from gen_evening import (ALL_FK, PRONE, SPINE_ORDER, breath, lerp_angles,  # noqa: E402
                         spine_at)
from gen_morning import (NEAR_LEG_LIGHT, SIDE_BASE, SIDE_FK, PLANK_BR,  # noqa: E402
                         bent_leg, clasped, compose, floor_arm, hips_for, leg,
                         lerp_keys, mix, placed, shoulder_points, smooth01,
                         straight, with_back_copies)

LEG = THIGH_LEN + SHIN_LEN          # 84, a straight leg


def into_hold(t, T, start=6, settle=24, leave=16):
    """0 -> 1 -> 0 over the loop: ease in, hold, ease out."""
    return ramp(t, [(0, 0), (start, 0), (start + settle, 1),
                    (T - leave, 1), (T - 2, 0), (T, 0)])


# ── yoga_one_leg_s5_half_moon ────────────────────────────────────────────────
# Standing on the leg at the left of the picture, the torso tips sideways over
# it until it is level, the lower hand reaches the floor under the shoulder,
# the upper arm points at the ceiling and the free leg rises to the other side,
# level with the body. Hold, breathe, come back up.

def half_moon():
    T = 104
    ankle = (206.0, float(STAND_ANKLE_Y))      # the standing foot

    def pose(t):
        u = into_hold(t, T, start=6, settle=30, leave=26)
        b = breath(t, 24) * (u > 0.98)
        lean = -80 * u + 1.2 * b
        hip_l = (ankle[0], ankle[1] - LEG)        # the standing leg stays vertical
        hips = add(hip_l, rot((HIP_DX, 0), lean))
        c = add(hips, rot((0, -51), lean))
        sh = shoulder_points(c, lean)
        # the lower hand goes to the floor under its shoulder, the elbow out
        hang = add(sh[0], (-6, 72))
        floor = (sh[0][0] - 4, 366.0)
        arm_l = (mix(hang, floor, smooth01(u * 1.15)), (-1, 0))
        arm_r = straight(sh[1], -6 - 172 * u)
        # the free leg swings out to level (a little above), toes to the camera
        hip_r = add(hips, rot((HIP_DX, 0), lean))
        a = -100 * u
        d = dirv(a)
        leg_r = dict(knee=add(hip_r, mul(d, THIGH_LEN)), ankle=add(hip_r, mul(d, LEG)),
                     foot_rot=90 * u, foot_scale=(1 - 0.3 * u, 1.0),
                     foot_off=mul(d, 4))
        leg_l = dict(knee=(ankle[0] - 0.5, ankle[1] - SHIN_LEN), ankle=ankle)
        return figure(hips=hips, lean=lean, head=(0, 0, 14 * u),
                      arm_l=arm_l, arm_r=arm_r, leg_l=leg_l, leg_r=leg_r)

    return Animation('yoga_one_leg_s5_half_moon', T, pose)


# ── yoga_one_leg_s2_eagle ────────────────────────────────────────────────────
# Knees soften and the hips sink, one leg lifts and wraps over the standing
# thigh, its foot hooking behind the standing calf; the arms wrap too (elbows
# stacked at shoulder height, forearms up, palms together in front of the
# face). Sit a little deeper and breathe; unwind.

def eagle():
    T = 104
    st_ankle = (192.0, float(STAND_ANKLE_Y))

    def wrap_leg(hips, v):
        """The screen-right leg: standing (0) -> knee lifted (1) -> wrapped (2)."""
        hr = (hips[0] + HIP_DX, hips[1])
        keys = [((hr[0] + 0.5, hips[1] + 46), (hr[0] + 1, 372.0), 1.0),
                ((hr[0] - 4, hips[1] + 16), (hr[0] + 2, hips[1] + 50), 1.25),
                ((176.0, hips[1] + 22), (200.0, 354.0), 1.15)]
        knee, ankle, near = lerp_keys(keys, v)
        w = max(0.0, v - 1)
        return dict(knee=knee, ankle=ankle, near=near,
                    foot_rot=-50 * w, foot_scale=(1 - 0.3 * w, 1), foot_off=(6 * w, 4))

    def pose(t):
        k = into_hold(t, T, start=6, settle=34, leave=22)
        b = breath(t, 24) * (k > 0.98)
        sink = 26 * k + 1.5 * b
        hips = (200 + 4 * k, 288 + sink)
        hl = (hips[0] - HIP_DX, hips[1])
        # standing leg: the knee comes forward (a short thigh, a bigger cap)
        knee_l = (hl[0] + 4 * k, hips[1] + THIGH_LEN - 26 * k)
        legs = figure(hips=hips, leg_l=dict(knee=knee_l, ankle=st_ankle, near=1 + 0.35 * k),
                      leg_r=wrap_leg(hips, 2 * k))
        ts = (1.0, 1 - 0.12 * k)                 # the torso leans forward
        c = (hips[0], hips[1] - 51 * ts[1])
        sh = shoulder_points(c, 0, ts)
        ey = sh[0][1] + 8
        end = {'arm_l': ((c[0] + 4, ey), (c[0] - 4, ey - 34)),
               'arm_r': ((c[0] - 4, ey + 8), (c[0] + 5, ey - 26))}
        arms = {}
        for i, (key, sx) in enumerate((('arm_l', -1), ('arm_r', 1))):
            start = rest_arm(sh[i], add(sh[i], (sx * 6, 72)), (sx, 0))
            arms[key] = swing_arm(start, end[key], k, -1 if sx < 0 else 1)
        upper = figure(hips=hips_for(c), torso_scale=ts, head=(0, 6 * k, 0),
                       hand_rot=(90 * k, -90 * k), **arms)
        return compose(legs, upper)

    def front(t):
        return 1.0 if into_hold(t, T, start=6, settle=34, leave=22) < 0.7 else 0.0

    order = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r', 'head',
             'knee_r', 'thigh_r', 'shin_r', 'foot_r', 'knee_l', 'thigh_l',
             'shin_l', 'foot_l', 'shin_r@b', 'foot_r@b', 'body']
    return Animation('yoga_one_leg_s2_eagle', T,
                     with_back_copies(pose, ['shin_r', 'foot_r'], front), order=order)


# ══ Side views ═══════════════════════════════════════════════════════════════

# The three-part spine with the hands on the floor: the head hangs in front of
# the near arm.
SPINE_FLOOR_ORDER = ['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r',
                     'sp_chest', 'sp_mid', 'sp_pelvis', 'thigh_l', 'shin_l', 'foot_l',
                     'uarm_l', 'farm_l']
_SPINE_PROBE = gr.Spec('probe', 1, [(0, gr.P(), 'linear')], modes=ALL_FK)


def body(hip, chest, s1=0.0, s2=0.0, ht=0.0, base=SIDE_BASE):
    """A three-part-spine pose with the near hip joint at ``hip``."""
    p = gr.P(base, cx=0.0, cy=0.0, br=chest, spine=(s1, s2), ht=ht)
    return placed(p, 'leg_n', hip)


# ── yoga_backbends_s5_camel ──────────────────────────────────────────────────
# Kneeling tall on tucked toes, hands on the lower back. The hips press forward
# over the knees, the chest lifts and the spine arches back, the head drops
# back (the face to the ceiling). Hold, breathe, and come up chest first.
# The hands stay on the back: Goro's arms reach the heels only with the chest
# level behind him, which read as a bow (the owner chose this version).

CAMEL_KNEE = (204.0, 366.0)


def camel():
    T = 120

    def pose(t):
        a = ramp(t, [(0, 0), (8, 0), (36, 1), (T - 18, 1), (T - 2, 0), (T, 0)])     # arch
        drop = ramp(t, [(0, 0), (36, 0), (50, 1), (T - 30, 1), (T - 16, 0), (T, 0)])  # head
        b = breath(t, 24) * (drop > 0.98)
        hip = add(CAMEL_KNEE, mul(dirv(180 + 6 * a), gr.THIGH))
        p = body(hip, -62 * a - 1.5 * b, 26 * a, 20 * a, base=gr.P(hip_n=8, hip_f=2))
        # kneeling on tucked toes: the shins rise a little to the heels
        for side, dx in (('n', 0), ('f', -5)):
            knee = (CAMEL_KNEE[0] + dx, CAMEL_KNEE[1])
            hj = gr.joint_of(p, 'leg_' + side)
            ankle = (knee[0] - 36, 354.0)
            p['leg_' + side] = (gr.ang_of(knee[0] - hj[0], knee[1] - hj[1]),
                                gr.ang_of(ankle[0] - knee[0], ankle[1] - knee[1]))
            p['sc_thigh_' + side] = math.dist(hj, knee) / gr.THIGH
            p['foot_' + side] = (2, 4, 62)
        pel = gr.solve(_SPINE_PROBE, p)['sp_pelvis']
        back = add(pel['p'], rot((-34, -4), pel['r']))           # the lower back
        for side in ('n', 'f'):
            p = gr.plant(p, 'arm_' + side, back, (1, 0.4))
        p['ht'] = -18 * a - 22 * drop
        return p

    return gr.Spec('yoga_backbends_s5_camel', T, gr.sampled(T, pose), modes=ALL_FK,
                   order=SPINE_ORDER)


# ── yoga_backbends_s6_wheel ──────────────────────────────────────────────────
# On the back, knees bent, feet near the hips, hands planted by the shoulders
# with the elbows up. Press up: the hips rise first, then the chest; the arms
# straighten and the head hangs between them, the body an arch on hands and
# feet (Goro's torso is long, so the arch is low). Hold, and lower slowly.

WHEEL_LIE = dict(hip_n=-6, hip_f=-12, foot_n=(5, 4, 0), foot_f=(5, 4, 0))
WHEEL_SH0, WHEEL_SH1 = (119.0, 345.0), (158.0, 294.0)     # the near shoulder
WHEEL_HANDS = {'n': (150.0, 368.0), 'f': (145.0, 368.0)}
WHEEL_FEET = {'n': (250.0, 372.0), 'f': (245.0, 372.0)}


def wheel():
    T = 108

    def pose(t):
        h = ramp(t, [(0, 0), (6, 0), (24, 1), (T - 10, 1), (T - 2, 0), (T, 0)])   # bridge
        c = ramp(t, [(0, 0), (20, 0), (44, 1), (T - 26, 1), (T - 8, 0), (T, 0)])  # chest up
        b = breath(t, 24) * (c > 0.98)
        sh = mix(WHEEL_SH0, WHEEL_SH1, c)
        sh = (sh[0], sh[1] - 10 * math.sin(math.pi * c) - 2 * b)
        s1 = -26 * h + (74 + 26) * c         # negative: the hips rise (a bridge)
        s2 = -10 * h + (56 + 10) * c
        p = gr.P(gr.P(**WHEEL_LIE), cx=0.0, cy=0.0, br=-90 - 70 * c, spine=(s1, s2))
        p = placed(p, 'arm_n', sh)
        for side in ('n', 'f'):
            p = gr.plant(p, 'leg_' + side, WHEEL_FEET[side], (1, -1))
            p = floor_arm(p, side, WHEEL_HANDS[side])
        p['ht'] = 30 * c
        return p

    return gr.Spec('yoga_backbends_s6_wheel', T, gr.sampled(T, pose), modes=ALL_FK,
                   order=SPINE_ORDER)


# ── yoga_flow_s4_sun_salutation_a ────────────────────────────────────────────
# Surya Namaskar A, one round: stand, arms up, swan-dive to a fold (the arms in
# line with the torso), half lift, fold, step back (near foot, far foot) to a
# plank, lower (chaturanga), upward dog, downward dog (a breath), step forward,
# half lift, rise with the arms up, stand. Every frame interpolates the key
# parameters and re-plants the hands and feet, so contacts never slide.

HANDS = {'n': (292.0, 368.0), 'f': (286.0, 368.0)}
FEET = {'n': (190.0, 372.0), 'f': (184.0, 372.0)}
STAND_FOOT, TUCKED, TOPS, DOG_FOOT = (5, 4, 0), (2, -3, 62), (-8, 4, 180), (2, 2, 0)


def _line(toes, shoulder):
    """Hip joint and chest angle of a straight body from the toes to the near
    shoulder (plank, chaturanga)."""
    d = (shoulder[0] - toes[0], shoulder[1] - toes[1])
    n = math.hypot(*d)
    u = (d[0] / n, d[1] / n)
    return add(toes, mul(u, LEG)), math.degrees(math.atan2(u[0], -u[1]))


def _key(hip, chest, s=(0.0, 0.0), ht=0.0, arm=0.0, w=0.0, feet=None, foot=STAND_FOOT):
    """A key pose: near hip joint, chest angle, spine bends, head turn, the
    free arms' angle relative to the chest, ``w`` = how planted the hands are,
    the ankles and the foot transforms."""
    feet = feet or FEET
    foot = foot if isinstance(foot, dict) else {'n': foot, 'f': foot}
    return dict(hip=hip, chest=chest, s1=s[0], s2=s[1], ht=ht, arm=arm, w=w,
                feet_n=feet['n'], feet_f=feet['f'], foot_n=foot['n'], foot_f=foot['f'])


def _build(k):
    p = body(k['hip'], k['chest'], k['s1'], k['s2'], k['ht'])
    for side in ('n', 'f'):
        f = k['feet_' + side]
        hip = gr.joint_of(p, 'leg_' + side)
        bend = (0, 1) if f[0] < hip[0] - 24 else (1, -1)   # a leg behind bends down
        p = gr.plant(p, 'leg_' + side, f, bend)
        p['foot_' + side] = k['foot_' + side]
    free = (k['chest'] + k['arm'],) * 2
    for side in ('n', 'f'):
        planted = floor_arm(p, side, HANDS[side])['arm_' + side]
        p['arm_' + side] = lerp_angles(free, planted, k['w'])
    return p


def _blend(a, b, u):
    out = {}
    for name in a:
        if name.startswith('feet_'):
            pa, pb = a[name], b[name]
            lift = 14 * math.sin(math.pi * u) if math.dist(pa, pb) > 6 else 0.0
            p = mix(pa, pb, u)
            out[name] = (p[0], p[1] - lift)
        elif isinstance(a[name], tuple):
            out[name] = mix(a[name], b[name], u)
        else:
            out[name] = a[name] + (b[name] - a[name]) * u
    return out


def _sun_states():
    """The key poses of the sun salutations (one layout: the feet at FEET, the
    hands at HANDS when planted)."""
    plank_sh = (HANDS['n'][0] - 4, 290.0)
    plank_toes = add(plank_sh, mul(dirv(PLANK_BR), 89 + LEG))
    back_feet = {'n': (plank_toes[0], 370.0), 'f': (plank_toes[0] - 5, 370.0)}
    low_toes = (plank_toes[0] + 16, 370.0)
    low_feet = {'n': low_toes, 'f': (low_toes[0] - 5, 370.0)}
    up_feet = {'n': (plank_toes[0] + 2, 366.0), 'f': (plank_toes[0] - 3, 366.0)}
    dog_feet = {'n': (plank_toes[0] + 6, 372.0), 'f': (plank_toes[0] + 1, 372.0)}
    plank_hip, plank_br = _line(back_feet['n'], plank_sh)
    low_hip, low_br = _line(low_toes, (low_toes[0] + 166, 324.0))
    dog_hip = add(dog_feet['n'], mul(dirv(14), -LEG))
    dog_br = math.degrees(math.atan2(HANDS['n'][0] - dog_hip[0], -(HANDS['n'][1] - dog_hip[1])))

    stand = _key((190.0, 288.0), 0.0)
    arms_up = _key((193.0, 288.0), -6.0, ht=-14, arm=-172)
    swan = _key((184.0, 289.0), 50.0, ht=-4, arm=-180)
    fold = _key((182.0, 289.0), 112.0, (-12, -12), ht=34, arm=-180, w=1)
    half = _key((184.0, 289.0), 96.0, (2, 2), ht=-34, arm=-180, w=1)
    lunge_b = _key((198.0, 314.0), 92.0, (-4, -4), ht=-14, w=1,
                   feet={'n': back_feet['n'], 'f': FEET['f']}, foot={'n': TUCKED, 'f': STAND_FOOT})
    plank = _key(plank_hip, plank_br, ht=-18, w=1, feet=back_feet, foot=TUCKED)
    low = _key(low_hip, low_br, ht=-16, w=1, feet=low_feet, foot=TUCKED)
    updog = _key((up_feet['n'][0] + 82, 350.0), 34.0, (14, 12), ht=-46, w=1,
                 feet=up_feet, foot=TOPS)
    dog = _key(dog_hip, dog_br, ht=24, w=1, feet=dog_feet, foot=DOG_FOOT)
    dog_b = _key(add(dog_hip, (1, -2)), dog_br + 1, ht=26, w=1, feet=dog_feet, foot=DOG_FOOT)
    lunge_f = _key((202.0, 314.0), 92.0, (-4, -4), ht=-14, w=1,
                   feet={'n': FEET['n'], 'f': dog_feet['f']}, foot={'n': STAND_FOOT, 'f': DOG_FOOT})
    return dict(stand=stand, arms_up=arms_up, swan=swan, fold=fold, half=half, lunge_b=lunge_b,
                plank=plank, low=low, updog=updog, dog=dog, dog_b=dog_b, lunge_f=lunge_f,
                back_feet=back_feet, dog_feet=dog_feet)


def _flow(name, keys):
    """A side-view animation through ``keys`` [(frame, key pose)], the last
    frame equal to the first."""
    T = keys[-1][0]

    def pose(t):
        for (t0, a), (t1, b) in zip(keys, keys[1:]):
            if t0 <= t <= t1:
                return _build(_blend(a, b, smooth01((t - t0) / (t1 - t0))))
        return _build(keys[0][1])

    return gr.Spec(name, T, gr.sampled(T, pose), modes=SIDE_FK, order=SPINE_FLOOR_ORDER)


def sun_salutation_a():
    S = _sun_states()
    return _flow('yoga_flow_s4_sun_salutation_a', [
        (0, S['stand']), (6, S['stand']), (22, S['arms_up']), (36, S['swan']), (52, S['fold']),
        (60, S['half']), (66, S['fold']), (78, S['lunge_b']), (88, S['plank']), (94, S['plank']),
        (104, S['low']), (116, S['updog']), (130, S['dog']), (142, S['dog_b']), (154, S['lunge_f']),
        (164, S['fold']), (172, S['half']), (188, S['swan']), (200, S['arms_up']), (216, S['stand'])])


# ── yoga_flow_s3_half_sun_salutation ─────────────────────────────────────────
# Stand, arms up, swan-dive to a fold, half lift, fold, rise with the arms up,
# stand: the first half of the sun salutation, without the floor part.

def half_sun_salutation():
    S = _sun_states()
    return _flow('yoga_flow_s3_half_sun_salutation', [
        (0, S['stand']), (6, S['stand']), (22, S['arms_up']), (36, S['swan']), (52, S['fold']),
        (62, S['half']), (70, S['fold']), (86, S['swan']), (98, S['arms_up']), (114, S['stand'])])


# ── yoga_flow_s5_sun_salutation_b ────────────────────────────────────────────
# Surya Namaskar B: chair, fold, half lift, step back, plank, lower, upward dog,
# downward dog; the near foot steps forward between the hands, Warrior I (the
# arms up), hands down, back through the plank to the dog; the same with the
# far foot in front; step forward, half lift, rise into the chair, stand.

def _warrior_1_keys(front, dog_feet):
    """Warrior I in the flow, ``front`` = the side whose foot steps forward:
    (hands-down lunge, upright with the arms up)."""
    back = 'f' if front == 'n' else 'n'
    fx = 243.0 if front == 'n' else 237.0
    feet = {front: (fx, 372.0), back: dog_feet[back]}
    foot = {front: STAND_FOOT, back: (5, 4, -12)}
    lunge = _key((208.0, 324.0), 75.0, (-2, -2), ht=-12, w=1, feet=feet, foot=foot)
    up = _key((200.0, 322.0), -4.0, ht=-14, arm=-176, feet=feet, foot=foot)
    return lunge, up


def sun_salutation_b():
    S = _sun_states()
    chair = _key((168.0, 318.0), 30.0, ht=-10, arm=-180)
    swan_b = _key((176.0, 304.0), 70.0, ht=-4, arm=-180)
    ln, wn = _warrior_1_keys('n', S['dog_feet'])
    lf, wf = _warrior_1_keys('f', S['dog_feet'])
    vinyasa = [S['plank'], S['low'], S['updog'], S['dog']]
    keys, t = [(0, S['stand']), (6, S['stand'])], 6
    for pose, dt in ((chair, 16), (swan_b, 12), (S['fold'], 12), (S['half'], 8), (S['fold'], 6),
                     (S['lunge_b'], 12), (S['plank'], 10), (S['low'], 10), (S['updog'], 12),
                     (S['dog'], 14), (ln, 14), (wn, 24), (wn, 8), (ln, 24), *zip(vinyasa, (12, 10, 12, 14)),
                     (lf, 14), (wf, 24), (wf, 8), (lf, 24), *zip(vinyasa, (12, 10, 12, 14)),
                     (S['dog_b'], 10), (S['lunge_f'], 14), (S['fold'], 10), (S['half'], 8),
                     (swan_b, 12), (chair, 12), (S['stand'], 16)):
        t += dt
        keys.append((t, pose))
    return _flow('yoga_flow_s5_sun_salutation_b', keys)


# ── yoga_standing_s1_chair ───────────────────────────────────────────────────
# Feet together, the knees bend and the hips sit back as if onto a chair, the
# torso leans forward and the arms rise in line with it; hold, breathe, stand.

def chair():
    stand = _key((190.0, 288.0), 0.0)
    sit = _key((168.0, 318.0), 30.0, ht=-10, arm=-180)
    sit_b = _key((167.0, 320.0), 31.0, ht=-11, arm=-182)
    return _flow('yoga_standing_s1_chair', [
        (0, stand), (6, stand), (30, sit), (44, sit_b), (58, sit), (72, sit_b), (82, sit),
        (100, stand), (104, stand)])


# ── yoga_standing_s2_warrior_1 ───────────────────────────────────────────────
# The far foot steps far back (turned out a little), the front knee bends over
# the ankle, the hips sink, the torso stays upright and the arms rise
# overhead; hold, breathe, step back to standing.

def warrior_1():
    stand = _key((190.0, 288.0), 0.0)
    feet = {'n': FEET['n'], 'f': (94.0, 372.0)}
    foot = {'n': STAND_FOOT, 'f': (5, 4, -12)}
    w = _key((160.0, 314.0), -4.0, ht=-14, arm=-176, feet=feet, foot=foot)
    w_b = _key((160.0, 316.0), -5.0, ht=-15, arm=-178, feet=feet, foot=foot)
    return _flow('yoga_standing_s2_warrior_1', [
        (0, stand), (6, stand), (34, w), (48, w_b), (62, w), (76, w_b), (84, w),
        (104, stand), (108, stand)])


# ── Front views: Warrior II, triangle, side angle, tree ──────────────────────

def turn(a, b, u):
    """Angle from ``a`` to ``b`` the short way round."""
    return a + (((b - a + 180) % 360) - 180) * u


def wide_legs(u, bend_front, sink=0.0, shift=0.0):
    """Feet stepping wide apart (the front foot on the right of the picture);
    ``bend_front`` bends the front knee out over the ankle."""
    hips = (200 + shift * u, 288 + sink * u)
    ank_l = (186 - 46 * u, float(STAND_ANKLE_Y))
    ank_r = (214 + 50 * u, float(STAND_ANKLE_Y))
    if bend_front and u > 1e-6:
        leg_r = bent_leg(1, hips, ank_r, (1, -0.5), near=1 + 0.1 * u)
    else:
        leg_r = leg(1, ank_r, hips=hips)
    return hips, leg(-1, ank_l, hips=hips), leg_r


# ── yoga_standing_s3_warrior_2 ───────────────────────────────────────────────
# Feet wide, the front knee bends out over the ankle and the hips sink; the arms
# open to a T at shoulder height and the head turns to the front hand.

def warrior_2():
    T = 96

    def pose(t):
        u = into_hold(t, T, start=6, settle=30, leave=24)
        b = breath(t, 24) * (u > 0.98)
        hips, leg_l, leg_r = wide_legs(u, True, sink=24 + b, shift=12)
        sh = shoulder_points(add(hips, (0, -51)))
        arms = {'arm_l': straight(sh[0], 6 + 84 * u), 'arm_r': straight(sh[1], -6 - 84 * u)}
        return figure(hips=hips, head=(8 * u, 0, 0), head_scale=(1 - 0.06 * u, 1),
                      leg_l=leg_l, leg_r=leg_r, **arms)

    return Animation('yoga_standing_s3_warrior_2', T, pose)


def _tilted(u, lean, hips, legs, low_target, up_angle, head_tilt, arm_k=None):
    """The torso tipped sideways by ``lean`` over the front leg: the lower hand
    goes to ``low_target``, the upper arm to the world angle ``up_angle``."""
    c = add(hips, rot((0, -51), lean))
    sh = shoulder_points(c, lean)
    k = smooth01(u * 1.15)
    wrist = mix(add(sh[1], (6, 72)), low_target, k)
    d = (wrist[0] - sh[1][0], wrist[1] - sh[1][1])
    arm_r = (wrist, (d[1], -d[0]))      # the elbow always out, away from the body
    arm_l = straight(sh[0], 6 + ((up_angle - 6) % 360) * (k if arm_k is None else arm_k))   # up through the side
    upper = figure(hips=hips_for(c, lean), lean=lean, head=(0, 0, head_tilt),
                   arm_l=arm_l, arm_r=arm_r)
    return compose(legs, upper)


# ── yoga_standing_s4_triangle ────────────────────────────────────────────────
# Feet wide, both legs straight; the torso tips sideways over the front leg,
# the lower hand slides down to the shin, the upper arm points at the ceiling
# in line with the shoulders and the gaze goes up to it.

def triangle():
    T = 104

    def pose(t):
        u = into_hold(t, T, start=6, settle=32, leave=26)
        b = breath(t, 24) * (u > 0.98)
        hips, leg_l, leg_r = wide_legs(u, False, sink=14)
        legs = figure(hips=hips, leg_l=leg_l, leg_r=leg_r)
        lean = 64 * u + 1.2 * b
        shin = mix(leg_r['knee'], leg_r['ankle'], 0.45)
        line = ang_of(*rot((-1, 0), lean))          # along the shoulders, upwards
        return _tilted(u, lean, hips, legs, (shin[0] - 8, shin[1]), line, -16 * u)

    return Animation('yoga_standing_s4_triangle', T, pose)


# ── yoga_standing_s5_side_angle ──────────────────────────────────────────────
# From Warrior II legs the torso tips deep over the front thigh: the lower
# forearm rests on it, the upper arm reaches over the ear in one line with the
# body, from the back foot to the fingertips.

def side_angle():
    T = 120

    def pose(t):
        u = into_hold(t, T, start=6, settle=40, leave=34)
        b = breath(t, 24) * (u > 0.98)
        hips, leg_l, leg_r = wide_legs(u, True, sink=26, shift=16)
        legs = figure(hips=hips, leg_l=leg_l, leg_r=leg_r)
        lean = 70 * u + 1.2 * b
        knee = leg_r['knee']
        top = ang_of(*rot((0, -1), lean))           # the long axis of the torso
        # the arm sweeps through the side over the head: it gets the whole settle
        return _tilted(u, lean, hips, legs, (knee[0] - 16, knee[1] - 12), top, 0.0, arm_k=u)

    return Animation('yoga_standing_s5_side_angle', T, pose)


# ── yoga_one_leg_s1_tree ─────────────────────────────────────────────────────
# Standing on the leg on the left of the picture, the other knee lifts and
# opens out to the side, the sole pressing on the inner thigh of the standing
# leg; the palms come together at the chest. Hold with a slight sway.

def tree():
    T = 96

    def pose(t):
        u = into_hold(t, T, start=6, settle=30, leave=24)
        b = breath(t, 30) * (u > 0.98)
        hips = (200 - 6 * u + 1.5 * b, 288.0)
        hr = hips[0] + HIP_DX
        keys = [((hr + 0.5, 334.0), (hr + 1, 372.0), 1.0),          # standing
                ((hr + 2, 300.0), (hr + 4, 336.0), 1.3),            # knee up in front
                ((hips[0] + 36, 320.0), (hips[0] - 2, 330.0), 1.2)]  # knee out, sole on the thigh
        knee, ankle, near = lerp_keys(keys, 2 * u)
        w = max(0.0, 2 * u - 1)
        leg_r = dict(knee=knee, ankle=ankle, near=near, foot_rot=80 * w,
                     foot_scale=(1 - 0.3 * w, 1), foot_off=(-4 * w, 4 - 2 * w))
        leg_l = dict(knee=(193.5, 334.0), ankle=(193.0, float(STAND_ANKLE_Y)))
        c = add(hips, (0, -51))
        sh = shoulder_points(c)
        hands = clasped(sh, c)
        arms = {}
        for i, (key, sx) in enumerate((('arm_l', -1), ('arm_r', 1))):
            wrist, _, elbow = hands[key]
            arms[key] = (mix(add(sh[i], (sx * 6, 72)), wrist, u), (0, 1),
                         mix(add(sh[i], (sx * 4, 40)), elbow, u))
        return figure(hips=hips, hand_rot=(90 * u, -90 * u), leg_l=leg_l, leg_r=leg_r, **arms)

    order = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r', 'head', 'foot_r',
             'shin_r', 'knee_r', 'thigh_r', 'knee_l', 'thigh_l', 'shin_l', 'foot_l', 'body']
    return Animation('yoga_one_leg_s1_tree', T, pose, order=order)


# ── Side views: Warrior III, dancer ──────────────────────────────────────────

def _on_far_leg(chest, foot, ht=0.0):
    """A pose standing on the far leg at ``foot``, torso at ``chest``."""
    p = gr.P(SIDE_BASE, cx=0.0, cy=0.0, br=chest, ht=ht)
    p = placed(p, 'leg_f', (foot[0] + 2, foot[1] - LEG + 1))
    return gr.plant(p, 'leg_f', foot, (1, -1))


# ── yoga_one_leg_s3_warrior_3 ────────────────────────────────────────────────
# Standing on one leg, the body hinges forward to level while the other leg
# lifts straight back in line with it and the arms reach forward: a T. Hold,
# and come back up.

def warrior_3():
    T = 104
    foot = (180.0, 372.0)

    def pose(t):
        u = into_hold(t, T, start=6, settle=34, leave=26)
        b = breath(t, 24) * (u > 0.98)
        chest = 88 * u + b
        p = _on_far_leg(chest, foot, ht=12 * u)
        p['leg_n'] = (90 * u + b, 90 * u + b)
        p['foot_n'] = (5 - 9 * u, 4 + 2 * u, 90 * u)
        arm = turn(0, chest - 180, u)
        p['arm_n'] = p['arm_f'] = (arm, arm)
        return p

    return gr.Spec('yoga_one_leg_s3_warrior_3', T, gr.sampled(T, pose), modes=SIDE_FK)


# ── yoga_one_leg_s4_dancer ───────────────────────────────────────────────────
# Standing on one leg, the other knee bends and the near hand takes the foot
# behind; pressing the foot into the hand the leg rises behind while the torso
# tips forward and the free arm reaches ahead. (Goro's arm reaches the foot
# only with the heel high, close above the hips.)

def dancer():
    T = 104
    foot = (170.0, 372.0)

    def pose(t):
        u = into_hold(t, T, start=6, settle=36, leave=26)
        bend = smooth01(u * 1.6)                     # the knee bends first
        b = breath(t, 24) * (u > 0.98)
        chest = 84 * u + b
        p = _on_far_leg(chest, foot, ht=-30 * u)
        a1 = 165 * u
        p['leg_n'] = (a1, a1 + 100 * bend)
        p['foot_n'] = (2, 0, 160 * bend)
        hip = gr.joint_of(p, 'leg_n')
        knee = add(hip, mul(dirv(a1), gr.THIGH))
        ankle = add(knee, mul(dirv(a1 + 100 * bend), gr.SHIN))
        held = gr.ik_to_fk(p, 'arm_n', ankle, (0, -1))
        p['arm_n'] = lerp_angles((0, 0), held, smooth01(u * 1.3))
        reach = turn(0, -120, u)
        p['arm_f'] = (reach, reach)
        return p

    return gr.Spec('yoga_one_leg_s4_dancer', T, gr.sampled(T, pose), modes=SIDE_FK,
                   tint=NEAR_LEG_LIGHT)


# ── Backbends on the floor: locust, bridge, bow ──────────────────────────────

LOCUST_PELVIS = (176.0, 348.0)


# ── yoga_backbends_s2_locust ─────────────────────────────────────────────────
# On the stomach, arms along the body. The chest, the arms and the legs lift
# off the floor together, the gaze down and a little forward; hold, lower.

def locust():
    T = 72

    def pose(t):
        k = into_hold(t, T, start=8, settle=20, leave=14)
        k *= 1 + 0.05 * breath(t, 24) * (k > 0.98)
        lift = 24 * k
        p = spine_at(gr.P(**PRONE), 90 - lift, lift / 2, lift / 2, 'pelvis', LOCUST_PELVIS)
        p['leg_n'] = (90 + 14 * k, 90 + 14 * k)
        p['leg_f'] = (91 + 12 * k, 91 + 12 * k)
        p['arm_n'] = p['arm_f'] = (88 + 12 * k, 88 + 12 * k)
        p['ht'] = (55 - 30 * k) - p['br']
        return p

    return gr.Spec('yoga_backbends_s2_locust', T, gr.sampled(T, pose), modes=ALL_FK,
                   order=SPINE_ORDER)


# ── yoga_backbends_s3_bridge ─────────────────────────────────────────────────
# On the back, knees bent, feet near the hips, arms long on the floor. The hips
# lift until knees, hips and shoulders are one line; hold, roll down.

def bridge():
    T = 84

    def pose(t):
        h = into_hold(t, T, start=6, settle=24, leave=18)
        h *= 1 + 0.04 * breath(t, 24) * (h > 0.98)
        p = gr.P(gr.P(**WHEEL_LIE), cx=0.0, cy=0.0, br=-90, spine=(-34 * h, -12 * h))
        p = placed(p, 'arm_n', WHEEL_SH0)
        for side in ('n', 'f'):
            p = gr.plant(p, 'leg_' + side, WHEEL_FEET[side], (1, -1))
        p['arm_n'] = p['arm_f'] = (-88, -88)
        return p

    return gr.Spec('yoga_backbends_s3_bridge', T, gr.sampled(T, pose), modes=ALL_FK,
                   order=SPINE_ORDER)


# ── yoga_backbends_s4_bow ────────────────────────────────────────────────────
# On the stomach. The knees bend (shins up), then the chest and the thighs
# lift while the hands reach back and take the ankles at the top (Goro's arms
# reach them only with the chest and the knees high); a gentle rock, release.

def bow():
    T = 96

    def pose(t):
        knees = ramp(t, [(0, 0), (6, 0), (20, 1), (T - 10, 1), (T - 2, 0), (T, 0)])
        k = ramp(t, [(0, 0), (16, 0), (40, 1), (T - 20, 1), (T - 8, 0), (T, 0)])
        rock = math.sin(2 * math.pi * (t - 40) / 24) * (k > 0.98)
        lift = 55 * k + 3 * rock
        p = spine_at(gr.P(**PRONE), 90 - lift, lift / 2, lift / 2, 'pelvis', (180.0, 348.0))
        a1 = 90 + 45 * k + 2 * rock
        for side, d in (('n', 0), ('f', -3)):
            p['leg_' + side] = (a1 + d, a1 + d + 100 * knees)
            p['foot_' + side] = (-6, 4, 75 + 100 * knees)
        for side in ('n', 'f'):
            hip = gr.joint_of(p, 'leg_' + side)
            a, b_ = p['leg_' + side]
            ankle = add(add(hip, mul(dirv(a), gr.THIGH)), mul(dirv(b_), gr.SHIN))
            held = gr.ik_to_fk(p, 'arm_' + side, ankle, (0, 1))
            p['arm_' + side] = lerp_angles((88, 88), held, k)
        p['ht'] = (55 - 45 * k) - p['br']
        return p

    return gr.Spec('yoga_backbends_s4_bow', T, gr.sampled(T, pose), modes=ALL_FK,
                   order=SPINE_ORDER)


ANIMATIONS = {
    'yoga_standing_s1_chair': chair,
    'yoga_standing_s2_warrior_1': warrior_1,
    'yoga_standing_s3_warrior_2': warrior_2,
    'yoga_standing_s4_triangle': triangle,
    'yoga_standing_s5_side_angle': side_angle,
    'yoga_one_leg_s1_tree': tree,
    'yoga_one_leg_s2_eagle': eagle,
    'yoga_one_leg_s3_warrior_3': warrior_3,
    'yoga_one_leg_s4_dancer': dancer,
    'yoga_one_leg_s5_half_moon': half_moon,
    'yoga_backbends_s2_locust': locust,
    'yoga_backbends_s3_bridge': bridge,
    'yoga_backbends_s4_bow': bow,
    'yoga_backbends_s5_camel': camel,
    'yoga_backbends_s6_wheel': wheel,
    'yoga_flow_s3_half_sun_salutation': half_sun_salutation,
    'yoga_flow_s4_sun_salutation_a': sun_salutation_a,
    'yoga_flow_s5_sun_salutation_b': sun_salutation_b,
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
