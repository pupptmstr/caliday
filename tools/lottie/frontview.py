"""Front-view Goro: standing, facing the camera.

For poses that do not read in the side-view rig (``goro_rig.py``): the head,
torso and blue sleeves come from the front-view asset ``warmup_wrist_circles``
(via ``topview.py``), scaled by 0.6 so the standing figure has the same size as
the profile one (hips at ``(200, 288)``, floor at ``y = 376``).

Parts are placed by their end points: a segment is a rounded rectangle
stretched between two joints. Every frame is solved independently from a pose
function, so planted hands/feet never drift and there are no angle
interpolation artefacts. Layers are named by *screen* side: ``l`` is the left
of the picture.

Usage: build an ``Animation(name, frames, pose_fn)`` where ``pose_fn(t)``
returns ``figure(...)`` for frame ``t``; ``write()`` from ``goro_rig`` saves it.
"""

import math

from goro_rig import (DARK, FLOOR, FLOOR_LINE, FLOOR_Y, FPS, SIZE, _el, _layer,  # noqa: F401
                      _prop, _rc, _single, _static_layer, _unwrap, add, ang_of,
                      bar, dirv, door_post, ik2, mul, rot)
from topview import K, KNEECAP, SLEEVE, THIGH, _shapes as _top_shapes

# Sizes (final pixels).
UARM = 72 * K            # 43.2
FARM = 58 * K            # 34.8
THIGH_LEN, SHIN_LEN = 46.0, 38.0
THIGH_W, SHIN_W = 26, 22
HIP_DX = 14              # hip joint offset from the body axis
STAND_ANKLE_Y = 372      # foot centre sits on the floor line (y = 376)

TORSO_W, TORSO_H = 130 * K, 170 * K     # 78 x 102
SHOULDER_DX, SHOULDER_DY = 36, -41      # from the torso centre
NECK_DY = -54                           # neck pivot above the torso centre
HEAD_DY = -36                           # head centre above the neck pivot

ORDER = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r', 'head',
         'knee_l', 'knee_r', 'thigh_l', 'thigh_r', 'shin_l', 'shin_r', 'foot_l',
         'foot_r', 'body']
# Same with round shoulder caps (for animations where the shoulders move).
ORDER_CAPS = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r',
              'cap_l', 'cap_r'] + ORDER[6:]


def _leg_shapes(name):
    if name.startswith('thigh'):
        return [_single('seg', _rc(THIGH_W, THIGH_LEN, (0, 0), 9), THIGH)]
    if name.startswith('shin'):
        return [_single('seg', _rc(SHIN_W, SHIN_LEN, (0, 0), 8), DARK)]
    if name.startswith('foot'):
        return [_single('f', _el(32, 13), DARK)]
    if name.startswith('knee'):
        return [_single('cap', _el(26, 22), KNEECAP)]
    if name.startswith('cap'):
        return [_single('cap', _el(22, 20), SLEEVE)]
    return None


def shapes(name):
    return _leg_shapes(name) or _top_shapes(name)


# ── Pose solving ─────────────────────────────────────────────────────────────

def _seg(j, k, base_len, x_scale=100):
    """Layer transform of a segment of natural length ``base_len`` drawn from
    joint ``j`` to joint ``k`` (stretched/foreshortened to fit)."""
    d = (k[0] - j[0], k[1] - j[1])
    dist = math.hypot(*d) or 1e-3
    return dict(p=((j[0] + k[0]) / 2, (j[1] + k[1]) / 2), r=ang_of(*d),
                s=(x_scale, 100 * dist / base_len))


def elbow_of(shoulder, wrist, bend, l1=UARM, l2=FARM):
    """Two-bone IK: elbow position and the (clamped) wrist, ``bend`` = side the
    elbow favours."""
    a1, a2 = ik2(shoulder, wrist, l1, l2, bend)
    elbow = add(shoulder, mul(dirv(a1), l1))
    return elbow, add(elbow, mul(dirv(a2), l2))


