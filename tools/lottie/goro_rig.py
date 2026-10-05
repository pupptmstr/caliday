"""Goro puppet rig that emits Lottie JSON.

The existing exercise animations are flat "paper-doll" Lottie files: every body
part is its own shape layer with a keyframed position/rotation (no parenting).
This module reproduces that format from a pose description, so a new animation
is a list of poses instead of hundreds of hand-edited numbers.

Conventions (all coordinates in the 400x400 Lottie canvas, y points down):

* Goro faces right (+x).
* A segment is a rectangle centred on its layer position. Its "joint" is the
  top end at rotation 0; at rotation ``a`` it points along ``dirv(a)``, so
  0 = down, +90 = left, -90 = right, 180 = up. Rotation is clockwise-positive.
* The forearm is mounted the other way round: its elbow is the +y end and the
  fist sits on the -y end (same as ``legs_s1_squat``), hence rotation = a + 180.
* Limbs are posed either with inverse kinematics (``('ik', (x, y))``: the
  ankle/wrist target) or forward kinematics (``('fk', (a1, a2))``).
"""

import copy
import json
import math

FPS = 12
SIZE = 400
FLOOR_Y = 376

# Segment lengths (rect heights in the reference files).
TORSO_H = 100
THIGH = 46
SHIN = 38
UARM = 44
FARM = 36

# Torso-local anchor points.
SHOULDER = (3, -39)
HEAD_DEFAULT = (7, -83)

DARK = [0.2196, 0.2196, 0.298, 1.0]
LIGHT = [0.2588, 0.2588, 0.3451, 1.0]
FAR = [0.2549, 0.2549, 0.3412, 1.0]
FACE = [0.7686, 0.6588, 0.5098, 1.0]
BAND = [0.6588, 0.8471, 1.0, 1.0]
WHITE = [1.0, 1.0, 1.0, 1.0]
FLOOR_LINE = [0.2275, 0.3137, 0.502, 1.0]
FLOOR = [0.102, 0.1686, 0.2902, 1.0]

FAR_OPACITY = 65

DEFAULT_ORDER = [
    'head', 'uarm_r', 'farm_r', 'thigh_r', 'shin_r', 'foot_r', 'body',
    'thigh_l', 'shin_l', 'foot_l', 'uarm_l', 'farm_l',
]


# ── Maths ────────────────────────────────────────────────────────────────────

def dirv(a):
    r = math.radians(a)
    return (-math.sin(r), math.cos(r))


def ang_of(x, y):
    return math.degrees(math.atan2(-x, y))


def rot(v, a):
    r = math.radians(a)
    c, s = math.cos(r), math.sin(r)
    return (v[0] * c - v[1] * s, v[0] * s + v[1] * c)


def add(a, b):
    return (a[0] + b[0], a[1] + b[1])


def mul(v, k):
    return (v[0] * k, v[1] * k)


def lerp(a, b, u):
    if isinstance(a, (tuple, list)):
        return tuple(lerp(x, y, u) for x, y in zip(a, b))
    return a + (b - a) * u


def smooth(u):
    return u * u * (3 - 2 * u)


def ik2(p, target, l1, l2, bend):
    """Two-bone IK. ``bend`` is the direction the middle joint should favour."""
    dx, dy = target[0] - p[0], target[1] - p[1]
    d = math.hypot(dx, dy)
    d = min(max(d, abs(l1 - l2) + 1e-3), l1 + l2 - 1e-3)
    ux, uy = (dx / (math.hypot(dx, dy) or 1), dy / (math.hypot(dx, dy) or 1))
    t = (p[0] + ux * d, p[1] + uy * d)
    base = ang_of(ux, uy)
    cos_a = (l1 * l1 + d * d - l2 * l2) / (2 * l1 * d)
    a = math.degrees(math.acos(max(-1.0, min(1.0, cos_a))))
    mid = ((p[0] + t[0]) / 2, (p[1] + t[1]) / 2)
    best = None
    for s in (1, -1):
        a1 = base + s * a
        k = add(p, mul(dirv(a1), l1))
        score = (k[0] - mid[0]) * bend[0] + (k[1] - mid[1]) * bend[1]
        if best is None or score > best[0]:
            best = (score, a1, k)
    _, a1, k = best
    a2 = ang_of(t[0] - k[0], t[1] - k[1])
    return a1, a2


