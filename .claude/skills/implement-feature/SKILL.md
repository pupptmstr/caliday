---
name: implement-feature
description: Step-by-step workflow for implementing a new feature or fixing a bug in CaliDay. Use when starting work on any non-trivial change — ensures correct context loading, architecture alignment, and proper documentation at the end.
---

# Implement Feature Workflow

## Шаг 1 — Загрузить контекст

Прочитай в следующем порядке:
1. `docs/ARCHITECTURE.md` — архитектура, Hive typeIds, API сервисов, паттерны
2. `docs/DEV_NOTES.md` — текущий статус и спеку фичи (если она есть в «Активных спеках»)
3. Релевантные файлы кода (найди через Glob/Grep)

**Ключевые паттерны из ARCHITECTURE.md** которые надо держать в голове:
- Hive typeIds нельзя менять после релиза
- UserProfile HiveField номера уже заняты до @22
- Сервисы мутируют объекты на месте, сохранение — ответственность вызывающего
- `homeDataProvider` и `profileDataProvider` нужно инвалидировать после тренировки
- `context.canPop() ? context.pop() : context.go('/home')` при выходе из workout

## Шаг 2 — Спланировать реализацию

Перед написанием кода сформулируй план:
- Какие файлы будут изменены / созданы
- Если добавляются Hive поля — какой следующий свободный `@HiveField` номер
- Нужна ли кодогенерация (`dart run build_runner build`)
- Нужны ли новые l10n ключи
- Нужны ли изменения в `app_router.dart`
- Есть ли Android/iOS специфика

Согласуй план с пользователем если изменения затрагивают архитектуру.

## Шаг 3 — Реализовать

Принципы:
- Минимум изменений для решения задачи — не рефакторить то, что не трогаешь
- Не добавлять docstrings/комментарии к существующему коду
- UI-строки — через l10n (не хардкодить в коде)
- Следить за emoji policy: UI chrome → Material Icons, контент (achievements) → emoji можно
- Новые HiveField: добавляй строго по порядку, документируй в ARCHITECTURE.md

## Шаг 4 — Проверить

```bash
flutter analyze          # Обязательно, исправить все предупреждения
flutter test             # Если есть тесты
```

Для изменений Hive моделей:
```bash
dart run build_runner build   # Регенерировать .g.dart файлы
```

## Шаг 5 — Задокументировать и закоммитить

Используй скилл `pre-commit`:
- История в DEV_NOTES
- Обновить ARCHITECTURE.md (финальные решения, backlog статус → ✅)
- Обновить MEMORY.md
- Коммит на английском

## Чеклист для фич с Hive изменениями

- [ ] Следующий свободный @HiveField номер проверен
- [ ] typeId не изменён для существующих классов
- [ ] `.g.dart` файл регенерирован
- [ ] Новые поля задокументированы в ARCHITECTURE.md → UserProfile HiveFields
- [ ] `main.dart`: если новый Hive box — добавлен `await Hive.openBox<T>('name')`

## Чеклист для фич с навигацией

- [ ] Маршрут добавлен в `app_router.dart`
- [ ] При выходе из workout: `context.canPop() ? context.pop() : context.go('/home')`
- [ ] Deep link guard в RouterNotifier если нужен
- [ ] Маршрут добавлен в таблицу навигации в ARCHITECTURE.md

## Чеклист для Android-специфики

- [ ] Новые разрешения добавлены в `AndroidManifest.xml`
- [ ] Proguard правила обновлены если нужны (для Kotlin/Java классов без Flutter)
- [ ] `postFrameCallback` для сервисов которые нельзя инициализировать в `main()` до `runApp()`