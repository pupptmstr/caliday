"""Front-view Goro: standing or sitting on the floor, facing the camera (or,
with ``view='back'``, seen from behind).

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

Seated poses: ``figure(hips=SEAT_HIPS, **cross_legs())`` (or ``butterfly_legs``,
``straddle_legs``) with ``order=ORDER_SEATED`` (the shins lie over the thighs,
the arms over everything). A fold towards the camera is ``fold_toward(k)``:
the torso foreshortens and the head comes down in front of it.
"""

import math

from goro_rig import (DARK, FLOOR, FLOOR_LINE, FLOOR_Y, FPS, SIZE, _el, _layer,  # noqa: F401
                      _prop, _rc, _single, _static_layer, _unwrap, add, ang_of,
                      bar, dirv, door_post, ik2, mul, rot)
from topview import (BAND, CHEST, DARK as FDARK, K, KNEECAP, SLEEVE, THIGH,
                     WHITE, _shapes as _top_shapes)

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


PAPER_ARM = [0.259, 0.259, 0.345, 1.0]   # arm colour of the original paper-doll files


def _paper_arm_shapes(name):
    """Dark arms and fists (like the profile / old front files) instead of the
    blue sleeves of the front-view asset."""
    if name.startswith('uarm'):
        return [_single('seg', _rc(28, 72, (0, 0), 8), PAPER_ARM)]
    if name.startswith('farm'):
        return [_single('seg', _rc(24, 58, (0, 0), 7), PAPER_ARM)]
    if name.startswith('hand'):
        return [_single('hand', _el(34, 22), PAPER_ARM)]
    if name.startswith('cap'):
        return [_single('cap', _el(22, 20), PAPER_ARM)]
    return None


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


def _back_shapes(name):
    """Goro from behind: the head without a face (the headband goes all the
    way round), the back with the spine and the shoulder blades."""
    if name == 'head':
        spec = [
            ('crest', _el(38, 33, (0, -53)), FDARK),
            ('shine', _rc(96, 7, (0, -29), 3), WHITE),
            ('headband', _rc(112, 15, (0, -28), 5), BAND),
            ('ear_l', _el(20, 27, (-54, 7)), FDARK),
            ('ear_r', _el(20, 27, (54, 7)), FDARK),
            ('skull', _el(110, 105), FDARK),
        ]
        return [_single(nm, sh, col, i + 1) for i, (nm, sh, col) in enumerate(spec)]
    if name == 'body':
        return [_single('torso', _rc(130, 170, (0, 0), 14), FDARK, 1),
                _single('spine', _rc(8, 120, (0, 6), 4), CHEST, 2),
                _single('blade_l', _el(40, 30, (-30, -46)), CHEST, 3),
                _single('blade_r', _el(40, 30, (30, -46)), CHEST, 4)]
    return None


def shapes(name, style='sleeve', view='front'):
    if name == 'crown':          # the top of the head, for a face turned down
        return _back_shapes('head')
    if style == 'paper':
        arm = _paper_arm_shapes(name)
        if arm:
            return arm
    if view == 'back':
        back = _back_shapes(name)
        if back:
            return back
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
           head_scale=(1.0, 1.0), arm_len=(UARM, FARM), hand_rot=(0, 0),
           crown=0):
    """Layer transforms of a standing Goro.

    ``hips``     bottom-centre of the torso, ``lean`` its tilt about the hips
                 (degrees, clockwise).
    ``arm_len``  (upper arm, forearm) lengths for the IK (the segments stretch).
    ``head``     (dx, dy, tilt): head offset from the neck and tilt about it;
                 ``head_scale`` squashes it along its own axes (chin tucked).
    ``sh_*``     shoulder offsets from the default shoulder points (shrugs).
    ``arm_*``    ``(wrist_target, bend)`` or ``(wrist, bend, elbow)`` with an
                 explicit elbow; default: hanging at the side. ``hand_rot``
                 turns the fists (l, r), e.g. 90 for palms pressed together.
    ``crown``    0..1: cross-fades the face to the top of the head (a layer
                 ``crown`` in the order), for a face turned to the floor.
    ``leg_*``    ``dict(knee=(x, y), ankle=(x, y), near=1.0)``; default: standing
                 straight (``near`` scales the knee cap for a knee raised
                 towards the camera; ``foot_rot`` / ``foot_scale`` turn the foot,
                 e.g. 90 for a sole facing sideways or toes pointing up).
    """
    out = {}
    c = add(hips, rot((0, -TORSO_H / 2), lean))
    out['body'] = dict(p=c, r=lean,
                       s=(K * 100 * torso_scale[0], K * 100 * torso_scale[1]))

    neck = add(c, rot((0, NECK_DY * torso_scale[1]), lean))
    hdx, hdy, tilt = head
    out['head'] = dict(p=add(neck, rot((hdx, HEAD_DY + hdy), lean + tilt)),
                       r=lean + tilt,
                       s=(K * 100 * head_scale[0], K * 100 * head_scale[1]),
                       o=100 - 100 * crown)
    out['crown'] = dict(out['head'], o=100 * crown)

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
            elbow, wrist = elbow_of(shoulder, arm[0], arm[1], *arm_len)
        out['cap_' + side] = dict(p=shoulder, r=0, s=(100, 100))
        out['uarm_' + side] = _seg(shoulder, elbow, 72, K * 100)
        out['farm_' + side] = _seg(elbow, wrist, 58, K * 100)
        out['hand_' + side] = dict(p=wrist, r=hand_rot[0 if side == 'l' else 1],
                                   s=(K * 100, K * 100))

        hip = add(hips, rot((sx * HIP_DX, 0), lean))
        leg = (leg_l if side == 'l' else leg_r) or {}
        ankle = leg.get('ankle', (hip[0] + sx * 1, STAND_ANKLE_Y))
        knee = leg.get('knee', (hip[0] + sx * 0.5, ankle[1] - SHIN_LEN))
        out['thigh_' + side] = _seg(hip, knee, THIGH_LEN)
        out['shin_' + side] = _seg(knee, ankle, SHIN_LEN)
        fs = leg.get('foot_scale', (1, 1))
        out['foot_' + side] = dict(p=add(ankle, leg.get('foot_off', (0, 4))),
                                   r=-sx * leg['foot_rot'] if 'foot_rot' in leg else 0,
                                   s=(100 * fs[0], 100 * fs[1]))
        cs = 100 * leg.get('near', 1.0)   # >1: the knee comes towards the camera
        out['knee_' + side] = dict(p=add(knee, (0, 2)), r=0, s=(cs, cs))
    return out


