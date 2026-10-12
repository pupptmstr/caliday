#!/usr/bin/env python3
"""Synthesises every workout cue of CaliDay in code (no samples, no licences).

Usage: python3 tools/sounds/gen_sounds.py [--out DIR] [name ...]

Writes 16-bit mono WAV files (22.05 kHz: a phone speaker plays nothing
higher, and the files stay small) to assets/sounds/ (or DIR): one file
per cue in CUES, all from one family of timbres — wooden ticks, a marimba, a
glockenspiel ping, a felt pad, a soft drum and a breath of noise — tuned to
C major so cues that follow each other never clash. Each cue is normalised to
the loudness of its role (ticks quiet, the end of a workout the loudest) and
peaks at -1 dBFS at most. Only the standard library is used, like
tools/lottie. Listen to them with tools/sounds/build_preview.py.
"""

import argparse
import math
import os
import random
import struct
import wave

ROOT = os.path.join(os.path.dirname(__file__), '..', '..')
OUT = os.path.join(ROOT, 'assets', 'sounds')
SR = 22050


# ── Notes ──────────────────────────────────────────────────────────────────

def note(name):
    """'C5' / 'F#4' → Hz (A4 = 440)."""
    steps = {'C': -9, 'D': -7, 'E': -5, 'F': -4, 'G': -2, 'A': 0, 'B': 2}
    letter, rest = name[0], name[1:]
    shift = 0
    if rest.startswith('#'):
        shift, rest = 1, rest[1:]
    elif rest.startswith('b'):
        shift, rest = -1, rest[1:]
    octave = int(rest)
    return 440.0 * 2 ** ((steps[letter] + shift + 12 * (octave - 4)) / 12)


# ── Buffers ────────────────────────────────────────────────────────────────

def blank(sec):
    return [0.0] * int(SR * sec)


def mix(dst, src, at=0.0, gain=1.0):
    """Adds [src] into [dst] starting at [at] seconds, growing [dst]."""
    start = int(SR * at)
    end = start + len(src)
    if end > len(dst):
        dst.extend([0.0] * (end - len(dst)))
    for i, v in enumerate(src):
        dst[start + i] += v * gain
    return dst


def partials(freq, dur, spec, attack=0.002):
    """A sum of decaying sines: spec = [(ratio, amplitude, decay τ in s)]."""
    n = int(SR * dur)
    out = [0.0] * n
    for ratio, amp, tau in spec:
        f = freq * ratio
        if f >= SR * 0.45:
            continue
        w = 2 * math.pi * f / SR
        k = math.exp(-1 / (tau * SR))
        a = amp
        for i in range(n):
            out[i] += a * math.sin(w * i)
            a *= k
    ramp = max(1, int(SR * attack))
    for i in range(min(ramp, n)):
        out[i] *= i / ramp
    return fade_tail(out)


def fade_tail(buf, sec=0.012):
    m = min(len(buf), int(SR * sec))
    for i in range(m):
        buf[len(buf) - m + i] *= 1 - (i + 1) / m
    return buf


def noise(dur, seed, tau=None, lowpass=None, highpass=None):
    """White noise with an optional exponential decay and one-pole filters."""
    rnd = random.Random(seed)
    n = int(SR * dur)
    out = [rnd.uniform(-1, 1) for _ in range(n)]
    if lowpass:
        a = math.exp(-2 * math.pi * lowpass / SR)
        y = 0.0
        for i in range(n):
            y = (1 - a) * out[i] + a * y
            out[i] = y
    if highpass:
        a = math.exp(-2 * math.pi * highpass / SR)
        y = prev = 0.0
        for i in range(n):
            y = a * (y + out[i] - prev)
            prev = out[i]
            out[i] = y
    if tau:
        k = math.exp(-1 / (tau * SR))
        g = 1.0
        for i in range(n):
            out[i] *= g
            g *= k
    return out


# ── Voices ─────────────────────────────────────────────────────────────────

