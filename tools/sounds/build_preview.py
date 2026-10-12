#!/usr/bin/env python3
"""Builds a page to listen to the workout cues and approve them.

Usage: python3 tools/sounds/build_preview.py [--dir DIR] [--out FILE] [--fragment]

Every WAV of assets/sounds (or DIR, a draft folder from gen_sounds.py --out)
is embedded in the page as base64: a card per cue, grouped by the moment of
the workout, and a short workout played in real time with every cue where it
falls. The page is written to build/sounds_preview.html. --fragment omits the
<!doctype>/<html> wrapper (the form the Artifact tool wants).
"""

import argparse
import base64
import html
import json
import os

ROOT = os.path.join(os.path.dirname(__file__), '..', '..')
SOUNDS = os.path.join(ROOT, 'assets', 'sounds')

# group id → title, the moments in it
GROUPS = [
    ('start', 'Начало', ['start', 'challenge_start']),
    ('count', 'Отсчёт «приготовься» и конец отдыха', ['tick', 'tick_last']),
    ('hold', 'Удержание', ['go', 'hold_half', 'tick_hold', 'switch_sides']),
    ('sets', 'Подходы и отдых', ['set_done', 'rest_over', 'next_exercise', 'skip']),
    ('taps', 'Твои нажатия', ['pause', 'resume']),
    ('end', 'Конец тренировки', ['complete', 'challenge_passed', 'challenge_failed']),
    ('summary', 'Экран итогов', ['stage_up', 'achievement', 'freeze_earned', 'freeze_used']),
]

# cue → (name, when it plays, what played there before 0.9.6, key?) — key as
# SoundCue.key in lib/core/services/sound_service.dart: kept by the "key only" mode
INFO = {
    'start': ('Старт', 'Открылось первое упражнение тренировки.', 'тишина', False),
    'challenge_start': ('Скала выходит', 'Вместо «Старта», когда это Испытание; на итогах — когда Испытание открылось.',
                        'тишина', False),
    'tick': ('Тик', 'Последние секунды отсчёта «приготовься» и отдыха: 5, 4, 3, 2.',
             'тик', False),
    'tick_last': ('Последний тик', 'На «1»: выше остальных, следом начнётся действие.',
                  'тик', True),
    'go': ('Пошли!', 'Отсчёт кончился, удержание пошло само.', 'динь', True),
    'hold_half': ('Половина', 'Середина удержания от 20 секунд. Тихий.', 'тишина', False),
    'tick_hold': ('Тик удержания', 'Последние 5 секунд удержания. Ниже тиков отсчёта.',
                  'тик', False),
    'switch_sides': ('Смена стороны', 'Первая сторона досчитана, отсчёт перед второй.',
                     'поп', True),
    'set_done': ('Подход сделан', 'Подход подтверждён или удержание досчитано; дальше отдых.',
                 'поп', True),
    'rest_over': ('Следующий подход', 'Отдых кончился, то же упражнение.', 'динь', True),
    'next_exercise': ('Новое упражнение', 'Начинается следующее упражнение (после отдыха или сразу).',
                      'динь или поп', True),
    'skip': ('Отдых пропущен', 'Нажата «Пропустить».', 'динь', False),
    'pause': ('Пауза', 'Отсчёт «приготовься» на паузе.', 'тишина', False),
    'resume': ('Продолжить', 'Отсчёт пошёл дальше.', 'тишина', False),
    'complete': ('Тренировка завершена', 'Последний подход сделан.', 'финал', True),
    'challenge_passed': ('Испытание пройдено', 'Вместо обычного финала: фанфары и барабан Скалы.',
                         'финал', True),
    'challenge_failed': ('Испытание не пройдено', 'Мягко, без «сирены».', 'финал', True),
    'stage_up': ('Новый этап', 'На итогах пройденного Испытания: ветка перешла на этап выше.', 'тишина', False),
    'achievement': ('Достижение', 'На итогах, когда открыто достижение.', 'тишина', False),
    'freeze_earned': ('Заморозка получена', 'На итогах: 7 дней серии дали заморозку.', 'тишина', False),
    'freeze_used': ('Заморозка спасла серию', 'На итогах: пропуск закрыт заморозкой.', 'тишина', False),
}

