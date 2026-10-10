#!/usr/bin/env python3
"""Goro's full-body poses, in the style of assets/goro/goro_idle_v2.svg.

    python3 tools/characters/gen_goro.py [--out DIR] [name ...]

Writes assets/goro/goro_pose_<name>.svg (the fun poses of the About screen:
a tap shows the next one) and goro_locked.svg (Goro holding an achievement he
has not earned yet). The designer's idle and flex files stay as they are.

The figure is a paper doll in the idle's own 1024 frame: the head (with the
neck) and the torso are the idle's shapes, placed by a transform; the arms and
legs are tapered capsules between joints solved by two-bone IK, with the
idle's lighter overlay; fists, feet and props are drawn at their joints. Edit
this script, not the SVGs.
"""

from __future__ import annotations

import argparse
import math
import pathlib
from dataclasses import dataclass, field

from gen_hosts import locked_badge

ROOT = pathlib.Path(__file__).resolve().parents[2]
OUT = ROOT / 'assets' / 'goro'

FUR = '#38384C'
FUR_L = '#424258'
FUR_HL = '#4A4A60'
FUR_D = '#2E2E42'
FUR_DD = '#1A1A30'
INK = '#1A1A2A'
MOUTH = '#7A6045'
ACCENT = '#A8D8FF'

# ── Geometry ──────────────────────────────────────────────────────────────────


def add(a, b):
    return (a[0] + b[0], a[1] + b[1])


def sub(a, b):
    return (a[0] - b[0], a[1] - b[1])


def mul(a, k):
    return (a[0] * k, a[1] * k)


def length(a):
    return math.hypot(a[0], a[1])


def unit(a):
    n = length(a) or 1.0
    return (a[0] / n, a[1] / n)


def rot(p, deg):
    r = math.radians(deg)
    c, s = math.cos(r), math.sin(r)
    return (p[0] * c - p[1] * s, p[0] * s + p[1] * c)


def perp(d):
    """d turned a quarter clockwise on screen (y points down)."""
    return (-d[1], d[0])


def ang(d):
    return math.degrees(math.atan2(d[1], d[0]))


def f(v):
    return f'{v:.1f}'.rstrip('0').rstrip('.')


def pt(p):
    return f'{f(p[0])} {f(p[1])}'


def ik(root, target, a, b, bend):
    """The middle joint of a two-bone chain root→target with bone lengths a
    and b; bend = +1 / -1 picks the side (perp of root→target). An
    unreachable target straightens the chain towards it."""
    d = sub(target, root)
    dist = min(length(d), a + b - 0.01)
    dist = max(dist, abs(a - b) + 0.01)
    u = unit(d)
    x = (a * a - b * b + dist * dist) / (2 * dist)
    h = math.sqrt(max(a * a - x * x, 0.0))
    return add(add(root, mul(u, x)), mul(perp(u), h * bend))


# ── Shapes ────────────────────────────────────────────────────────────────────


def capsule(p0, p1, r0, r1, fill, bulge=0.12, opacity=None):
    """A tapered limb from p0 to p1 with round ends and a slight bulge."""
    d = unit(sub(p1, p0))
    n = perp(d)
    a0, a1 = add(p0, mul(n, r0)), add(p1, mul(n, r1))
    b0, b1 = sub(p0, mul(n, r0)), sub(p1, mul(n, r1))
    mid = mul(add(p0, p1), 0.5)
    rm = (r0 + r1) / 2 * (1 + 2 * bulge)
    c1, c2 = add(mid, mul(n, rm)), sub(mid, mul(n, rm))
    op = f' opacity="{opacity}"' if opacity is not None else ''
    return (f'<path d="M{pt(a0)} Q{pt(c1)} {pt(a1)} A{f(r1)} {f(r1)} 0 0 0 {pt(b1)} '
            f'Q{pt(c2)} {pt(b0)} A{f(r0)} {f(r0)} 0 0 0 {pt(a0)}Z" fill="{fill}"{op}/>')


def limb(p0, p1, r0, r1, light=1):
    """A limb segment with the idle's lighter overlay on one side."""
    d = unit(sub(p1, p0))
    n = mul(perp(d), light)
    return '\n'.join([
        capsule(p0, p1, r0, r1, FUR),
        capsule(add(p0, mul(n, r0 * 0.3)), add(p1, mul(n, r1 * 0.3)),
                r0 * 0.5, r1 * 0.5, FUR_L, opacity=0.5),
    ])


def ellipse(c, rx, ry, fill, a=0.0, opacity=None):
    op = f' opacity="{opacity}"' if opacity is not None else ''
    tr = f' transform="rotate({f(a)} {pt(c)})"' if a else ''
    return f'<ellipse cx="{f(c[0])}" cy="{f(c[1])}" rx="{f(rx)}" ry="{f(ry)}" fill="{fill}"{tr}{op}/>'


