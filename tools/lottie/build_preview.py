#!/usr/bin/env python3
"""Builds a self-contained preview page that plays Lottie animations.

Usage: python3 tools/lottie/build_preview.py [--preset flex|supp|posture|neck|cooldown]
                                              [--out FILE] [--fragment]
                                              [--dir DIR] [name ...]

The flex preset (default) shows every assets/animations/flex_*.json, the supp
preset the supplementary pool, posture and neck the Posture and Neck branches
of the Healthy Body course, cooldown the generated cooldown (cat-cow). --dir reads the files from DIR (a draft folder) instead of
assets/animations. The page is written to build/lottie_preview.html
as a standalone file (lottie-web comes from cdnjs).
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


SUPP_INFO = {
    'supp_oblique_crunch': (
        'Косые скручивания', 'Кор', '2 × 10 повторений',
        'Вид сверху: лёжа на спине, руки за головой, корпус поворачивается и локоть тянется к противоположному колену.'),
    'supp_russian_twists': (
        'Русские скручивания', 'Кор', '2 × 12 повторений',
        'Сидя с поднятыми ногами: корпус поворачивается, руки уходят то к камере, то за торс.'),
    'supp_side_plank': (
        'Боковая планка', 'Кор', '2 × удержание 20 с',
        'Тело в одной линии на предплечье, бёдра чуть «дышат», верхняя рука вверх.'),
    'supp_standing_calf_raise': (
        'Подъёмы на носки', 'Ноги', '2 × 15 повторений',
        'Медленный подъём на носки и контролируемое опускание.'),
    'supp_single_leg_calf_raise': (
        'Подъём на носок (одна нога)', 'Ноги', '2 × 10 повторений',
        'То же на одной ноге: вторая согнута назад, руки на поясе, лёгкий баланс.'),
    'supp_dead_bug': (
        'Мёртвый жук', 'Кор', '2 × 8 повторений',
        'Лёжа: рука уходит за голову, противоположная нога вытягивается, затем наоборот.'),
    'supp_bird_dog': (
        'Птица-собака', 'Кор', '2 × 8 повторений',
        'На четвереньках: рука вперёд и противоположная нога назад в линию со спиной.'),
    'supp_neck_isometrics': (
        'Изометрика шеи', 'Шея', '30 с',
        'Ладонь давит на лоб, висок и затылок по очереди, шея сопротивляется.'),
    'supp_wrist_circles': (
        'Вращения запястьями', 'Кисти', '30 с',
        'Готовая анимация warmup_wrist_circles: кулаки вращаются в обе стороны.'),
}
POSTURE_INFO = {
    'posture_s1_pelvic_tilt': (
        'Наклон таза назад', 'Осанка · этап 1', '3 × удержание 10 с',
        'Лёжа, колени согнуты. Поясница сначала чуть выгнута над полом, затем прижимается: таз подворачивается.'),
    'posture_s2_dead_bug': (
        'Мёртвый жук', 'Осанка · этап 2', '3 × 10 повторений',
        'Та же анимация, что у supp_dead_bug: рука уходит за голову, противоположная нога вытягивается.'),
    'posture_s3_glute_bridge': (
        'Ягодичный мостик', 'Осанка · этап 3', '3 × 20 повторений',
        'Лёжа, стопы на полу. Таз поднимается до одной линии плечо–таз–колено, пауза и спуск.'),
    'posture_s4_hip_march': (
        'Марш на месте', 'Осанка · этап 4', '3 × 20 повторений',
        'Вид спереди: колено поднимается до уровня бедра (нога идёт к камере), корпус прямой, руки на поясе.'),
    'posture_s5_kneeling_lunge': (
        'Растяжка сгибателей бедра', 'Осанка · этап 5', '2 × удержание 60 с',
        'Та же анимация, что у flex_s1: выпад на колено, таз вперёд, корпус вертикален.'),
}
NECK_INFO = {
    'warmup_neck_rolls': (
        'Вращения шеей', 'Разминка', '5 повторений',
        'Вид спереди: голова полукругом идёт от плеча к плечу через грудь, назад не запрокидывается.'),
    'neck_s1_neck_tilt': (
        'Наклоны шеи', 'Шея · этап 1', '2 × удержание 15–45 с',
        'Вид спереди: ухо тянется к плечу, пауза, на другую сторону. Противоположное плечо опускается, рука не помогает.'),
    'neck_s2_chest_opener': (
        'Раскрытие груди', 'Шея · этап 2', '2 × удержание 15–45 с',
        'Сбоку: руки сцеплены за спиной и уходят назад, лопатки сводятся, грудь идёт вперёд, подбородок чуть вверх.'),
    'neck_s3_shoulder_roll': (
        'Круги плечами', 'Шея · этап 3', '2–3 × 8–20 повторений',
        'Вид спереди: большие медленные круги, сначала вперёд, потом назад. Плечи поднимаются, сводятся и опускаются.'),
    'neck_s4_wall_angel': (
        'Ангелы у стены', 'Шея · этап 4', '2–3 × 5–15 повторений',
        'Сбоку: спина, затылок и руки у стены. Руки скользят вверх вдоль стены и обратно.'),
    'neck_s5_doorway_stretch': (
        'Растяжка груди в дверном проёме', 'Шея · этап 5', '2 × удержание 20–60 с',
        'Вид спереди: предплечья на косяках, корпус и голова подаются к камере (наклон вперёд), грудь раскрывается.'),
}
COOLDOWN_INFO = {
    'cooldown_cat_cow': (
        'Кошка-корова', 'Заминка · Core, Flex, Neck', '30–60 с',
        'На четвереньках: спина прогибается вниз (корова, голова вверх) и округляется вверх '
        '(кошка, подбородок к груди). Руки и колени остаются на месте.'),
}
INFO.update(SUPP_INFO)
INFO.update(POSTURE_INFO)
INFO.update(NECK_INFO)
INFO.update(COOLDOWN_INFO)

# name -> (page title, heading, lead, file names). A card's file may differ from
# its id (supp_wrist_circles reuses warmup_wrist_circles.json).
PRESETS = {
    'flex': (
        'Стенд анимаций Flex', 'Анимации ветки Flex',
        'Анимации Goro так, как они играют в приложении: по кругу, 12 кадров в секунду. '
        'Размер «Миниатюра» показывает, что читается в карточке библиотеки.',
        None),
    'supp': (
        'Стенд дополнительных упражнений', 'Анимации дополнительных упражнений',
        'Девять упражнений пула для бонусных тренировок, как они играют в приложении: '
        'по кругу, 12 кадров в секунду. Косые скручивания показаны сверху, русские '
        'скручивания в профиле условно: вращение корпуса передано поворотом плеч '
        'и сменой слоёв.',
        [('supp_oblique_crunch', None), ('supp_russian_twists', None),
         ('supp_side_plank', None), ('supp_standing_calf_raise', None),
         ('supp_single_leg_calf_raise', None), ('supp_dead_bug', None),
         ('supp_bird_dog', None), ('supp_neck_isometrics', None),
         ('supp_wrist_circles', 'warmup_wrist_circles')]),
    'posture': (
        'Стенд анимаций Posture', 'Анимации ветки Posture',
        'Пять из шести упражнений курса «Здоровое тело», как они играют в приложении: по кругу, '
        '12 кадров в секунду. «Мёртвый жук» и «Растяжка сгибателей» используют уже готовые '
        'анимации, марш на месте показан спереди. Поза голубя сознательно без анимации.',
        [('posture_s1_pelvic_tilt', None), ('posture_s2_dead_bug', 'supp_dead_bug'),
         ('posture_s3_glute_bridge', None), ('posture_s4_hip_march', None),
         ('posture_s5_kneeling_lunge', 'flex_s1_hip_flexor_stretch')]),
    'neck': (
        'Стенд анимаций Neck', 'Анимации ветки Neck',
        'Разминка и пять упражнений ветки «Шея» курса «Здоровое тело», как они играют '
        'в приложении: по кругу, 12 кадров в секунду. Четыре показаны спереди, «Раскрытие груди» '
        'и «Ангелы у стены» сбоку.',
        [('warmup_neck_rolls', None), ('neck_s1_neck_tilt', None),
         ('neck_s2_chest_opener', None), ('neck_s3_shoulder_roll', None),
         ('neck_s4_wall_angel', None), ('neck_s5_doorway_stretch', None)]),
    'cooldown': (
        'Стенд заминки Cat-Cow', 'Заминка «Кошка-корова»',
        'Новая анимация заминки Core, Flex и Neck, как она играет в приложении: по кругу, '
        '12 кадров в секунду. Позвоночник гнётся в трёх местах: сначала прогиб вниз, затем горб.',
        [('cooldown_cat_cow', None)]),
}

STANDALONE_HEAD = ('<!doctype html>\n<html lang="ru">\n<head>\n<meta charset="utf-8">\n'
                   '<meta name="viewport" content="width=device-width, initial-scale=1">\n')
STANDALONE_RESET = ('<style>body{margin:0}[hidden]{display:none!important}</style>\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=os.path.join(ROOT, 'build', 'lottie_preview.html'))
    ap.add_argument('--fragment', action='store_true')
    ap.add_argument('--preset', choices=sorted(PRESETS), default='flex')
    ap.add_argument('--dir', default=ANIMATIONS)
    ap.add_argument('names', nargs='*')
    args = ap.parse_args()

    title, heading, lead, cards = PRESETS[args.preset]
    if args.names:
        cards = [(n, None) for n in args.names]
    elif cards is None:
        cards = [(os.path.basename(p)[:-5], None) for p in sorted(
            glob.glob(os.path.join(ANIMATIONS, 'flex_*.json')))]

    data, meta = {}, []
    for card_id, file_name in cards:
        path = os.path.join(args.dir, (file_name or card_id) + '.json')
        if not os.path.exists(path):  # reused files live in assets/animations
            path = os.path.join(ANIMATIONS, (file_name or card_id) + '.json')
        with open(path) as f:
            data[card_id] = json.load(f)
        card_title, stage, kind, text = INFO.get(card_id, (card_id, '', '', ''))
        meta.append(dict(id=card_id, title=card_title, stage=stage, kind=kind, text=text))

    with open(os.path.join(os.path.dirname(__file__), 'preview_template.html')) as f:
        page = f.read()
    for key, value in (('__TITLE__', title), ('__H1__', heading), ('__LEAD__', lead)):
        page = page.replace(key, value)
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