# A short workout, in seconds: (time, cue, caption)
DEMO = [
    (0.0, 'start', 'Боковая планка, 30 с на сторону. Приготовься'),
    (1.0, 'tick', '5'), (2.0, 'tick', '4'), (3.0, 'tick', '3'), (4.0, 'tick', '2'),
    (5.0, 'tick_last', '1'),
    (6.0, 'go', 'Держим, сторона 1'),
    (8.0, 'hold_half', 'Половина'),
    (9.5, 'tick_hold', '5'), (10.5, 'tick_hold', '4'), (11.5, 'tick_hold', '3'),
    (12.5, 'tick_hold', '2'), (13.5, 'tick_hold', '1'),
    (14.5, 'switch_sides', 'Смена стороны'),
    (15.5, 'tick', '4'), (16.5, 'tick', '3'), (17.5, 'tick', '2'),
    (18.5, 'tick_last', '1'),
    (19.5, 'go', 'Держим, сторона 2'),
    (21.5, 'hold_half', 'Половина'),
    (23.0, 'tick_hold', '5'), (24.0, 'tick_hold', '4'), (25.0, 'tick_hold', '3'),
    (26.0, 'tick_hold', '2'), (27.0, 'tick_hold', '1'),
    (28.0, 'set_done', 'Подход сделан. Отдых'),
    (30.0, 'tick', '5'), (31.0, 'tick', '4'), (32.0, 'tick', '3'), (33.0, 'tick', '2'),
    (34.0, 'tick_last', '1'),
    (35.0, 'next_exercise', 'Отжимания, 2 × 10'),
    (38.0, 'set_done', 'Нажато «Готово». Отдых'),
    (39.5, 'skip', 'Нажато «Пропустить»'),
    (42.5, 'complete', 'Последний подход: тренировка завершена'),
    (44.6, 'achievement', 'Итоги: достижение'),
    (45.5, 'freeze_earned', 'Итоги: заморозка'),
]