def fist(wrist, d, side=1, knuckles=True):
    """A fist past the wrist along d; side = which way the thumb sticks out."""
    d = unit(d)
    n = perp(d)
    c = add(wrist, mul(d, 24))
    a = ang(d) - 90
    out = [ellipse(c, 50, 40, FUR, a), ellipse(add(c, mul(d, -4)), 41, 32, FUR_L, a)]
    if knuckles:
        for k in (-1.5, -0.5, 0.5, 1.5):
            out.append(ellipse(add(add(c, mul(d, 26)), mul(n, k * 20)), 12, 10, FUR_HL, a, 0.6))
    out.append(ellipse(add(add(c, mul(n, 44 * side)), mul(d, -6)), 16, 12, FUR, ang(n) + 25 * side))
    return '\n'.join(out)


def foot(ankle, d):
    """A wide gorilla foot at the end of a shin pointing along d."""
    d = unit(d)
    c = add(ankle, mul(d, 14))
    return '\n'.join([
        ellipse(c, 54, 22, FUR_D, ang(d) - 90),
        ellipse(add(c, mul(perp(d), -14)), 14, 10, '#282838', ang(d) - 90, 0.7),
    ])


# ── Head (the idle's, with face variants) ─────────────────────────────────────

NECK = (512, 400)          # where the head sits on the torso (head frame)


def eyes(kind):
    if kind in ('open', 'up', 'side'):
        look = {'open': (5, 3), 'up': (2, -10), 'side': (12, 2)}[kind]
        out = []
        for cx, lx in ((452, 1), (572, -1)):
            px, py = cx + look[0] * lx if kind == 'open' else cx + look[0], 260 + look[1]
            out += [
                ellipse((cx, 252), 50, 36, FUR_DD, opacity=0.3),
                ellipse((cx, 257), 37, 32, 'white'),
                ellipse((px, py), 21, 24, INK),
                f'<circle cx="{f(px + 5)}" cy="{f(py - 9)}" r="9" fill="white"/>',
                f'<circle cx="{f(px - 6)}" cy="{f(py + 6)}" r="4" fill="white" opacity="0.5"/>',
            ]
        return '\n'.join(out)
    if kind == 'closed':          # calm, eyes shut (meditation)
        out = []
        for cx in (452, 572):
            out += [ellipse((cx, 252), 50, 36, FUR_DD, opacity=0.25),
                    f'<path d="M{cx - 32} 258 Q{cx} 276 {cx + 32} 258" stroke="{INK}" '
                    'stroke-width="9" stroke-linecap="round" fill="none"/>']
        return '\n'.join(out)
    if kind == 'happy':           # ^ ^, laughing or enjoying
        out = []
        for cx in (452, 572):
            out += [ellipse((cx, 252), 50, 36, FUR_DD, opacity=0.25),
                    f'<path d="M{cx - 32} 268 Q{cx} 236 {cx + 32} 268" stroke="{INK}" '
                    'stroke-width="10" stroke-linecap="round" fill="none"/>']
        return '\n'.join(out)
    if kind == 'wink':            # left open, right ^
        return '\n'.join([
            ellipse((452, 252), 50, 36, FUR_DD, opacity=0.3),
            ellipse((452, 257), 37, 32, 'white'),
            ellipse((459, 261), 21, 24, INK),
            '<circle cx="464" cy="252" r="9" fill="white"/>',
            '<circle cx="453" cy="267" r="4" fill="white" opacity="0.5"/>',
            ellipse((572, 252), 50, 36, FUR_DD, opacity=0.25),
            f'<path d="M540 266 Q572 238 604 266" stroke="{INK}" stroke-width="10" '
            'stroke-linecap="round" fill="none"/>',
        ])
    if kind == 'squeeze':         # > <, effort
        return '\n'.join([
            ellipse((452, 252), 50, 36, FUR_DD, opacity=0.25),
            ellipse((572, 252), 50, 36, FUR_DD, opacity=0.25),
            f'<path d="M428 240 L474 258 L428 274" stroke="{INK}" stroke-width="10" '
            'stroke-linecap="round" stroke-linejoin="round" fill="none"/>',
            f'<path d="M596 240 L550 258 L596 274" stroke="{INK}" stroke-width="10" '
            'stroke-linecap="round" stroke-linejoin="round" fill="none"/>',
        ])
    raise ValueError(kind)