def chain(joint, l1, l2, mode, spec, bend):
    if mode == 'ik':
        a1, a2 = ik2(joint, spec, l1, l2, bend)
    else:
        a1, a2 = spec
    mid = add(joint, mul(dirv(a1), l1))
    end = add(mid, mul(dirv(a2), l2))
    return a1, a2, mid, end


# ── Pose ─────────────────────────────────────────────────────────────────────

BASE_POSE = dict(
    cx=200.0, cy=288.0, br=0.0,
    head=HEAD_DEFAULT, ht=0.0,
    hip_n=8.0, hip_f=2.0,
    leg_n=(0.0, 0.0), leg_f=(0.0, 0.0),
    arm_n=(0.0, 0.0), arm_f=(0.0, 0.0),
    foot_n=(4.0, 0.0, 0.0), foot_f=(4.0, 0.0, 0.0),
    # Foreshortening (1 = full length) for 3-D illusions, per segment.
    sc_thigh_n=1.0, sc_shin_n=1.0, sc_thigh_f=1.0, sc_shin_f=1.0,
    sc_uarm_n=1.0, sc_farm_n=1.0, sc_uarm_f=1.0, sc_farm_f=1.0,
)


def P(base=None, **kw):
    p = copy.deepcopy(base if base is not None else BASE_POSE)
    for k, v in kw.items():
        if k not in p:
            raise KeyError(k)
        p[k] = v
    return p


def interp_pose(a, b, u):
    return {k: lerp(a[k], b[k], u) for k in a}


LIMBS = ('leg_n', 'leg_f', 'arm_n', 'arm_f')
DEFAULT_BENDS = {'leg_n': (1, -1), 'leg_f': (1, -1),
                 'arm_n': (-1, 0), 'arm_f': (-1, 0)}


class Spec:
    """One animation: limb solver modes + a looping timeline of key poses.

    ``modes`` maps each limb to ``'ik'`` or ``'fk'`` (default ``'ik'``) and
    ``bends`` to the direction its middle joint should favour under IK.
    """

    def __init__(self, name, frames, keys, modes=None, bends=None, order=None,
                 step=2):
        self.name = name
        self.frames = frames
        self.keys = keys  # [(frame, pose, ease)] — ease: smooth|linear|hold
        self.modes = {k: 'ik' for k in LIMBS}
        self.modes.update(modes or {})
        self.bends = dict(DEFAULT_BENDS)
        self.bends.update(bends or {})
        self.order = order or DEFAULT_ORDER
        self.step = step

    def pose_at(self, t):
        ks = self.keys
        for (t0, p0, ease), (t1, p1, _) in zip(ks, ks[1:]):
            if t0 <= t <= t1:
                u = 0.0 if t1 == t0 else (t - t0) / (t1 - t0)
                if ease == 'hold':
                    u = 0.0
                elif ease == 'smooth':
                    u = smooth(u)
                return interp_pose(p0, p1, u)
        return ks[-1][1]


def joint_of(pose, limb):
    """World position of the limb's root joint (shoulder or hip)."""
    c = (pose['cx'], pose['cy'])
    if limb.startswith('arm'):
        return add(c, rot(SHOULDER, pose['br']))
    hip_x = pose['hip_' + limb[-1]]
    return add(c, rot((hip_x, TORSO_H / 2), pose['br']))


def ik_to_fk(pose, limb, target, bend=None):
    """FK angles that reach ``target`` for ``limb`` of ``pose`` (torso first)."""
    l1, l2 = (UARM, FARM) if limb.startswith('arm') else (THIGH, SHIN)
    return ik2(joint_of(pose, limb), target, l1, l2,
               bend or DEFAULT_BENDS[limb])


def at_hips(hips, br, **kw):
    """Pose kwargs placing the torso so its bottom-centre sits at ``hips``."""
    off = rot((0, TORSO_H / 2), br)
    return dict(cx=hips[0] - off[0], cy=hips[1] - off[1], br=br, **kw)


# ── Solve a pose into per-layer transforms ───────────────────────────────────