STYLE = """
/* Layout: one listening column — the workout player on top, then the cues by moment. */
:root {
  --bg: #F2F6FB; --surface: #FFFFFF; --line: #DCE5F0;
  --fg: #172231; --muted: #5A6A7E;
  --accent: #2B7DE9; --accent-ink: #FFFFFF;
  --g-start: #2B7DE9; --g-count: #E07F00; --g-hold: #1A5FA8;
  --g-sets: #23964A; --g-taps: #6B7A8F; --g-end: #7A4FD0; --g-summary: #B8860B;
  --skala: #8E2A2A;
  --display: "Barlow Condensed", "Arial Narrow", system-ui, sans-serif;
  --body: "Barlow", system-ui, -apple-system, "Segoe UI", sans-serif;
}
@media (prefers-color-scheme: dark) { :root:not([data-theme="light"]) {
  --bg: #0E141C; --surface: #17202B; --line: #263243;
  --fg: #E4ECF5; --muted: #94A4B8;
  --accent: #4DA6FF; --accent-ink: #0E141C;
  --g-start: #4DA6FF; --g-count: #FF9F2E; --g-hold: #7FC3FF;
  --g-sets: #4CD07A; --g-taps: #A3B1C4; --g-end: #B596FF; --g-summary: #F2C14E;
  --skala: #E07A6A; color-scheme: dark; } }
:root[data-theme="dark"] {
  --bg: #0E141C; --surface: #17202B; --line: #263243;
  --fg: #E4ECF5; --muted: #94A4B8;
  --accent: #4DA6FF; --accent-ink: #0E141C;
  --g-start: #4DA6FF; --g-count: #FF9F2E; --g-hold: #7FC3FF;
  --g-sets: #4CD07A; --g-taps: #A3B1C4; --g-end: #B596FF; --g-summary: #F2C14E;
  --skala: #E07A6A; color-scheme: dark; }
body { background: var(--bg); color: var(--fg); font: 16px/1.5 var(--body);
  padding-inline: 16px; padding-block: 28px 56px; }
main { max-width: 760px; margin: 0 auto; display: grid; gap: 28px; }
h1, h2 { font-family: var(--display); text-wrap: balance; margin: 0; }
h1 { font-size: 2.6rem; line-height: 1.05; font-weight: 700; letter-spacing: .01em; }
h2 { font-size: 1.45rem; font-weight: 600; }
p { margin: 0; max-width: 65ch; }
.lead { color: var(--muted); }
.decide { display: grid; gap: 6px; padding: 0; margin: 0; list-style: none; }
.decide li { padding-left: 1.4em; position: relative; }
.decide li::before { content: "✓"; position: absolute; left: 0; font-family: var(--display);
  font-weight: 700; color: var(--accent); }
.player { background: var(--surface); border: 1px solid var(--line); border-radius: 18px;
  padding: 20px; display: grid; gap: 14px; }
.player-row { display: flex; flex-wrap: wrap; align-items: center; gap: 14px; }
.btn { font: 600 1.05rem var(--display); letter-spacing: .03em; text-transform: uppercase;
  border: 0; border-radius: 12px; padding: 12px 20px; cursor: pointer;
  background: var(--accent); color: var(--accent-ink); }
.btn:focus-visible, .play:focus-visible { outline: 3px solid var(--g-count); outline-offset: 2px; }
.caption { font-family: var(--display); font-size: 1.6rem; font-weight: 600; min-height: 2.2rem;
  min-width: 0; flex: 1 1 12rem; }
.track { position: relative; height: 34px; border-radius: 8px; background: var(--bg);
  overflow: hidden; }
.mark { position: absolute; top: 7px; width: 4px; height: 20px; border-radius: 2px;
  background: var(--c); opacity: .45; transform: translateX(-2px); }
.mark.on { opacity: 1; height: 26px; top: 4px; }
.head { position: absolute; top: 0; bottom: 0; width: 2px; background: var(--fg); left: 0; }
.legend { display: flex; flex-wrap: wrap; gap: 6px 14px; font-size: .85rem; color: var(--muted); }
.legend span::before { content: ""; display: inline-block; width: 10px; height: 10px;
  border-radius: 3px; background: var(--c); margin-right: 6px; vertical-align: -1px; }
section { display: grid; gap: 10px; }
.group-title { display: flex; align-items: center; gap: 10px; }
.group-title i { width: 12px; height: 12px; border-radius: 3px; background: var(--c); }
.cues { display: grid; grid-template-columns: repeat(auto-fill, minmax(min(100%, 330px), 1fr)); gap: 10px; }
.cue { display: grid; grid-template-columns: auto 1fr; gap: 4px 14px; align-items: start;
  background: var(--surface); border: 1px solid var(--line); border-radius: 14px; padding: 14px; }
.cue.on { border-color: var(--c); box-shadow: 0 0 0 2px var(--c) inset; }
.play { grid-row: span 3; width: 48px; height: 48px; border-radius: 50%; border: 0; cursor: pointer;
  background: var(--c); color: var(--surface); display: grid; place-items: center; }
.play svg { width: 18px; height: 18px; fill: currentColor; margin-left: 3px; }
.cue h3 { margin: 0; font: 600 1.2rem var(--display); display: flex; flex-wrap: wrap; gap: 8px; align-items: baseline; }
.cue .when { color: var(--fg); min-width: 0; }
.cue .meta { font-size: .85rem; color: var(--muted); font-variant-numeric: tabular-nums; }
.tag { font: 600 .72rem var(--body); letter-spacing: .06em; text-transform: uppercase;
  color: var(--g-count); border: 1px solid currentColor; border-radius: 6px; padding: 0 6px; }
.note { font-size: .9rem; color: var(--muted); }
@media (prefers-reduced-motion: reduce) { .mark, .cue { transition: none; } }
"""