def marimba(name, dur=0.55, vel=1.0, bright=1.0):
    """A wooden bar: the fundamental, the bar's 4th and 10th partials, a
    mallet's knock at the start."""
    f = note(name)
    out = partials(f, dur, [
        (1.0, 1.0, dur * 0.42),
        (3.93, 0.30 * bright, dur * 0.10),
        (9.24, 0.07 * bright, dur * 0.035),
    ])
    knock = noise(0.006, seed=int(f), tau=0.0015, lowpass=5000)
    mix(out, knock, 0, 0.25 * bright)
    return [v * vel for v in out]


def wood(freq, dur=0.07, vel=1.0):
    """A wood block: a short knock with a pitch, for the countdown ticks."""
    out = partials(freq, dur, [
        (1.0, 1.0, 0.016),
        (2.57, 0.45, 0.007),
        (4.10, 0.15, 0.004),
    ], attack=0.0006)
    mix(out, noise(0.004, seed=int(freq), tau=0.001, highpass=1500), 0, 0.35)
    return [v * vel for v in out]


def glock(name, dur=0.7, vel=1.0):
    """A glockenspiel ping: bright, rings longer than the marimba."""
    out = partials(note(name), dur, [
        (1.0, 1.0, dur * 0.40),
        (2.76, 0.32, dur * 0.14),
        (5.40, 0.12, dur * 0.06),
        (8.93, 0.05, dur * 0.03),
    ], attack=0.001)
    return [v * vel for v in out]


def felt(name, dur=0.3, vel=1.0):
    """A felt-hammer note: round and soft, for the user's own taps."""
    out = partials(note(name), dur, [
        (1.0, 1.0, dur * 0.35),
        (2.0, 0.18, dur * 0.18),
        (3.0, 0.05, dur * 0.10),
    ], attack=0.012)
    return [v * vel for v in out]


def drum(f0=150, f1=62, dur=0.5, vel=1.0, seed=7):
    """A soft floor tom: the pitch drops as it rings — Skala's drum."""
    n = int(SR * dur)
    out = [0.0] * n
    phase = 0.0
    for i in range(n):
        t = i / SR
        f = f1 + (f0 - f1) * math.exp(-t / 0.045)
        phase += 2 * math.pi * f / SR
        out[i] = math.sin(phase) * math.exp(-t / 0.20)
    mix(out, noise(0.03, seed=seed, tau=0.008, lowpass=1800), 0, 0.35)
    return fade_tail([v * vel for v in out])


def breath(dur=0.28, lo=500, hi=3200, rising=True, seed=3):
    """A breath of air: noise through a band-pass that sweeps."""
    rnd = random.Random(seed)
    n = int(SR * dur)
    out = [0.0] * n
    low = band = 0.0
    q = 0.35
    for i in range(n):
        x = i / n
        fc = lo + (hi - lo) * (x if rising else 1 - x)
        f = 2 * math.sin(math.pi * fc / SR)
        s = rnd.uniform(-1, 1)
        low += f * band
        high = s - low - q * band
        band += f * high
        out[i] = band * math.sin(math.pi * x) ** 2
    return fade_tail(out)


def seq(*events):
    """events: (start in s, buffer, gain)."""
    out = []
    for at, buf, gain in events:
        mix(out, buf, at, gain)
    return out


# ── The cues ───────────────────────────────────────────────────────────────
# Contours to tell them apart by ear: up = on we go, down = done / rest,
# a high ping = the hold runs, wood = a countdown, a drum = Skala.

def cue_start():
    # The workout opens: a rising triad that stays.
    return seq((0.00, marimba('C5', 0.9), 0.8),
               (0.09, marimba('E5', 0.9), 0.8),
               (0.18, marimba('G5', 0.9), 0.9),
               (0.18, glock('G6', 0.7), 0.18))


def cue_challenge_start():
    # Skala steps in: two drum strokes, the second one heavier.
    return seq((0.00, drum(130, 60, 0.35), 0.6),
               (0.22, drum(150, 55, 0.6), 1.0),
               (0.22, marimba('C3', 0.6, bright=0.5), 0.35))


def cue_tick():
    return wood(1046.5)          # C6


