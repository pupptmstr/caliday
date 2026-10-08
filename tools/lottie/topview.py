"""Top-down Goro for exercises that are unreadable in a side view.

Goro lies on his back seen from above (head at the top of the frame, face to
the camera), so he looks like the existing front-view asset
(``warmup_wrist_circles``): same head, torso and blue sleeves, scaled down to
fit the whole body. Parts are placed by their end points; a segment is a
rounded rectangle stretched between two joints.

Used by ``supp_oblique_crunch`` (elbow to the opposite knee reads clearly
from above, while a side view tangled the arms) and, with their own pose
functions (``TopViewAnimation(name, frames, pose_fn)``), the supine twist and
the reclined figure four of Evening Stretch (``gen_evening.py``).
"""

import math

from goro_rig import (FLOOR, FLOOR_LINE, FPS, SIZE, _el, _layer, _prop, _rc,  # noqa: E501
                      _single, _unwrap, add, ang_of, dirv, ik2, mul, rot, smooth)

K = 0.6  # scale of the front-view asset (head 110 px wide -> 66 px)

DARK = [0.216, 0.216, 0.298, 1.0]
CHEST = [0.255, 0.255, 0.345, 1.0]
BROW = [0.18, 0.18, 0.255, 1.0]
FACE = [0.765, 0.655, 0.506, 1.0]
BAND = [0.655, 0.847, 1.0, 1.0]
WHITE = [1.0, 1.0, 1.0, 1.0]
NOSE = [0.584, 0.467, 0.337, 1.0]
NOSTRIL = [0.474, 0.377, 0.271, 1.0]
PUPIL = [0.102, 0.102, 0.161, 1.0]
SLEEVE = [0.255, 0.612, 0.961, 1.0]
HAND = [0.118, 0.427, 0.722, 1.0]
THIGH = [0.275, 0.275, 0.37, 1.0]   # raised thighs catch the light
KNEECAP = [0.35, 0.35, 0.46, 1.0]

UARM, FARM = 72 * K, 58 * K


def _front_head():
    """The head of ``warmup_wrist_circles`` (exact sizes, offsets and order)."""
    spec = [
        ('crest', _el(38, 33, (0, -53)), DARK),
        ('brow', _rc(92, 20, (0, -24), 6), BROW),
        ('face', _el(72, 75, (0, 10)), FACE),
        ('headband', _rc(112, 15, (0, -28), 5), BAND),
        ('shine', _rc(82, 7, (0, -29), 3), WHITE),
        ('nose', _el(34, 22, (0, 17)), NOSE),
        ('nos_l', _el(12, 9, (-9, 22)), NOSTRIL),
        ('nos_r', _el(12, 9, (9, 22)), NOSTRIL),
        ('eye_l_w', _el(24, 20, (-22, -3)), WHITE),
        ('eye_l_p', _el(12, 14, (-22, -3)), PUPIL),
        ('eye_l_s', _el(5, 5, (-19, -7)), WHITE),
        ('eye_r_w', _el(24, 20, (22, -3)), WHITE),
        ('eye_r_p', _el(12, 14, (22, -3)), PUPIL),
        ('eye_r_s', _el(5, 5, (25, -7)), WHITE),
        ('ear_l', _el(20, 27, (-54, 7)), DARK),
        ('ear_r', _el(20, 27, (54, 7)), DARK),
        ('ear_l_in', _el(12, 17, (-54, 9)), FACE),
        ('ear_r_in', _el(12, 17, (54, 9)), FACE),
        ('skull', _el(110, 105), DARK),
    ]
    return [_single(nm, sh, col, i + 1) for i, (nm, sh, col) in enumerate(spec)]


def _shapes(name):
    if name == 'head':
        return _front_head()
    if name == 'body':
        return [_single('torso', _rc(130, 170, (0, 0), 14), DARK, 1),
                _single('chest', _rc(116, 30, (0, -52), 8), CHEST, 2),
                _single('abs', _rc(96, 16, (0, 10), 6), CHEST, 3)]
    if name.startswith('uarm'):
        return [_single('seg', _rc(28, 72, (0, 0), 8), SLEEVE)]
    if name.startswith('farm'):
        return [_single('seg', _rc(24, 58, (0, 0), 7), SLEEVE)]
    if name.startswith('hand'):
        return [_single('hand', _el(34, 22), HAND)]
    if name.startswith('thigh'):
        return [_single('seg', _rc(36, 70, (0, 0), 10), THIGH)]
    if name.startswith('shin'):
        return [_single('seg', _rc(30, 70, (0, 0), 9), DARK)]
    if name.startswith('knee'):
        return [_single('cap', _el(34, 30), KNEECAP)]
    if name.startswith('foot'):
        return [_single('f', _el(34, 20), DARK)]
    if name == 'mat':
        return [_single('mat', _rc(292, 352, (200, 200), 20), FLOOR, 1),
                _single('border', _rc(304, 364, (200, 200), 24), FLOOR_LINE, 2)]
    raise KeyError(name)


