#!/usr/bin/env python3
"""Generates the animations of the branches outside the courses (0.9.5):
Strong Back, Glutes, Arms & Shoulders and Cardio
(assets/animations/{strong_back,glutes,arms_shoulders,cardio}_*.json).

Usage: python3 tools/lottie/gen_extra.py [--out DIR] [name ...]
Defaults to writing every animation into assets/animations/.

Top views (``topview.py``), Goro face down with his back seen as in the frog:
Y-T-W raises and reverse snow angels (arms lifted off the floor are drawn a
little bigger: closer to the camera), the fire hydrant on all fours (a thigh
pointing at the floor is short with its kneecap showing; lifted out to the side
it shows its full length). Side views (``goro_rig.py``): the door-frame row
(a straight body leaning back from the feet at the post), chair dips (a chair
behind Goro) and the burpee, a chain of key poses as the sun salutation.
"""

import argparse
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import goro_rig as gr  # noqa: E402
from goro_rig import add, ang_of, dirv, hold_ramp as ramp, mul, rot, write  # noqa: E402
from topview import K as TK, TopViewAnimation, _segment  # noqa: E402
from gen_evening import (ALL_FK, LEG_LIGHT, PRONE, SPINE_ORDER, breath,  # noqa: E402
                         frog_shapes, into_hold, lerp_angles, spine_at)
from gen_morning import (SIDE_BASE, SIDE_FK, floor_arm, mix, mix_angles,  # noqa: E402
                         placed, smooth01)
from gen_yoga import STAND_FOOT, TUCKED, SPINE_FLOOR_ORDER, _line, body  # noqa: E402

LEG = 84.0                             # a straight leg (thigh + shin)


# ══ Top views: face down, the back seen ══════════════════════════════════════

PRONE_TOP_ORDER = ['head', 'hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l',
                   'uarm_r', 'body', 'thigh_l', 'thigh_r', 'shin_l', 'shin_r',
                   'foot_l', 'foot_r', 'mat']
ARM_TOP = 78.0                         # a straight arm seen from above (43 + 35)
UARM_TOP = 43.0


def _prone_top(lift):
    """Face down, legs long, seen from above; ``lift`` 0..1 raises the chest a
    little (the crown comes up towards the camera). Returns (parts, shoulders)."""
    c = (200.0, 200.0)
    parts = {'body': dict(p=c, r=0, s=(TK * 100, TK * 100)),
             'head': dict(p=(200, 122 - 3 * lift), r=0,
                          s=(TK * 100 * (1 + 0.05 * lift), TK * 92 * (1 + 0.05 * lift)))}
    for side, sx in (('l', -1), ('r', 1)):
        hip = (200 + sx * 22, c[1] + 50)
        knee = (200 + sx * 24, c[1] + 96)
        ankle = (200 + sx * 25, c[1] + 140)
        parts['thigh_' + side] = _segment(hip, knee, 'thigh')
        parts['shin_' + side] = _segment(knee, ankle, 'shin')
        parts['foot_' + side] = dict(p=add(ankle, (0, 8)), r=0, s=(TK * 100, TK * 100))
    shoulders = {'l': (164.0, c[1] - 41), 'r': (236.0, c[1] - 41)}
    return parts, shoulders


def _top_arm(parts, side, sh, a1, a2, lift):
    """An arm seen from above by its two angles (goro_rig convention, the left
    arm given mirrored); a lifted arm is drawn a little larger."""
    sx = -1 if side == 'l' else 1
    a1, a2 = sx * a1, sx * a2
    grow = 1 + 0.12 * lift
    elbow = add(sh, mul(dirv(a1), UARM_TOP * grow))
    wrist = add(elbow, mul(dirv(a2), (ARM_TOP - UARM_TOP) * grow))
    parts['uarm_' + side] = _segment(sh, elbow, 'uarm')
    parts['farm_' + side] = _segment(elbow, wrist, 'farm')
    parts['hand_' + side] = dict(p=wrist, r=0, s=(TK * 100 * grow, TK * 100 * grow))


# ── strong_back_s1_ytw ───────────────────────────────────────────────────────
# Face down. The straight arms lift off the floor in a Y (overhead, wide), lower;
# move to a T (straight out to the sides), lift, lower; then a W (elbows bent
# down by the ribs, hands by the shoulders), lift, lower. One round is one rep.
# Angles are the right arm's (0 = towards the feet, 180 = towards the head).

