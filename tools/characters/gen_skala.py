"""Skala, the challenge host: a bull, not a recoloured Goro (redrawn 2026-10-08).

    python3 tools/characters/gen_skala.py [OUT_DIR]

Writes skala_neutral.svg (arms crossed, judging) and skala_approve.svg
(thumb up) into OUT_DIR (default: assets/skala). What makes him a bull:
ivory horns out of the sides of a broad flat head, a curly forelock, ears
sticking out sideways, small stern eyes, a wide light muzzle with a gold
nose ring, the head sunk between massive shoulders, hoof caps on the fists.
"""
import math
import sys
from pathlib import Path

# ── palette ────────────────────────────────────────────────────────────────
BODY_D = '#2A1F17'   # deep brown-black
BODY_M = '#3B2C21'
BODY_L = '#52402F'
ARM = '#5C4836'      # forearms and fists: lighter, so the pose reads
ARM_L = '#7A6250'
FACE = '#46362A'
MUZ_T = '#C9A07A'    # muzzle, light tan
MUZ_B = '#A97D5A'
NOSTRIL = '#4A2E20'
HORN_T = '#F2E6C8'   # ivory
HORN_B = '#CDB78C'
HORN_TIP = '#3A2E24'
EAR_IN = '#9C6B53'
HOOF = '#17110C'
CURL = '#1C1510'
GOLD = '#D4A73C'
GOLD_L = '#F4D676'
BROW = '#120D09'


def bezier(p0, p1, p2, p3, t):
    u = 1 - t
    return tuple(u**3 * a + 3 * u * u * t * b + 3 * u * t * t * c + t**3 * d
                 for a, b, c, d in zip(p0, p1, p2, p3))


def horn_polygon(p0, p1, p2, p3, w0, w1, t0=0.0, t1=1.0, n=40):
    """A tapered band along a cubic Bezier centre-line, from t0 to t1."""
    left, right = [], []
    for i in range(n + 1):
        t = t0 + (t1 - t0) * i / n
        x, y = bezier(p0, p1, p2, p3, t)
        x2, y2 = bezier(p0, p1, p2, p3, min(1, t + 0.01))
        x1, y1 = bezier(p0, p1, p2, p3, max(0, t - 0.01))
        dx, dy = x2 - x1, y2 - y1
        ln = math.hypot(dx, dy) or 1
        nx, ny = -dy / ln, dx / ln
        w = (w0 + (w1 - w0) * t ** 0.9) / 2
        left.append((x + nx * w, y + ny * w))
        right.append((x - nx * w, y - ny * w))
    pts = left + right[::-1]
    return 'M' + ' L'.join(f'{x:.1f} {y:.1f}' for x, y in pts) + ' Z'


def mirror_pts(pts):
    return [(1024 - x, y) for x, y in pts]


# Left horn centre-line: out of the top of the head, sideways, then up.
HORN_L = [(408, 205), (300, 228), (196, 214), (150, 92)]
HORN_R = mirror_pts(HORN_L)


def horns():
    out = []
    for pts in (HORN_L, HORN_R):
        out.append(f'<path d="{horn_polygon(*pts, 64, 6)}" fill="url(#hornGrad)"/>')
        # a lighter ridge along the top edge
        out.append(f'<path d="{horn_polygon(*pts, 22, 3, 0.15, 0.9)}" '
                   f'fill="#FFF8E6" opacity="0.35" transform="translate(0,-10)"/>')
        out.append(f'<path d="{horn_polygon(*pts, 64, 6, 0.80, 1.0)}" fill="{HORN_TIP}"/>')
    return '\n  '.join(out)


def ears(droop=0):
    # Wide, flat ears sticking out sideways under the horns.
    return f'''
  <g transform="rotate({-18 - droop} 330 282)">
    <ellipse cx="318" cy="282" rx="74" ry="30" fill="{BODY_M}"/>
    <ellipse cx="312" cy="284" rx="50" ry="16" fill="{EAR_IN}"/>
  </g>
  <g transform="rotate({18 + droop} 694 282)">
    <ellipse cx="706" cy="282" rx="74" ry="30" fill="{BODY_M}"/>
    <ellipse cx="712" cy="284" rx="50" ry="16" fill="{EAR_IN}"/>
  </g>'''


