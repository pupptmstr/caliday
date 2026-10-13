#!/usr/bin/env python3
"""Checks the store listings in fastlane/metadata against the stores' limits and our rules.

    python3 tools/store/check_listing.py          # prints a table, exits 1 on any error

App Store (fastlane deliver, fastlane/metadata/<locale>/) and Google Play (fastlane supply,
fastlane/metadata/android/<locale>/). The limits are the stores' own (App Store Connect help,
Play Console); the rules are the owner's: no promise of minutes, "free" but never "free forever",
no price words in a name or title, and each store's text names only its own platform.
Spec: internal_docs/specs/store-listing.md.
"""
import os
import re
import sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'fastlane', 'metadata')
LANGS = {'en': ('en-US', 'en-US'), 'ru': ('ru', 'ru-RU'), 'de': ('de-DE', 'de-DE'),
         'es': ('es-ES', 'es-ES')}

# (file, limit, unit, required). Keywords are counted in UTF-8 bytes, as App Store Connect does.
IOS_FIELDS = [
    ('name.txt', 30, 'chars', True),
    ('subtitle.txt', 30, 'chars', True),
    ('promotional_text.txt', 170, 'chars', True),
    ('description.txt', 4000, 'chars', True),
    ('keywords.txt', 100, 'bytes', True),
    ('release_notes.txt', 4000, 'chars', True),
    ('support_url.txt', None, 'url', True),
    ('marketing_url.txt', None, 'url', True),
    ('privacy_url.txt', None, 'url', True),
]
PLAY_FIELDS = [
    ('title.txt', 30, 'chars', True),
    ('short_description.txt', 80, 'chars', True),
    ('full_description.txt', 4000, 'chars', True),
    ('changelogs/default.txt', 500, 'chars', True),
]
SINGLE_LINE = {'name.txt', 'subtitle.txt', 'keywords.txt', 'support_url.txt', 'marketing_url.txt',
               'privacy_url.txt', 'title.txt', 'short_description.txt'}

MINUTES = re.compile(r'(?i)\bmin\b|minute|минут|\bмин\b|minuto|\d+\s*[′\']')
FOREVER = re.compile(r'(?i)forever|навсегда|für immer|para siempre|siempre gratis|immer kostenlos')
PRICE = re.compile(r'(?i)\bfree\b|бесплат|kostenlos|gratis|no ads|без рекламы|ohne werbung|sin anuncios')
NOT_ON_IOS = re.compile(r'(?i)android|google|health connect|play store')
NOT_ON_PLAY = re.compile(r'(?i)iphone|\bios\b|ipad|apple|app store|lock screen|экран блокировки|sperrbildschirm|pantalla de bloqueo')

errors: list[str] = []
rows: list[tuple[str, str, str, str]] = []


def read(path: str) -> str | None:
    if not os.path.exists(path):
        return None
    with open(path, encoding='utf-8') as f:
        return f.read()


def check_field(store: str, locale: str, base: str, field: str, limit, unit: str, required: bool,
                name_words: set[str]) -> str | None:
    where = f'{store} {locale}/{field}'
    text = read(os.path.join(base, field))
    if text is None:
        if required:
            errors.append(f'{where}: missing')
        return None
    if text != text.strip():
        # deliver strips, supply sends the file as it is: keep both clean.
        errors.append(f'{where}: leading or trailing whitespace / newline')
    if field in SINGLE_LINE and '\n' in text.strip():
        errors.append(f'{where}: must be one line')
    if not text.strip():
        errors.append(f'{where}: empty')
    size = len(text.encode('utf-8')) if unit == 'bytes' else len(text)
    if unit == 'url':
        if not re.fullmatch(r'https://\S+', text.strip()):
            errors.append(f'{where}: not an https URL: {text.strip()!r}')
        rows.append((store, locale, field, text.strip()))
        return text
    if limit is not None and size > limit:
        errors.append(f'{where}: {size} {unit} > {limit}')
    rows.append((store, locale, field, f'{size}/{limit} {unit}'))

    if MINUTES.search(text):
        errors.append(f'{where}: mentions minutes ({MINUTES.search(text).group(0)!r}) — '
                      'name workouts by volume, never by time')
    if FOREVER.search(text):
        errors.append(f'{where}: "{FOREVER.search(text).group(0)}" — say "free", never "free forever"')
    if field in ('name.txt', 'subtitle.txt', 'title.txt', 'keywords.txt') and PRICE.search(text):
        errors.append(f'{where}: price words ({PRICE.search(text).group(0)!r}) are not allowed here')
    wrong = NOT_ON_IOS if store == 'ios' else NOT_ON_PLAY
    if wrong.search(text):
        errors.append(f'{where}: names the other platform ({wrong.search(text).group(0)!r})')
    if field == 'keywords.txt':
        words = text.strip().split(',')
        for w in words:
            if w != w.strip():
                errors.append(f'{where}: no spaces around commas ({w!r})')
            if len(w.strip()) <= 2:
                errors.append(f'{where}: keyword {w!r} is too short (more than two characters)')
            if w.strip().lower() in name_words:
                errors.append(f'{where}: {w.strip()!r} is already in the name or subtitle')
        if len({w.strip().lower() for w in words}) != len(words):
            errors.append(f'{where}: duplicate keywords')
    return text


def words_of(*texts: str | None) -> set[str]:
    out: set[str] = set()
    for t in texts:
        if t:
            out |= {w.lower() for w in re.findall(r'\w+', t)}
    return out


for lang, (ios, play) in LANGS.items():
    base = os.path.join(ROOT, ios)
    name_words = words_of(read(os.path.join(base, 'name.txt')),
                          read(os.path.join(base, 'subtitle.txt')))
    for field, limit, unit, required in IOS_FIELDS:
        check_field('ios', ios, base, field, limit, unit, required, name_words)
    base = os.path.join(ROOT, 'android', play)
    for field, limit, unit, required in PLAY_FIELDS:
        check_field('play', play, base, field, limit, unit, required, set())

# Locale folders the script does not know about would go up unchecked.
known_ios = {v[0] for v in LANGS.values()} | {'android', 'review_information', 'default'}
for d in sorted(os.listdir(ROOT)):
    if os.path.isdir(os.path.join(ROOT, d)) and d not in known_ios:
        errors.append(f'ios: unknown folder {d!r} (add the language to LANGS)')
for d in sorted(os.listdir(os.path.join(ROOT, 'android'))):
    if d not in {v[1] for v in LANGS.values()}:
        errors.append(f'play: unknown folder {d!r} (add the language to LANGS)')

for row in rows:
    print(f'{row[0]:5} {row[1]:6} {row[2]:24} {row[3]}')
if errors:
    print(f'\n{len(errors)} problem(s):')
    for e in errors:
        print('  ✗', e)
    sys.exit(1)
print('\nAll listings are within the limits.')
