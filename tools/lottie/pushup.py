"""Push-up rig in the style of the original push_s1..s3 files.

The original push-up animations draw Goro with a long, slim body (torso 130 x 50),
chunky arms (24 / 20 px) and a richer head than the paper-doll rig of
``goro_rig.py``, so the redrawn variations (diamond, wide, archer, handstand)
must use exactly those shapes to look like their siblings. The shapes and colours
are copied from ``push_s3_full_pushup.json``; only the transforms are new.

A pose is a handful of joints (ankle ``F``, shoulder ``S``, hands, head); the
body is a straight line from the ankle through knee, hip and shoulder (the same
way the original is built), the arms are solved by two-bone IK, and a limb can be
foreshortened (``*_sc``) to fake out-of-plane movement. Every frame is solved
independently, so planted hands and feet never drift.
"""

import copy
import json
import math
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from goro_rig import (FLOOR, FLOOR_LINE, FLOOR_Y, FPS, SIZE, _layer, _prop,  # noqa: E402
                      _static_layer, _unwrap)

ROOT = os.path.join(os.path.dirname(__file__), '..', '..')
TEMPLATE = os.path.join(ROOT, 'assets', 'animations', 'push_s3_full_pushup.json')

# Segment lengths (the rect widths of the original file).
L_UARM, L_FARM = 34.74, 44.80
L_FAR_UARM, L_FAR_FARM = 34.74, 42.32
L_SHIN, L_THIGH, L_TORSO = 36.45, 44.55, 130.0
BODY = L_SHIN + L_THIGH + L_TORSO          # ankle -> shoulder, 211
MIN_LEN = 9.0                              # shortest drawn segment
FAR_SHOULDER = (-10.0, 3.0)                # far shoulder relative to the near one

ORDER = ['head', 'hands', 'farm', 'uarm', 'chest_vol', 'torso', 'far_hands',
         'far_farm', 'far_uarm', 'thigh', 'shin', 'foot']

_templates = None


def templates():
    """Layer name -> template layer of push_s3_full_pushup.json (with an extra
    'far_hands' copy of the hand in the far-limb colour)."""
    global _templates
    if _templates is None:
        with open(TEMPLATE) as f:
            data = json.load(f)
        _templates = {l['nm']: l for l in data['layers']}
        far = copy.deepcopy(_templates['hands'])
        far['nm'] = 'far_hands'
        for sh in far['shapes']:
            for it in sh['it']:
                if it['ty'] == 'fl':
                    it['c']['k'] = [0.165, 0.165, 0.251, 1.0]
        _templates['far_hands'] = far
    return _templates


# ── Maths ────────────────────────────────────────────────────────────────────

def add(a, b):
    return (a[0] + b[0], a[1] + b[1])


def sub(a, b):
    return (a[0] - b[0], a[1] - b[1])


def mul(v, k):
    return (v[0] * k, v[1] * k)


def norm(v):
    n = math.hypot(*v) or 1e-9
    return (v[0] / n, v[1] / n)


def ik(shoulder, hand, l1, l2, bend):
    """Elbow of a two-bone limb reaching ``hand`` (clamped), on the side of
    ``bend``."""
    d = sub(hand, shoulder)
    dist = min(max(math.hypot(*d), abs(l1 - l2) + 1e-3), l1 + l2 - 1e-3)
    u = norm(d)
    a = (l1 * l1 - l2 * l2 + dist * dist) / (2 * dist)
    h = math.sqrt(max(l1 * l1 - a * a, 0.0))
    foot = add(shoulder, mul(u, a))
    perp = (-u[1], u[0])
    options = [add(foot, mul(perp, h)), add(foot, mul(perp, -h))]
    return max(options, key=lambda e: e[0] * bend[0] + e[1] * bend[1])


def _seg(a, b, length, flip=False):
    """Layer transform of a rect of natural ``length`` drawn from a to b."""
    d = sub(b, a)
    dist = max(math.hypot(*d), MIN_LEN)   # an edge-on limb stays a small blob
    return dict(p=((a[0] + b[0]) / 2, (a[1] + b[1]) / 2),
                r=math.degrees(math.atan2(d[1], d[0])),
                s=(100 * dist / length, -100 if flip else 100))


# ── Pose ─────────────────────────────────────────────────────────────────────