def ytw():
    T = 84
    letters = [(-145.0, -145.0), (-90.0, -90.0), (-58.0, -160.0)]   # Y, T, W

    def pose(t):
        i = min(int(t // 28), 2)
        u = t - 28 * i
        lift = ramp(u, [(0, 0), (6, 0), (12, 1), (18, 1), (24, 0), (28, 0)])
        move = smooth01((u - 22) / 6)
        a = lerp_angles(letters[i], letters[(i + 1) % 3], move)
        parts, sh = _prone_top(0.6 * lift)
        for side in ('l', 'r'):
            _top_arm(parts, side, sh[side], a[0], a[1], lift)
        return parts

    return TopViewAnimation('strong_back_s1_ytw', T, pose, PRONE_TOP_ORDER,
                            shapes_fn=frog_shapes)


# ── strong_back_s2_reverse_snow_angel ────────────────────────────────────────
# Face down, the arms long by the hips. Lifted off the floor, the straight arms
# sweep wide out to the sides and on overhead, then back down to the hips.

def reverse_snow_angel():
    T = 72

    def pose(t):
        sweep = ramp(t, [(0, 0), (8, 0), (32, 1), (38, 1), (62, 0), (72, 0)])
        lift = ramp(t, [(0, 0), (4, 0), (8, 1), (62, 1), (66, 0), (72, 0)])
        a = -12 - 150 * sweep
        parts, sh = _prone_top(0.6 * lift)
        for side in ('l', 'r'):
            _top_arm(parts, side, sh[side], a, a, lift)
        return parts

    return TopViewAnimation('strong_back_s2_reverse_snow_angel', T, pose, PRONE_TOP_ORDER,
                            shapes_fn=frog_shapes)


# ── glutes_s2_fire_hydrant ───────────────────────────────────────────────────
# On all fours seen from behind (as a dog at a hydrant): the thighs straight
# down to the knees on the floor, the shins pointing at the camera (short, the
# soles showing), the back foreshortened with the head beyond it and the arms
# straight down at the far end. Keeping the knee bent, one thigh lifts out to
# the side to hip height and lowers; then the other.

FOURS_HIP_Y = 316.0
FOURS_TORSO_Y = 292.0
ALL_FOURS_ORDER = ['foot_l', 'foot_r', 'shin_l', 'shin_r', 'thigh_l', 'thigh_r',
                   'body', 'head', 'hand_l', 'hand_r', 'farm_l', 'farm_r',
                   'uarm_l', 'uarm_r']


def fire_hydrant():
    from frontview import HIP_DX, THIGH_LEN, Animation as FrontAnimation, figure
    from gen_morning import compose
    T = 56

    def pose(t):
        lifts = {'r': ramp(t, [(0, 0), (4, 0), (12, 1), (16, 1), (24, 0), (56, 0)]),
                 'l': ramp(t, [(0, 0), (28, 0), (36, 1), (40, 1), (48, 0), (56, 0)])}
        shift = 4 * (lifts['l'] - lifts['r'])        # the weight moves off the lifting knee
        legs = {}
        for side, sx in (('l', -1), ('r', 1)):
            k = lifts[side]
            hip = (200 + shift / 2 + sx * HIP_DX, FOURS_HIP_Y)
            a = math.radians(84 * k)
            knee = (hip[0] + sx * (2 + THIGH_LEN * math.sin(a)),
                    hip[1] + THIGH_LEN * math.cos(a))
            ankle = (knee[0] + sx * 1, knee[1] + 11)
            legs['leg_' + side] = dict(knee=knee, ankle=ankle, near=0.0, foot_rot=0,
                                       foot_scale=(0.75, 1.35), foot_off=(0, 3))
        lower = figure(hips=(200 + shift / 2, FOURS_HIP_Y), **legs)
        c = (200 + shift, FOURS_TORSO_Y)
        arms = {}
        for side, sx in (('l', -1), ('r', 1)):
            arms['arm_' + side] = ((c[0] + sx * 38, 364.0), (sx, 0))
        upper = figure(hips=(c[0], c[1] + 51), torso_scale=(1.0, 0.45),
                       head=(0, 46, 0), head_scale=(0.9, 0.9), arm_len=(50.0, 42.0),
                       **arms)
        return compose(lower, upper)

    return FrontAnimation('glutes_s2_fire_hydrant', T, pose, order=ALL_FOURS_ORDER,
                          view='back')


# ══ Side views ═══════════════════════════════════════════════════════════════

# ── strong_back_s5_door_row ──────────────────────────────────────────────────
# The feet in the doorway just past the post, both hands on the post at chest
# height; the body straight from the ankles to the head, leaning back on
# straight arms. The arms pull the
# chest towards the post (the elbows go back past the body) and lower it back.

POST_X = 300.0
ROW_ANKLE = (318.0, 372.0)
ROW_GRIP = {'n': (294.0, 244.0), 'f': (292.0, 248.0)}


def door_row():
    T = 48

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (18, 1), (24, 1), (40, 0), (48, 0)])
        lean = 32 - 22 * u                       # degrees back from vertical
        hip = add(ROW_ANKLE, mul(dirv(180 - lean), LEG))
        p = gr.mk(gr.P(SIDE_BASE), hip, -lean, ht=4 * u)
        for side, dx in (('n', 0), ('f', -5)):
            p = gr.plant(p, 'leg_' + side, (ROW_ANKLE[0] + dx, ROW_ANKLE[1]), (1, -1))
            p['foot_' + side] = (5, 4, 0)
            p = gr.plant(p, 'arm_' + side, ROW_GRIP[side], (-1, 0.6))
        return p

    def props(frames):
        return gr.door_post('post', POST_X, 30, frames)

    return gr.Spec('strong_back_s5_door_row', T, gr.sampled(T, pose), modes=SIDE_FK,
                   props=props)


# ── arms_shoulders_s2_chair_dips ─────────────────────────────────────────────
# A chair behind Goro: hands on the front edge of the seat, knees bent, feet
# flat on the floor ahead. The elbows bend straight back and the hips sink in
# front of the seat, then the arms press back up.

CHAIR = [0.29, 0.33, 0.45, 1.0]
CHAIR_DARK = [0.23, 0.26, 0.37, 1.0]
SEAT_Y = 302.0
SEAT_X = (88.0, 172.0)


def chair_props(frames):
    x0, x1 = SEAT_X
    return [
        gr.bar('seat', (x0 + x1) / 2, SEAT_Y + 5, x1 - x0, 10, CHAIR, frames, 3, 60),
        gr.bar('leg_front', x1 - 8, (SEAT_Y + gr.FLOOR_Y) / 2 + 5, 8, gr.FLOOR_Y - SEAT_Y - 10,
               CHAIR_DARK, frames, 2, 61),
        gr.bar('leg_back', x0 + 8, (SEAT_Y + gr.FLOOR_Y) / 2 + 5, 8, gr.FLOOR_Y - SEAT_Y - 10,
               CHAIR_DARK, frames, 2, 62),
        gr.bar('back', x0 + 5, SEAT_Y - 48, 10, 96, CHAIR, frames, 3, 63),
    ]


