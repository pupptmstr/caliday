# CaliDay — Геймифицированные домашние тренировки

## Описание проекта

Мобильное приложение для домашних тренировок с игровой механикой прогрессии.
Пользователь проходит от базовых упражнений (отжимания с колен) до продвинутой
калистеники (стойка на руках) через короткие ежедневные сеты по 5-15 минут.

Все данные хранятся локально. Нет бэкенда. Бесплатное, без рекламы.

## Документация
- Дизайн-документ: `docs/CaliDay_Design_Document.md`
- **Живые заметки разработки (прочти при старте сессии!):** `docs/DEV_NOTES.md`
  Содержит: статус MVP, принятые решения, Hive typeIds, историю изменений,
  архитектурные паттерны, идеи для v1.1.
- **Дизайн-концепция маскота и визуального стиля:** `docs/design-concept/caliday_design_concept.md`
  Содержит: маскот Горо (горилла), цветовая палитра, система выражений лица, иконки.
  Файлы: `caliday_icon_face.svg` (иконка приложения), `caliday_icon.svg` (флекс/промо),
  `caliday_icon_idle.svg` (idle-поза), `caliday_icon_preview.html` (превью).

## Технический стек

- **Flutter** (Dart)
- **State management**: Riverpod
- **Локальное хранение**: Hive
- **Навигация**: go_router
- **Уведомления**: flutter_local_notifications
- **Целевые платформы**: iOS (первичная), Android (вторичная)

## Архитектура

Feature-first структура с разделением на слои:

- `lib/core/` — общие утилиты, тема, константы, переиспользуемые виджеты
- `lib/data/` — модели, репозитории, источники данных, статические каталоги
- `lib/domain/` — бизнес-логика (генерация тренировок, прогрессия, стрики)
- `lib/features/` — экраны по фичам (home, workout, profile, settings, onboarding)

State management — Riverpod providers в каждой фиче.

## Ключевые концепции

### Сет (Set / Workout)
Короткое занятие: 3-6 упражнений, 5-15 минут. Типы: Daily, Skill, Challenge.

### Ветки прогрессии (Branches)
5 веток: Push, Pull, Core, Legs, Balance. Каждая — линейка этапов от простого
к сложному (например, Push: отжимания от стены → с колен → полные → алмазные →
одной рукой → в стойке на руках).

### Прогрессия внутри этапа
Повторения ↑ → Подходы ↑ → Отдых ↓ → Challenge-тест → Следующий этап.

### Геймификация
- SP (Strength Points) — очки за упражнения
- Streak — дни подряд
- Ранги: Новичок → Любитель → Спортсмен → Атлет → Мастер → Легенда
- Достижения (achievements)
- Календарь активности (GitHub contribution graph style)

## Модели данных

- `UserProfile` — ранг, totalSP, streak, streakFreezeCount
- `SkillProgress` — branchId, currentStage, currentReps/Sets/RestSec
- `WorkoutLog` — date, setType, exercises[], spEarned, durationSec
- `ExerciseResult` — exerciseId, targetReps, completedReps, durations
- `Exercise` (static) — id, name, description, branch, stage, type (reps/timed)

## MVP v1.0 (текущий скоуп)

- 2 ветки: Push + Core
- Ежедневные сеты с автогенерацией
- Прогрессия (повторения, подходы)
- Стрики и SP
- Пуш-уведомления
- Статические иллюстрации
- Onboarding-опрос
- Локальное хранение (Hive)

## Стиль кода и коммиты

- **Commit messages — всегда на английском.**
- Dart — следовать official Dart style guide
- Виджеты — предпочитать StatelessWidget + Riverpod ConsumerWidget
- Именование файлов: snake_case
- Именование классов: PascalCase
- Комментарии к публичным API на английском
- UI-строки на русском (будущая локализация через intl)

## Команды
```bash
flutter run                    # Запуск
flutter test                   # Тесты
flutter analyze                # Линтер
dart run build_runner build    # Кодогенерация (Hive adapters)
```

## Обязательный процесс перед коммитом

Перед **каждым** коммитом необходимо:
1. Обновить `docs/DEV_NOTES.md` — добавить запись в «История изменений» с описанием что сделано и какие файлы изменены. Если изменение затрагивает архитектурные решения, обновить соответствующие разделы документа.
2. Обновить собственную автопамять (`MEMORY.md` в `.claude/projects/.../memory/`) — зафиксировать новые паттерны, ключевые файлы или решения.
3. Только после этого создавать коммит.