def head():
    return f'''
  <!-- head: broad flat forehead, long face -->
  <path d="M372 230 C368 176 436 158 512 158 C588 158 656 176 652 230
           C656 300 640 360 616 412 L408 412 C384 360 368 300 372 230 Z" fill="{BODY_D}"/>
  <path d="M396 236 C394 194 446 182 512 182 C578 182 630 194 628 236
           C630 296 616 350 596 400 L428 400 C408 350 394 296 396 236 Z" fill="{FACE}"/>
  <!-- forelock between the horns -->
  <g fill="{CURL}">
    <circle cx="458" cy="178" r="26"/><circle cx="491" cy="166" r="28"/>
    <circle cx="526" cy="166" r="28"/><circle cx="560" cy="178" r="26"/>
    <circle cx="474" cy="202" r="22"/><circle cx="510" cy="198" r="24"/>
    <circle cx="546" cy="202" r="22"/>
  </g>
  <g fill="none" stroke="{BODY_L}" stroke-width="5" stroke-linecap="round" opacity="0.8">
    <path d="M478 160 q12 -10 22 2"/><path d="M514 158 q12 -10 22 2"/>
    <path d="M448 178 q10 -9 20 1"/><path d="M548 178 q10 -9 20 1"/>
    <path d="M498 194 q11 -9 21 2"/>
  </g>'''


def muzzle(mouth):
    return f'''
  <!-- muzzle: wide and light, the bull's signature -->
  <path d="M404 404 C404 384 444 374 512 374 C580 374 620 384 620 404
           C648 444 656 502 630 534 C602 562 422 562 394 534 C368 502 376 444 404 404 Z"
        fill="url(#muzzleGrad)"/>
  <ellipse cx="512" cy="410" rx="92" ry="18" fill="#E2BE98" opacity="0.45"/>
  <g transform="rotate(-18 466 470)"><ellipse cx="466" cy="470" rx="26" ry="17" fill="{NOSTRIL}"/></g>
  <g transform="rotate(18 558 470)"><ellipse cx="558" cy="470" rx="26" ry="17" fill="{NOSTRIL}"/></g>
  {mouth}
  <!-- nose ring -->
  <ellipse cx="512" cy="512" rx="36" ry="30" fill="none" stroke="{GOLD}" stroke-width="10"/>
  <path d="M480 520 A36 30 0 0 0 544 520" fill="none" stroke="{GOLD_L}" stroke-width="4" opacity="0.7"/>'''


def eyes(stern):
    if stern:
        lids = f'''
  <path d="M418 296 Q452 276 488 296 L488 284 L418 284 Z" fill="{FACE}"/>
  <path d="M536 296 Q572 276 606 296 L606 284 L536 284 Z" fill="{FACE}"/>'''
        brows = f'''
  <path d="M410 268 L486 290" stroke="{BROW}" stroke-width="20" stroke-linecap="round"/>
  <path d="M614 268 L538 290" stroke="{BROW}" stroke-width="20" stroke-linecap="round"/>'''
        pupils = (458, 312, 566, 312)
    else:
        lids = ''
        brows = f'''
  <path d="M412 262 Q450 246 488 262" stroke="{BROW}" stroke-width="18" stroke-linecap="round" fill="none"/>
  <path d="M536 262 Q574 246 612 262" stroke="{BROW}" stroke-width="18" stroke-linecap="round" fill="none"/>'''
        pupils = (456, 306, 568, 306)
    lx, ly, rx_, ry = pupils
    return f'''
  <!-- eyes: small, set wide, under heavy brows -->
  <ellipse cx="452" cy="306" rx="34" ry="27" fill="white"/>
  <ellipse cx="572" cy="306" rx="34" ry="27" fill="white"/>
  <circle cx="{lx}" cy="{ly}" r="17" fill="#120D08"/>
  <circle cx="{rx_}" cy="{ry}" r="17" fill="#120D08"/>
  <circle cx="{lx + 6}" cy="{ly - 7}" r="6" fill="white"/>
  <circle cx="{rx_ + 6}" cy="{ry - 7}" r="6" fill="white"/>{lids}{brows}'''