def chair_dip(name, ankles, foot):
    T = 48
    hands = {'n': (SEAT_X[1] + 2, SEAT_Y - 4), 'f': (SEAT_X[1] - 4, SEAT_Y - 4)}

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (20, 1), (26, 1), (42, 0), (48, 0)])
        sh = (hands['n'][0] + 8 - 2 * u, hands['n'][1] - 76 + 26 * u)
        p = gr.P(SIDE_BASE, cx=0.0, cy=0.0, br=6 + 8 * u, ht=-6)
        p = placed(p, 'arm_n', sh)
        for side in ('n', 'f'):
            p = gr.plant(p, 'arm_' + side, hands[side], (-1, -0.3))
            p = gr.plant(p, 'leg_' + side, ankles[side], (1, -1))
            p['foot_' + side] = foot
        return p

    return gr.Spec(name, T, gr.sampled(T, pose), modes=SIDE_FK, props=chair_props)


def chair_dips():
    return chair_dip('arms_shoulders_s2_chair_dips',
                     {'n': (246.0, 372.0), 'f': (240.0, 372.0)}, (5, 4, 0))


# ── cardio_s6_burpee ─────────────────────────────────────────────────────────
# Stand; squat with the hands to the floor; jump the feet back to a plank; one
# push-up; jump the feet in; stand up into a jump with the arms overhead; land.

BURPEE_HANDS = {'n': (262.0, 368.0), 'f': (256.0, 368.0)}
STAND_FEET = {'n': (212.0, 372.0), 'f': (206.0, 372.0)}


def _bkey(hip, chest, s=(0.0, 0.0), ht=0.0, arm=0.0, w=0.0, feet=None, foot=STAND_FOOT):
    feet = feet or STAND_FEET
    foot = foot if isinstance(foot, dict) else {'n': foot, 'f': foot}
    return dict(hip=hip, chest=chest, s1=s[0], s2=s[1], ht=ht, arm=arm, w=w,
                feet_n=feet['n'], feet_f=feet['f'], foot_n=foot['n'], foot_f=foot['f'])


def _bbuild(k):
    p = body(k['hip'], k['chest'], k['s1'], k['s2'], k['ht'])
    for side in ('n', 'f'):
        f = k['feet_' + side]
        hip = gr.joint_of(p, 'leg_' + side)
        bend = (0, 1) if f[0] < hip[0] - 24 else (1, -1)
        p = gr.plant(p, 'leg_' + side, f, bend)
        p['foot_' + side] = k['foot_' + side]
    free = (k['chest'] + k['arm'],) * 2
    for side in ('n', 'f'):
        planted = floor_arm(p, side, BURPEE_HANDS[side])['arm_' + side]
        p['arm_' + side] = lerp_angles(free, planted, k['w'])
    return p


def _bblend(a, b, u):
    out = {}
    for name in a:
        if isinstance(a[name], tuple):
            out[name] = mix(a[name], b[name], u)
        else:
            out[name] = a[name] + (b[name] - a[name]) * u
    return out


def burpee():
    plank_sh = (BURPEE_HANDS['n'][0] - 4, 290.0)
    toes = add(plank_sh, mul(dirv(62.5), 89 + LEG))
    back = {'n': (toes[0], 370.0), 'f': (toes[0] - 5, 370.0)}
    plank_hip, plank_br = _line(back['n'], plank_sh)
    low_sh = (plank_sh[0] + 6, 326.0)
    low_hip, low_br = _line(back['n'], low_sh)
    air = {'n': (STAND_FEET['n'][0] + 2, 346.0), 'f': (STAND_FEET['f'][0] + 2, 346.0)}

    stand = _bkey((206.0, 288.0), 0.0, arm=4)
    squat = _bkey((196.0, 330.0), 74.0, (-8, -8), ht=-20, w=1)
    plank = _bkey(plank_hip, plank_br, ht=-18, w=1, feet=back, foot=TUCKED)
    low = _bkey(low_hip, low_br, ht=-16, w=1, feet=back, foot=TUCKED)
    rise = _bkey((204.0, 300.0), 22.0, ht=-6, arm=-70)
    reach = _bkey((208.0, 284.0), -4.0, ht=-12, arm=-172)
    jump = _bkey((210.0, 258.0), -4.0, ht=-14, arm=-176, feet=air, foot=(4, 6, 30))
    keys = [(0, stand), (6, stand), (18, squat), (24, plank), (30, low), (36, plank),
            (42, squat), (50, rise), (62, reach), (67, jump), (72, reach), (88, stand),
            (92, stand)]
    T = keys[-1][0]

    def pose(t):
        for (t0, a), (t1, b) in zip(keys, keys[1:]):
            if t0 <= t <= t1:
                return _bbuild(_bblend(a, b, smooth01((t - t0) / (t1 - t0))))
        return _bbuild(keys[0][1])

    return gr.Spec('cardio_s6_burpee', T, gr.sampled(T, pose), modes=SIDE_FK,
                   order=SPINE_FLOOR_ORDER)


# ── strong_back_s3_superman / s4_swimmers ────────────────────────────────────
# On the stomach seen from the side, the head to the right. The superman lifts
# the arms (reaching ahead past the head), the chest and the legs at once and
# holds; the swimmers keep the chest and legs up and flutter the opposite arm
# and leg (near arm up with the far leg, then the other pair).

PRONE_PELVIS = (176.0, 348.0)
ARMS_AHEAD_ORDER = ['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r',
                    'sp_chest', 'sp_mid', 'sp_pelvis', 'thigh_l', 'shin_l', 'foot_l',
                    'uarm_l', 'farm_l']