def brows(kind):
    if kind == 'raised':
        return '\n'.join([
            f'<path d="M405 222 Q434 204 478 214" stroke="{INK}" stroke-width="9" stroke-linecap="round" fill="none"/>',
            f'<path d="M619 222 Q590 204 546 214" stroke="{INK}" stroke-width="9" stroke-linecap="round" fill="none"/>',
        ])
    if kind == 'effort':
        return '\n'.join([
            f'<path d="M408 214 Q440 220 478 234" stroke="{INK}" stroke-width="9" stroke-linecap="round" fill="none"/>',
            f'<path d="M616 214 Q584 220 546 234" stroke="{INK}" stroke-width="9" stroke-linecap="round" fill="none"/>',
        ])
    if kind == 'worried':         # inner ends up: hopeful, a little unsure
        return '\n'.join([
            f'<path d="M405 232 Q438 222 476 212" stroke="{INK}" stroke-width="9" stroke-linecap="round" fill="none"/>',
            f'<path d="M619 232 Q586 222 548 212" stroke="{INK}" stroke-width="9" stroke-linecap="round" fill="none"/>',
        ])
    return '\n'.join([           # relaxed (the idle's)
        f'<path d="M405 230 Q432 218 476 224" stroke="{INK}" stroke-width="9" stroke-linecap="round" fill="none"/>',
        f'<path d="M619 230 Q592 218 548 224" stroke="{INK}" stroke-width="9" stroke-linecap="round" fill="none"/>',
    ])


def mouth(kind):
    if kind == 'grin':            # open laugh
        return '\n'.join([
            f'<path d="M454 366 Q512 360 570 366 Q566 420 512 426 Q458 420 454 366Z" fill="#5A4030"/>',
            '<path d="M476 404 Q512 392 548 404 Q540 420 512 422 Q484 420 476 404Z" fill="#D97A7A"/>',
            '<path d="M462 368 Q512 363 562 368 L558 380 Q512 375 466 380Z" fill="white" opacity="0.9"/>',
            f'<path d="M454 366 Q512 360 570 366" stroke="{MOUTH}" stroke-width="5" stroke-linecap="round" fill="none"/>',
        ])
    if kind == 'o':               # biting / "ooh"
        return '\n'.join([
            ellipse((512, 390), 26, 22, '#5A4030'),
            ellipse((512, 398), 15, 9, '#D97A7A'),
        ])
    if kind == 'teeth':           # gritted
        return '\n'.join([
            '<rect x="462" y="368" width="100" height="34" rx="15" fill="white"/>',
            f'<rect x="462" y="368" width="100" height="34" rx="15" fill="none" stroke="{MOUTH}" stroke-width="5"/>',
            f'<path d="M462 385 H562 M487 368 V402 M512 368 V402 M537 368 V402" stroke="{MOUTH}" stroke-width="3" opacity="0.7"/>',
        ])
    if kind == 'small':           # a little hopeful smile
        return '\n'.join([
            f'<path d="M478 380 Q512 398 546 380" stroke="{MOUTH}" stroke-width="5.5" stroke-linecap="round" fill="none"/>',
        ])
    return '\n'.join([            # smile (the idle's)
        f'<path d="M460 374 Q488 365 512 367 Q536 365 564 374" stroke="{MOUTH}" stroke-width="4.5" stroke-linecap="round" fill="none"/>',
        f'<path d="M462 378 Q488 400 512 403 Q536 400 562 378" stroke="{MOUTH}" stroke-width="5.5" stroke-linecap="round" fill="none"/>',
        f'<path d="M466 380 Q490 398 512 400 Q534 398 558 380 Q512 390 466 380Z" fill="{MOUTH}" opacity="0.3"/>',
    ])


def head(face):
    """The idle's neck and head (head frame: neck base at NECK)."""
    e, b, m = face
    return '\n'.join([
        f'<rect x="458" y="352" width="108" height="82" rx="44" fill="{FUR}"/>',
        ellipse((512, 228), 175, 185, FUR),
        ellipse((512, 112), 92, 55, FUR),
        ellipse((512, 82), 70, 48, '#353548'),
        ellipse((512, 55), 45, 32, FUR_D),
        f'<path d="M478 68 Q512 42 546 68 Q512 55 478 68Z" fill="{FUR_DD}" opacity="0.5"/>',
        f'<path d="M335 222 Q392 170 512 162 Q632 170 689 222 Q638 190 512 182 Q386 190 335 222Z" fill="{FUR_D}"/>',
        ellipse((512, 202), 168, 38, FUR_D, opacity=0.7),
        ellipse((512, 225), 148, 18, FUR_DD, opacity=0.5),
        '<path d="M360 195 Q430 178 512 175 Q594 178 664 195 Q594 188 512 185 Q430 188 360 195Z" fill="#3A3A52" opacity="0.5"/>',
        '<path d="M396 232 Q394 190 512 178 Q630 190 628 232 L636 348 Q642 428 512 442 Q382 428 388 348Z" fill="url(#faceGrad)"/>',
        '<ellipse cx="512" cy="398" rx="96" ry="52" fill="url(#muzzleGrad)"/>',
        ellipse((512, 393), 78, 40, '#C4A882', opacity=0.35),
        ellipse((340, 238), 33, 38, FUR), ellipse((342, 238), 21, 26, '#A8896A'),
        ellipse((684, 238), 33, 38, FUR), ellipse((682, 238), 21, 26, '#A8896A'),
        eyes(e),
        brows(b),
        ellipse((512, 318), 54, 32, '#967756'),
        ellipse((486, 323), 17, 14, '#7A6045'),
        ellipse((538, 323), 17, 14, '#7A6045'),
        '<path d="M503 292 Q512 287 521 292" stroke="#7A6045" stroke-width="5" fill="none" opacity="0.5"/>',
        ellipse((512, 308), 20, 10, '#A88866', opacity=0.3),
        mouth(m),
        f'<path d="M348 168 Q432 126 512 122 Q592 126 676 168" stroke="{ACCENT}" stroke-width="22" stroke-linecap="round" fill="none"/>',
        '<path d="M374 161 Q448 133 512 130 Q576 133 650 161" stroke="white" stroke-width="5" stroke-linecap="round" fill="none" opacity="0.25"/>',
        f'<g transform="translate(340, 176)"><path d="M0,0 Q-12,18 -20,45 Q-16,27 -6,13Z" fill="{ACCENT}"/>'
        f'<path d="M-2,-1 Q-17,13 -28,40 Q-20,22 -10,9Z" fill="{ACCENT}"/></g>',
    ])