def cue_tick_last():
    return wood(1568.0, 0.09)    # G6, the last one before the hold


def cue_go():
    # The hold starts: one clear ping with a wooden attack under it.
    return seq((0.0, glock('C6', 0.8), 1.0),
               (0.0, marimba('C5', 0.5), 0.35))


def cue_hold_half():
    return glock('E6', 0.35)


def cue_tick_hold():
    return wood(659.3, 0.06)     # E5: lower than the get-ready ticks


def cue_switch_sides():
    # Turn round: a quick back-and-forth.
    return seq((0.00, marimba('E5', 0.3), 1.0),
               (0.08, marimba('A5', 0.3), 1.0),
               (0.16, marimba('E5', 0.3), 0.9),
               (0.24, marimba('A5', 0.4), 1.0))


def cue_set_done():
    # Done, breathe out: down a fifth, a little air after it.
    return seq((0.00, marimba('G5', 0.4), 1.0),
               (0.10, marimba('C5', 0.6), 1.0),
               (0.12, breath(0.35, 2200, 500, rising=False, seed=11), 0.12))


def cue_rest_over():
    # The next set: up a fifth.
    return seq((0.00, marimba('C5', 0.35), 1.0),
               (0.10, marimba('G5', 0.5), 1.0))


def cue_next_exercise():
    # Something new: a brisk run up to the octave.
    return seq((0.00, marimba('G4', 0.3), 0.9),
               (0.07, marimba('C5', 0.3), 0.9),
               (0.14, marimba('E5', 0.3), 0.95),
               (0.21, marimba('G5', 0.5), 1.0),
               (0.21, glock('G6', 0.4), 0.15))


def cue_skip():
    return seq((0.0, breath(0.22, 600, 3800, seed=5), 1.0),
               (0.12, marimba('G5', 0.3), 0.35))


def cue_pause():
    return seq((0.00, felt('E5'), 1.0), (0.11, felt('A4', 0.4), 1.0))


def cue_resume():
    return seq((0.00, felt('A4'), 1.0), (0.11, felt('E5', 0.4), 1.0))


def cue_complete():
    # The workout is done: the run up and a chord that rings out.
    out = seq((0.00, marimba('C5', 0.5), 0.8),
              (0.08, marimba('E5', 0.5), 0.8),
              (0.16, marimba('G5', 0.5), 0.85),
              (0.26, marimba('C6', 1.2), 1.0),
              (0.26, marimba('E5', 1.2), 0.6),
              (0.26, marimba('G5', 1.2), 0.6),
              (0.26, glock('C7', 1.0), 0.22),
              (0.38, glock('G6', 0.9), 0.15))
    return out


def cue_challenge_passed():
    # Fanfare: Skala's drum, a triplet up, a big chord.
    return seq((0.00, drum(140, 60, 0.4), 0.55),
               (0.00, marimba('G4', 0.25), 0.8),
               (0.10, marimba('G4', 0.25), 0.8),
               (0.20, marimba('G4', 0.25), 0.8),
               (0.32, marimba('C5', 0.4), 0.9),
               (0.42, marimba('E5', 0.4), 0.9),
               (0.52, drum(160, 60, 0.7), 0.8),
               (0.52, marimba('C6', 1.4), 1.0),
               (0.52, marimba('G5', 1.4), 0.7),
               (0.52, marimba('E5', 1.4), 0.7),
               (0.52, glock('C7', 1.2), 0.25),
               (0.64, glock('E7', 1.0), 0.15))


def cue_challenge_failed():
    # Not this time: gentle notes that settle, no buzzer.
    return seq((0.00, felt('G5', 0.4), 0.9),
               (0.18, felt('E5', 0.4), 0.85),
               (0.36, felt('C5', 0.7), 0.85),
               (0.36, felt('C4', 0.7), 0.4))


def cue_stage_up():
    # A new stage: a sparkle running up.
    names = ['C6', 'D6', 'E6', 'G6', 'A6', 'C7']
    return seq(*[(i * 0.045, glock(n, 0.45), 0.5 + i * 0.08)
                 for i, n in enumerate(names)])