SIDE_ORDER = ['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r', 'body',
              'thigh_l', 'shin_l', 'foot_l', 'uarm_l', 'farm_l']
NEAR_LEG_TINT = {'thigh_r': LEG_LIGHT, 'shin_r': LEG_LIGHT, 'foot_r': LEG_LIGHT}


def _prone_lift(lift, arms, legs):
    """``lift`` 0..1 raises the chest; ``arms`` / ``legs`` = (near, far) lift
    of each limb 0..1."""
    chest = 22 * lift
    p = spine_at(gr.P(**PRONE), 90 - chest, chest / 2, chest / 2, 'pelvis', PRONE_PELVIS)
    for side, k in zip(('n', 'f'), legs):
        a = 90 + (1 if side == 'n' else 2) + 16 * k
        p['leg_' + side] = (a, a)
    for side, k in zip(('n', 'f'), arms):
        a = -88 - 20 * k
        p['arm_' + side] = (a, a)
    p['ht'] = (62 - 20 * lift) - p['br']
    return p


def superman():
    T = 72

    def pose(t):
        k = into_hold(t, T, start=6, settle=18, leave=14)
        k *= 1 + 0.05 * breath(t, 24) * (k > 0.98)
        return _prone_lift(k, (k, k * 0.9), (k, k * 0.9))

    return gr.Spec('strong_back_s3_superman', T, gr.sampled(T, pose), modes=ALL_FK,
                   order=ARMS_AHEAD_ORDER)


def swimmers():
    T = 48

    def pose(t):
        a = math.sin(2 * math.pi * t / 16)
        up, down = 0.6 + 0.4 * a, 0.6 - 0.4 * a
        return _prone_lift(1.0, (up, down), (down, up))

    return gr.Spec('strong_back_s4_swimmers', T, gr.sampled(T, pose), modes=ALL_FK,
                   order=ARMS_AHEAD_ORDER)


# ── glutes_s1_donkey_kicks ───────────────────────────────────────────────────
# On all fours (hands under the shoulders, knees under the hips). The near leg,
# knee bent, pushes the sole up to the ceiling until the thigh is level with
# the back, and lowers; then the far leg.

FOURS_HIPS = (128.0, 308.0)


def donkey_kicks():
    T = 56
    kneel, kick = (0.0, 90.0), (88.0, 182.0)

    def pose(t):
        kn = ramp(t, [(0, 0), (4, 0), (12, 1), (16, 1), (24, 0), (56, 0)])
        kf = ramp(t, [(0, 0), (28, 0), (36, 1), (40, 1), (48, 0), (56, 0)])
        p = gr.mk(gr.P(hip_n=8, hip_f=2), FOURS_HIPS, 70, ht=-8)
        for side, k in (('n', kn), ('f', kf)):
            p['leg_' + side] = mix_angles(kneel, kick, k)
            p['foot_' + side] = (-10 + 4 * k, 3 - 8 * k, 160 * k)
            sh = gr.joint_of(p, 'arm_' + side)
            p = gr.plant(p, 'arm_' + side, (sh[0] + (4 if side == 'n' else -2), 362))
        return p

    return gr.Spec('glutes_s1_donkey_kicks', T, gr.sampled(T, pose), modes=SIDE_FK,
                   order=SIDE_ORDER, tint=NEAR_LEG_TINT)


# ── glutes_s3_single_leg_bridge ──────────────────────────────────────────────
# On the back, knees bent, the head to the left. One leg stretches out long in
# line with the thigh and the other foot pushes the hips up into a bridge,
# hold, lower; then the other leg.

def single_leg_bridge():
    from gen_yoga import WHEEL_FEET, WHEEL_LIE, WHEEL_SH0
    T = 72

    def pose(t):
        near = t < 36
        u = t % 36
        h = ramp(u, [(0, 0), (8, 0), (17, 1), (22, 1), (29, 0), (36, 0)])
        up = ramp(u, [(0, 0), (8, 1), (29, 1), (36, 0)])     # the free leg goes out first
        p = gr.P(gr.P(**WHEEL_LIE), cx=0.0, cy=0.0, br=-90, spine=(-30 * h, -10 * h))
        p = placed(p, 'arm_n', WHEEL_SH0)
        free, stand = ('n', 'f') if near else ('f', 'n')
        p = gr.plant(p, 'leg_' + stand, WHEEL_FEET[stand], (1, -1))
        bent = gr.ik_to_fk(p, 'leg_' + free, WHEEL_FEET[free], (1, -1))
        thigh = p['leg_' + stand][0]
        p['leg_' + free] = mix_angles(bent, (thigh - 4, thigh - 4), up)
        p['foot_' + free] = (5, 4 - 8 * up, -70 * up)
        p['arm_n'] = p['arm_f'] = (-88, -88)
        return p

    return gr.Spec('glutes_s3_single_leg_bridge', T, gr.sampled(T, pose), modes=ALL_FK,
                   order=SPINE_ORDER, tint=NEAR_LEG_TINT)


# ── glutes_s4_hip_thrust / s5_single_leg_hip_thrust ──────────────────────────
# The upper back on the front edge of a (low) sofa on the left, knees bent,
# feet flat. The hips drive up until the body is level from the knees to the
# shoulders, squeeze, and lower towards the floor. The single-leg one keeps the
# other leg stretched out in line with the body.

SOFA = [0.36, 0.30, 0.42, 1.0]
SOFA_DARK = [0.29, 0.24, 0.35, 1.0]
SOFA_Y = 336.0
SOFA_X = (30.0, 132.0)