SCRIPT = """
const SOUNDS = __SOUNDS__;
const DEMO = __DEMO__;
const GROUP_OF = __GROUP_OF__;
let ctx, buffers = {};
async function ready() {
  if (!ctx) {
    ctx = new (window.AudioContext || window.webkitAudioContext)();
    await Promise.all(Object.entries(SOUNDS).map(async ([name, b64]) => {
      const bytes = Uint8Array.from(atob(b64), c => c.charCodeAt(0));
      buffers[name] = await ctx.decodeAudioData(bytes.buffer);
    }));
  }
  if (ctx.state === 'suspended') await ctx.resume();
}
function play(name, at = 0) {
  const src = ctx.createBufferSource();
  src.buffer = buffers[name];
  src.connect(ctx.destination);
  src.start(ctx.currentTime + at);
}
function flash(name) {
  const card = document.getElementById('cue-' + name);
  if (!card) return;
  card.classList.add('on');
  setTimeout(() => card.classList.remove('on'), 500);
}
document.querySelectorAll('.play').forEach(b => b.addEventListener('click', async () => {
  await ready(); play(b.dataset.cue); flash(b.dataset.cue);
}));
const total = DEMO[DEMO.length - 1][0] + 2;
const track = document.getElementById('track');
const head = document.getElementById('head');
const caption = document.getElementById('caption');
DEMO.forEach(([t, name], i) => {
  const m = document.createElement('div');
  m.className = 'mark'; m.id = 'mark-' + i;
  m.style.left = (t / total * 100) + '%';
  m.style.setProperty('--c', 'var(--g-' + GROUP_OF[name] + ')');
  track.appendChild(m);
});
let timers = [], raf = 0;
function stop() {
  timers.forEach(clearTimeout); timers = []; cancelAnimationFrame(raf);
  document.querySelectorAll('.mark.on').forEach(m => m.classList.remove('on'));
}
document.getElementById('demo').addEventListener('click', async () => {
  await ready(); stop();
  const t0 = ctx.currentTime + 0.15;
  DEMO.forEach(([t, name, text], i) => {
    const src = ctx.createBufferSource();
    src.buffer = buffers[name]; src.connect(ctx.destination); src.start(t0 + t);
    timers.push(setTimeout(() => {
      caption.textContent = text;
      document.getElementById('mark-' + i).classList.add('on');
      flash(name);
    }, (t + 0.15) * 1000));
  });
  const step = () => {
    const x = Math.min(1, (ctx.currentTime - t0) / total);
    head.style.left = (Math.max(0, x) * 100) + '%';
    if (x < 1) raf = requestAnimationFrame(step);
  };
  step();
});
"""

PLAY_ICON = '<svg viewBox="0 0 16 16" aria-hidden="true"><path d="M3 1.5v13l11-6.5z"/></svg>'


def cue_count(n):
    """21 сигнал, 22 сигнала, 25 сигналов."""
    if n % 10 == 1 and n % 100 != 11:
        word = 'сигнал'
    elif 2 <= n % 10 <= 4 and not 12 <= n % 100 <= 14:
        word = 'сигнала'
    else:
        word = 'сигналов'
    return f'{n} {word}'