def body():
    return f'''
  <!-- torso: hump and shoulders rise beside the head -->
  <path d="M168 480 C160 400 226 338 330 326 C420 316 604 316 694 326
           C798 338 864 400 856 480 C866 610 826 768 704 846
           C622 888 402 888 320 846 C198 768 158 610 168 480 Z" fill="{BODY_D}"/>
  <path d="M206 488 C204 418 258 366 344 356 C430 348 594 348 680 356
           C766 366 820 418 818 488 C826 606 790 750 684 818
           C610 856 414 856 340 818 C234 750 198 606 206 488 Z" fill="url(#bodyGrad)"/>
  <ellipse cx="300" cy="372" rx="96" ry="44" fill="{BODY_L}" opacity="0.45"/>
  <ellipse cx="724" cy="372" rx="96" ry="44" fill="{BODY_L}" opacity="0.45"/>
  <!-- chest and belly -->
  <ellipse cx="512" cy="620" rx="200" ry="130" fill="{BODY_L}" opacity="0.28"/>
  <path d="M512 560 L512 760" stroke="{BODY_D}" stroke-width="6" opacity="0.5"/>'''


def legs():
    out = []
    for x in (428, 596):
        out.append(f'''
  <path d="M{x-58} 816 C{x-62} 870 {x-58} 920 {x-50} 948 L{x+50} 948 C{x+58} 920 {x+62} 870 {x+58} 816 Z" fill="{BODY_D}"/>
  <path d="M{x-34} 830 C{x-38} 876 {x-34} 914 {x-28} 940 L{x+4} 940 C{x+2} 900 {x} 862 {x-2} 830 Z" fill="{BODY_M}" opacity="0.6"/>
  <!-- split hoof -->
  <path d="M{x-58} 944 L{x-4} 944 L{x-6} 984 L{x-62} 984 Q{x-70} 962 {x-58} 944 Z" fill="{HOOF}"/>
  <path d="M{x+4} 944 L{x+58} 944 Q{x+70} 962 {x+62} 984 L{x+6} 984 Z" fill="{HOOF}"/>''')
    return ''.join(out)


def shoulder(cx, cy):
    return f'''
  <ellipse cx="{cx}" cy="{cy}" rx="104" ry="94" fill="{BODY_D}"/>
  <ellipse cx="{cx - 18 if cx < 512 else cx + 18}" cy="{cy - 28}" rx="58" ry="40" fill="{BODY_L}" opacity="0.45"/>'''


def fist(cx, cy, r, side):
    """A fist whose knuckles end in a dark hoof cap; side = -1 cap on the left, 1 on the right."""
    k = cx + side * r * 0.55
    return f'''
  <ellipse cx="{cx}" cy="{cy}" rx="{r}" ry="{r * 0.92:.0f}" fill="{ARM}"/>
  <ellipse cx="{cx - side * r * 0.2:.0f}" cy="{cy - r * 0.3:.0f}" rx="{r * 0.5:.0f}" ry="{r * 0.3:.0f}" fill="{ARM_L}" opacity="0.7"/>
  <path d="M{k:.0f} {cy - r * 0.78:.0f} Q{cx + side * r * 1.12:.0f} {cy} {k:.0f} {cy + r * 0.78:.0f}
           Q{cx + side * r * 0.72:.0f} {cy} {k:.0f} {cy - r * 0.78:.0f} Z" fill="{HOOF}"/>
  <path d="M{cx + side * r * 0.86:.0f} {cy} L{cx + side * r * 1.08:.0f} {cy}" stroke="{BODY_M}" stroke-width="5"/>'''


def limb(x1, y1, x2, y2, w, color):
    return (f'<path d="M{x1} {y1} L{x2} {y2}" stroke="{color}" stroke-width="{w}" '
            f'stroke-linecap="round"/>')