def sofa_props(frames):
    x0, x1 = SOFA_X
    return [
        gr.bar('sofa_seat', (x0 + x1) / 2, (SOFA_Y + gr.FLOOR_Y) / 2, x1 - x0,
               gr.FLOOR_Y - SOFA_Y, SOFA, frames, 8, 60),
        gr.bar('sofa_back', x0 + 13, SOFA_Y - 36, 26, 80, SOFA_DARK, frames, 8, 61),
    ]


def _hip_thrust(name, single):
    T = 96 if single else 48
    shoulder_at = (SOFA_X[1] - 4, SOFA_Y - 26)
    feet = {'n': (262.0, 372.0), 'f': (256.0, 372.0)}

    def pose(t):
        u = t % 48
        h = ramp(u, [(0, 0), (4, 0), (18, 1), (24, 1), (40, 0), (48, 0)])
        hip = (shoulder_at[0] + 96 - 10 * (1 - h), 358 - 40 * h)
        d = (shoulder_at[0] - hip[0], shoulder_at[1] - hip[1])
        br = math.degrees(math.atan2(d[0], -d[1]))
        p = gr.mk(gr.P(SIDE_BASE), hip, br, ht=24 * h - 18)
        ext = {'n': ramp(t, [(0, 0), (6, 1), (42, 1), (48, 0), (96, 0)]),
               'f': ramp(t, [(0, 0), (48, 0), (54, 1), (90, 1), (96, 0)])} if single             else {'n': 0.0, 'f': 0.0}
        line = br - 6                              # in line with the body, away from the head
        for side in ('n', 'f'):
            planted = gr.ik_to_fk(p, 'leg_' + side, feet[side], (1, -1))
            p['leg_' + side] = lerp_angles(planted, (line, line), ext[side])
            p['foot_' + side] = mix((5, 4, 0), (4, -2, -80), ext[side])
        p['arm_n'] = p['arm_f'] = (84.0, 84.0)
        return p

    return gr.Spec(name, T, gr.sampled(T, pose), modes=SIDE_FK, props=sofa_props,
                   tint=NEAR_LEG_TINT if single else None)


def hip_thrust():
    return _hip_thrust('glutes_s4_hip_thrust', False)


def single_leg_hip_thrust():
    return _hip_thrust('glutes_s5_single_leg_hip_thrust', True)


# ── arms_shoulders_s1_shoulder_taps ──────────────────────────────────────────
# A plank on straight arms. The near hand lifts and taps the far shoulder
# (the elbow drops under it), plants again; then the far hand taps the near
# shoulder.

TAP_SH = (276.0, 290.0)
TAP_HANDS = {'n': (279.0, 368.0), 'f': (273.0, 368.0)}


def shoulder_taps():
    from gen_morning import plank as side_plank
    T = 48

    def pose(t):
        taps = {'n': ramp(t, [(0, 0), (2, 0), (10, 1), (12, 1), (20, 0), (48, 0)]),
                'f': ramp(t, [(0, 0), (24, 0), (32, 1), (34, 1), (42, 0), (48, 0)])}
        sway = 3 * (taps['n'] - taps['f'])
        p = side_plank((TAP_SH[0], TAP_SH[1] + sway * 0.3))
        for side in ('n', 'f'):
            p['leg_' + side] = (62.5, 62.5)
            p['foot_' + side] = (2, -3, 62)
        for side in ('n', 'f'):
            planted = floor_arm(p, side, TAP_HANDS[side])['arm_' + side]
            sh = gr.joint_of(p, 'arm_' + side)
            tap = gr.ik_to_fk(p, 'arm_' + side, (sh[0] + 3, sh[1] + 2), (0.3, 1))
            p['arm_' + side] = lerp_angles(planted, tap, taps[side])
        return p

    return gr.Spec('arms_shoulders_s1_shoulder_taps', T, gr.sampled(T, pose),
                   modes=SIDE_FK, order=SIDE_ORDER)


# ── arms_shoulders_s3_plank_up_down ──────────────────────────────────────────
# From a plank on the forearms, the near hand and then the far hand plant and
# the body presses up to a plank on straight arms; then down onto the near
# forearm and the far one.

UPDOWN_TOES = (114.0, 370.0)


def plank_up_down():
    T = 64
    up_sh, low_sh = (276.0, 290.0), (272.0, 324.0)

    def pose(t):
        an = ramp(t, [(0, 0), (4, 0), (12, 1), (36, 1), (44, 0), (64, 0)])
        af = ramp(t, [(0, 0), (12, 0), (20, 1), (44, 1), (52, 0), (64, 0)])
        sh = mix(low_sh, up_sh, (an + af) / 2)
        hip, br = _line(UPDOWN_TOES, sh)
        p = gr.mk(gr.P(SIDE_BASE), hip, br, ht=-18)
        for side, a in (('n', an), ('f', af)):
            p['leg_' + side] = (br, br)
            p['foot_' + side] = (2, -3, 62)
            j = gr.joint_of(p, 'arm_' + side)
            dx = 3 if side == 'n' else -3
            on_hand = floor_arm(p, side, (j[0] + dx, 368.0))['arm_' + side]
            ey = 362.0
            e = (j[0] + dx + math.sqrt(max(0.0, 44.0 ** 2 - (ey - j[1]) ** 2)) * 0.3, ey)
            on_arm = (ang_of(e[0] - j[0], e[1] - j[1]), -90.0)
            p['arm_' + side] = lerp_angles(on_arm, on_hand, a)
        return p

    return gr.Spec('arms_shoulders_s3_plank_up_down', T, gr.sampled(T, pose),
                   modes=SIDE_FK, order=SIDE_ORDER)


# ── arms_shoulders_s4_pike_pushup / s6_elevated_pike ─────────────────────────
# An upside-down V (hips high, legs straight); the elbows bend back and the top
# of the head comes down towards the floor ahead of the hands, then the arms
# press back. The elevated one has the feet on a chair, the back nearly upright.