# ── Torso (the idle's) ────────────────────────────────────────────────────────

TORSO_C = (512, 620)       # the torso's pivot (torso frame)
SHOULDER = {'l': (298, 466), 'r': (726, 466)}
HIP = {'l': (466, 800), 'r': (558, 800)}


def torso():
    return '\n'.join([
        f'<path d="M282 455 Q262 530 268 640 Q278 748 378 815 Q440 850 512 852 Q584 850 646 815 '
        f'Q746 748 756 640 Q762 530 742 455 Q668 398 512 388 Q356 398 282 455Z" fill="{FUR}"/>',
        f'<path d="M310 472 Q294 545 300 648 Q310 748 398 808 Q456 838 512 840 Q568 838 626 808 '
        f'Q714 748 724 648 Q730 545 714 472 Q646 420 512 410 Q378 420 310 472Z" fill="{FUR_L}"/>',
        ellipse((448, 548), 108, 72, FUR_HL, opacity=0.38),
        ellipse((576, 548), 108, 72, FUR_HL, opacity=0.38),
        '<path d="M512 480 Q512 585 512 665" stroke="#353548" stroke-width="4" opacity="0.5" fill="none"/>',
        ellipse((512, 510), 85, 40, FUR_HL, opacity=0.12),
        ellipse((512, 708), 58, 28, FUR_HL, opacity=0.18),
        ellipse((512, 758), 52, 25, FUR_HL, opacity=0.13),
    ])


def shoulder_cap(c, side, a):
    return '\n'.join([
        ellipse(c, 98, 80, FUR_L, a),
        ellipse(add(c, rot((-6 if side == 'l' else 6, -6), a)), 80, 66, FUR_HL, a, 0.3),
    ])


# ── A pose ────────────────────────────────────────────────────────────────────

UPPER, FORE = 290, 200     # arm bones
THIGH, SHIN = 92, 80       # leg bones (short and stocky)


@dataclass
class Arm:
    hand: tuple            # where the wrist goes
    bend: int = 1          # 1: the elbow out to its own side (for an arm
                           # hanging down), -1: in
    point: tuple | None = None   # where the fist points (default: along the forearm)
    knuckles: bool = True
    thumb: int = 1


@dataclass
class Leg:
    ankle: tuple
    bend: int = 1          # as Arm.bend, for the knee
    point: tuple | None = None   # where the sole faces (default: along the shin)


@dataclass
class Pose:
    name: str
    at: tuple = (512, 620)          # torso pivot in the picture
    tilt: float = 0.0               # torso rotation, degrees clockwise
    head_tilt: float = 0.0          # head rotation relative to the torso
    face: tuple = ('open', 'relaxed', 'smile')
    arms: dict = field(default_factory=dict)    # 'l' / 'r' → Arm
    legs: dict = field(default_factory=dict)    # 'l' / 'r' → Leg
    order: tuple = ('legs', 'torso', 'arm_l', 'arm_r', 'head')
    back: list = field(default_factory=list)    # props behind everything
    front: list = field(default_factory=list)   # props over everything
    extra: dict = field(default_factory=dict)   # 'after_<part>' → svg
    scale: float = 1.0                          # the whole figure, about `anchor`
    anchor: tuple = (512, 980)

    def world(self, p):
        """A torso-frame point in the picture."""
        return add(self.at, rot(sub(p, TORSO_C), self.tilt))


def arm_svg(pose, side):
    arm = pose.arms[side]
    s = pose.world(SHOULDER[side])
    root = add(s, rot((24 if side == 'l' else -24, 30), pose.tilt))
    elbow = ik(root, arm.hand, UPPER, FORE, arm.bend * (1 if side == 'l' else -1))
    d = sub(arm.point, arm.hand) if arm.point else sub(arm.hand, elbow)
    light = 1 if side == 'l' else -1
    return '\n'.join([
        shoulder_cap(s, side, pose.tilt),
        limb(root, elbow, 52, 38, light),
        limb(elbow, arm.hand, 40, 46, light),
        fist(arm.hand, d, arm.thumb * (1 if side == 'r' else -1), arm.knuckles),
    ])