def _turn_angle(a0, a1, turn):
    while turn > 0 and a1 < a0:
        a1 += 360
    while turn < 0 and a1 > a0:
        a1 -= 360
    return a1


def swing_arm(start, end, u, turn, shoulder=None, uturn=None):
    """An arm moving between two poses by its joints: the forearm *rotates*
    about the elbow (``turn`` = +1 clockwise, -1 anticlockwise on screen)
    instead of the wrist sliding past the elbow. The elbow travels in a
    straight line, or, with ``shoulder`` and ``uturn``, swings round the
    shoulder the same way (an arm raised sideways). ``start`` / ``end`` are
    ``(elbow, wrist)``; returns ``(wrist, bend, elbow)`` for ``figure``."""
    (e0, w0), (e1, w1) = start, end
    if shoulder is None:
        elbow = (e0[0] + (e1[0] - e0[0]) * u, e0[1] + (e1[1] - e0[1]) * u)
    else:
        b0 = ang_of(e0[0] - shoulder[0], e0[1] - shoulder[1])
        b1 = _turn_angle(b0, ang_of(e1[0] - shoulder[0], e1[1] - shoulder[1]), uturn)
        r0 = math.hypot(e0[0] - shoulder[0], e0[1] - shoulder[1])
        r1 = math.hypot(e1[0] - shoulder[0], e1[1] - shoulder[1])
        elbow = add(shoulder, mul(dirv(b0 + (b1 - b0) * u), r0 + (r1 - r0) * u))
    a0 = ang_of(w0[0] - e0[0], w0[1] - e0[1])
    a1 = _turn_angle(a0, ang_of(w1[0] - e1[0], w1[1] - e1[1]), turn)
    l0 = math.hypot(w0[0] - e0[0], w0[1] - e0[1])
    l1 = math.hypot(w1[0] - e1[0], w1[1] - e1[1])
    wrist = add(elbow, mul(dirv(a0 + (a1 - a0) * u), l0 + (l1 - l0) * u))
    return (wrist, (0, 1), elbow)


def rest_arm(shoulder, wrist, bend):
    """``(elbow, wrist)`` of an arm reaching ``wrist`` by IK (for ``swing_arm``)."""
    return elbow_of(shoulder, wrist, bend)


# ── Seated on the floor ──────────────────────────────────────────────────────

SEAT_HIPS = (200.0, 352.0)   # bottom-centre of the torso when sitting
LEG_FLOOR_Y = 368            # centre line of a leg lying on the floor

# The arms over everything, then the head; the shins (nearest to the camera)
# over the knees and the thighs, the body at the back.
ORDER_SEATED = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r',
                'head', 'crown', 'foot_l', 'foot_r', 'shin_l', 'shin_r', 'knee_l',
                'knee_r', 'thigh_l', 'thigh_r', 'body']
# Seen from behind: the legs are behind the body, the arms on the back.
ORDER_BACK = ['hand_l', 'hand_r', 'farm_l', 'farm_r', 'uarm_l', 'uarm_r',
              'head', 'body', 'foot_l', 'foot_r', 'shin_l', 'shin_r',
              'knee_l', 'knee_r', 'thigh_l', 'thigh_r']


def _sides(fn):
    return {'leg_l': fn(-1), 'leg_r': fn(1)}