PIKE_HANDS = {'n': (270.0, 368.0), 'f': (264.0, 368.0)}


def _pike(name, feet, hip_top, lower, props=None):
    T = 48

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (20, 1), (26, 1), (42, 0), (48, 0)])
        hip = (hip_top[0] + 4 * u, hip_top[1] + 6 * u)
        sh0 = add(PIKE_HANDS['n'], (-14, -76))
        sh = add(sh0, (10 * u, lower * u))
        d = (sh[0] - hip[0], sh[1] - hip[1])
        br = math.degrees(math.atan2(d[0], -d[1]))
        p = gr.mk(gr.P(SIDE_BASE), hip, br, ht=24 + 10 * u)
        for side in ('n', 'f'):
            p = gr.plant(p, 'leg_' + side, feet[side], (1, -1))
            p['foot_' + side] = (2, 2, 0) if feet[side][1] > 360 else (4, 3, 0)
            p = floor_arm(p, side, PIKE_HANDS[side])
        return p

    return gr.Spec(name, T, gr.sampled(T, pose), modes=SIDE_FK, order=SIDE_ORDER,
                   props=props)


def pike_pushup():
    feet = {'n': (184.0, 372.0), 'f': (178.0, 372.0)}
    return _pike('arms_shoulders_s4_pike_pushup', feet, (212.0, 262.0), 30)


def elevated_pike():
    feet = {'n': (176.0, SEAT_Y - 6), 'f': (170.0, SEAT_Y - 6)}

    def props(frames):
        x0, x1 = 112.0, 190.0
        return [
            gr.bar('seat', (x0 + x1) / 2, SEAT_Y + 5, x1 - x0, 10, CHAIR, frames, 3, 60),
            gr.bar('leg_front', x1 - 8, (SEAT_Y + gr.FLOOR_Y) / 2 + 5, 8,
                   gr.FLOOR_Y - SEAT_Y - 10, CHAIR_DARK, frames, 2, 61),
            gr.bar('leg_back', x0 + 8, (SEAT_Y + gr.FLOOR_Y) / 2 + 5, 8,
                   gr.FLOOR_Y - SEAT_Y - 10, CHAIR_DARK, frames, 2, 62),
            gr.bar('back', x0 + 5, SEAT_Y - 48, 10, 96, CHAIR, frames, 3, 63),
        ]

    return _pike('arms_shoulders_s6_elevated_pike', feet, (226.0, 236.0), 34, props)


# ── arms_shoulders_s5_chair_dips_straight ────────────────────────────────────
# Chair dips with the legs straight: the heels on the floor far ahead are the
# pivot, so the hips travel on an arc round them as the elbows bend.

def chair_dips_straight():
    T = 48
    hands = {'n': (SEAT_X[1] + 2, SEAT_Y - 4), 'f': (SEAT_X[1] - 4, SEAT_Y - 4)}
    heel = {'n': (262.0, 370.0), 'f': (256.0, 370.0)}

    def pose(t):
        u = ramp(t, [(0, 0), (4, 0), (20, 1), (26, 1), (42, 0), (48, 0)])
        sh = (hands['n'][0] + 8 - 2 * u, hands['n'][1] - 76 + 26 * u)
        best = None
        for br10 in range(-200, 600):
            br = br10 / 10
            q = placed(gr.P(SIDE_BASE, cx=0.0, cy=0.0, br=br, ht=-6), 'arm_n', sh)
            err = abs(math.dist(gr.joint_of(q, 'leg_n'), heel['n']) - 83.0)
            if best is None or err < best[0]:
                best = (err, q)
        p = best[1]
        for side in ('n', 'f'):
            p = gr.plant(p, 'arm_' + side, hands[side], (-1, -0.3))
            p = gr.plant(p, 'leg_' + side, heel[side], (1, -1))
            p['foot_' + side] = (2, -4, -70)
        return p

    return gr.Spec('arms_shoulders_s5_chair_dips_straight', T, gr.sampled(T, pose),
                   modes=SIDE_FK, props=chair_props)


# ── cardio_s1_high_knees ─────────────────────────────────────────────────────
# Running on the spot: one knee drives up to hip height (the thigh level, the
# shin hanging) while the other foot is on the floor, the arms pumping the
# other way; a small bounce on every step.

def high_knees():
    T = 24

    def pose(t):
        kn = ramp(t, [(0, 0), (6, 1), (12, 0), (24, 0)])
        kf = ramp(t, [(0, 0), (12, 0), (18, 1), (24, 0)])
        bounce = 4 * abs(math.sin(math.pi * t / 12))
        p = gr.mk(gr.P(SIDE_BASE), (200.0, 288.0 - bounce), 2)
        for side, k, ankle in (('n', kn, (206.0, 372.0 - bounce)), ('f', kf, (200.0, 372.0 - bounce))):
            rest = gr.ik_to_fk(p, 'leg_' + side, ankle, (1, -1))
            p['leg_' + side] = mix_angles(rest, (-84.0, -4.0), k)
            p['foot_' + side] = (5, 4 - 4 * k, 20 * k)
        for side, sw in (('n', kf - kn), ('f', kn - kf)):
            a1 = 40 * sw
            p['arm_' + side] = (a1, a1 - 100)
        return p

    return gr.Spec('cardio_s1_high_knees', T, gr.sampled(T, pose), modes=SIDE_FK,
                   tint=NEAR_LEG_TINT)


# ── cardio_s2_skater_jumps ───────────────────────────────────────────────────
# Seen from the front: a jump sideways from one foot to the other, landing on a
# bent knee while the free foot sweeps behind the landing leg and the arms
# swing across; then back. The speed skater of Morning Routine with a flight.