def leg_svg(pose, side):
    leg = pose.legs[side]
    hip = pose.world(HIP[side])
    knee = ik(hip, leg.ankle, THIGH, SHIN, leg.bend * (1 if side == 'l' else -1))
    d = sub(leg.point, leg.ankle) if leg.point else sub(leg.ankle, knee)
    light = 1 if side == 'l' else -1
    return '\n'.join([
        limb(hip, knee, 40, 36, light),
        limb(knee, leg.ankle, 36, 32, light),
        foot(leg.ankle, d),
    ])


def figure(pose):
    parts = {
        'torso': f'<g transform="translate({pt(sub(pose.at, TORSO_C))}) rotate({f(pose.tilt)} {pt(TORSO_C)})">{torso()}</g>',
        'head': (f'<g transform="translate({pt(pose.world(NECK))}) rotate({f(pose.tilt + pose.head_tilt)}) '
                 f'translate({f(-NECK[0])} {f(-NECK[1])})">{head(pose.face)}</g>'),
    }
    for side in ('l', 'r'):
        if side in pose.arms:
            parts[f'arm_{side}'] = arm_svg(pose, side)
        if side in pose.legs:
            parts[f'leg_{side}'] = leg_svg(pose, side)
    parts['legs'] = '\n'.join(parts.get(f'leg_{s}', '') for s in ('l', 'r'))
    out = []
    for name in pose.order:
        out.append(parts.get(name, ''))
        if f'after_{name}' in pose.extra:
            out.append(pose.extra[f'after_{name}'])
    body = '\n'.join(pose.back + out + pose.front)
    if pose.scale != 1.0:
        ax, ay = pose.anchor
        body = (f'<g transform="translate({f(ax)} {f(ay)}) scale({f(pose.scale)}) '
                f'translate({f(-ax)} {f(-ay)})">\n{body}\n</g>')
    return body


DEFS = '''<defs>
  <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
    <stop offset="0%" style="stop-color:#4DA6FF"/><stop offset="100%" style="stop-color:#2B7DE9"/>
  </linearGradient>
  <radialGradient id="glow" cx="50%" cy="45%" r="40%">
    <stop offset="0%" style="stop-color:#A8D8FF;stop-opacity:0.2"/><stop offset="100%" style="stop-color:#4DA6FF;stop-opacity:0"/>
  </radialGradient>
  <linearGradient id="faceGrad" x1="0%" y1="0%" x2="0%" y2="100%">
    <stop offset="0%" style="stop-color:#C4A882"/><stop offset="100%" style="stop-color:#A8896A"/>
  </linearGradient>
  <linearGradient id="muzzleGrad" x1="0%" y1="0%" x2="0%" y2="100%">
    <stop offset="0%" style="stop-color:#B89870"/><stop offset="100%" style="stop-color:#9A7E5A"/>
  </linearGradient>
  <linearGradient id="steel" x1="0%" y1="0%" x2="100%" y2="0%">
    <stop offset="0%" style="stop-color:#9AA6B8"/><stop offset="45%" style="stop-color:#E6ECF5"/><stop offset="100%" style="stop-color:#8592A6"/>
  </linearGradient>
  <linearGradient id="steelH" x1="0%" y1="0%" x2="0%" y2="100%">
    <stop offset="0%" style="stop-color:#9AA6B8"/><stop offset="45%" style="stop-color:#E6ECF5"/><stop offset="100%" style="stop-color:#8592A6"/>
  </linearGradient>
  <linearGradient id="banana" x1="0%" y1="0%" x2="100%" y2="100%">
    <stop offset="0%" style="stop-color:#FFE36E"/><stop offset="100%" style="stop-color:#F5C531"/>
  </linearGradient>
  <linearGradient id="badge" x1="0%" y1="0%" x2="100%" y2="100%">
    <stop offset="0%" style="stop-color:#D9DEE8"/><stop offset="100%" style="stop-color:#9AA3B5"/>
  </linearGradient>
</defs>'''