def cue_achievement():
    return seq((0.00, glock('E6', 0.9), 0.9),
               (0.12, glock('B6', 1.0), 0.8),
               (0.12, marimba('E5', 0.8), 0.35))


def cue_freeze_earned():
    # Ice: high, slightly detuned pings that shimmer.
    return seq((0.00, glock('B6', 0.8), 0.7),
               (0.00, [v * 0.7 for v in partials(note('B6') * 1.006, 0.8,
                                                  [(1.0, 1.0, 0.3)])], 0.6),
               (0.09, glock('E7', 0.7), 0.6),
               (0.18, glock('B7', 0.6), 0.4))


def cue_freeze_used():
    return seq((0.00, glock('B6', 0.6), 0.6),
               (0.12, glock('E6', 0.8), 0.7),
               (0.12, [v * 0.7 for v in partials(note('E6') * 1.006, 0.8,
                                                  [(1.0, 1.0, 0.3)])], 0.5))


# name → (synthesiser, loudness target in dBFS of the loudest 50 ms)
CUES = {
    'start': (cue_start, -12),
    'challenge_start': (cue_challenge_start, -11),
    'tick': (cue_tick, -16),
    'tick_last': (cue_tick_last, -14),
    'go': (cue_go, -11),
    'hold_half': (cue_hold_half, -20),
    'tick_hold': (cue_tick_hold, -17),
    'switch_sides': (cue_switch_sides, -12),
    'set_done': (cue_set_done, -12),
    'rest_over': (cue_rest_over, -12),
    'next_exercise': (cue_next_exercise, -12),
    'skip': (cue_skip, -16),
    'pause': (cue_pause, -16),
    'resume': (cue_resume, -16),
    'complete': (cue_complete, -9),
    'challenge_passed': (cue_challenge_passed, -9),
    'challenge_failed': (cue_challenge_failed, -13),
    'stage_up': (cue_stage_up, -12),
    'achievement': (cue_achievement, -12),
    'freeze_earned': (cue_freeze_earned, -13),
    'freeze_used': (cue_freeze_used, -14),
}


# ── Loudness and files ─────────────────────────────────────────────────────

def loudest_rms_db(buf, win=0.05):
    n = int(SR * win)
    best = 0.0
    for start in range(0, max(1, len(buf) - n), n // 4):
        chunk = buf[start:start + n]
        rms = math.sqrt(sum(v * v for v in chunk) / len(chunk))
        best = max(best, rms)
    return 20 * math.log10(best) if best > 0 else -120.0


def normalise(buf, target_db, ceiling_db=-1.0):
    gain = 10 ** ((target_db - loudest_rms_db(buf)) / 20)
    peak = max(abs(v) for v in buf) * gain
    ceiling = 10 ** (ceiling_db / 20)
    if peak > ceiling:
        gain *= ceiling / peak
    return [v * gain for v in buf]


def trim(buf, floor_db=-50):
    floor = 10 ** (floor_db / 20)
    end = len(buf)
    while end > 0 and abs(buf[end - 1]) < floor:
        end -= 1
    return fade_tail(buf[:end + int(SR * 0.01)], 0.008)


def write_wav(path, buf):
    with wave.open(path, 'wb') as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(b''.join(
            struct.pack('<h', int(max(-1.0, min(1.0, v)) * 32767))
            for v in buf))


def render(name):
    synth, target = CUES[name]
    return trim(normalise(synth(), target))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--out', default=OUT)
    parser.add_argument('names', nargs='*')
    args = parser.parse_args()
    os.makedirs(args.out, exist_ok=True)
    for name in args.names or CUES:
        buf = render(name)
        path = os.path.join(args.out, f'{name}.wav')
        write_wav(path, buf)
        peak = 20 * math.log10(max(abs(v) for v in buf))
        print(f'{name:18} {len(buf) / SR:5.2f} s  '
              f'loudest {loudest_rms_db(buf):6.1f} dB  peak {peak:5.1f} dB  '
              f'{os.path.getsize(path) // 1024:4d} KB')


if __name__ == '__main__':
    main()
