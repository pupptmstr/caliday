#!/usr/bin/env python3
"""Builds a self-contained preview page that plays Lottie animations.

Usage: python3 tools/lottie/build_preview.py [--out FILE] [--fragment] [name ...]

Defaults to every assets/animations/flex_*.json, written to
build/lottie_preview.html as a standalone page (lottie-web comes from cdnjs).
--fragment omits the <!doctype>/<html> wrapper (the form the Artifact tool wants).
"""

import argparse
import glob
import json
import os

ROOT = os.path.join(os.path.dirname(__file__), '..', '..')
ANIMATIONS = os.path.join(ROOT, 'assets', 'animations')

# Card copy per animation; unknown names fall back to the file name.
INFO = {
    'flex_s1_hip_flexor_stretch': (
        'Растяжка сгибателей бедра', 'Этап 1', 'удержание 20–60 с',
        'Выпад с коленом на полу: бёдра уходят вперёд-вниз, руки с пояса тянутся вверх.'),
    'flex_s2_worlds_greatest_stretch': (
        'Лучшая растяжка в мире', 'Этап 2', '3–8 повторений',
        'Низкий выпад, руки на полу. Одна рука поднимается к потолку, голова следует за ней.'),
    'flex_s4_thoracic_bridge': (
        'Торакальный мост', 'Этап 4', '3–8 повторений',
        'Из седа в обратный «столик», затем рука взмахом идёт вверх над грудью.'),
    'flex_s5_deep_squat_hold': (
        'Глубокий присед (удержание)', 'Этап 5', 'удержание 20–90 с',
        'Удержание приседа, ладони перед грудью, медленное «дыхание» вверх-вниз.'),
    'flex_s6_pike_stretch': (
        'Растяжка в наклоне вперёд', 'Этап 6', 'удержание 20–60 с',
        'Сидя ровно, затем складка вперёд от бёдер и руки к носкам.'),
}

STANDALONE_HEAD = ('<!doctype html>\n<html lang="ru">\n<head>\n<meta charset="utf-8">\n'
                   '<meta name="viewport" content="width=device-width, initial-scale=1">\n')
STANDALONE_RESET = ('<style>body{margin:0}[hidden]{display:none!important}</style>\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=os.path.join(ROOT, 'build', 'lottie_preview.html'))
    ap.add_argument('--fragment', action='store_true')
    ap.add_argument('names', nargs='*')
    args = ap.parse_args()

    names = args.names or sorted(
        os.path.basename(p)[:-5]
        for p in glob.glob(os.path.join(ANIMATIONS, 'flex_*.json')))
    data, meta = {}, []
    for n in names:
        with open(os.path.join(ANIMATIONS, n + '.json')) as f:
            data[n] = json.load(f)
        title, stage, kind, text = INFO.get(n, (n, '', '', ''))
        meta.append(dict(id=n, title=title, stage=stage, kind=kind, text=text))

    with open(os.path.join(os.path.dirname(__file__), 'preview_template.html')) as f:
        page = f.read()
    page = page.replace('__META__', json.dumps(meta, ensure_ascii=False))
    page = page.replace('__DATA__', json.dumps(data, separators=(',', ':')))

    if not args.fragment:
        # Move <title>/<link>/<style> into a real <head>.
        split = page.index('<main')
        page = (STANDALONE_HEAD + page[:split] + STANDALONE_RESET +
                '</head>\n<body>\n' + page[split:] + '\n</body>\n</html>\n')

    os.makedirs(os.path.dirname(os.path.abspath(args.out)), exist_ok=True)
    with open(args.out, 'w') as f:
        f.write(page)
    print(os.path.abspath(args.out), '%d KB' % (len(page) // 1024))


if __name__ == '__main__':
    main()