def svg(title, body, shadow=(512, 990, 200)):
    sx, sy, sr = shadow
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
<!-- {title}. Generated by tools/characters/gen_goro.py; edit the script, not this file. -->
{DEFS}
<rect width="1024" height="1024" rx="224" fill="url(#bgGrad)"/>
<circle cx="512" cy="450" r="380" fill="url(#glow)"/>
<ellipse cx="{sx}" cy="{sy}" rx="{sr}" ry="22" fill="#2B7DE9" opacity="0.35"/>
{body}
</svg>
'''


# ── Props ─────────────────────────────────────────────────────────────────────


def sparkle(x, y, r, color='#FFE27A', opacity=1.0):
    k = r * 0.28
    return (f'<path d="M{f(x)} {f(y - r)} Q{f(x + k)} {f(y - k)} {f(x + r)} {f(y)} Q{f(x + k)} {f(y + k)} '
            f'{f(x)} {f(y + r)} Q{f(x - k)} {f(y + k)} {f(x - r)} {f(y)} Q{f(x - k)} {f(y - k)} {f(x)} {f(y - r)}Z" '
            f'fill="{color}" opacity="{opacity}"/>')


def drop(x, y, s, a=0.0):
    return (f'<path d="M{f(x)} {f(y - 22 * s)} Q{f(x + 14 * s)} {f(y)} {f(x)} {f(y + 10 * s)} '
            f'Q{f(x - 14 * s)} {f(y)} {f(x)} {f(y - 22 * s)}Z" fill="#E6F4FF" opacity="0.9" '
            f'transform="rotate({f(a)} {f(x)} {f(y)})"/>')


def pole(x, top, bottom, w=34):
    return '\n'.join([
        f'<rect x="{f(x - w / 2)}" y="{f(top)}" width="{w}" height="{f(bottom - top)}" rx="{w / 2}" fill="url(#steel)"/>',
        f'<rect x="{f(x - 70)}" y="{f(bottom - 14)}" width="140" height="28" rx="14" fill="#5B6577"/>',
        f'<rect x="{f(x - w / 2 - 6)}" y="{f(top - 10)}" width="{w + 12}" height="24" rx="12" fill="#5B6577"/>',
    ])


def bar(y, x0, x1, h=30):
    return f'<rect x="{f(x0)}" y="{f(y - h / 2)}" width="{f(x1 - x0)}" height="{h}" rx="{h / 2}" fill="url(#steelH)"/>'


def barbell(y, x0, x1, sag=18):
    """A bar bending under two big plates on each end."""
    out = [f'<path d="M{f(x0)} {f(y + sag)} Q512 {f(y - sag)} {f(x1)} {f(y + sag)}" '
           'stroke="#C9D2DE" stroke-width="22" stroke-linecap="round" fill="none"/>']
    for x, s in ((x0 + 46, -1), (x1 - 46, 1)):
        yy = y + sag * 0.75
        out += [
            f'<rect x="{f(x - 30)}" y="{f(yy - 130)}" width="60" height="260" rx="24" fill="#26263A"/>',
            f'<rect x="{f(x - 22 + 34 * s)}" y="{f(yy - 100)}" width="44" height="200" rx="18" fill="#30304A"/>',
            f'<rect x="{f(x - 22)}" y="{f(yy - 126)}" width="12" height="252" rx="6" fill="{ACCENT}" opacity="0.35"/>',
        ]
    return '\n'.join(out)


def banana(grip, toward):
    """A half-peeled banana held at `grip`, its peeled end pointing at
    `toward`; the peel hangs in three strips over the fist."""
    a = ang(sub(toward, grip)) + 90       # local -y → toward
    body = '\n'.join([
        # the unpeeled lower half, under the fist
        '<path d="M-26 -40 Q-30 34 -4 74 L6 74 Q30 30 26 -40Z" fill="url(#banana)"/>',
        '<rect x="-7" y="70" width="14" height="18" rx="5" fill="#7A5A24"/>',
        # the fruit
        '<path d="M-22 -36 Q-44 -150 -14 -236 Q-2 -248 10 -236 Q-6 -150 24 -36Z" fill="#FFF2C2"/>',
        '<path d="M8 -60 Q-8 -150 4 -226" stroke="#F0DFA0" stroke-width="8" stroke-linecap="round" fill="none"/>',
        # the peel strips
        '<path d="M-26 -44 Q-74 -30 -92 32 Q-88 46 -76 40 Q-62 -4 -18 -14Z" fill="url(#banana)"/>',
        '<path d="M26 -44 Q78 -30 96 26 Q92 40 80 34 Q64 -6 18 -14Z" fill="url(#banana)"/>',
        '<path d="M-12 -46 Q-2 -6 -14 40 Q-2 50 8 38 Q14 -2 12 -46Z" fill="#E8B92A"/>',
        '<path d="M-26 -44 Q0 -56 26 -44 L22 -30 Q0 -40 -22 -30Z" fill="#F5C531"/>',
    ])
    return f'<g transform="translate({pt(grip)}) rotate({f(a)})">{body}</g>'


# ── The poses ─────────────────────────────────────────────────────────────────

FLOOR = 962


def placed(local, world, tilt):
    """The torso pivot that puts the torso-frame point `local` at `world`."""
    return sub(world, rot(sub(local, TORSO_C), tilt))


def standing_legs(p, spread=6, bend=1):
    hl, hr = p.world(HIP['l']), p.world(HIP['r'])
    return {
        'l': Leg(ankle=(hl[0] - spread, FLOOR), bend=bend, point=(hl[0] - spread, FLOOR + 50)),
        'r': Leg(ankle=(hr[0] + spread, FLOOR), bend=bend, point=(hr[0] + spread, FLOOR + 50)),
    }


def one_arm_handstand():
    """Upside down on one fist, the other arm out for balance, legs in a V."""
    tilt = 190
    hand = (668, FLOOR - 34)
    shoulder = (hand[0] - 16, hand[1] - 474)
    p = Pose('one_arm_handstand', at=placed(SHOULDER['l'], shoulder, tilt), tilt=tilt,
             head_tilt=-14, face=('wink', 'raised', 'grin'), scale=0.8, anchor=(512, 985))
    free = p.world(SHOULDER['r'])
    p.arms = {
        'l': Arm(hand=hand, bend=1, point=(hand[0], FLOOR + 40)),
        'r': Arm(hand=add(free, (-250, -110)), bend=-1, point=add(free, (-330, -190))),
    }
    hl, hr = p.world(HIP['l']), p.world(HIP['r'])
    p.legs = {
        'l': Leg(ankle=add(hl, (150, -110)), bend=1, point=add(hl, (210, -170))),
        'r': Leg(ankle=add(hr, (-150, -120)), bend=-1, point=add(hr, (-210, -180))),
    }
    p.order = ('legs', 'torso', 'arm_r', 'arm_l', 'head')
    p.front = [sparkle(880, 330, 26), sparkle(840, 250, 14, opacity=0.8), sparkle(150, 200, 18, opacity=0.8)]
    return p


def flag():
    """The human flag: body level beside a pole, held by both arms."""
    x_pole = 128
    p = Pose('flag', at=(690, 470), tilt=-90, head_tilt=62,
             face=('open', 'raised', 'grin'), scale=0.8, anchor=(512, 975))
    top, low = p.world(SHOULDER['r']), p.world(SHOULDER['l'])
    p.arms = {
        'r': Arm(hand=(x_pole + 54, top[1] - 120), bend=-1, point=(x_pole - 20, top[1] - 124), thumb=-1),
        'l': Arm(hand=(x_pole + 54, low[1] + 150), bend=1, point=(x_pole - 20, low[1] + 160)),
    }
    hl, hr = p.world(HIP['l']), p.world(HIP['r'])
    p.legs = {
        'l': Leg(ankle=add(hl, (166, 20)), bend=1, point=add(hl, (300, 24))),
        'r': Leg(ankle=add(hr, (166, -20)), bend=1, point=add(hr, (300, -24))),
    }
    p.back = [pole(x_pole, 30, 975)]
    p.order = ('legs', 'torso', 'arm_l', 'arm_r', 'head')
    p.front = [sparkle(900, 200, 24), sparkle(860, 140, 12, opacity=0.8)]
    return p


def one_arm_pullup():
    """Hanging from a bar by one fist, the other hand waving."""
    p = Pose('one_arm_pullup', at=(500, 610), tilt=5, head_tilt=-8,
             face=('happy', 'raised', 'grin'), scale=0.86, anchor=(512, 985))
    s = p.world(SHOULDER['r'])
    w = p.world(SHOULDER['l'])
    p.arms = {
        'r': Arm(hand=(s[0] - 50, 132), bend=-1, point=(s[0] - 50, 60)),
        'l': Arm(hand=add(w, (-200, -80)), bend=1, point=add(w, (-212, -180)), thumb=-1),
    }
    hl, hr = p.world(HIP['l']), p.world(HIP['r'])
    p.legs = {
        'l': Leg(ankle=add(hl, (-14, 160)), bend=1),
        'r': Leg(ankle=add(hr, (30, 140)), bend=1),
    }
    p.back = [bar(120, 40, 984)]
    p.order = ('legs', 'torso', 'arm_l', 'head', 'arm_r')
    hx, hy = p.arms['l'].hand
    p.front = [  # waving: two arcs beside the fist
        f'<path d="M{f(hx - 10)} {f(hy - 160)} q-34 -14 -54 18 M{f(hx - 18)} {f(hy - 204)} q-58 -24 -90 30" '
        'stroke="white" stroke-width="9" stroke-linecap="round" fill="none" opacity="0.6"/>',
    ]
    return p


def barbell_press():
    """A loaded barbell overhead, the bar bending."""
    p = Pose('barbell', at=(512, 650), face=('squeeze', 'effort', 'teeth'),
             scale=0.84, anchor=(512, 985))
    sl, sr = p.world(SHOULDER['l']), p.world(SHOULDER['r'])
    y_bar = 126
    p.arms = {
        'l': Arm(hand=(sl[0] - 50, y_bar + 22), bend=-1, point=(sl[0] - 50, y_bar - 40)),
        'r': Arm(hand=(sr[0] + 50, y_bar + 22), bend=-1, point=(sr[0] + 50, y_bar - 40)),
    }
    p.legs = standing_legs(p, spread=50)
    p.order = ('legs', 'torso', 'head', 'arm_l', 'arm_r')
    p.front = [barbell(y_bar, 40, 984, sag=26),
               fist(p.arms['l'].hand, (0, -1), -1),
               fist(p.arms['r'].hand, (0, -1), 1),
               drop(318, 300, 1.1, -20), drop(708, 290, 1.0, 20)]
    return p


def lotus():
    """Floating in lotus, eyes shut, fists on the knees."""
    p = Pose('lotus', at=(512, 560), face=('closed', 'relaxed', 'small'),
             scale=0.9, anchor=(512, 950))
    hl, hr = p.world(HIP['l']), p.world(HIP['r'])
    kl, kr = (290, 820), (734, 820)
    p.arms = {
        'l': Arm(hand=(kl[0] + 30, kl[1] - 56), bend=1, point=(kl[0] + 36, kl[1] + 20)),
        'r': Arm(hand=(kr[0] - 30, kr[1] - 56), bend=1, point=(kr[0] - 36, kr[1] + 20)),
    }
    thighs = '\n'.join([limb(hl, kl, 48, 44, 1), limb(hr, kr, 48, 44, -1)])
    shins = '\n'.join([
        limb(kr, (430, 872), 42, 36, -1), foot((430, 872), (-1, 0.1)),
        limb(kl, (594, 880), 42, 36, 1), foot((594, 880), (1, 0.1)),
    ])
    p.order = ('thighs', 'torso', 'shins', 'arm_l', 'arm_r', 'head')
    p.extra = {'after_thighs': thighs, 'after_shins': shins}
    p.back = [
        f'<rect x="232" y="944" width="560" height="26" rx="13" fill="{ACCENT}" opacity="0.9"/>',
        '<rect x="262" y="948" width="500" height="6" rx="3" fill="white" opacity="0.5"/>',
    ]
    p.front = [sparkle(190, 300, 18, '#FFFFFF', 0.75), sparkle(840, 250, 22, '#FFFFFF', 0.75),
               sparkle(870, 560, 13, '#FFFFFF', 0.55), sparkle(150, 600, 13, '#FFFFFF', 0.55)]
    return p


def banana_break():
    """A rest day: a peeled banana, the other fist on the floor."""
    p = Pose('banana', at=(512, 620), head_tilt=-5, face=('happy', 'raised', 'o'))
    sl = p.world(SHOULDER['l'])
    hand, toward = (690, 600), (548, 404)
    p.arms = {
        'l': Arm(hand=(sl[0] - 40, FLOOR - 30), bend=1, point=(sl[0] - 44, FLOOR + 20)),
        'r': Arm(hand=hand, bend=1, point=toward, thumb=-1),
    }
    p.legs = standing_legs(p)
    grip = add(hand, mul(unit(sub(toward, hand)), 24))
    p.order = ('legs', 'torso', 'arm_l', 'head', 'arm_r', 'banana')
    p.extra = {'after_banana': '\n'.join([
        banana(grip, toward),
        ellipse(grip, 44, 34, FUR, ang(sub(toward, hand)) - 90),
        ellipse(add(grip, mul(unit(sub(toward, hand)), -4)), 36, 27, FUR_L, ang(sub(toward, hand)) - 90),
    ])}
    p.front = [sparkle(860, 240, 22), sparkle(810, 170, 12, opacity=0.8)]
    return p


def locked():
    """Holding an achievement he has not earned yet: a grey medal with a
    padlock, a hopeful look."""
    p = Pose('locked', face=('open', 'worried', 'small'), head_tilt=-4)
    c = (512, 690)
    p.arms = {
        'l': Arm(hand=(384, 738), bend=1, point=(430, 690), thumb=-1),
        'r': Arm(hand=(640, 738), bend=1, point=(594, 690), thumb=-1),
    }
    p.legs = standing_legs(p)
    p.order = ('legs', 'torso', 'arm_l', 'arm_r', 'head', 'badge')
    p.extra = {'after_badge': '\n'.join([
        locked_badge(*c),
        fist(p.arms['l'].hand, (0.7, -0.7), 1),
        fist(p.arms['r'].hand, (-0.7, -0.7), -1),
    ])}
    return p



POSES = {
    'one_arm_handstand': one_arm_handstand,
    'flag': flag,
    'one_arm_pullup': one_arm_pullup,
    'barbell': barbell_press,
    'lotus': lotus,
    'banana': banana_break,
}


def all_art():
    out = {}
    for name, fn in POSES.items():
        p = fn()
        out[f'goro_pose_{name}.svg'] = svg(f'Goro — {name.replace("_", " ")}', figure(p))
    out['goro_locked.svg'] = svg('Goro — an achievement still ahead', figure(locked()))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', type=pathlib.Path, default=OUT)
    ap.add_argument('names', nargs='*')
    args = ap.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    for fname, text in all_art().items():
        if args.names and not any(n in fname for n in args.names):
            continue
        (args.out / fname).write_text(text)
        print(args.out / fname)


if __name__ == '__main__':
    main()