def arms_crossed():
    return f'''
  <!-- arms crossed: authority. Forearms first, then the upper arms over the tucked fists -->
  {limb(800, 742, 330, 736, 84, BODY_L)}
  {fist(318, 736, 46, -1)}
  {limb(226, 690, 702, 678, 90, ARM)}
  <path d="M250 660 L700 650" stroke="{ARM_L}" stroke-width="18" stroke-linecap="round" opacity="0.7"/>
  {fist(712, 678, 50, 1)}
  {shoulder(214, 486)}
  {shoulder(810, 486)}
  <path d="M128 500 C112 590 128 690 168 744 C200 780 262 776 286 736 C306 680 306 570 290 496 Z" fill="{BODY_D}"/>
  <path d="M896 500 C912 590 896 690 856 744 C824 780 762 776 738 736 C718 680 718 570 734 496 Z" fill="{BODY_D}"/>
  <path d="M160 540 C150 610 160 690 190 730" stroke="{BODY_M}" stroke-width="22" stroke-linecap="round" fill="none" opacity="0.8"/>
  <path d="M864 540 C874 610 864 690 834 730" stroke="{BODY_M}" stroke-width="22" stroke-linecap="round" fill="none" opacity="0.8"/>'''


def arms_approve():
    return f'''
  <!-- left arm hangs, hoof-fist at the hip -->
  {shoulder(214, 486)}
  {limb(196, 520, 170, 700, 104, BODY_D)}
  {limb(170, 700, 184, 800, 90, BODY_D)}
  <path d="M150 560 C140 640 150 720 164 780" stroke="{BODY_M}" stroke-width="22" stroke-linecap="round" fill="none" opacity="0.8"/>
  <ellipse cx="186" cy="826" rx="50" ry="42" fill="{ARM}"/>
  <path d="M140 840 L182 840 L180 878 L136 878 Q130 858 140 840 Z" fill="{HOOF}"/>
  <path d="M190 840 L232 840 Q242 858 236 878 L192 878 Z" fill="{HOOF}"/>
  <!-- right arm raised, thumb up -->
  {limb(830, 500, 904, 610, 100, BODY_D)}
  {limb(904, 610, 884, 480, 86, BODY_M)}
  <path d="M928 600 C934 560 924 520 904 486" stroke="{BODY_M}" stroke-width="20" stroke-linecap="round" fill="none" opacity="0.8"/>
  {shoulder(810, 486)}
  <!-- thumbs-up fist: thumb on the outer side, the curled fingers in front -->
  <g transform="translate(872, 452) scale(1.15)">
    <rect x="-56" y="-50" width="112" height="104" rx="44" fill="{ARM}"/>
    <rect x="-12" y="-46" width="70" height="25" rx="12.5" fill="{ARM_L}"/>
    <rect x="-12" y="-20" width="72" height="25" rx="12.5" fill="{ARM_L}"/>
    <rect x="-12" y="6" width="70" height="25" rx="12.5" fill="{ARM_L}"/>
    <rect x="-10" y="32" width="62" height="22" rx="11" fill="{ARM_L}"/>
    <g stroke="{BODY_M}" stroke-width="4" stroke-linecap="round">
      <path d="M-4 -21 L52 -21"/><path d="M-4 5 L54 5"/><path d="M-4 31 L52 31"/>
    </g>
    <g transform="rotate(-10 -34 -40)">
      <rect x="-58" y="-142" width="46" height="112" rx="23" fill="url(#thumbGrad)"/>
      <path d="M-54 -122 Q-35 -150 -16 -122 Q-35 -130 -54 -122 Z" fill="{HORN_TIP}"/>
      <path d="M-52 -56 Q-35 -46 -18 -56" stroke="{BODY_M}" stroke-width="4" fill="none" opacity="0.6"/>
    </g>
  </g>
  <!-- sparkles -->
  <g transform="translate(800, 300)"><path d="M0,-22 L5.5,-5.5 L22,0 L5.5,5.5 L0,22 L-5.5,5.5 L-22,0 L-5.5,-5.5 Z" fill="#E8C040"/><circle r="5.5" fill="white" opacity="0.92"/></g>
  <g transform="translate(950, 330)"><path d="M0,-15 L3.8,-3.8 L15,0 L3.8,3.8 L0,15 L-3.8,3.8 L-15,0 L-3.8,-3.8 Z" fill="#F0D060"/><circle r="3.8" fill="white" opacity="0.9"/></g>
  <g transform="translate(930, 250)"><path d="M0,-11 L2.8,-2.8 L11,0 L2.8,2.8 L0,11 L-2.8,2.8 L-11,0 L-2.8,-2.8 Z" fill="#C8A030"/><circle r="2.8" fill="white" opacity="0.85"/></g>
  <circle cx="842" cy="262" r="5" fill="#E8D070" opacity="0.75"/>
  <circle cx="972" cy="392" r="3.5" fill="#F0D060" opacity="0.65"/>'''