BASE_LEN = {'uarm': 72, 'farm': 58, 'thigh': 70, 'shin': 70}


def _segment(j, k, kind):
    """Layer transform for a segment of ``kind`` drawn from joint j to k."""
    d = (k[0] - j[0], k[1] - j[1])
    dist = math.hypot(*d) or 1e-3
    return dict(p=((j[0] + k[0]) / 2, (j[1] + k[1]) / 2), r=ang_of(*d),
                s=(K * 100, 100 * dist / BASE_LEN[kind]))


PIVOT = (200, 262)       # hips: the torso rotates about this point
SHOULDER_X = 36
SHOULDER_DY = 262 - 175  # shoulder height above the pivot
HEAD_DY = 262 - 118
TORSO_DY = 262 - 216
HIP_X = 22
KNEE = (40, 226)         # knees up: projected thigh is short
FOOT = (26, 300)


def _lift(u):
    return 1 - 0.12 * u


def _geometry(u, s):
    """Torso, head and joint positions when crunching to side ``s`` by ``u``."""
    theta = s * 24 * u
    ls = _lift(u)
    g = dict(theta=theta, ls=ls)
    g['torso'] = add(PIVOT, rot((0, -TORSO_DY * ls), theta))
    g['head'] = add(PIVOT, rot((0, -HEAD_DY * (1 - 0.18 * u)), theta))
    g['head_rot'] = theta * 1.1
    for side, sx in (('l', -1), ('r', 1)):
        g['sh_' + side] = add(PIVOT, rot((sx * SHOULDER_X, -SHOULDER_DY * ls),
                                         theta))
        # The fists stay on the temples.
        g['wr_' + side] = add(g['head'], rot((sx * 33, 4), g['head_rot']))
    return g


def _inward(sh, wr, side):
    """Unit normal of the shoulder -> temple line pointing at the body axis."""
    w = (wr[0] - sh[0], wr[1] - sh[1])
    n = math.hypot(*w) or 1e-3
    w = (w[0] / n, w[1] / n)
    return (-w[1], w[0]) if side == 'l' else (w[1], -w[0])


def _elbow_qp(sh, wr, side, inward):
    """IK elbow (inside or outside the arm line) as (fraction along the
    shoulder -> temple line, signed distance from it, positive = inwards)."""
    n = _inward(sh, wr, side)
    a1, _ = ik2(sh, wr, UARM, FARM, n if inward else (-n[0], -n[1]))
    e = add(sh, mul(dirv(a1), UARM))
    w = (wr[0] - sh[0], wr[1] - sh[1])
    d = (e[0] - sh[0], e[1] - sh[1])
    return ((d[0] * w[0] + d[1] * w[1]) / (w[0] ** 2 + w[1] ** 2),
            d[0] * n[0] + d[1] * n[1])


def _end_poses():
    """Elbow (q, p) at rest and fully crunched, for each side and direction."""
    out = {}
    g0 = _geometry(0, 1)
    for side in ('l', 'r'):
        out[side, 'rest'] = _elbow_qp(g0['sh_' + side], g0['wr_' + side],
                                      side, False)
    for s in (1, -1):
        g = _geometry(1, s)
        for side in ('l', 'r'):
            lead = (side == 'l') == (s == 1)  # elbow crossing to the far knee
            out[side, s] = _elbow_qp(g['sh_' + side], g['wr_' + side], side,
                                     lead)
    return out


END = _end_poses()


CRUNCH_KEYS = [(0, 0), (1, 0), (12, 1), (15, 1), (24, 0), (25, 0), (36, 1),
               (39, 1), (48, 0)]