def figure(hips=(200.0, 288.0), lean=0.0, head=(0.0, 0.0, 0.0),
           sh_l=(0.0, 0.0), sh_r=(0.0, 0.0), arm_l=None, arm_r=None,
           leg_l=None, leg_r=None, torso_scale=(1.0, 1.0),
           head_scale=(1.0, 1.0)):
    """Layer transforms of a standing Goro.

    ``hips``     bottom-centre of the torso, ``lean`` its tilt about the hips
                 (degrees, clockwise).
    ``head``     (dx, dy, tilt): head offset from the neck and tilt about it;
                 ``head_scale`` squashes it along its own axes (chin tucked).
    ``sh_*``     shoulder offsets from the default shoulder points (shrugs).
    ``arm_*``    ``(wrist_target, bend)`` or ``(wrist, bend, elbow)`` with an
                 explicit elbow; default: hanging at the side.
    ``leg_*``    ``dict(knee=(x, y), ankle=(x, y), near=1.0)``; default: standing
                 straight (``near`` scales the knee cap for a knee raised
                 towards the camera).
    """
    out = {}
    c = add(hips, rot((0, -TORSO_H / 2), lean))
    out['body'] = dict(p=c, r=lean,
                       s=(K * 100 * torso_scale[0], K * 100 * torso_scale[1]))

    neck = add(c, rot((0, NECK_DY * torso_scale[1]), lean))
    hdx, hdy, tilt = head
    out['head'] = dict(p=add(neck, rot((hdx, HEAD_DY + hdy), lean + tilt)),
                       r=lean + tilt,
                       s=(K * 100 * head_scale[0], K * 100 * head_scale[1]))

    for side, sx in (('l', -1), ('r', 1)):
        off = sh_l if side == 'l' else sh_r
        shoulder = add(add(c, rot((sx * SHOULDER_DX * torso_scale[0],
                                   SHOULDER_DY * torso_scale[1]), lean)), off)
        arm = arm_l if side == 'l' else arm_r
        if arm is None:
            arm = (add(shoulder, (sx * 6, UARM + FARM - 6)), (sx, 0))
        if len(arm) == 3:
            wrist, _, elbow = arm
        else:
            elbow, wrist = elbow_of(shoulder, arm[0], arm[1])
        out['cap_' + side] = dict(p=shoulder, r=0, s=(100, 100))
        out['uarm_' + side] = _seg(shoulder, elbow, 72, K * 100)
        out['farm_' + side] = _seg(elbow, wrist, 58, K * 100)
        out['hand_' + side] = dict(p=wrist, r=0, s=(K * 100, K * 100))

        hip = add(hips, rot((sx * HIP_DX, 0), lean))
        leg = (leg_l if side == 'l' else leg_r) or {}
        ankle = leg.get('ankle', (hip[0] + sx * 1, STAND_ANKLE_Y))
        knee = leg.get('knee', (hip[0] + sx * 0.5, ankle[1] - SHIN_LEN))
        out['thigh_' + side] = _seg(hip, knee, THIGH_LEN)
        out['shin_' + side] = _seg(knee, ankle, SHIN_LEN)
        out['foot_' + side] = dict(p=add(ankle, (0, 4)), r=0, s=(100, 100))
        cs = 100 * leg.get('near', 1.0)   # >1: the knee comes towards the camera
        out['knee_' + side] = dict(p=add(knee, (0, 2)), r=0, s=(cs, cs))
    return out


# ── Animation ────────────────────────────────────────────────────────────────

class Animation:
    """Spec-compatible: ``write()`` in goro_rig calls ``build()``."""

    def __init__(self, name, frames, pose_fn, step=2, order=None, props=None):
        self.name = name
        self.frames = frames
        self.pose_fn = pose_fn
        self.step = step
        self.order = order or ORDER
        # Extra static layers (walls, posts), drawn behind the figure: a list or
        # a function ``frames -> list`` (see ``bar`` / ``door_post``).
        self.props = props or []

    def build(self):
        times = list(range(0, self.frames + 1, self.step))
        if times[-1] != self.frames:
            times.append(self.frames)
        poses = [self.pose_fn(t) for t in times]
        layers = []
        for idx, nm in enumerate(self.order, start=1):
            shp = shapes(nm)
            pos = [p[nm]['p'] for p in poses]
            rots = _unwrap([p[nm]['r'] for p in poses])
            scl = [p[nm]['s'] for p in poses]
            layers.append(_layer(
                nm, idx, self.frames, shp, _prop(times, pos),
                _prop(times, [(r,) for r in rots]), _prop(times, scl),
                {"a": 0, "k": [100]}))
        layers.extend(self.props(self.frames) if callable(self.props)
                      else self.props)
        layers.append(_static_layer('floor_line', 96, self.frames,
                                    (200, FLOOR_Y, 400, 2), FLOOR_LINE, 5))
        layers.append(_static_layer('floor', 97, self.frames,
                                    (200, 388, 400, 26), FLOOR, 5))
        return {"v": "5.7.4", "fr": FPS, "ip": 0, "op": self.frames,
                "w": SIZE, "h": SIZE, "nm": self.name, "ddd": 0, "assets": [],
                "fonts": {"list": []}, "markers": [], "layers": layers}