def pose(ankle, shoulder, hand, far_hand=None, head=None, bend=(-1.0, 0.0),
         far_bend=None, flip=False, uarm_sc=1.0, far_uarm_sc=1.0,
         far_shoulder=None, head_tilt=0.0, show_far_hand=True,
         straight=(False, False), foot=(0.0, 0.0, 0.0), elbows=(None, None)):
    """Layer transforms for one frame.

    ``ankle`` / ``shoulder`` pin the straight body line, ``hand`` / ``far_hand``
    the planted hands (the far one defaults to just behind the near one),
    ``head`` the head centre (default: ahead of and above the shoulder),
    ``flip`` mirrors the asymmetric parts (an inverted body), ``*_uarm_sc``
    shortens an upper arm (an elbow flared out of the picture), ``straight``
    draws an arm as one straight, foreshortened line (the other arm of an archer
    push-up), ``elbows`` = explicit (near, far) elbow positions instead of IK,
    ``foot`` = (dx, dy, rotation) of the foot ellipse about the ankle."""
    F, S = ankle, shoulder
    d = norm(sub(S, F))
    knee = add(F, mul(d, L_SHIN))
    hip = add(F, mul(d, L_SHIN + L_THIGH))
    out = {}
    out['shin'] = _seg(F, knee, L_SHIN)
    out['thigh'] = _seg(knee, hip, L_THIGH)
    out['foot'] = dict(p=add(F, foot[:2]), r=foot[2], s=(100, 100))
    out['torso'] = _seg(hip, S, L_TORSO, flip)
    n = (d[1], -d[0])                    # the back side of the body
    if flip:
        n = (-n[0], -n[1])
    mid = ((hip[0] + S[0]) / 2, (hip[1] + S[1]) / 2)
    out['chest_vol'] = dict(p=add(add(mid, mul(d, 25)), mul(n, 10)),
                            r=math.degrees(math.atan2(d[1], d[0])), s=(100, 100))

    S2 = far_shoulder or add(S, FAR_SHOULDER)
    H2 = far_hand or add(hand, (-2, 0))
    far_bend = far_bend or bend
    for key, sh, hd, l1, l2, bd, sc, line, elbow in (
            ('', S, hand, L_UARM, L_FARM, bend, uarm_sc, straight[0], elbows[0]),
            ('far_', S2, H2, L_FAR_UARM, L_FAR_FARM, far_bend, far_uarm_sc,
             straight[1], elbows[1])):
        if elbow is not None:
            e = elbow
        elif line:   # one straight line: the elbow sits on the shoulder -> hand line
            e = add(sh, mul(sub(hd, sh), l1 / (l1 + l2)))
        else:
            e = ik(sh, hd, l1 * sc, l2, bd)
        out[key + 'uarm'] = _seg(sh, e, l1)
        out[key + 'farm'] = _seg(e, hd, l2)
        out[key + 'hands'] = dict(p=hd, r=0, s=(100 if key == '' or show_far_hand
                                                 else 0, 100))
    if head is None:
        head = add(S, (44.0, -26.0))
    out['head'] = dict(p=head, r=head_tilt, s=(100, -100 if flip else 100))
    return out


# ── Animation ────────────────────────────────────────────────────────────────

class Animation:
    """Spec-compatible: ``write()`` in goro_rig calls ``build()``. ``props`` is a
    function ``frames -> layers`` for walls / insets, drawn behind the figure."""

    def __init__(self, name, frames, pose_fn, props=None, step=2):
        self.name = name
        self.frames = frames
        self.pose_fn = pose_fn
        self.props = props
        self.step = step

    def build(self):
        times = list(range(0, self.frames + 1, self.step))
        if times[-1] != self.frames:
            times.append(self.frames)
        poses = [self.pose_fn(t) for t in times]
        tpl = templates()
        layers = []
        for idx, nm in enumerate(ORDER, start=1):
            t = tpl[nm]
            o = copy.deepcopy(t['ks']['o'])
            pos = [p[nm]['p'] for p in poses]
            rots = _unwrap([p[nm]['r'] for p in poses])
            scl = [p[nm]['s'] for p in poses]
            layers.append(_layer(nm, idx, self.frames, copy.deepcopy(t['shapes']),
                                 _prop(times, pos), _prop(times, [(r,) for r in rots]),
                                 _prop(times, scl), o))
        if self.props:
            layers.extend(self.props(self.frames))
        layers.append(_static_layer('floor_line', 96, self.frames,
                                    (200, 375.5, 400, 2), FLOOR_LINE, 0))
        layers.append(_static_layer('floor', 97, self.frames,
                                    (200, 387, 400, 26), FLOOR, 0))
        return {"v": "5.7.4", "fr": FPS, "ip": 0, "op": self.frames,
                "w": SIZE, "h": SIZE, "nm": self.name, "ddd": 0, "assets": [],
                "fonts": {"list": []}, "markers": [], "layers": layers}