def defs(approve):
    glow_op = 0.65 if approve else 0.4
    extra = '''
    <radialGradient id="approveGlow" cx="84%" cy="38%" r="22%">
      <stop offset="0%" style="stop-color:#C8A040;stop-opacity:0.3"/>
      <stop offset="100%" style="stop-color:#C8A040;stop-opacity:0"/>
    </radialGradient>''' if approve else ''
    return f'''<defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#5C1A1A"/>
      <stop offset="100%" style="stop-color:#3A0C0C"/>
    </linearGradient>
    <radialGradient id="glow" cx="50%" cy="42%" r="44%">
      <stop offset="0%" style="stop-color:#8A2222;stop-opacity:{glow_op}"/>
      <stop offset="100%" style="stop-color:#3A0C0C;stop-opacity:0"/>
    </radialGradient>{extra}
    <linearGradient id="bodyGrad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:{BODY_L}"/>
      <stop offset="100%" style="stop-color:{BODY_D}"/>
    </linearGradient>
    <linearGradient id="muzzleGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:{MUZ_T}"/>
      <stop offset="100%" style="stop-color:{MUZ_B}"/>
    </linearGradient>
    <linearGradient id="hornGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:{HORN_T}"/>
      <stop offset="100%" style="stop-color:{HORN_B}"/>
    </linearGradient>
    <linearGradient id="thumbGrad" x1="0%" y1="100%" x2="0%" y2="0%">
      <stop offset="0%" style="stop-color:#6E5844"/>
      <stop offset="100%" style="stop-color:#947A62"/>
    </linearGradient>
  </defs>'''


HEADER = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
  <!--
    SKALA — {pose}. The challenge host: a bull. Strict but fair.
    Generated by tools/characters/gen_skala.py: edit the script, not this file.
    Palette: body {d} / {m} / {l}, muzzle {mt} -> {mb}, horns {ht} -> {hb} with {tip} tips,
    nose ring {gold}, background #5C1A1A -> #3A0C0C.
  -->
  '''


def svg(approve):
    pose = 'Approving (thumb up)' if approve else 'Neutral (arms crossed, evaluating)'
    bg = ('<rect width="1024" height="1024" rx="224" fill="url(#bgGrad)"/>\n'
          '  <circle cx="512" cy="440" r="420" fill="url(#glow)"/>')
    if approve:
        bg += '\n  <circle cx="512" cy="512" r="512" fill="url(#approveGlow)"/>'
    mouth = ('<path d="M450 540 Q512 556 574 540" stroke="#7A5038" stroke-width="7" '
             'stroke-linecap="round" fill="none"/>') if approve else (
             '<path d="M456 544 L568 544" stroke="#7A5038" stroke-width="7" stroke-linecap="round"/>')
    parts = [
        HEADER.format(pose=pose, d=BODY_D, m=BODY_M, l=BODY_L, mt=MUZ_T, mb=MUZ_B,
                      ht=HORN_T, hb=HORN_B, tip=HORN_TIP, gold=GOLD),
        defs(approve),
        bg,
        '<ellipse cx="512" cy="990" rx="240" ry="20" fill="#180404" opacity="0.55"/>',
        legs(),
        body(),
        arms_approve() if approve else arms_crossed(),
        '<g transform="translate(512 360) scale(1.1) translate(-512 -360)">',
        ears(),
        horns(),
        head(),
        eyes(stern=not approve),
        muzzle(mouth),
        '</g>',
        '</svg>\n',
    ]
    return '\n  '.join(parts)


if __name__ == '__main__':
    out = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).resolve().parents[2] / 'assets' / 'skala')
    (out / 'skala_neutral.svg').write_text(svg(False))
    (out / 'skala_approve.svg').write_text(svg(True))