def solve(spec, pose):
    """Returns {layer: dict(p=(x,y), r=deg, s=(sx,sy))}."""
    out = {}
    c = (pose['cx'], pose['cy'])
    br = pose['br']
    out['body'] = dict(p=c, r=br, s=(100, 100))

    hx, hy = pose['head']
    out['head'] = dict(p=add(c, rot((hx, hy), br)), r=br + pose['ht'],
                       s=(100, 100))

    for side in ('n', 'f'):
        sfx = 'r' if side == 'n' else 'l'
        # Arm
        shoulder = joint_of(pose, 'arm_' + side)
        a1, a2, _, _ = chain(
            shoulder, UARM, FARM, spec.modes['arm_' + side],
            pose['arm_' + side], spec.bends['arm_' + side])
        su, sf = pose['sc_uarm_' + side], pose['sc_farm_' + side]
        out['uarm_' + sfx] = dict(
            p=add(shoulder, mul(dirv(a1), UARM * su / 2)), r=a1,
            s=(100, 100 * su))
        elbow = add(shoulder, mul(dirv(a1), UARM * su))
        out['farm_' + sfx] = dict(
            p=add(elbow, mul(dirv(a2), FARM * sf / 2)), r=a2 + 180,
            s=(100, 100 * sf))
        # Leg
        hip = joint_of(pose, 'leg_' + side)
        b1, b2, _, _ = chain(
            hip, THIGH, SHIN, spec.modes['leg_' + side],
            pose['leg_' + side], spec.bends['leg_' + side])
        st, ss = pose['sc_thigh_' + side], pose['sc_shin_' + side]
        out['thigh_' + sfx] = dict(
            p=add(hip, mul(dirv(b1), THIGH * st / 2)), r=b1,
            s=(100, 100 * st))
        knee = add(hip, mul(dirv(b1), THIGH * st))
        out['shin_' + sfx] = dict(
            p=add(knee, mul(dirv(b2), SHIN * ss / 2)), r=b2,
            s=(100, 100 * ss))
        ankle = add(knee, mul(dirv(b2), SHIN * ss))
        fdx, fdy, frot = pose['foot_' + side]
        out['foot_' + sfx] = dict(p=add(ankle, (fdx, fdy)), r=frot,
                                  s=(100, 100))
    return out


# ── Lottie emission ──────────────────────────────────────────────────────────

def _tr():
    return {"ty": "tr", "p": {"a": 0, "k": [0, 0]}, "r": {"a": 0, "k": 0},
            "s": {"a": 0, "k": [100, 100]}, "a": {"a": 0, "k": [0, 0]},
            "o": {"a": 0, "k": 100}, "sk": {"a": 0, "k": 0},
            "sa": {"a": 0, "k": 0}, "nm": "tr"}


def _fill(c):
    return {"ty": "fl", "c": {"a": 0, "k": c}, "o": {"a": 0, "k": 100},
            "r": 1, "nm": "fill"}


def _rc(w, h, p=(0, 0), r=5):
    return {"ty": "rc", "s": {"a": 0, "k": [w, h]}, "p": {"a": 0, "k": list(p)},
            "r": {"a": 0, "k": r}, "nm": "rc", "d": 1}


def _el(w, h, p=(0, 0)):
    return {"ty": "el", "s": {"a": 0, "k": [w, h]}, "p": {"a": 0, "k": list(p)},
            "nm": "el", "d": 1}


def _group(nm, items, ix=1):
    return {"ty": "gr", "nm": nm, "it": items + [_tr()], "np": len(items) + 1,
            "cix": 2, "ix": ix}


def _single(nm, shape, color, ix=1):
    return _group(nm, [shape, _fill(color)], ix)


def _head_shapes():
    spec = [
        ('crest', _el(20, 18, (-2, -30)), DARK),
        ('shine', _rc(44, 4, (0, -17), 2), WHITE),
        ('headband', _rc(62, 9, (0, -16), 3), BAND),
        ('face', _el(38, 42, (10, 6)), FACE),
        ('brow', _rc(50, 12, (3, -14), 4), DARK),
        ('ear_in', _el(7, 10, (-20, 5)), FACE),
        ('ear', _el(12, 16, (-20, 4)), DARK),
        ('skull', _el(58, 58), DARK),
    ]
    return [_single(nm, sh, col, i + 1) for i, (nm, sh, col) in enumerate(spec)]