def skater_jumps():
    from frontview import HIP_DX, STAND_ANKLE_Y, Animation as FrontAnimation, figure
    from gen_morning import (ARMS, compose, hips_for, shoulder_points,
                             with_back_copies)
    T = 40
    land_x, behind_x, hips_low, flight = 60, 70, 312.0, 22.0

    def legs_for(s, hx, hy, air):
        """Legs with the weight on side ``s`` (``air`` lifts both feet)."""
        out = {}
        for side, sx in (('l', -1), ('r', 1)):
            hip = (hx + sx * HIP_DX, hy)
            if sx == s:
                ankle = (200 + s * land_x, STAND_ANKLE_Y - air)
                knee = add(mix(hip, ankle, 46 / 84), (sx * 8, -4))
                out['leg_' + side] = dict(knee=knee, ankle=ankle, near=1.25)
            else:
                ankle = (200 + s * behind_x, STAND_ANKLE_Y - 14 - air)
                knee = add(mix(hip, ankle, 46 / 84), (-s * 6, -2))
                out['leg_' + side] = dict(knee=knee, ankle=ankle, near=0.9)
        return out

    def blend_legs(a, b, u):
        out = {}
        for k in a:
            out[k] = dict(knee=mix(a[k]['knee'], b[k]['knee'], u),
                          ankle=mix(a[k]['ankle'], b[k]['ankle'], u),
                          near=a[k]['near'] + (b[k]['near'] - a[k]['near']) * u)
        return out

    def arms_for(sh, c, s):
        out = {}
        for i, (side, sx) in enumerate((('l', -1), ('r', 1))):
            shoulder = sh[i]
            if sx == -s:                          # swings across, low
                e, wr = add(shoulder, (s * 10, 36)), (c[0] + s * 36, shoulder[1] + 66)
            else:                                 # swings back and out
                e, wr = add(shoulder, (sx * 24, 26)), add(shoulder, (sx * 44, 44))
            out['arm_' + side] = (wr, (0, 1), e)
        return out

    def pose(t):
        if t < 20:
            s0, s1, u = -1, 1, t / 20
        else:
            s0, s1, u = 1, -1, (t - 20) / 20
        jump = smooth01((u - 0.2) / 0.6)
        air = flight * math.sin(math.pi * jump)
        hx = 200 + 40 * (s0 + (s1 - s0) * jump)
        hy = hips_low - 26 * math.sin(math.pi * jump)
        legs = blend_legs(legs_for(s0, 200 + 40 * s0, hips_low, 0),
                          legs_for(s1, 200 + 40 * s1, hips_low, 0), jump)
        for k in legs:                            # carry the legs with the hips
            off = (hx - (200 + 40 * (s0 + (s1 - s0) * jump)), -air)
            legs[k]['ankle'] = add(legs[k]['ankle'], off)
            legs[k]['knee'] = add(legs[k]['knee'], (off[0], off[1] - 6 * math.sin(math.pi * jump)))
        lower = figure(hips=(hx, hy), **legs)
        lean = 8 * (s0 + (s1 - s0) * jump)
        c = add((hx, hy), rot((0, -51 + 6), lean))
        ts = (1, 0.88)
        sh = shoulder_points(c, lean, ts)
        arms0, arms1 = arms_for(sh, c, s0), arms_for(sh, c, s1)
        arms = {k: (mix(arms0[k][0], arms1[k][0], jump), (0, 1), mix(arms0[k][2], arms1[k][2], jump))
                for k in arms0}
        upper = figure(hips=hips_for(c, lean), lean=lean, torso_scale=ts, head=(0, 8, 0), **arms)
        return compose(lower, upper)

    def front(t):
        # the left leg is in front while it carries the weight; behind while it
        # sweeps behind the right one
        if t < 20:
            return 1.0 if t < 10 else 0.0
        return 0.0 if t < 30 else 1.0

    order = ARMS + ['head', 'crown', 'body', 'knee_l', 'thigh_l', 'shin_l', 'foot_l',
                    'knee_r', 'thigh_r', 'shin_r', 'foot_r',
                    'knee_l@b', 'thigh_l@b', 'shin_l@b', 'foot_l@b']
    names = ['knee_l', 'thigh_l', 'shin_l', 'foot_l']
    return FrontAnimation('cardio_s2_skater_jumps', T, with_back_copies(pose, names, front),
                          order=order)


# ── cardio_s3_squat_jumps ────────────────────────────────────────────────────
# Squat with the arms swung back, jump straight up with the arms overhead,
# land softly back in the squat.

def squat_jumps():
    T = 40
    air = {'n': (STAND_FEET['n'][0] + 2, 348.0), 'f': (STAND_FEET['f'][0] + 2, 348.0)}
    squat = _bkey((200.0, 326.0), 34.0, ht=-30, arm=6)
    rise = _bkey((204.0, 300.0), 14.0, ht=-16, arm=-70)
    stand = _bkey((206.0, 288.0), -2.0, ht=-8, arm=-150)
    jump = _bkey((208.0, 264.0), -2.0, ht=-10, arm=-172, feet=air, foot=(4, 6, 30))
    keys = [(0, squat), (4, squat), (10, rise), (15, stand), (20, jump), (25, stand),
            (31, rise), (37, squat), (40, squat)]

    def pose(t):
        for (t0, a), (t1, b) in zip(keys, keys[1:]):
            if t0 <= t <= t1:
                return _bbuild(_bblend(a, b, smooth01((t - t0) / (t1 - t0))))
        return _bbuild(keys[0][1])

    return gr.Spec('cardio_s3_squat_jumps', T, gr.sampled(T, pose), modes=SIDE_FK,
                   order=SPINE_FLOOR_ORDER)