def build(sound_dir):
    sounds = {}
    for name in INFO:
        path = os.path.join(sound_dir, f'{name}.wav')
        if os.path.exists(path):
            with open(path, 'rb') as f:
                sounds[name] = base64.b64encode(f.read()).decode()
    group_of = {cue: gid for gid, _, cues in GROUPS for cue in cues}

    sections = []
    for gid, title, cues in GROUPS:
        cards = []
        for cue in cues:
            if cue not in sounds:
                continue
            name, when, before, key = INFO[cue]
            color = 'var(--skala)' if cue.startswith('challenge') else f'var(--g-{gid})'
            tag = '<span class="tag">главный</span>' if key else ''
            cards.append(
                f'<article class="cue" id="cue-{cue}" style="--c:{color}">'
                f'<button class="play" id="play-{cue}" data-cue="{cue}" '
                f'aria-label="Сыграть: {html.escape(name)}">{PLAY_ICON}</button>'
                f'<h3>{html.escape(name)} {tag}</h3>'
                f'<p class="when">{html.escape(when)}</p>'
                f'<p class="meta">До 0.9.6: {html.escape(before)} · {cue}.wav</p>'
                '</article>')
        extra = ''
        if gid == 'taps':
            extra = ('<p class="note">Кнопки «+» и «−» у счётчика повторений — '
                     'без звука, только лёгкая вибрация.</p>')
        sections.append(
            f'<section style="--c:var(--g-{gid})"><div class="group-title"><i></i>'
            f'<h2>{html.escape(title)}</h2></div>{extra}'
            f'<div class="cues">{"".join(cards)}</div></section>')

    legend = ''.join(
        f'<span style="--c:var(--g-{gid})">{html.escape(title)}</span>'
        for gid, title, _ in GROUPS[:4] + GROUPS[5:])
    script = (SCRIPT.replace('__SOUNDS__', json.dumps(sounds))
              .replace('__DEMO__', json.dumps(DEMO, ensure_ascii=False))
              .replace('__GROUP_OF__', json.dumps(group_of)))
    return f"""<title>Звуки тренировки CaliDay</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Barlow:wght@400;600&family=Barlow+Condensed:wght@600;700&display=swap">
<style>{STYLE}</style>
<main>
<header style="display:grid;gap:12px">
<h1>Звуки тренировки CaliDay</h1>
<p class="lead">{cue_count(len(sounds))} вместо четырёх прежних, в приложении с версии 0.9.6. Все синтезированы скриптом
<code>tools/sounds/gen_sounds.py</code> в одной семье тембров — деревянные тики, маримба, колокольчик,
мягкий барабан Скалы. Вверх — «поехали», вниз — «готово, отдыхай», дерево — отсчёт.</p>
<ul class="decide">
<li>Тембр — этот; звучат все сигналы, в том числе «Половина» и звуки итогов.</li>
<li>Отсчёт — 5 тиков, последний выше остальных.</li>
<li>Настройки → Звуки: «Все», «Главные» (сигналы с меткой «главный») или «Выкл.». Вибрация — своим переключателем.</li>
<li>Сигналы звучат поверх музыки и не останавливают её.</li>
</ul>
</header>
<div class="player">
<div class="player-row">
<button class="btn" id="demo">Послушать тренировку</button>
<div class="caption" id="caption" aria-live="polite">46 секунд: боковая планка на две стороны, отжимания, финал, итоги</div>
</div>
<div class="track" id="track"><div class="head" id="head"></div></div>
<div class="legend">{legend}</div>
</div>
{''.join(sections)}
</main>
<script>{script}</script>
"""


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir', default=SOUNDS)
    parser.add_argument('--out', default=os.path.join(ROOT, 'build', 'sounds_preview.html'))
    parser.add_argument('--fragment', action='store_true')
    args = parser.parse_args()
    page = build(args.dir)
    if not args.fragment:
        page = ('<!doctype html><html lang="ru"><head><meta charset="utf-8">'
                '<meta name="viewport" content="width=device-width, initial-scale=1">'
                f'</head><body>{page}</body></html>')
    os.makedirs(os.path.dirname(os.path.abspath(args.out)), exist_ok=True)
    with open(args.out, 'w', encoding='utf-8') as f:
        f.write(page)
    print(f'{args.out}: {len(page) // 1024} KB')


if __name__ == '__main__':
    main()