def _body_shapes():
    return [
        _single('torso', _rc(56, 100), DARK, 1),
        _single('chest', _rc(42, 16, (0, -30), 4), LIGHT, 2),
        _single('abs', _rc(36, 10, (0, 6), 3), LIGHT, 3),
    ]


def _part_shapes(name):
    far = name.endswith('_l')
    if name == 'head':
        return _head_shapes()
    if name == 'body':
        return _body_shapes()
    if name.startswith('thigh'):
        return [_single('seg', _rc(26 if far else 28, 46), FAR if far else DARK)]
    if name.startswith('shin'):
        return [_single('seg', _rc(20 if far else 22, 38), FAR if far else DARK)]
    if name.startswith('foot'):
        return [_single('f', _el(30 if far else 34, 12), FAR if far else DARK)]
    if name.startswith('uarm'):
        return [_single('uarm', _rc(16, 44), FAR if far else LIGHT)]
    if name.startswith('farm'):
        return [_group('farm', [_rc(14, 36), _el(18, 12, (0, -24)),
                                _fill(FAR if far else LIGHT)])]
    raise KeyError(name)


def _static_layer(nm, ind, op, rect, color, rnd):
    shapes = [_single('fl', _rc(rect[2], rect[3], (rect[0], rect[1]), rnd),
                      color)]
    return _layer(nm, ind, op, shapes, {"a": 0, "k": [0, 0]},
                  {"a": 0, "k": [0]}, {"a": 0, "k": [100, 100]},
                  {"a": 0, "k": [100]})


def _layer(nm, ind, op, shapes, p, r, s, o):
    return {"ty": 4, "nm": nm, "ind": ind, "ip": 0, "op": op, "st": 0,
            "bm": 0, "sr": 1, "ao": 0,
            "ks": {"p": p, "r": r, "a": {"a": 0, "k": [0, 0]}, "s": s, "o": o},
            "shapes": shapes}


def _prop(times, values, linear=True):
    """Static if every value is identical, otherwise keyframed."""
    first = values[0]
    if all(all(abs(a - b) < 1e-3 for a, b in zip(v, first)) for v in values):
        return {"a": 0, "k": [round(x, 2) for x in first]}
    kfs = []
    for i, (t, v) in enumerate(zip(times, values)):
        kf = {"t": t, "s": [round(x, 2) for x in v]}
        if i < len(times) - 1:
            kf["i"] = {"x": [1.0], "y": [1.0]}
            kf["o"] = {"x": [0.0], "y": [0.0]}
        kfs.append(kf)
    return {"a": 1, "k": kfs}


def _unwrap(seq):
    out = [seq[0]]
    for v in seq[1:]:
        prev = out[-1]
        while v - prev > 180:
            v -= 360
        while v - prev < -180:
            v += 360
        out.append(v)
    return out


def build(spec):
    times = list(range(0, spec.frames + 1, spec.step))
    if times[-1] != spec.frames:
        times.append(spec.frames)
    frames = [solve(spec, spec.pose_at(t)) for t in times]

    layers = []
    for idx, nm in enumerate(spec.order, start=1):
        pos = [f[nm]['p'] for f in frames]
        rots = _unwrap([f[nm]['r'] for f in frames])
        scl = [f[nm]['s'] for f in frames]
        far = nm.endswith('_l')
        layers.append(_layer(
            nm, idx, spec.frames, _part_shapes(nm),
            _prop(times, pos), _prop(times, [(r,) for r in rots]),
            _prop(times, scl),
            {"a": 0, "k": [FAR_OPACITY if far and nm != 'body' else 100]}))
    layers.append(_static_layer('floor_line', 96, spec.frames,
                                (200, FLOOR_Y, 400, 2), FLOOR_LINE, 5))
    layers.append(_static_layer('floor', 97, spec.frames,
                                (200, 388, 400, 26), FLOOR, 5))
    return {"v": "5.7.4", "fr": FPS, "ip": 0, "op": spec.frames, "w": SIZE,
            "h": SIZE, "nm": spec.name, "ddd": 0, "assets": [],
            "fonts": {"list": []}, "markers": [], "layers": layers}


def write(spec, directory):
    data = build(spec)
    path = f'{directory}/{spec.name}.json'
    with open(path, 'w') as f:
        json.dump(data, f, separators=(',', ':'))
    return path