# ── cardio_s4_fast_climbers ──────────────────────────────────────────────────
# A plank on straight arms; the feet switch quickly, one knee driving to the
# chest as the other leg goes back (both feet move at once, a small hop).

def fast_climbers():
    from gen_morning import PLANK_BR, lerp_keys, plank as side_plank
    T = 24
    sh = (276.0, 290.0)
    hands = {'n': (279.0, 368.0), 'f': (273.0, 368.0)}
    straight = (PLANK_BR, PLANK_BR)

    def pose(t):
        w = 0.5 + 0.5 * math.cos(2 * math.pi * t / 24)   # 1: near knee in, far leg back
        p = side_plank((sh[0], sh[1] - 3 * abs(math.sin(2 * math.pi * t / 24))))
        for side, k in (('n', w), ('f', 1 - w)):
            k = 0.15 + 0.7 * k
            p['leg_' + side] = tuple(lerp_keys([straight, (-5.0, 100.0), (-78.0, 42.0)], 2 * k))
            p['foot_' + side] = (2, -3, 62 - 50 * k)
        for side in ('n', 'f'):
            p = floor_arm(p, side, hands[side])
        return p

    return gr.Spec('cardio_s4_fast_climbers', T, gr.sampled(T, pose), modes=SIDE_FK,
                   order=['uarm_r', 'farm_r', 'head', 'thigh_r', 'shin_r', 'foot_r', 'body',
                          'thigh_l', 'shin_l', 'foot_l', 'uarm_l', 'farm_l'],
                   tint=NEAR_LEG_TINT)


# ── cardio_s5_half_burpee ────────────────────────────────────────────────────
# Squat with the hands on the floor, step the near foot and then the far foot
# back to a plank, step them in again one by one, stand up. No jump, no push-up.

def half_burpee():
    plank_sh = (BURPEE_HANDS['n'][0] - 4, 290.0)
    toes = add(plank_sh, mul(dirv(62.5), 89 + LEG))
    back = {'n': (toes[0], 370.0), 'f': (toes[0] - 5, 370.0)}
    plank_hip, plank_br = _line(back['n'], plank_sh)
    stand = _bkey((206.0, 288.0), 0.0, arm=4)
    squat = _bkey((196.0, 330.0), 74.0, (-8, -8), ht=-20, w=1)
    half = _bkey((182.0, 322.0), 70.0, (-4, -4), ht=-18, w=1,
                 feet={'n': back['n'], 'f': STAND_FEET['f']}, foot={'n': TUCKED, 'f': STAND_FOOT})
    plank = _bkey(plank_hip, plank_br, ht=-18, w=1, feet=back, foot=TUCKED)
    half_in = _bkey((182.0, 322.0), 70.0, (-4, -4), ht=-18, w=1,
                    feet={'n': STAND_FEET['n'], 'f': back['f']}, foot={'n': STAND_FOOT, 'f': TUCKED})
    rise = _bkey((204.0, 300.0), 22.0, ht=-6, arm=4)
    keys = [(0, stand), (6, stand), (18, squat), (26, half), (34, plank), (40, plank),
            (48, half_in), (56, squat), (66, rise), (74, stand), (78, stand)]
    T = keys[-1][0]

    def pose(t):
        for (t0, a), (t1, b) in zip(keys, keys[1:]):
            if t0 <= t <= t1:
                k = _bblend(a, b, smooth01((t - t0) / (t1 - t0)))
                for side in ('n', 'f'):          # a stepping foot lifts a little
                    fa, fb = a['feet_' + side], b['feet_' + side]
                    if math.dist(fa, fb) > 6:
                        u = (t - t0) / (t1 - t0)
                        x, y = k['feet_' + side]
                        k['feet_' + side] = (x, y - 10 * math.sin(math.pi * u))
                return _bbuild(k)
        return _bbuild(keys[0][1])

    return gr.Spec('cardio_s5_half_burpee', T, gr.sampled(T, pose), modes=SIDE_FK,
                   order=SPINE_FLOOR_ORDER)


ANIMATIONS = {
    'cardio_s1_high_knees': high_knees,
    'cardio_s2_skater_jumps': skater_jumps,
    'cardio_s3_squat_jumps': squat_jumps,
    'cardio_s4_fast_climbers': fast_climbers,
    'cardio_s5_half_burpee': half_burpee,
    'strong_back_s3_superman': superman,
    'strong_back_s4_swimmers': swimmers,
    'glutes_s1_donkey_kicks': donkey_kicks,
    'glutes_s3_single_leg_bridge': single_leg_bridge,
    'glutes_s4_hip_thrust': hip_thrust,
    'glutes_s5_single_leg_hip_thrust': single_leg_hip_thrust,
    'arms_shoulders_s1_shoulder_taps': shoulder_taps,
    'arms_shoulders_s3_plank_up_down': plank_up_down,
    'arms_shoulders_s4_pike_pushup': pike_pushup,
    'arms_shoulders_s5_chair_dips_straight': chair_dips_straight,
    'arms_shoulders_s6_elevated_pike': elevated_pike,
    'strong_back_s1_ytw': ytw,
    'strong_back_s2_reverse_snow_angel': reverse_snow_angel,
    'strong_back_s5_door_row': door_row,
    'glutes_s2_fire_hydrant': fire_hydrant,
    'arms_shoulders_s2_chair_dips': chair_dips,
    'cardio_s6_burpee': burpee,
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=os.path.join(
        os.path.dirname(__file__), '..', '..', 'assets', 'animations'))
    ap.add_argument('names', nargs='*')
    args = ap.parse_args()
    os.makedirs(args.out, exist_ok=True)
    for n in args.names or list(ANIMATIONS):
        print(write(ANIMATIONS[n](), args.out))


if __name__ == '__main__':
    main()