def _amount(t):
    """(u, side): crunch amount 0..1 and direction (+1 right, -1 left)."""
    u = 0.0
    for (t0, u0), (t1, u1) in zip(CRUNCH_KEYS, CRUNCH_KEYS[1:]):
        if t0 <= t <= t1:
            u = u0 + (u1 - u0) * smooth((t - t0) / (t1 - t0))
            break
    return u, (1 if t < 24.5 else -1)


def _pose(t):
    u, s = _amount(t)
    g = _geometry(u, s)
    parts = {}
    parts['body'] = dict(p=g['torso'], r=g['theta'],
                         s=(K * 100, K * 100 * g['ls']))
    parts['head'] = dict(p=g['head'], r=g['head_rot'], s=(K * 100, K * 100))
    for side in ('l', 'r'):
        sh, wrist = g['sh_' + side], g['wr_' + side]
        # The elbow travels from outside the arm line to inside it *over the
        # top*: it passes along the shoulder -> temple line (the arm foreshort-
        # ens as the elbow rises towards the camera) and the fist never leaves
        # the temple.
        (q0, p0), (q1, p1) = END[side, 'rest'], END[side, s]
        q, pd = q0 + (q1 - q0) * u, p0 + (p1 - p0) * u
        n = _inward(sh, wrist, side)
        elbow = (sh[0] + (wrist[0] - sh[0]) * q + n[0] * pd,
                 sh[1] + (wrist[1] - sh[1]) * q + n[1] * pd)
        parts['uarm_' + side] = _segment(sh, elbow, 'uarm')
        parts['farm_' + side] = _segment(elbow, wrist, 'farm')
        parts['hand_' + side] = dict(p=wrist, r=0, s=(K * 100, K * 100))

        # The legs do not move in a crunch: feet planted, knees up.
        sx = -1 if side == 'l' else 1
        hip = (200 + sx * HIP_X, PIVOT[1])
        knee = (200 + sx * KNEE[0], KNEE[1])
        foot = (200 + sx * FOOT[0], FOOT[1])
        parts['thigh_' + side] = _segment(hip, knee, 'thigh')
        parts['shin_' + side] = _segment(knee, foot, 'shin')
        parts['knee_' + side] = dict(p=knee, r=0, s=(K * 100, K * 100))
        parts['foot_' + side] = dict(p=add(foot, (0, 4)), r=0, s=(K * 100, K * 100))
    return parts


ORDER = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r', 'head',
         'knee_l', 'knee_r', 'thigh_l', 'thigh_r', 'shin_l', 'shin_r', 'foot_l',
         'foot_r', 'body', 'mat']


class TopViewAnimation:
    """Spec-compatible object: ``write()`` in goro_rig calls ``build()``.
    ``pose_fn(t)`` returns the layer transforms of frame ``t`` (by default the
    oblique crunch); ``order`` lists the layers, top first."""

    def __init__(self, name, frames, pose_fn=None, order=None, step=2,
                 shapes_fn=None):
        self.name = name
        self.frames = frames
        self.pose_fn = pose_fn or _pose
        self.order = order or ORDER
        self.step = step
        # Layer name -> shapes; e.g. Goro seen from above lying face down.
        self.shapes_fn = shapes_fn or _shapes

    def build(self):
        times = list(range(0, self.frames + 1, self.step))
        if times[-1] != self.frames:
            times.append(self.frames)
        poses = [self.pose_fn(t) for t in times]
        layers = []
        for idx, nm in enumerate(self.order, start=1):
            if nm == 'mat':
                layers.append(_layer(
                    nm, idx, self.frames, self.shapes_fn(nm), {"a": 0, "k": [0, 0]},
                    {"a": 0, "k": [0]}, {"a": 0, "k": [100, 100]},
                    {"a": 0, "k": [100]}))
                continue
            pos = [f[nm]['p'] for f in poses]
            rots = _unwrap([f[nm]['r'] for f in poses])
            scl = [f[nm]['s'] for f in poses]
            layers.append(_layer(
                nm, idx, self.frames, self.shapes_fn(nm), _prop(times, pos),
                _prop(times, [(r,) for r in rots]), _prop(times, scl),
                {"a": 0, "k": [100]}))
        return {"v": "5.7.4", "fr": FPS, "ip": 0, "op": self.frames,
                "w": SIZE, "h": SIZE, "nm": self.name, "ddd": 0, "assets": [],
                "fonts": {"list": []}, "markers": [], "layers": layers}


def oblique_crunch():
    return TopViewAnimation('supp_oblique_crunch', 48)