def cross_legs(hips=SEAT_HIPS, spread=48):
    """Sitting cross-legged: knees out to the sides, the shins cross in front
    (the left shin over the right one in ``ORDER_SEATED``)."""
    def leg(sx):
        knee = (hips[0] + sx * spread, LEG_FLOOR_Y - 8)
        ankle = (hips[0] - sx * 14, LEG_FLOOR_Y + (2 if sx < 0 else 0))
        return dict(knee=knee, ankle=ankle, near=1.1, foot_rot=70,
                    foot_scale=(0.8, 0.9), foot_off=(-sx * 6, 2))
    return _sides(leg)


def butterfly_legs(hips=SEAT_HIPS, knees_up=0.0):
    """Soles together in front, knees out to the sides; ``knees_up`` (0..1)
    raises the knees (1 = a stiff start, 0 = knees near the floor)."""
    def leg(sx):
        knee = (hips[0] + sx * (58 - 6 * knees_up), LEG_FLOOR_Y - 6 - 26 * knees_up)
        ankle = (hips[0] + sx * 9, LEG_FLOOR_Y + 2)
        return dict(knee=knee, ankle=ankle, near=1.1 + 0.1 * knees_up,
                    foot_rot=90, foot_scale=(1.0, 0.8), foot_off=(sx * 3, -2))
    return _sides(leg)


def straddle_legs(hips=SEAT_HIPS, width=1.0):
    """Straight legs wide apart on the floor, toes pointing up."""
    def leg(sx):
        hip = (hips[0] + sx * HIP_DX, hips[1])
        ankle = (hips[0] + sx * (16 + 80 * width), LEG_FLOOR_Y + 2)
        knee = ((hip[0] + ankle[0]) / 2, (hip[1] + ankle[1]) / 2 + 2)
        return dict(knee=knee, ankle=ankle, near=0.9, foot_rot=90,
                    foot_scale=(1.0, 0.85), foot_off=(sx * 4, -12))
    return _sides(leg)


def fold_toward(k, hips=SEAT_HIPS):
    """``figure`` keywords for a forward fold towards the camera (0..1): the
    torso foreshortens and widens a little, the head comes down in front of it
    and, past half-way, the face turns down and the crown shows
    (``crown`` in the order)."""
    return dict(hips=hips, torso_scale=(1 + 0.08 * k, 1 - 0.55 * k),
                head=(0, 74 * k, 0), head_scale=(1 + 0.04 * k, 1 - 0.14 * k),
                crown=min(1.0, max(0.0, (k - 0.45) / 0.4)))


# ── Animation ────────────────────────────────────────────────────────────────

class Animation:
    """Spec-compatible: ``write()`` in goro_rig calls ``build()``."""

    def __init__(self, name, frames, pose_fn, step=2, order=None, props=None,
                 props_index=None, style='sleeve', floor=True, view='front',
                 shapes_fn=None):
        self.name = name
        self.frames = frames
        self.pose_fn = pose_fn
        self.step = step
        self.order = order or ORDER
        # Extra static layers (walls, posts), drawn behind the figure: a list or
        # a function ``frames -> list`` (see ``bar`` / ``door_post``).
        self.props = props or []
        # Insert the props into the layer order after this many figure layers
        # (None: behind everything), e.g. a bar in front of the head but under
        # the fists; ``style='paper'`` draws dark arms; ``floor=False`` omits it.
        self.props_index = props_index
        self.style = style
        self.floor = floor
        self.view = view
        # ``shapes_fn(name)`` -> shapes, or None for the default ones (extra
        # layers such as a chest patch that slides over a turning torso).
        self.shapes_fn = shapes_fn

    def build(self):
        times = list(range(0, self.frames + 1, self.step))
        if times[-1] != self.frames:
            times.append(self.frames)
        poses = [self.pose_fn(t) for t in times]
        layers = []
        props = list(self.props(self.frames) if callable(self.props)
                     else self.props)
        for idx, nm in enumerate(self.order, start=1):
            if self.props_index is not None and idx - 1 == self.props_index:
                layers.extend(props)
                props = []
            shp = ((self.shapes_fn and self.shapes_fn(nm))
                   or shapes(nm, self.style, self.view))
            pos = [p[nm]['p'] for p in poses]
            rots = _unwrap([p[nm]['r'] for p in poses])
            scl = [p[nm]['s'] for p in poses]
            opa = [(p[nm].get('o', 100),) for p in poses]
            layers.append(_layer(
                nm, idx, self.frames, shp, _prop(times, pos),
                _prop(times, [(r,) for r in rots]), _prop(times, scl),
                _prop(times, opa)))
        layers.extend(props)
        if self.floor:
            layers.append(_static_layer('floor_line', 96, self.frames,
                                        (200, FLOOR_Y, 400, 2), FLOOR_LINE, 5))
            layers.append(_static_layer('floor', 97, self.frames,
                                        (200, 388, 400, 26), FLOOR, 5))
        return {"v": "5.7.4", "fr": FPS, "ip": 0, "op": self.frames,
                "w": SIZE, "h": SIZE, "nm": self.name, "ddd": 0, "assets": [],
                "fonts": {"list": []}, "markers": [], "layers": layers}
