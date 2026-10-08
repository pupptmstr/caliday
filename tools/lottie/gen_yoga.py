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
from goro_rig import add, dirv, hold_ramp as ramp, mul, rot, write  # noqa: E402
import goro_rig as gr  # noqa: E402
from gen_evening import ALL_FK, SPINE_ORDER, breath, lerp_angles  # noqa: E402
from gen_morning import (SIDE_BASE, SIDE_FK, PLANK_BR, compose,  # noqa: E402
                         floor_arm, hips_for, lerp_keys, mix, placed,
                         shoulder_points, smooth01, straight, with_back_copies)

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
        s1 = 26 * h + (74 - 26) * c
        s2 = 10 * h + (56 - 10) * c
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


def sun_salutation_a():
    T = 216
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

    keys = [(0, stand), (6, stand), (22, arms_up), (36, swan), (52, fold), (60, half),
            (66, fold), (78, lunge_b), (88, plank), (94, plank), (104, low), (116, updog),
            (130, dog), (142, dog_b), (154, lunge_f), (164, fold), (172, half),
            (188, swan), (200, arms_up), (216, stand)]

    def pose(t):
        for (t0, a), (t1, b) in zip(keys, keys[1:]):
            if t0 <= t <= t1:
                return _build(_blend(a, b, smooth01((t - t0) / (t1 - t0))))
        return _build(stand)

    return gr.Spec('yoga_flow_s4_sun_salutation_a', T, gr.sampled(T, pose),
                   modes=SIDE_FK, order=SPINE_FLOOR_ORDER)


ANIMATIONS = {
    'yoga_one_leg_s5_half_moon': half_moon,
    'yoga_one_leg_s2_eagle': eagle,
    'yoga_backbends_s5_camel': camel,
    'yoga_backbends_s6_wheel': wheel,
    'yoga_flow_s4_sun_salutation_a': sun_salutation_a,
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
