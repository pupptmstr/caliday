 # CaliDay — Заметки разработки

Живой документ: фиксирует принятые решения, прогресс и следующие шаги.
Обновляется по мере работы над проектом.

---

## Статус MVP v1.0

| Слой | Статус |
|------|--------|
| Модели данных + Hive | ✅ Готово |
| Статический каталог упражнений | ✅ Готово |
| Репозитории | ✅ Готово |
| Доменные сервисы | ✅ Готово |
| Навигация (go_router) | ✅ Готово |
| Onboarding | ✅ Готово |
| Home экран | ✅ Готово |
| Workout экран | ✅ Готово |
| Summary экран | ✅ Готово |
| Profile экран | ✅ Готово |
| Settings экран | ✅ Готово |
| Уведомления | ✅ Готово |

---

## Чеклист до релиза v1.0

Всё ниже должно быть сделано перед публикацией в App Store / Google Play.

### 🔴 Критично (UX-блокеры)

| # | Задача | Статус |
|---|--------|--------|
| 1 | **Диалог подтверждения выхода из тренировки** — кнопка ✕ должна спрашивать "Прервать тренировку?", иначе прогресс теряется без предупреждения | ✅ |
| 2 | **Граничный случай: максимальный этап** — проверить, что происходит когда пользователь достиг последнего этапа в ветке (stage 7 Push / stage 6 Core). ProgressionService не должен падать | ✅ |
| 3 | **Challenge-флоу end-to-end** — убедиться, что когда `isChallengeUnlocked == true` тренировка генерируется корректно и переход на следующий этап происходит после её завершения | ✅ |

### 🟡 Важно для выпуска (стор-требования)

| # | Задача | Статус |
|---|--------|--------|
| 4 | **Иконка приложения** — заменить стандартную Flutter-иконку на собственную (1024×1024 png для iOS, адаптивная для Android) | ✅ |
| 5 | **Launch screen / Splash** — убрать белый экран при холодном старте пока Hive инициализируется | ✅ |

### 🟢 Желательно (можно в патче 1.0.1)

| # | Задача | Статус |
|---|--------|--------|
| 6 | **Заморозки стрика** — `streakFreezeCount` есть в модели, но не зарабатывается и не тратится. Либо реализовать механику, либо скрыть из UI до v1.1 | ✅ |

---

## Принятые технические решения

### Зависимости
- `build_runner` зафиксирован на `^2.4.13` — версия `^2.4.14` несовместима с
  `hive_generator ^2.0.1` из-за конфликта транзитивных зависимостей `analyzer` / `dart_style`.
- `flutter_timezone ^5.0.0` — версии v1.x используют удалённый Android API `Registrar`; в v5 поле `.identifier`.

### Gradle Java 17 (Android)
Плагины Flutter по умолчанию компилируются с `sourceCompatibility = JavaVersion.VERSION_8`, что
вызывает предупреждения «source/target value 8 is obsolete». Исправляется в root `build.gradle.kts`:
```kotlin
subprojects {
    afterEvaluate {
        if (extensions.findByName("android") != null) {
            extensions.configure<com.android.build.gradle.BaseExtension> {
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
        }
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
            }
        }
    }
}
```
**Важно:** использовать `compilerOptions {}`, **не** `kotlinOptions {}` — последнее является ошибкой компиляции в новых версиях KGP.

### Android notification icons
Android разделяет два типа иконок уведомления:

1. **Small icon** (монохромный, в статус-баре) — управляется кодом:
   - `AndroidInitializationSettings('ic_goro_notif')` + `AndroidNotificationDetails(icon: 'ic_goro_notif')`
   - Должен быть белым на прозрачном фоне
   - Реализован как Vector Drawable: `android/app/src/main/res/drawable/ic_goro_notif.xml`
   - `flutter_local_notifications` ищет ресурс по имени в `drawable/`; имя нельзя называть `ic_notification` (конфликт с ресурсом внутри пакета)

2. **Large circular icon** (цветной, в шторке уведомлений, Android 12+) — **это адаптивная иконка приложения** (`@mipmap/ic_launcher`), добавляется Android автоматически.
   - Управляется через `adaptive_icon_foreground` (foreground PNG) + `adaptive_icon_background` (цвет) в pubspec.yaml
   - `adaptive_icon_foreground` должен быть PNG **без фона** (прозрачный); при использовании full-icon (с фоном) уведомление покажет белый блоб

**SVG-маски и rsvg-convert:** `<mask>` рендерится инвертированно (чёрное в маске = показать, белое = скрыть) — противоположно SVG-спецификации. Для иконок избегать масок; использовать Vector Drawable напрямую.

**IDE lint-предупреждение** «`<vector>` requires API level 21 (current min is 1)» — ложноположительное: Flutter Studio не может разрешить `flutter.minSdkVersion`, подставляет API 1. Сборка и рантайм работают корректно.

### Hive typeId-ы
Каждому Hive-типу назначен уникальный typeId. Нельзя менять после первого релиза.

| typeId | Класс |
|--------|-------|
| 0 | `UserProfile` |
| 1 | `SkillProgress` |
| 2 | `WorkoutLog` |
| 3 | `ExerciseResult` |
| 4 | `BranchId` (enum) |
| 5 | `SetType` (enum) |
| 6 | `ExerciseType` (enum) |
| 7 | `Rank` (enum) |
| 8 | `FitnessGoal` (enum) |

### Модель Exercise
`Exercise` — статическая `const`-модель, не хранится в Hive.
Загружается из `ExerciseCatalog` во время выполнения.
Одна запись = один этап прогрессии в рамках ветки.

### Каталог упражнений
- Разминка/заминка используют `stage = 0` как соглашение.
- `WorkoutGeneratorService` (будущий) будет выбирать упражнения с `stage = 0`
  для разминки и заминки.

### SP (Strength Points)
- `spBase` для `ExerciseType.reps` = SP за одно выполненное повторение.
- `spBase` для `ExerciseType.timed` = SP за каждые 10 секунд удержания.
- Итоговый SP за упражнение считается в `SPService` (доменный слой).

### Rank пороги
| Ранг | SP |
|------|----|
| Новичок | 0 |
| Любитель | 500 |
| Спортсмен | 2 000 |
| Атлет | 5 000 |
| Мастер | 15 000 |
| Легенда | 50 000 |

---

## Структура файлов (текущая)

```
l10n/
├── app_ru.arb                         ← шаблон ARB (русский, ~145 ключей)
└── app_en.arb                         ← английский перевод

assets/
├── goro/
│   ├── goro_face.svg                  ← маскот иконка (onboarding)
│   ├── goro_flex.svg                  ← маскот промо (home, summary)
│   └── goro_idle.svg                  ← маскот меню (не используется пока)
└── icon/
    ├── icon.png                       ← 1024×1024 Горо на синем фоне (iOS icon)
    └── icon_foreground.png            ← Горо без фона (Android adaptive foreground)

android/app/src/main/res/
├── drawable/
│   ├── ic_goro_notif.xml              ← notification small icon (Vector Drawable)
│   ├── launch_background.xml          ← синий фон #4DA6FF
│   └── ic_launcher_foreground.xml     ← сгенерировано flutter_launcher_icons
├── drawable-v21/
│   └── launch_background.xml          ← синий фон #4DA6FF
└── mipmap-*/
    └── ic_launcher*.png               ← сгенерировано flutter_launcher_icons

lib/
├── main.dart                          ← Hive init, ProviderScope, locale, точка входа
├── l10n/                              ← СГЕНЕРИРОВАНО flutter gen-l10n (не редактировать)
│   ├── app_localizations.dart
│   ├── app_localizations_ru.dart
│   └── app_localizations_en.dart
├── core/
│   ├── router/app_router.dart         ← GoRouter + RouterNotifier
│   ├── services/notification_service.dart ← NotificationService singleton
│   ├── providers/locale_provider.dart ← StateProvider<String>
│   ├── extensions/
│   │   ├── build_context_l10n.dart    ← context.l10n shortcut
│   │   └── exercise_l10n.dart         ← ExerciseL10n static helper
│   └── widgets/                       ← переиспользуемые виджеты
├── data/
│   ├── models/
│   │   ├── enums.dart + enums.g.dart
│   │   ├── exercise.dart              ← статическая модель (без Hive)
│   │   ├── exercise_result.dart + .g.dart
│   │   ├── skill_progress.dart + .g.dart
│   │   ├── user_profile.dart + .g.dart
│   │   └── workout_log.dart + .g.dart
│   ├── repositories/
│   │   ├── user_repository.dart
│   │   ├── skill_progress_repository.dart
│   │   └── workout_repository.dart
│   └── static/
│       └── exercise_catalog.dart      ← все 5 веток: Push(7)+Pull(6)+Core(6)+Legs(5)+Balance(6) + разминки/заминки
├── domain/
│   ├── models/workout_plan.dart
│   └── services/
│       ├── sp_service.dart
│       ├── streak_service.dart
│       ├── progression_service.dart
│       └── workout_generator_service.dart
└── features/
    ├── home/screens/home_screen.dart
    ├── workout/screens/
    │   ├── workout_screen.dart
    │   └── summary_screen.dart
    ├── profile/screens/profile_screen.dart
    ├── home/screens/branch_journey_screen.dart ← NEW (сессия 24)
    ├── settings/screens/settings_screen.dart
    ├── settings/screens/developer_options_screen.dart ← NEW (сессия 22)
    └── onboarding/screens/onboarding_screen.dart
```

---

## Каталог упражнений (MVP v1.0)

### Ветка Push

| Этап | ID | Название | Старт | Цель |
|------|----|----------|-------|------|
| 1 | `push_s1_wall_pushup` | Отжимания от стены | 1×5 | 3×10 |
| 2 | `push_s2_knee_pushup` | Отжимания с колен | 1×5 | 3×15 |
| 3 | `push_s3_full_pushup` | Полные отжимания | 1×3 | 3×20 |
| 4 | `push_s4_diamond_pushup` | Алмазные отжимания | 1×3 | 3×15 |
| 5 | `push_s5_archer_pushup` | Отжимания лучника | 1×2 | 3×10 |
| 6 | `push_s6_one_arm_pushup` | Отжимания на одной руке | 1×1 | 3×5 |
| 7 | `push_s7_handstand_pushup` | Отжимания в стойке на руках | 1×1 | 3×10 |

### Ветка Core

| Этап | ID | Название | Старт | Цель |
|------|----|----------|-------|------|
| 1 | `core_s1_crunches` | Скручивания | 1×8 | 3×20 |
| 2 | `core_s2_plank` | Планка | 1×15с | 3×60с |
| 3 | `core_s3_lying_leg_raise` | Подъёмы ног лёжа | 1×5 | 3×15 |
| 4 | `core_s4_hanging_leg_raise` | Подъёмы ног в висе | 1×3 | 3×10 |
| 5 | `core_s5_l_sit` | Уголок (L-sit) | 1×5с | 3×20с |
| 6 | `core_s6_dragon_flag` | Драконовый флаг | 1×1 | 3×5 |

### Аксессуары (stage = 0)

| ID | Название | Применение |
|----|----------|-----------|
| `warmup_arm_rotations` | Круговые вращения руками | Разминка Push |
| `warmup_jumping_jacks` | Прыжки «Ноги врозь» | Разминка общая |
| `warmup_dead_hang` | Вис на перекладине 20 сек | Разминка Pull |
| `warmup_leg_swings` | Махи ногами | Разминка Legs |
| `warmup_hip_circles` | Вращения тазом | Разминка Legs |
| `warmup_wrist_circles` | Вращения запястьями | Разминка Balance |
| `cooldown_shoulder_stretch` | Растяжка плеч и груди | Заминка Push |
| `cooldown_cat_cow` | Кошка-корова | Заминка Core |
| `cooldown_lat_stretch` | Растяжка широчайших | Заминка Pull |
| `cooldown_quad_stretch` | Растяжка квадрицепса | Заминка Legs |
| `cooldown_hip_flexor` | Растяжка сгибателей бедра | Заминка Legs |
| `cooldown_wrist_stretch` | Растяжка запястий | Заминка Balance |
| `cooldown_downward_dog` | Собака мордой вниз | Заминка Balance |

---

## Репозитории

Три класса в `lib/data/repositories/`, у каждого — Riverpod `Provider` в конце файла.

| Файл | Класс | Provider |
|------|-------|---------|
| `user_repository.dart` | `UserRepository` | `userRepositoryProvider` |
| `skill_progress_repository.dart` | `SkillProgressRepository` | `skillProgressRepositoryProvider` |
| `workout_repository.dart` | `WorkoutRepository` | `workoutRepositoryProvider` |

### UserRepository
- `getProfile()` — возвращает профиль или дефолтный `UserProfile()` при первом запуске
- `saveProfile(profile)` — сохраняет профиль по фиксированному ключу `"profile"`
- `hasProfile` — bool, проверяет был ли первый запуск

### SkillProgressRepository
- `getProgress(branch)` — прогресс ветки или дефолт (стартовые значения по ветке)
- `saveProgress(progress)` — ключ хранения = `branch.name`
- `getAll()` — все сохранённые ветки
- `hasProgress(branch)` — bool

### WorkoutRepository
- `addLog(log)` — append-only, auto-increment ключи Hive (`box.add`)
- `getAll()` — все логи, новые первыми
- `getForDate(date)` — лог конкретного дня (nullable)
- `getInRange(from, to)` — диапазон дат
- `getRecent(count)` — последние N логов
- `hasWorkoutToday()` — bool, используется для стрика и уведомлений
- `deleteForDate(date)` — удаляет лог за конкретный день (используется в debug-режиме)

⚠️ **Нужно добавить при реализации бонусных тренировок (v1.1):**
- `getAllForDate(date)` → `List<WorkoutLog>` — все тренировки за день (сейчас `getForDate` возвращает только одну)
- `getPrimaryForDate(date)` → `WorkoutLog?` — первая (основная) тренировка за день

---

## Доменный слой

### Модели (`lib/domain/models/`)

**`WorkoutPlan`** — сгенерированная тренировка, готовая к выполнению.
- `exercises: List<PlannedExercise>` — упорядоченный список слотов
- `totalSets` — суммарное кол-во подходов
- `estimatedDurationSec` — грубая оценка длительности

**`PlannedExercise`** — один слот в тренировке.
- `targetAmount` = повторения (для reps) или секунды (для timed) — то же соглашение, что в `SkillProgress.currentReps`

### Сервисы (`lib/domain/services/`)

**`SPService`** (`spServiceProvider`)
- `forExercise(result, exercise)` — SP за одно упражнение; warmup/cooldown (stage=0) дают 0
- `forWorkout(...)` — суммирует SP + бонус +50% за первую тренировку дня, +10% за полное завершение
- `applyToProfile(profile, sp)` — мутирует профиль: прибавляет SP, пересчитывает ранг

⚠️ **Конфликт с механикой бонусных тренировок (v1.1):**
`forWorkout` уже имеет "+50% за первую тренировку дня" (daily bonus). С введением `isPrimary`:
- **Основная** (`isPrimary=true`): SP × 1.5 (daily bonus) × 1.1 (completion) = полная формула
- **Бонусная** (`isPrimary=false`): base SP × 0.5 (50% от base, без daily bonus и completion bonus)
При реализации бонусных тренировок `forWorkout` должен принимать `isPrimary` как параметр.

**`StreakService`** (`streakServiceProvider`)
- `applyWorkout(profile, date)` → `bool` — обновляет стрик; при пропуске 1 дня тратит заморозку и возвращает `true`
- `tryAwardFreeze(profile)` → `bool` — выдаёт 1 заморозку если `streak % 7 == 0` и `freezeCount < 3`; вызывать **после** `applyWorkout`
- `isStreakAtRisk(profile)` — true если сегодня ещё не занимались (для уведомлений)
- `daysSinceLastWorkout(profile)` — вспомогательный счётчик

**Механика заморозок:**
- Зарабатываются: каждые 7 дней стрика подряд → +1 заморозка (макс. 3)
- Тратятся: автоматически при пропуске ровно 1 дня (daysSince == 2) если есть запас
- Summary-экран показывает баннер `❄️ Заморозка сохранила стрик!` / `❄️ Получена заморозка!`

**Важно — отображаемый стрик vs хранимый (UX-fix, v1.1):**
`profile.currentStreak` мутируется только внутри `applyWorkout` (т.е. при завершении тренировки).
Если пользователь пропустил дни и открыл Home — Hive хранит старое значение, UI показывает его.
Решение — **Вариант A**: вычислять `displayStreak` на лету в `homeDataProvider`, не мутируя профиль:
```
days = daysSinceLastWorkout(profile)
days <= 1                          → profile.currentStreak  (всё в порядке)
days == 2 && freezeCount > 0       → profile.currentStreak  (заморозка спасёт при следующей тренировке)
иначе                              → 0
```
Home screen читает `displayStreak`, а не `profile.currentStreak` напрямую.
Фактический сброс в Hive происходит при следующей тренировке через `applyWorkout` — как и сейчас.

**`ProgressionService`** (`progressionServiceProvider`)
- `applyResult(progress, exercise, result)` → bool (true = challenge разблокирован)
- Порядок прогрессии: повторения ↑ → подходы ↑ (с ресетом повторений) → отдых ↓ → challenge
- `advanceStage(progress, nextExercise)` — переход на следующий этап после challenge
- `applyRegression(progress, exercise, daysSkipped)` — откат при пропуске 3+ дней
- `nextExercise(progress)` — возвращает следующий этап из каталога

**`WorkoutGeneratorService`** (`workoutGeneratorServiceProvider`)
- `generateDaily({activeBranches, preferredMinutes, dayIndexOverride?})` — ротация веток по dayIndex (дни с 2020-01-01): N = min(2,total) при ≤5мин, min(3,total) при 10мин, total при ≥15мин. Warmup от первой ветки, cooldowns max 2 уникальных. Sets = progress.currentSets.
- `generateChallenge(branch)` — Challenge-план: `warmupFor(branch)` → текущий этап (1 лёгкий сет) → следующий этап (`challengeTargetReps`) → `cooldownsFor(branch).first`. Fallback на `generateDaily` если ветка завершена.
- Зависит от `SkillProgressRepository` через конструктор (инжектируется Riverpod)

### Паттерн мутации
Все сервисы **мутируют** переданные объекты (`UserProfile`, `SkillProgress`) на месте.
Сохранение — ответственность вызывающего кода через репозитории.

---

## Навигация и онбординг

### Router (`lib/core/router/app_router.dart`)

- `isOnboardingCompleteProvider` — `StateProvider<bool>`, инициализируется из `userRepository.hasProfile`
- `_RouterNotifier extends ChangeNotifier` — слушает провайдер, триггерит `GoRouter.refreshListenable`
- `routerProvider` — создаёт `GoRouter` с redirect-логикой:
  - нет профиля → всегда `/onboarding`
  - есть профиль + путь `/onboarding` → `/home`
- Маршруты: `/onboarding`, `/home`, `/workout`, `/summary`, `/profile`, `/settings`, `/branch/:branchId`, `/dev-options` (kDebugMode)
- `CaliDayApp` переведён на `ConsumerWidget` + `MaterialApp.router`

### Онбординг (`lib/features/onboarding/`)

**7 шагов** (PageView с `NeverScrollableScrollPhysics`, анимация через `ref.listen`):

| Шаг | Содержание |
|-----|-----------|
| 0 | Welcome — логотип + описание приложения |
| 1 | Как часто занимаешься спортом? (3 варианта) |
| 2 | Сколько отжиманий? (4 варианта) |
| 3 | Сколько минут в день? (3 варианта) |
| 4 | К чему стремишься? (3 варианта) |
| 5 | Есть ли турник дома? (Да / Нет) ← добавлен в сессии 23 |
| 6 | Во сколько напомнить? (6 пресетов) |

**Калибровка Push** по ответу на вопрос 2:
- 0 отжиманий → stage 1, reps=3 (стена)
- 1–5 → stage 2, reps=5 (с колен)
- 5–15 → stage 3, reps=5 (полные)
- 15+ → stage 3, reps=10, sets=2

По завершении: сохраняет `UserProfile` + `SkillProgress` для Push, Core, Legs, Balance, и Pull (если есть турник). `isOnboardingCompleteProvider = true` — роутер переходит на `/home`.

**Виджеты:**
- `OptionCard` — анимированная карточка ответа (emoji + label + description + checkmark)

### Home (`lib/features/home/screens/home_screen.dart`)

- Stats row: Streak / SP / Rank чипы
- Маскот Горо — `goro_face_[expression].svg` через `goroExpressionProvider` с `AnimatedSwitcher` (height=140)
- `_BranchProgressCard` для каждой активной ветки из `profile.activeBranches` (прогресс-бар, стадия, challenge-бейдж, tappable → `/branch/:id`)
- ChallengeCard когда `isChallengeUnlocked == true` — кнопка «Принять вызов 🏆»
- Кнопка «Тренировка дня»

---

## Архитектурные паттерны

### Инвалидация homeDataProvider после тренировки
`homeDataProvider` — `Provider.autoDispose`. После завершения тренировки
`WorkoutNotifier._finishWorkout` вызывает `_ref.invalidate(homeDataProvider)`.
Это заставляет HomeScreen обновиться и показать свежие данные (стрик, SP,
«Тренировка выполнена»).

### Тренировочный экран (WorkoutScreen)
- `workoutProvider = StateNotifierProvider.autoDispose` — план генерируется
  при открытии экрана через `WorkoutGeneratorService.generateDaily()`.
- `WorkoutPhase` enum: `exercise` | `rest` | `done`.
- Таймер управляется в `ConsumerStatefulWidget` (Timer.periodic → `notifier.tick()`).
- Timed-упражнения: таймер от `targetAmount` до 0, auto-confirm при 0.
- Rest-фаза: таймер от `restSec` до 0, пользователь может пропустить.
- При `phase == done` → `context.pushReplacement('/summary', extra: {...})`.

### Навигация workout → summary → home
- home → **push** `/workout` (обычная тренировка)
- home ChallengeCard → `challengeBranchProvider = branch` → **push** `/workout` (Challenge-тренировка)
- workout done → **pushReplacement** `/summary` (extra: {spEarned, durationSec, exerciseCount, freezeEarned, freezeUsed, challengeUnlocked, challengePassed, newStageExerciseId})
- summary → **go** `/home` (полная замена стека, HomeScreen пересоздаётся)

`WorkoutState` при `phase == done` содержит:
- `spEarned` — заработанные SP
- `freezeEarned: bool` — получена новая заморозка (стрик кратен 7)
- `freezeUsed: bool` — заморозка потрачена для сохранения стрика
- `challengeUnlocked: bool` — Challenge разблокирован впервые в этой тренировке
- `challengePassed: bool` — Challenge-тренировка успешна, этап повышен
- `newStageExerciseId: String?` — id упражнения нового этапа (если challengePassed)

### ExerciseResult semantics (MVP)
- Одна запись на упражнение (не на подход).
- `completedReps` = кол-во повторений в **последнем** подходе (для ProgressionService).
- `actualDurationSec` = секунды в последнем подходе для timed.
- SP считается по последнему подходу (недооценка при многоподходовых, OK для MVP).

---

## Дизайн-концепция Горо (ВНЕДРЕНО ✅)

**Документ:** `docs/design-concept/caliday_design_concept.md`

### Маскот — Горо
Горилла в мультяшном flat-стиле. Три позы: **Face** (иконка), **Flex** (промо/главный экран), **Idle** (меню/настройки).
Голубая повязка — бренд-акцент. Имя "Горо" (от горилла, коротко).

SVG-ассеты скопированы в `assets/goro/`:
- `goro_face.svg` ← `docs/design-concept/caliday_icon_face.svg`
- `goro_flex.svg` ← `docs/design-concept/caliday_icon.svg`
- `goro_idle.svg` ← `docs/design-concept/caliday_icon_idle.svg`

Горо появляется на экранах:
- **Home** — `goro_flex.svg`, height=140, между stats row и ветками
- **Summary** — `goro_flex.svg`, height=120, вместо emoji 🎉
- **Onboarding Welcome** — `goro_face.svg`, height=120, вместо emoji 🏋️; заголовок "Привет! Я Горо"

### Бренд-цвет (внедрён)

| Роль | HEX |
|------|-----|
| Primary | `#4DA6FF` |
| Primary Dark | `#2B7DE9` |
| Primary Light (повязка Горо) | `#A8D8FF` |
| Energy (стрики) | `#FF9500` |
| Success (прогресс) | `#34C759` |

Изменено: `main.dart` seedColor, `LaunchScreen.storyboard`, оба `launch_background.xml`, `adaptive_icon_background` в pubspec.yaml.

### Иконка приложения
- `assets/icon/icon.png` — 1024×1024, конвертирован из `caliday_icon_face.svg` через `rsvg-convert`
- `assets/icon/icon_foreground.png` — тот же Горо, но **без фона** (удалены rect/circle с градиентом); используется как `adaptive_icon_foreground` для Android
- `remove_alpha_ios: true` в `flutter_launcher_icons` — убирает альфа-канал для iOS (иначе иконка в трее = белый квадрат/Flutter-лого)
- Команда генерации: `dart run flutter_launcher_icons`

### Дизайн-ассеты v1.1 — получены, ждут интеграции

**Источник:** `docs/caliday_design_v1_1/`

| Файл | Описание |
|------|----------|
| `goro_face_happy/sad/angry/sleeping/excited/supportive.svg` | 6 выражений лица, единый шаблон слоёв |
| `goro_flex_v2.svg` | Горо флекс — улучшенная анатомия |
| `goro_idle_v2.svg` | Горо idle — улучшенная анатомия |
| `skala_neutral.svg` | Скала — руки скрещены, нейтральный взгляд |
| `skala_approve.svg` | Скала — foreshortened большой палец, золотые искры |

**Структура слоёв face-SVG (все 6 идентичны по static-части):**
```
Static:  #layer-bg, #layer-head, #layer-face-skin, #layer-ears, #layer-nose, #layer-headband
Dynamic: #layer-brows (#brow-left / #brow-right)
         #layer-eyes  (#eye-*-socket / #eye-*-white / #eye-*-pupil / #eye-*-shine1/2)
         #layer-mouth (#mouth-line-upper / #mouth-curve / #mouth-fill / #mouth-lowerlip)
```

**Цвета Скалы:** тело `#2E2A22`/`#3D3728`, морда `#6B4F38→#8A6848`,
рога `#8B7355→#A89060`, нос-кольцо `#C8A040` (золото),
**фон `#5C1A1A→#3A0C0C`** (тёмно-красный — «арена испытания», отличается от синего Горо).

### ~~Система выражений Горо~~ ✅ сессия 21

~~Реализован `GoroExpressionProvider` (`lib/core/providers/goro_expression_provider.dart`).
Логика: sleeping(23-06) > happy(workout done) > angry(22+, streak>0) > sad(20+) > supportive(daysSince≥2) > happy.
Ассеты: `assets/goro/goro_face_[expression].svg` (6 штук) + `goro_flex_v2.svg` + `goro_idle_v2.svg`.
`assets/skala/skala_neutral.svg` + `skala_approve.svg` — Скала на Challenge-экране.
Home: AnimatedSwitcher по expression. Summary: goro_flex_v2. Profile: goro_idle_v2.
Onboarding welcome: goro_face_happy. Workout (Challenge): _SkalaDisplay, фон #5C1A1A.~~

---

## ~~Экран «Возможности разработчика»~~ ✅ ГОТОВО (session 22)

**Проблема текущего подхода:** дебаг-кнопки вшиты прямо в `settings_screen.dart` как
хардкодные сценарии (`Стрик → 6`, `Симулировать пропуск дня`). Под каждый новый тест
нужна новая кнопка. Нет возможности задать произвольное состояние.

**Решение:** отдельный экран `DeveloperOptionsScreen`, доступный из настроек только при
`kDebugMode`. Не хардкодные сценарии, а **прямые элементы управления** каждым полем состояния.
Любая комбинация тестовых условий собирается без написания нового кода.

### Структура экрана

**Раздел: Профиль**

| Контрол | Тип | Действие |
|---------|-----|---------|
| Текущий стрик | `±` степпер + ввод числа | мутирует `profile.currentStreak` |
| Дата последней тренировки | чипы: Сегодня / Вчера / 2 дня / 3 дня / Никогда | мутирует `profile.lastWorkoutDate` |
| SP | `±` степпер с шагом 100 + ввод числа | мутирует `profile.totalSP` |
| Заморозки | чипы: 0 / 1 / 2 / 3 | мутирует `profile.streakFreezeCount` |
| Ранг | `DropdownButton<Rank>` | мутирует `profile.rank` |

Кнопка **«Сохранить профиль»** внизу раздела — один вызов `userRepo.saveProfile(profile)`.
Все изменения в разделе — только in-memory до нажатия кнопки.

**Раздел: Прогресс веток**

Для каждой активной ветки (Push, Core и т.д.):

| Контрол | Тип | Действие |
|---------|-----|---------|
| Этап | `±` степпер (1 … max) | мутирует `progress.currentStage` |
| Повторения | `±` степпер | мутирует `progress.currentReps` |
| Подходы | чипы 1 / 2 / 3 | мутирует `progress.currentSets` |
| Challenge разблокирован | `Switch` | мутирует `progress.isChallengeUnlocked` |
| Кнопка «Сохранить» | — | `progressRepo.saveProgress(progress)` |

**Раздел: Журнал тренировок**

| Кнопка | Действие |
|--------|---------|
| Удалить тренировку сегодня | `workoutRepo.deleteForDate(today)` |
| Добавить фейковую тренировку за день | date picker → создаёт `WorkoutLog` с нулевыми данными |
| Удалить все тренировки | полная очистка `WorkoutRepository` |

**Раздел: Уведомления**

| Кнопка | Действие |
|--------|---------|
| Утреннее → сейчас | `debugShowNow(id: 1)` |
| Вечернее → сейчас | `debugShowNow(id: 2)` |
| Угроза стрику → сейчас | `debugShowNow(id: 3)` |
| Потеря стрика → сейчас | `debugShowNow(id: 4)` |
| Показать все запланированные | вывод списка через `getScheduledNotifications()` в диалог |

**Раздел: Приложение**

| Кнопка | Действие |
|--------|---------|
| Полный сброс → онбординг | очистить все Hive-боксы + `isOnboardingCompleteProvider = false` |
| Дамп состояния (JSON) | показать весь профиль + прогресс в диалоге/snackbar |

### Архитектура реализации

```
lib/features/settings/screens/
├── settings_screen.dart       ← убрать все if(kDebugMode) блоки
│                                 добавить одну плитку "Возможности разработчика"
│                                 защищённую if(kDebugMode)
└── developer_options_screen.dart  ← новый экран
```

**Реализовано:**
- `lib/features/settings/screens/developer_options_screen.dart` — полный экран (`ConsumerStatefulWidget`)
- Роутер: `/dev-options` — добавлен под `if (kDebugMode)`
- Плитка «Возможности разработчика» в `settings_screen.dart` под `if (kDebugMode)`
- Использует все репозитории напрямую; после сохранения `ref.invalidate(homeDataProvider)`

---

## Идеи для будущих версий

### Сводный backlog по версиям

| Версия   | Фича                                                                      | Статус                                                                   |
|----------|---------------------------------------------------------------------------|--------------------------------------------------------------------------|
| **v1.1** | Достижения (27 штук)                                                      | ✅ реализовано                                                            |
| **v1.1** | Бонусные тренировки (multiple per day)                                    | ✅ реализовано                                                            |
| **v1.1** | Анимации упражнений (Lottie) — Push ветка                                 | ✅ реализовано (7/7 этапов)                                               |
| **v1.2** | Звук + вибрация во время тренировки                                       | ✅ реализовано                                                            |
| **v1.2** | Вибрация на Android (не работает, нужен фикс)                             | ✅ реализовано (VIBRATE permission)                                      |
| **v1.2** | Таймер обратного отсчёта: увеличить до 5 сек, изменить поведение          | ✅ реализовано                                                            |
| **v1.2** | История тренировок: детальный просмотр (открыть запись)                   | ✅ реализовано (bottom sheet)                                             |
| **v1.2** | Home экран: переделать иерархию — тренировка дня в фокусе, ветки вторичны | ✅ реализовано (bottom nav: Тренировка / Прогресс / Профиль)             |
| **v1.2** | Замена эмодзи на Material Icons (рендеринг одинаков на всех устройствах)  | ✅ реализовано                                                            |
| **v1.2** | Инфо-баннер на экране Прогресса (ветки — необязательные)                  | ✅ реализовано                                                            |
| **v1.2** | Адаптивный UI для landscape                                               | 💡 идея                                                                  |
| **v1.2** | Заморозки стрика                                                          | ✅ реализовано (earn каждые 7 дней, auto-spend при пропуске 1 дня, cap=3) |
| **v1.2** | Анимации Lottie на Branch Journey Screen                                  | 💡 идея (ждёт других веток)                                              |
| **v1.3** | Home Screen Widget (iOS + Android)                                        | ✅ реализовано (Flutter+Android полностью; iOS требует Xcode target)     |
| **v1.3** | Интеграция Apple Health / Health Connect                                  | 📐 спроектировано сессии 2026-03-02                                      |
| **v1.4** | Друзья (Bluetooth / QR-обмен, без сервера)                                | 📐 спроектировано сессии 2026-03-02                                      |
| **v1.4** | Базовая интеграция со смарт-часами                                        | 📐 спроектировано сессии 2026-03-02                                      |
| **v1.5** | Полноценное приложение на часы (WatchKit / Wear OS)                       | 💡 идея                                                                  |
| **v1.2** | Экран «О приложении» (версия, донат, ссылки, копирайт)                    | ✅ реализовано                                                            |
| **?**    | Кнопка «Поддержать автора» (донаты через Apple Pay / Google Pay)          | 💡 идея                                                                  |

Обозначения: ✅ сделано · ⚠️ спроектировано · 🔒 ждёт внешнего ресурса · 💡 идея · 📐 спроектировано в сессии

---

### v1.1 — Обсуждённые задачи (сессия 2026-02-27)

#### ~~Редизайн системы Challenge~~ ✅ сессия 20

~~Реализована новая схема: кнопка «Принять вызов 🏆» на Home, пользователь сам решает когда готов.
Challenge можно провалить — остаёмся на этапе. Challenge можно откладывать сколько угодно.
`Exercise.challengeTargetReps` — отдельный норматив перехода. `generateChallenge(branch)` в генераторе.
Баннеры на Summary: разблокировка вызова + успешный переход этапа.~~

#### ~~UX-fix: отображаемый стрик~~ ✅ сессия 18
~~Реализовать `displayStreak` в `homeDataProvider` по формуле Вариант A (см. раздел StreakService выше).
Без этого Home показывает устаревший стрик, если пользователь открыл приложение после пропуска дней.~~

#### ~~Автоопределение языка системы~~ ✅ сессия 18
~~Flutter предоставляет `WidgetsBinding.instance.platformDispatcher.locale` без плагинов.~~
В `main.dart` (до инициализации профиля) вычислять:
```dart
final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
final detectedLocale = systemLocale.languageCode == 'ru' ? 'ru' : 'en';
```
- **Первый запуск:** `localeProvider` инициализируется через `detectedLocale` → welcome-экран онбординга показывается сразу на правильном языке
- **Повторный запуск:** `profile.locale ?? detectedLocale` (вместо `?? 'ru'`)
- Пользователь по-прежнему может переключить язык вручную в настройках

#### ~~Уведомление о сгоревшем стрике~~ ✅ сессия 18
~~Добавить ID 4 `streak_lost`. Схема:~~
- После каждого завершения тренировки (`_finishWorkout`) планировать уведомление
  на следующее утро (время утреннего напоминания пользователя + 30 мин, или фиксировано 09:30)
- Текст содержит реальную длину стрика, известную в момент планирования:
  *"Твой стрик X дней пропал 😔 Начни новую серию — первый шаг всегда самый важный!"*
- Отправлять только если `currentStreak >= 2` (потеря стрика в 1 день несущественна)
- Добавить ID 4 в `cancelDayReminders()` — отменять при завершении следующей тренировки

#### ~~Tech debt: вопрос «сколько минут» в онбординге не влияет ни на что~~ ✅ сессия 18
`workoutMinutes` выбирается на шаге 3 онбординга и сохраняется в `OnboardingState`,
но в `completeOnboarding()` **не передаётся** в `UserProfile` и не используется в генераторе.
План реализации:
1. Добавить `@HiveField(12) int? preferredWorkoutMinutes` в `UserProfile`
2. В `completeOnboarding()` передавать `workoutMinutes?.minutes`
3. В `WorkoutGeneratorService.generateDaily()` использовать для управления объёмом:
   - 5 мин → 1 основное упражнение на ветку (минимальный сет)
   - 10 мин → стандарт (текущее поведение, Push + Core)
   - 15 мин → дополнительные подходы или 2-3 основных упражнения

#### ~~Новые ветки прогрессии~~ ✅ сессия 23

~~Добавлены Pull (6), Legs (5), Balance (6). `Exercise.requiresEquipment`, `UserProfile.hasPullUpBar`,
`UserProfile.activeBranches`, ротация по dayIndex, онбординг шаг 5 (турник), настройки.~~

Исходные таблицы (справочно):

**Pull (6 этапов) — ⚠️ требует турник**

| Этап | ID | Название | Старт | Цель | Отдых старт→цель | SP/rep |
|------|----|----------|-------|------|------------------|--------|
| 1 | `pull_s1_australian` | Австралийские подтягивания | 1×5 | 3×15 | 60с→30с | 1 |
| 2 | `pull_s2_negative` | Негативные подтягивания | 1×3 | 3×8 | 90с→45с | 2 |
| 3 | `pull_s3_pullup` | Подтягивания | 1×1 | 3×10 | 90с→45с | 3 |
| 4 | `pull_s4_close_grip` | Подтягивания узким хватом | 1×3 | 3×10 | 90с→45с | 3 |
| 5 | `pull_s5_archer` | Подтягивания лучника | 1×2 | 3×6 | 90с→60с | 4 |
| 6 | `pull_s6_one_arm` | Подтягивания на одной руке | 1×1 | 3×3 | 120с→90с | 5 |

Разминка Pull: `warmup_dead_hang` — вис на перекладине 20 сек (grip + плечи)
Заминка Pull: `cooldown_lat_stretch` — растяжка широчайших (наклон, рука над головой)

**Legs (5 этапов) — без оборудования**

| Этап | ID | Название | Старт | Цель | Отдых старт→цель | SP/rep |
|------|----|----------|-------|------|------------------|--------|
| 1 | `legs_s1_squat` | Приседания | 1×10 | 3×20 | 45с→20с | 1 |
| 2 | `legs_s2_lunge` | Выпады | 1×6 | 3×12 | 45с→20с | 1 |
| 3 | `legs_s3_bulgarian` | Болгарские приседания | 1×5 | 3×10 | 60с→30с | 2 |
| 4 | `legs_s4_assisted_pistol` | Пистолетик с опорой | 1×3 | 3×8 | 60с→30с | 3 |
| 5 | `legs_s5_pistol` | Пистолетик | 1×1 | 3×5 | 90с→45с | 5 |

Разминка Legs: `warmup_leg_swings` — махи ногами вперёд-назад и в стороны (10 каждое)
Разминка Legs: `warmup_hip_circles` — вращения тазом (10 в каждую сторону)
Заминка Legs: `cooldown_quad_stretch` — растяжка квадрицепса стоя (30 сек на ногу)
Заминка Legs: `cooldown_hip_flexor` — растяжка сгибателей бедра в выпаде (30 сек)

**Balance (6 этапов) — без оборудования**

| Этап | ID | Название | Старт | Цель | Отдых старт→цель | SP/10с |
|------|----|----------|-------|------|------------------|--------|
| 1 | `bal_s1_one_leg_stand` | Стойка на одной ноге | 1×20с | 3×60с | 30с→15с | 1 |
| 2 | `bal_s2_one_arm_plank` | Планка на одной руке | 1×10с | 3×30с | 45с→20с | 2 |
| 3 | `bal_s3_crow_prep` | Подвод к позе ворона | 1×5с | 3×20с | 45с→20с | 3 |
| 4 | `bal_s4_crow_pose` | Поза ворона (Crow Pose) | 1×3с | 3×15с | 60с→30с | 4 |
| 5 | `bal_s5_wall_hs` | Стойка на руках у стены | 1×10с | 3×30с | 60с→30с | 4 |
| 6 | `bal_s6_free_hs` | Свободная стойка на руках | 1×5с | 3×30с | 90с→60с | 5 |

Разминка Balance: `warmup_wrist_circles` — вращения запястьями (обязательно перед стойкой на руках)
Заминка Balance: `cooldown_wrist_stretch` — растяжка запястий (прямые руки, пальцы к себе, 30 сек)
Заминка Balance: `cooldown_downward_dog` — собака мордой вниз (растяжка после инверсий, 30 сек)

**Технические задачи для новых веток:**
- Добавить флаг `requiresEquipment: bool` в модель `Exercise` (Pull = true, остальные = false)
- UI: предупреждение на карточке Pull «Нужен турник»
- Онбординг: дополнительный вопрос «Есть ли турник дома?» — если нет, Pull не включается в daily до разблокировки вручную
- `WorkoutGeneratorService`: поддержка выбора активных веток
- Все разминки/заминки для новых веток описаны выше — добавить в `ExerciseCatalog`

### v1.2 — Идеи

#### Адаптивный UI для горизонтальной ориентации

Сейчас все экраны рассчитаны только на portrait. В `main.dart` вызывается
`SystemChrome.setPreferredOrientations([portraitUp, portraitDown])` — блокировка включена.

Когда потребуется поддержка landscape:
1. Убрать блокировку в `main.dart`
2. Переработать раскладки ключевых экранов (Home, Workout, Summary) под широкий экран,
   например через `LayoutBuilder` + двухколоночный layout при `maxWidth > 600`
3. Особое внимание: `_TimedDisplay` (круговой таймер), `_RepsDisplay` (±-счётчик)
   и карточки Home — они могут обрезаться на низком landscape-экране

#### ~~Экран «Путь прогрессии» ветки (Branch Journey Screen)~~ ✅ сессия 24

**Реализовано:**
- Маршрут `/branch/:branchId` в роутере
- `lib/features/home/screens/branch_journey_screen.dart` — `BranchJourneyScreen(branchId: BranchId)`
- Вертикальная timeline: `_StageCircle` (число / чекмарк / серый) + `_StageRow` (три состояния: `completed` / `current` / `locked`)
- `_BranchProgressCard` на Home теперь `onTap: () => context.push('/branch/${branch.name}')`
- `ExerciseCatalog.progressionFor(branch)` — новый статический метод
- Шапка: «Пройдено X из Y этапов»; текущий этап показывает reps×sets, rest, прогресс-бар

**Будущее улучшение (когда появятся анимации в v1.1):**
Миниатюры Lottie/Rive рядом с каждым этапом — пройденные/текущий воспроизводятся, будущие затенены.

### v1.1 — Улучшения продукта

- ~~**Тёмная тема**~~ ✅ сессия 22

- **Анимация упражнения** — на **экране тренировки** (WorkoutScreen) показывать Lottie-анимацию
  Горо, выполняющего упражнение, пока пользователь считает повторения / держит время.
  Та же анимация переиспользуется на **Branch Journey Screen** в v1.2 (с персонажем Бруно).
  43 анимации суммарно по всем 5 веткам + аксессуарам — см. `docs/design-concept/caliday_design_concept.md` §5.5.
  Формат: Lottie JSON, `assets/animations/[exercise_id].json`.
  Приоритет: средний; зависит от получения ассетов от дизайнера.

---

### Бонусные тренировки (multiple workouts per day) — ✅ реализовано

**Концепция:** пользователь может делать сколько угодно тренировок в день.

**Правила:**
- **Основная тренировка** (первая за день): полные SP, двигает прогрессию, засчитывается в стрик.
- **Бонусные тренировки** (2-я и далее): 50% SP от основной, прогрессия не двигается, стрик не меняется, лимита нет.
- Генератор создаёт ту же тренировку что и основная (идентичный план).

**Определение «основная vs бонус»:** в `WorkoutLog` добавить поле `isPrimary: bool`.
При старте тренировки проверять: есть ли уже `WorkoutLog` за сегодня → если да, `isPrimary = false`.

**Статистика / история:**
- В истории бонусные тренировки помечаются иконкой/плашкой «+бонус»
- На Summary: если это бонусная тренировка — особое сообщение («Ты сделал X тренировок за день! 💪»)
- В `WorkoutLog`: `spEarned` хранит уже пересчитанные очки (50%), не оригинальные.

**Технические изменения:**
- `WorkoutLog.isPrimary: bool` — `@HiveField(5)` (следующий свободный после 4)
- `WorkoutGeneratorService`: без изменений — план одинаковый
- `WorkoutNotifier._finishWorkout`: перед расчётом SP проверить isPrimary
- `ProgressionService.advanceProgress()`: вызывать только если `isPrimary == true`
- Виджет на рабочем столе: показывает «Ещё раз →» вместо «Начать →» если `workoutDoneToday == true` (но всё равно ведёт в тренировку)

---

### ~~Форсированный Challenge с Branch Journey Screen~~ ✅ сессия 26

**Концепция:** пользователь может в любой момент нажать «Пройти испытание» прямо на экране
Branch Journey и запустить Challenge на переход к следующему этапу, не дожидаясь автоматической разблокировки.

**Правила:**
- Доступно с первого дня на этапе, без минимального порога
- Только переход на **следующий** этап (не произвольный)
- Провал — без кулдауна, можно повторить хоть сразу
- Та же механика что и обычный Challenge: `generateChallenge(branch)`, `advanceStage` при успехе
- **Старая система остаётся:** `isChallengeUnlocked == true` → кнопка «Принять вызов» на Home. Обе точки входа сосуществуют, дублирование кнопок допустимо.

**UX на Branch Journey Screen:**
- На строке текущего этапа — кнопка «Пройти испытание 🏆»
- На заблокированных и пройденных этапах кнопки нет
- Если `isChallengeUnlocked == true` — та же кнопка, просто два входа в одно

**Технические изменения:**
- `BranchJourneyScreen`: добавить кнопку на `_StageRow` с состоянием `current`
- Кнопка → `context.push('/workout', extra: WorkoutStartParams(type: SetType.challenge, branch: branchId))`
- Или отдельный маршрут `/challenge/:branchId`
- Никаких новых полей в модели не требуется

---

### Достижения (achievements) — ✅ реализовано

#### Концепция

Статический каталог достижений. Условия проверяются после каждой тренировки и перехода этапа. Секретные достижения (`isSecret: true`) не видны в списке до получения. **Вознаграждение:** только визуальное (badge на Summary + секция в Profile). Заморозки за достижения — кандидат для v1.2.

#### Хранение

Отдельный Hive-бокс `'achievements'` типа `Box<int>` (примитив, адаптер не нужен):

```
ключ:   achievementId (String)
значение: earnedAt.millisecondsSinceEpoch (int)
```

Бокс живёт постоянно (как `workout_log`). Через него получаем полный список earned-достижений, сортируем по дате для Profile.

```dart
class AchievementRepository {
  static const _boxName = 'achievements';
  Box<int> get _box => Hive.box<int>(_boxName);

  bool isEarned(String id) => _box.containsKey(id);
  Future<void> markEarned(String id) async {
    if (!isEarned(id)) await _box.put(id, DateTime.now().millisecondsSinceEpoch);
  }
  // All earned IDs sorted newest-first
  List<String> getAllEarned() => _box.keys
      .cast<String>()
      .toList()
    ..sort((a, b) => (_box.get(b) ?? 0).compareTo(_box.get(a) ?? 0));
  DateTime? earnedAt(String id) {
    final ms = _box.get(id);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }
}
```

Инициализация в `main.dart`: `await Hive.openBox<int>('achievements');`

#### Каталог достижений (27 штук)

| ID | Название (RU) | Эмодзи | Условие | Секрет |
|----|--------------|--------|---------|--------|
| **Первые шаги** | | | | |
| `first_workout` | Первый шаг | 🐾 | Завершить первую тренировку | — |
| `first_challenge` | Принял вызов | 🏆 | Первый успешный Challenge (переход этапа) | — |
| **Регулярность** | | | | |
| `streak_3` | Три в ряд | 🔥 | 3-дневный стрик | — |
| `streak_7` | Неделя без пропусков | 📅 | 7-дневный стрик | — |
| `streak_30` | Марафонец | 🏃 | 30-дневный стрик | — |
| `streak_100` | Железная воля | ⚡ | 100-дневный стрик | — |
| **Объём** | | | | |
| `workouts_10` | Десятка | 💪 | 10 завершённых тренировок | — |
| `workouts_50` | Полсотни | 🎯 | 50 завершённых тренировок | — |
| `workouts_100` | Центурион | 🏅 | 100 завершённых тренировок | — |
| **Ранги** | | | | |
| `rank_amateur` | Любитель | ⭐ | Ранг Любитель (500 SP) | — |
| `rank_sportsman` | Спортсмен | ⭐⭐ | Ранг Спортсмен (2 000 SP) | — |
| `rank_athlete` | Атлет | ⭐⭐⭐ | Ранг Атлет (5 000 SP) | — |
| `rank_master` | Мастер | 🥇 | Ранг Мастер (15 000 SP) | — |
| `rank_legend` | Легенда | 👑 | Ранг Легенда (50 000 SP) | — |
| **Push** | | | | |
| `push_s3` | Полное отжимание | 💥 | Разблокировать этап 3 Push | — |
| `push_s6` | Одна рука | 🤜 | Разблокировать этап 6 Push | — |
| `push_complete` | Властелин Push | 🦍 | Пройти все 7 этапов Push | — |
| **Core** | | | | |
| `core_s2` | Железная доска | 🪨 | Разблокировать этап 2 Core (Планка) | — |
| `core_s5` | Уголок | 📐 | Разблокировать этап 5 Core (L-sit) | — |
| `core_complete` | Железный кор | 🏋️ | Пройти все 6 этапов Core | — |
| **Pull** | | | | |
| `pull_s3` | Первое подтягивание | 🔝 | Разблокировать этап 3 Pull | — |
| `pull_complete` | Король перекладины | 👑 | Пройти все 6 этапов Pull | — |
| **Legs** | | | | |
| `legs_s5` | Пистолетик | 🦵 | Разблокировать этап 5 Legs | — |
| `legs_complete` | Стальные ноги | 🦾 | Пройти все 5 этапов Legs | — |
| **Balance** | | | | |
| `balance_s4` | Поза ворона | 🐦 | Разблокировать этап 4 Balance | — |
| `balance_s6` | Свободная стойка | 🤸 | Разблокировать этап 6 Balance | — |
| `balance_complete` | Мастер равновесия | ⚖️ | Пройти все 6 этапов Balance | — |
| **Секретное** | | | | |
| `all_complete` | Полный комплект | 🌟 | Завершить все 5 веток | ✅ |

#### AchievementService

```dart
class AchievementService {
  /// Call after _finishWorkout. Returns IDs of newly earned achievements.
  List<String> checkAfterWorkout({
    required UserProfile profile,
    required WorkoutLog log,
    required int totalWorkouts,    // workoutRepository.totalCount
    required AchievementRepository achievementRepo,
  });

  /// Call after advanceStage. Returns IDs of newly earned achievements.
  List<String> checkAfterStageAdvance({
    required BranchId branch,
    required int newStage,         // progress.currentStage after advance
    required Map<BranchId, SkillProgress> allProgress,
    required AchievementRepository achievementRepo,
  });
}
```

**Триггер-точки:**
- `WorkoutNotifier._finishWorkout`:
  1. → `checkAfterStageAdvance` (если был переход этапа)
  2. → `checkAfterWorkout` (всегда)
  3. Объединённый результат `newAchievements` передаётся в `WorkoutSummary`

#### UI — где показывать

**Summary Screen — баннер новых достижений:**
Если `newAchievements.isNotEmpty` — карточка `_AchievementsEarnedBanner` с плитками (эмодзи + название). Тап по плитке → показывает описание достижения (BottomSheet или Dialog).

**Profile Screen — секция «Достижения»:**
- Показывает последние 4–5 earned-достижений (из `getAllEarned().take(5)`) в виде горизонтального ряда кружков с эмодзи.
- Кнопка «Все достижения →» → `/achievements` — полный список.
- Тап по кружку → BottomSheet с названием, описанием, датой получения.

**Экран /achievements — полный список:**
- Секция «Полученные» (дата получения): earned-достижения sorted newest-first.
- Секция «Заблокированные»: все не earned. Секретные показываются как `🔒 ???`.
- Тап → BottomSheet с деталями (или затемнённым описанием для locked/secret).

#### Технические изменения

1. `lib/data/repositories/achievement_repository.dart` — новый файл
2. `lib/domain/services/achievement_service.dart` — новый файл
3. `lib/data/static/achievement_catalog.dart` — статический список `Achievement` (id, emoji, isSecret)
4. `main.dart` — `await Hive.openBox<int>('achievements');`
5. `WorkoutNotifier._finishWorkout` — вызов сервиса
6. `WorkoutSummary` (domain model) — добавить `List<String> newAchievements`
7. `SummaryScreen` — `_AchievementsEarnedBanner`
8. `ProfileScreen` — секция достижений (последние 5)
9. `lib/features/profile/screens/achievements_screen.dart` — новый экран
10. `app_router.dart` — маршрут `/achievements`
11. l10n — названия и описания всех 27 достижений

---

### Home Screen Widget — спроектировано, не реализовано

**Размеры:** Small (2×2) и Medium (2×4).

**Визуал:** Горо + цифры. Два состояния:

| Состояние | Горо | Текст кнопки |
|-----------|------|--------------|
| Pending (не тренировался) | idle-поза | «Начать →» |
| Done (тренировался сегодня) | flex-поза | «Ещё раз →» |

**Small виджет:**
```
┌─────────────────┐
│   [Горо idle]   │
│    🔥  12       │
│    ⚡ 340 SP    │
└─────────────────┘
```
Весь виджет тапабелен → deep link `caliday://workout`.

**Medium виджет:**
```
┌──────────────────────────────┐
│          CaliDay             │
│ [Горо]   🔥 12 дней         │
│          ⚡ 340 SP           │
│          Сегодня: ✅         │
│          [  Начать →  ]      │
└──────────────────────────────┘
```

**Данные (сохраняются через `home_widget.saveWidgetData()`):**

| Ключ | Тип | Источник |
|------|-----|---------|
| `streak` | int | `userProfile.currentStreak` |
| `totalSP` | int | `userProfile.totalSP` |
| `workoutDoneToday` | bool | `lastWorkoutDate == today` |
| `lastUpdated` | int (unix ms) | момент сохранения |

Обновляются при: старте приложения, завершении тренировки, открытии Home.

**Ассеты (нужен экспорт из SVG в PNG):**
- `goro_widget_idle.png` — из `caliday_icon_idle.svg` (2× и 3×)
- `goro_widget_flex.png` — из `caliday_icon.svg` (2× и 3×)
- iOS: в Asset Catalog Widget Extension
- Android: в `res/drawable-xhdpi/`, `res/drawable-xxhdpi/`

**Deep link:** `caliday://workout`
- iOS: `Info.plist` URL Types
- Android: `AndroidManifest.xml` intent-filter
- Flutter: `go_router` initialLocation из входящего URI

**Стек реализации:**
- Flutter: пакет `home_widget` (передача данных + триггер обновления)
- iOS: Swift + SwiftUI WidgetKit (Widget Extension таргет в Xcode)
- Android: Kotlin + Jetpack Compose Glance

**Порядок реализации:**
1. `home_widget` в pubspec + сохранение данных в Flutter (~2ч)
2. Deep link схема iOS + Android (~1ч)
3. Экспорт PNG ассетов Горо (~30мин)
4. SwiftUI виджет iOS (~4ч)
5. Glance виджет Android (~4ч)

---

### ~~v1.2 — Звук и вибрация во время тренировки~~ ✅ сессия 30

~~Пользователь может тренироваться не глядя в телефон: аудио- и тактильные сигналы
информируют о ключевых моментах тренировки.~~

**Реализовано:**
- `audioplayers ^6.1.0` в pubspec; `assets/sounds/` зарегистрирован
- `lib/core/services/sound_service.dart` — `SoundService.instance`, методы `tick()`, `ding()`, `pop()`, `complete()`
- `HapticFeedback`: light=тики, heavy=ding+complete, medium=pop; complete = 3×heavy через 150мс
- `UserProfile @HiveField(19) soundEnabled`, `@HiveField(20) hapticEnabled` (null → true)
- Settings: два Switch в разделе ТРЕНИРОВКА
- `workout_screen.dart`: tick при `timerSec ∈ [1..3]` во время rest; `ref.listen` на фазы для ding/pop/complete

---

### v1.3 — Друзья (Friends) — спроектировано, не реализовано

#### Концепция

Социальная фича без сервера. Данные хранятся только локально; обмен происходит
peer-to-peer при физической встрече через QR-код или Bluetooth LE. При каждой
новой встрече snapshot друга обновляется. Нет аккаунтов, нет облака, нет постоянного
подключения — только «встретились, синхронизировались».

#### Механика обмена

Два способа добавить друга, используются вместе:

**A. QR-код (надёжный, кроссплатформенный)**
- «Поделиться» → генерируется QR с JSON-снапшотом профиля
- Друг сканирует QR → данные добавляются в локальный Hive-бокс
- Обновление: при следующей встрече — повторное сканирование QR

**B. Bluetooth LE discovery (удобный, автоматический)**
- Приложение в фоне рекламирует BLE-сервис с UUID `caliday-peer`
- При открытии экрана «Друзья» — сканирование 30 сек, показ найденных
  CaliDay-устройств в секции «Рядом сейчас»
- Тап → обмен данными по BLE (GATT: write/notify)
- Используется только для discovery + small payload (< 512 bytes)

#### Данные снапшота (FriendProfile)

```dart
// HiveType 9
@HiveType(typeId: 9)
class FriendProfile {
  @HiveField(0) final String id;              // UUID, генерируется при первом запуске
  @HiveField(1) final String displayName;     // имя (пользователь задаёт в Settings)
  @HiveField(2) final int totalSP;
  @HiveField(3) final int currentStreak;
  @HiveField(4) final int longestStreak;
  @HiveField(5) final int rankIndex;          // Rank.index
  @HiveField(6) final Map<String, int> branchStages; // branchId.name → currentStage
  @HiveField(7) final DateTime profileDate;   // когда данные были актуальны
  @HiveField(8) final DateTime lastSynced;    // когда мы последний раз получили данные
}
```

Hive typeId 9 зарезервирован. Бокс: `'friends'` (`Box<FriendProfile>`).

#### Собственный идентификатор пользователя

- `UserProfile.peerId: String?` — `@HiveField(17)`, UUID v4, генерируется при первом запуске
  и больше не меняется. Нужен для идентификации при BLE-обнаружении.
- `UserProfile.displayName: String?` — `@HiveField(18)`, задаётся в Settings (если null — «Атлет»)

#### JSON-снапшот для QR (< 1KB)

```json
{
  "v": 1,
  "id": "uuid",
  "name": "Имя",
  "sp": 3400,
  "streak": 14,
  "longestStreak": 28,
  "rank": 2,
  "stages": {"push": 3, "core": 2, "legs": 1},
  "date": 1740000000
}
```

QR кодируется как `caliday://friend?data=<base64url>`.

#### UI

**Settings** — новое поле «Имя (для друзей)» и toggle «Видимость для друзей по Bluetooth».

**Profile Screen** — секция «Друзья» (если список не пуст):
- Горизонтальный ряд аватаров (эмодзи ранга + имя + streak)
- Кнопка «Все друзья →» → `/friends`

**Экран `/friends`:**
```
┌────────────────────────────────┐
│  Друзья                   [+QR] │
├────────────────────────────────┤
│  Рядом сейчас (BLE):           │
│  ● Антон · 🔥14 · Спортсмен   │ ← обнаружен по BLE
│    [Синхронизировать]          │
├────────────────────────────────┤
│  Мои друзья:                   │
│  Антон    Rank ⭐⭐  SP 3400    │
│           🔥 14 дней  (3 дн. назад) │
│  Маша     Rank ⭐    SP 890    │
│           🔥 7 дней   (14 дн. назад)│
├────────────────────────────────┤
│  [Добавить по QR-коду]         │
│  [Показать мой QR]             │
└────────────────────────────────┘
```

- «Последняя синхронизация: X дней назад» — серый текст под именем
- Нет leaderboard в v1.3, только список с прогрессом (leaderboard → v1.4)

#### Технические задачи

| # | Задача |
|---|--------|
| 1 | `FriendProfile` модель + Hive adapter (typeId=9) |
| 2 | `UserProfile.peerId` (@HiveField(17)) + `displayName` (@HiveField(18)) |
| 3 | `FriendRepository` — Hive-бокс `'friends'` |
| 4 | QR-генерация: пакет `qr_flutter`, JSON→base64url encode |
| 5 | QR-сканирование: пакет `mobile_scanner` |
| 6 | BLE-сканирование (discovery): пакет `flutter_blue_plus` |
| 7 | BLE-GATT обмен данными (маленький payload) |
| 8 | `FriendsScreen` + `FriendDetailBottomSheet` |
| 9 | Profile: секция «Друзья» |
| 10 | Settings: поле «Имя» + toggle видимости |
| 11 | l10n: все строки |
| 12 | `app_router.dart`: маршрут `/friends` |

**Пакеты:**
- `qr_flutter` — генерация QR
- `mobile_scanner` — сканирование QR (активно поддерживается)
- `flutter_blue_plus` — BLE discovery (iOS + Android)

**Разрешения:**
- iOS: `NSBluetoothAlwaysUsageDescription`, `NSCameraUsageDescription` (QR)
- Android: `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `CAMERA`

---

### v1.3 — Интеграция Apple Health / Health Connect — спроектировано, не реализовано

#### Концепция

После завершения тренировки CaliDay записывает workout-сессию в системное
Health-хранилище. Пользователь видит тренировки CaliDay в Apple Health / Google Fit.
Приложение также может читать массу тела и пульс для более точного расчёта калорий.

#### Что пишем (Write)

| Метрика | Apple Health (HealthKit) | Google Health Connect |
|---------|--------------------------|----------------------|
| Тип тренировки | `HKWorkoutActivityType.traditionalStrengthTraining` | `ExerciseSessionRecord(type=STRENGTH_TRAINING)` |
| Длительность | `durationSec` из `WorkoutLog` | то же |
| Активные калории | расчётные (см. ниже) | `TotalCaloriesBurnedRecord` |

#### Что читаем (Read, опционально)

| Метрика | Источник | Использование |
|---------|---------|--------------|
| Масса тела | Health (последнее измерение) | точный расчёт калорий |
| Пульс в покое | Health | показ в Profile stats |

#### Расчёт калорий (MET-формула)

Калории = MET × вес(кг) × длительность(ч)

MET для калистеники (приблизительно):
- Лёгкие этапы (stage 1–2): MET 4.0
- Средние (stage 3–4): MET 5.5
- Тяжёлые (stage 5+): MET 7.0

Вес по умолчанию если недоступен: 70 кг.

`UserProfile.bodyWeightKg: double?` — `@HiveField(19)` (если добавим поле массы в профиль).
Альтернатива для v1.3: читать из Health и не хранить в профиле.

#### UI

**Settings — новый раздел «Здоровье»:**
```
┌─────────────────────────────────┐
│  ЗДОРОВЬЕ                        │
│  Apple Health       [Подключить] │  ← iOS
│  Google Health      [Подключить] │  ← Android
│                                  │
│  Записывать тренировки   [  ●  ] │
│  Записывать калории      [  ●  ] │
│  Читать массу тела       [  ●  ] │
└─────────────────────────────────┘
```

- «Подключить» → запрос разрешений через нативный диалог
- Toggles активны только после подключения

**Summary Screen** — если Health подключен и запись включена:
- Маленький бейдж «Сохранено в Apple Health ✓»

#### Технические задачи

| # | Задача |
|---|--------|
| 1 | Пакет `health` (pub.dev) — единый API для HealthKit и Health Connect |
| 2 | `HealthService` в доменном слое — write/read методы |
| 3 | `SettingsNotifier`: поля `healthEnabled`, `healthCaloriesEnabled`, `healthWeightEnabled` |
| 4 | Settings UI — раздел «Здоровье» |
| 5 | `WorkoutNotifier._finishWorkout` — вызов `HealthService.writeWorkout` |
| 6 | `SummaryScreen` — бейдж «Сохранено в Health» |
| 7 | iOS: `Info.plist` — `NSHealthUpdateUsageDescription`, `NSHealthShareUsageDescription` |
| 8 | Android: `AndroidManifest.xml` — Health Connect permissions + провайдер |
| 9 | l10n: строки |

**Пакет:** `health` (pub.dev, активно поддерживается, покрывает iOS + Android).

---

### v1.3 — Базовая интеграция со смарт-часами — спроектировано, не реализовано

#### Концепция

Не отдельное приложение на часы, а «зеркало» через уведомления.
Apple Watch и Wear OS автоматически отражают уведомления с телефона — это
позволяет показывать таймер отдыха и текущее упражнение на экране часов
**без написания кода для watchOS / Wear OS**.

#### Что работает «бесплатно» (через уведомления)

- Начало упражнения → уведомление с именем упражнения + таймер/счётчик
- Конец отдыха → тактильный сигнал (haptic) на часах через notification sound
- Смена упражнения → обновление уведомления

На Apple Watch уведомления из `flutter_local_notifications` отражаются автоматически.
На Wear OS — аналогично.

#### Что требует дополнительной работы

- **Интерактивные действия** (кнопка «Готово» прямо на часах) — нужен
  `UNNotificationAction` (iOS) / `RemoteInput` (Android), добавляемый к уведомлению.
  Это v1.4-задача.
- **Живой таймер на экране часов** (countdown в уведомлении) — нужен
  `setChronometer` (Android) / `relevanceDate` + `UNTimerInterval` (iOS).

#### Реализация v1.3

1. **Rest timer notification** — когда начинается отдых, показывать `ongoing` уведомление:
   - Заголовок: «Отдых: X сек»
   - Body: следующее упражнение
   - Android: `setOngoing(true)` + `setUsesChronometer(true)` (обратный отсчёт)
   - iOS: `interruptionLevel = timeSensitive`
   - Отменяется когда пользователь нажимает «Готово» (возврат в приложение)

2. **Current exercise notification** — при старте упражнения:
   - «Push · Алмазные отжимания · 3 × 8»

3. `WorkoutNotifier` — вызывать `NotificationService.showRestTimer(durationSec, nextExercise)`.
   `NotificationService.cancelRestTimer()` при переходе к упражнению.

**ID уведомления: 5** (`rest_timer`).

---

### v1.5 — Полноценное приложение на часы — идея

#### Apple Watch (watchOS)

- Отдельный Watch App target в Xcode (SwiftUI + WatchKit)
- WatchConnectivity для синхронизации данных телефон ↔ часы
- Функции:
  - Запуск тренировки с часов
  - Счётчик повторений (Crown rotation или Double Tap)
  - Таймер выдержки с тактильным сигналом окончания
  - Пульс в реальном времени (HealthKit `HKWorkoutSession`)
  - Итоги тренировки на часах

#### Wear OS (Android)

- Отдельное Wear OS-приложение (Compose for Wear OS)
- Health Services API для пульса
- Аналогичный набор функций

#### Технический подход

- **Не Flutter:** Flutter for WatchOS / Wear OS в 2026 не production-ready.
  Нативный код + Method Channel для связи с Flutter.
- Или отдельные нативные приложения, которые читают данные из Health.

#### Когда браться

После того как v1.3 Health-интеграция устоялась и есть достаточная аудитория
(смысл делать Watch App только когда есть кому его использовать).

---

### Кнопка «Поддержать автора» — идея

#### Концепция

Приложение бесплатное и без рекламы. Чтобы дать пользователям возможность
отблагодарить автора, добавить кнопку с разовым донатом через нативные платёжные
системы — Apple Pay (iOS) и Google Pay (Android).

#### Где разместить

Кандидаты:
- Экран **Settings** — раздел «О приложении», кнопка в самом низу списка.
- Экран **Profile** — рядом с рангом или внизу страницы.
- После завершения важного достижения — тост/баннер «Понравилось? Поддержи
  разработку» с кнопкой (ненавязчиво, один раз).

Приоритет мест: Settings → Profile → пост-ачивмент-промо.

#### Техническая реализация

Платформа | Механизм
---|---
iOS | **StoreKit 2 — In-App Purchase (Consumable)** или **StoreKit 2 Tip Jar** (специальный тип продуктов «tip»). Apple не разрешает прямую оплату вне IAP, поэтому донат должен быть оформлен как consumable IAP.
Android | **Google Play Billing Library** — consumable in-app product («донат»). Google Pay как метод оплаты доступен автоматически внутри диалога Billing.

Flutter-пакет: [`in_app_purchase`](https://pub.dev/packages/in_app_purchase) —
официальный плагин от Flutter team, поддерживает оба стора.

Продукты (consumable, одиночная покупка):
- `tip_small` — ~99₽ / $0.99
- `tip_medium` — ~249₽ / $2.99
- `tip_large` — ~499₽ / $4.99

После успешной покупки — конфетти + благодарственное сообщение от Горо.
Никакого разблокируемого контента — только «спасибо».

#### Ограничения

- Требует регистрации продуктов в App Store Connect + Google Play Console.
- Apple берёт 30% комиссию (15% для малого бизнеса Small Business Program).
- Google — аналогично.
- Нельзя принимать донаты через внешние ссылки (PayPal, Patreon и т.д.) —
  Apple это явно запрещает в App Store Review Guidelines §3.1.1.

#### Когда браться

После первого реального релиза, когда появятся первые пользователи.
Реализация несложная (1–2 дня), но требует настройки продуктов в консолях сторов.

---

### Экран «О приложении» — идея

#### Концепция

Вынести информацию о приложении из Settings на отдельный экран `/about`,
доступный через кнопку в нижней части Settings-экрана.

#### Содержимое экрана

- **Иконка приложения** + название «CaliDay» + версия (`package_info_plus`)
- **Короткий слоган** / описание в 1–2 предложения
- **Кнопка «Поддержать автора»** — донат через Apple Pay / Google Pay (см. идею выше)
- **Ссылки:**
  - Оценить в App Store / Google Play (`in_app_review` или прямая ссылка)
  - Написать отзыв / сообщить об ошибке (mailto или GitHub Issues)
  - Политика конфиденциальности (WebView или внешний браузер)
- **Секция «Использованные технологии»** — Flutter, Riverpod, Hive и т.д.
  (опционально, для прозрачности / любопытных пользователей)
- **Copyright** — «© 2025 [Имя автора]. Все права защищены.»

#### Пакеты

- `package_info_plus` — для получения версии приложения (уже должен быть в проекте или легко добавляется)
- `in_app_review` — нативный диалог «Оценить приложение» без выхода из app
- `url_launcher` — для внешних ссылок (вероятно, уже используется)

#### UX

- Переход: Settings → тап на «О приложении» → push-навигация на `/about`
- Горо на экране — idle-поза (`goro_idle_v2.svg`), делает экран живым
- Кнопка доната — выделена цветом акцента, но не агрессивно

---

### Идеи из тестирования (2026-03-04)

#### 🐛 Вибрация на Android не работает

**Проблема:** `SoundService` вызывает вибрацию через `vibration` пакет, но на Android устройствах вибрация не срабатывает.

**Вероятные причины:**
- Отсутствует `VIBRATE` permission в `AndroidManifest.xml`
- Пакет `vibration` требует нативного вызова через channel, который мог не инициализироваться до первого использования
- Возможно, нужен fallback через `HapticFeedback` из Flutter (работает без разрешений)

**План фикса:**
1. Проверить `AndroidManifest.xml` на наличие `<uses-permission android:name="android.permission.VIBRATE"/>`
2. Проверить логику `SoundService` — если `vibration` пакет возвращает `hasVibrator() == false`, вибрация молча пропускается
3. Добавить fallback: если `hasVibrator()` вернул `false` → попробовать `HapticFeedback.mediumImpact()` из `flutter/services.dart`
4. Протестировать на реальном Android устройстве (не эмуляторе — эмулятор может не поддерживать вибрацию)

---

#### ⏱️ Таймер обратного отсчёта: изменить длину и поведение

**Текущее поведение:** 3 → tick → 2 → tick → 1 → tick+completed → 0

**Желаемое поведение:** 6 → tick → 5 → tick → 4 → tick → 3 → tick → 2 → tick → 1 → completed → 0

**Изменения:**
- Увеличить начальное значение с 3 до 5 секунд (отображается 5, тикает до 1, затем сигнал завершения)
- Убрать tick-звук на последнем шаге (1 → 0) — вместо него только сигнал завершения
- Т.е. ticks звучат на: 6→5, 5→4, 4→3, 3→2, 2→1; сигнал completed звучит один раз после «1»

**Файлы для изменения:**
- `lib/features/workout/screens/workout_screen.dart` — константа начального значения таймера
- `lib/core/services/sound_service.dart` — логика когда играть tick vs completed

---

#### 📋 История тренировок: детальный просмотр

**Проблема:** в Profile → история показаны карточки тренировок, но нельзя открыть и посмотреть что было внутри (какие упражнения, сколько повторений).

**Идея:** при тапе на карточку тренировки в истории открывается детальный экран с:
- Дата, тип тренировки (Daily/Challenge/Bonus), SP заработанные
- Список упражнений с результатами: название, целевые повторения, выполненные повторения
- Длительность общая

**UX варианты:**
- A) Modal bottom sheet (проще, достаточно для MVP)
- B) Отдельный экран `/workout-log/:id` (лучше для длинных тренировок)

**Файлы:** `lib/features/profile/` — ProfileScreen, добавить WorkoutLogDetailSheet или WorkoutLogDetailScreen.
Данные уже есть в `WorkoutLog.exercises` (список `ExerciseResult`).

---

#### 🏠 Home экран: ветки прогрессии не должны конкурировать с тренировкой дня

**Проблема:** сейчас на Home экране ветки прогрессии (BranchProgressCard) занимают много места и визуально «требуют» нажатия. Пользователи воспринимают их как обязательные задачи, хотя это опциональный инструмент для сознательного продвижения по этапам.

**Основная механика:** тренировка дня — это главное. Ветки — вспомогательный инструмент.

**Варианты редизайна Home:**

**Вариант A — Кнопка в фокусе:**
- Кнопка «Начать тренировку» занимает большую часть экрана (hero-блок с Горо)
- Ветки убраны в коллапсируемую секцию «Прогрессия» (по умолчанию свёрнута)
- Или ветки перенесены на отдельную вкладку/экран

**Вариант B — Разделение экранов:**
- Home = только тренировка дня + стрик + SP
- Отдельная иконка/вкладка «Прогрессия» в bottom nav — там ветки
- Bottom nav: Home | Progress | Profile (3 пункта вместо 2)

**Вариант C — Переформулировка:**
- Оставить ветки на Home, но переименовать: «Прогрессия (по желанию)» + добавить подзаголовок «Для осознанного развития»
- Визуально сделать их менее яркими (серый border вместо цветного, меньше размер)
- Кнопка тренировки — более крупная, занимает верхнюю треть

**Рекомендуемый вариант:** B (отдельная вкладка), если добавляем bottom nav; или A (hero-блок) если навигацию менять не хотим.

---

## История изменений

### 2026-03-05 — сессия 37 (Home Screen Widget: Flutter + Android + iOS swift-файлы)

**Реализован Home Screen Widget (Small 2×2): Горо (idle/flex) + стрик + SP. Тап → `caliday://workout`.**

**Новые зависимости:**
- `home_widget: ^0.9.0` — Flutter ↔ нативный виджет (SharedPreferences Android / UserDefaults AppGroup iOS)
- `app_links: ^6.4.1` — обработка deep link `caliday://workout`
- `androidx.glance:glance-appwidget:1.1.0` — Android нативный виджет (Compose Glance)

**PNG-ассеты:** сконвертированы `goro_idle_v2.svg` и `goro_flex_v2.svg` через sharp (Node.js):
- Android: `drawable-mdpi/hdpi/xhdpi/xxhdpi/goro_{idle,flex}.png` (80/120/160/240px)
- iOS: `ios/CaliDayWidget/Assets.xcassets/Goro{Idle,Flex}.imageset/` (1x/2x/3x: 80/160/240px)

**Новые файлы:**
- `lib/core/services/widget_service.dart` — `WidgetService.instance` singleton: `init()` + `update({streak, totalSP, workoutDoneToday})`
- ~~`android/app/src/main/kotlin/com/pupptmstr/caliday/CaliDayWidget.kt`~~ — **удалён** (см. сессию 38)
- `android/app/src/main/kotlin/com/pupptmstr/caliday/CaliDayWidgetReceiver.kt` — изначально `GlanceAppWidgetReceiver`, **переписан** в сессии 38 как классический `AppWidgetProvider`
- `android/app/src/main/res/xml/caliday_widget_info.xml` — `AppWidgetProviderInfo` (110dp×110dp, 2×2)
- `android/app/src/main/res/drawable/ic_widget_fire.xml` — оранжевый огонь для стрика
- `android/app/src/main/res/drawable/ic_widget_bolt.xml` — жёлтая молния для SP
- `ios/CaliDayWidget/CaliDayWidget.swift` — SwiftUI WidgetKit: `StaticConfiguration`, `TimelineProvider` (30-мин обновление), читает `UserDefaults(suiteName: "group.com.pupptmstr.caliday")`
- `ios/CaliDayWidget/Assets.xcassets/GoroIdle.imageset/Contents.json` + PNG x3
- `ios/CaliDayWidget/Assets.xcassets/GoroFlex.imageset/Contents.json` + PNG x3
- `ios/CaliDayWidget/Assets.xcassets/Contents.json`

**Изменённые файлы:**
- `pubspec.yaml` — `home_widget`, `app_links`
- `lib/main.dart` — import `app_links`, `widget_service`, `workout_repository`, `streak_service`; `WidgetService.instance.init()` + начальный `update()` в postFrameCallback; `AppLinks().uriLinkStream` → `router.go('/workout')`; `dispose()` → `_linkSub?.cancel()`
- `lib/features/workout/providers/workout_provider.dart` — `unawaited(WidgetService.instance.update(...))` после `_finishWorkout` (streak=displayStreak, workoutDoneToday=true)
- `android/app/src/main/AndroidManifest.xml` — deep link intent-filter (`caliday://`), widget receiver
- `android/app/build.gradle.kts` — ~~`implementation("androidx.glance:glance-appwidget:1.1.0")`~~ — **удалено** в сессии 38
- `android/app/proguard-rules.pro` — keep CaliDayWidgetReceiver (Glance rule убрана в сессии 38)
- `ios/Runner/Info.plist` — `CFBundleURLTypes` → scheme `caliday`
- `lib/features/profile/screens/profile_screen.dart` — lint fix: `_i` → `i` в separatorBuilder

**Ключевые параметры:**
- App Group ID: `group.com.pupptmstr.caliday`
- SharedPreferences name: `HomeWidgetPreferences` (home_widget default)
- Widget kind (iOS): `CaliDayWidget`
- Widget receiver (Android): `com.pupptmstr.caliday.CaliDayWidgetReceiver`
- Deep link: `caliday://workout`

**iOS: требует ручной настройки в Xcode (на Mac):**
1. File → New → Target → Widget Extension → `CaliDayWidget`
2. Заменить сгенерированный `.swift` файлом из `ios/CaliDayWidget/CaliDayWidget.swift`
3. Добавить PNG-ассеты из `ios/CaliDayWidget/Assets.xcassets/` в Asset Catalog виджета
4. Runner target → Signing & Capabilities → App Groups → `group.com.pupptmstr.caliday`
5. CaliDayWidget target → то же App Group

### 2026-03-05 — сессия 38 (Android виджет: Glance → AppWidgetProvider, fix NoSuchMethodError)

**Исправлен рантайм-краш Android-виджета. Заменена Glance-реализация на классический AppWidgetProvider + RemoteViews.**

**Проблема:** `java.lang.NoSuchMethodError: No static method provideContent(GlanceAppWidget, Function0, Continuation)` при открытии виджета.

**Причина:** Flutter-проект не подключает Compose Compiler Plugin (`buildFeatures.compose = false` по умолчанию). Без этого плагина лямбда в `provideContent { }` не трансформируется Compose-компилятором: генерируется `Function0` вместо `Function2<Composer, Int, Unit>`, которого ожидает `glance-appwidget:1.2.0-rc01` (версия, разрешённая Gradle через `1.+` из home_widget). Результат — несоответствие сигнатур → `NoSuchMethodError` в рантайме.

**Решение:** Переход на классический `AppWidgetProvider` + `RemoteViews` (не требует Compose Compiler Plugin):
- **Удалён** `android/app/src/main/kotlin/com/pupptmstr/caliday/CaliDayWidget.kt` (GlanceAppWidget)
- **Переписан** `CaliDayWidgetReceiver.kt`: `AppWidgetProvider`, читает SharedPreferences `HomeWidgetPreferences`, строит `RemoteViews` из XML-layout, ставит `PendingIntent` на тап → `caliday://workout`
- **Создан** `android/app/src/main/res/layout/caliday_widget_layout.xml` — LinearLayout: ImageView(Горо) + Row(огонь + streak) + Row(молния + SP)
- **Убрана** зависимость `glance-appwidget` из `build.gradle.kts` (приходит транзитивно из home_widget)
- **Обновлён** `proguard-rules.pro` — убрано keep-правило Glance

**Итог:** `flutter build apk --debug` — успех, `flutter analyze` — 3 pre-existing info (без новых).

**Дополнительный fix (в той же сессии):** Тап на виджет вызывал `GoException: no routes for location: caliday://workout/`.
Причина: Flutter Router передаёт full URI deep link'а в go_router, который пытается его матчить как путь.
Решение: добавлен guard `if (state.uri.scheme == 'caliday') return '/workout';` в redirect функцию `_RouterNotifier` (`lib/core/router/app_router.dart`).

**Дополнительный fix 2:** `GoError: There is nothing to pop` при прерывании тренировки запущенной с виджета.
Причина: deep link открывает `/workout` через `go()` (замена стека), поэтому `pop()` падал без предшествующего роута.
Решение: `_confirmExit` в `workout_screen.dart` — `context.canPop() ? context.pop() : context.go('/home')`.

### 2026-03-03 — сессия 31 (Lottie анимации Push ветки + рефакторинг прогрессии)

**Интегрированы анимации Lottie для всех 7 этапов Push-ветки.**

**Каталог упражнений:** прогрессия Push приведена в соответствие с ассетами дизайнера:
- Stage 5: Archer Pushup → **Wide Pushup** (id: `push_s5_wide_pushup`)
- Stage 6: One-Arm Pushup → **Archer Pushup** (id: `push_s6_archer_pushup`)
- Stage 7: Handstand Pushup — без изменений

**Достижение `push_s6`:** переименовано «Одна рука» → «Лучник» (RU) / «Archer» (EN).

**Новые зависимости:** `lottie: ^3.3.2` (раскомментировано в pubspec.yaml).
**Новые ассеты:** `assets/animations/` (7 JSON файлов Push ветки).
**Поле модели:** `Exercise.animationPath: String?` добавлено.
**WorkoutScreen:** Lottie-анимация показывается выше названия упражнения, когда `animationPath != null`.

Изменены файлы:
- `pubspec.yaml` — lottie + assets/animations/
- `lib/data/models/exercise.dart` — поле animationPath
- `lib/data/static/exercise_catalog.dart` — Push s5/s6 + animationPath для s1-s7
- `lib/core/extensions/exercise_l10n.dart` — новые ID для s5/s6
- `l10n/app_ru.arb`, `l10n/app_en.arb` — новые ключи s5/s6 + achievement pushS6
- `lib/features/workout/screens/workout_screen.dart` — Lottie widget

### 2026-03-04 — сессия 36 (инфо-баннер на Progress + замена эмодзи на иконки)

**1. Инфо-баннер на экране Прогресса.**
Добавлена карточка-подсказка вверху вкладки «Прогресс», объясняющая что ветки прогрессии —
это необязательный личный путь, а не обязательные задания. Пользователь тренируется в своём
темпе и сам решает когда принимать Испытание.

**2. Замена эмодзи на Material Icons по всему приложению.**
Мотивация: эмодзи рендерятся по-разному на разных устройствах/ОС; иконки — одинаковые везде.

Заменены:
- Home → stat chips: 🔥→`local_fire_department`, ⚡→`bolt`, 🏅→`military_tech`
- Home → workout button: ✅/🏋️ → `check_circle_outline`/`fitness_center`
- Progress → branch card: branch.emoji → `Icon(branch.icon)`
- BranchJourney → AppBar title: emoji убран, добавлен `Icon(branch.icon)`
- Profile → rank card: 🌱💪🏃⚡🔥👑 → `eco/fitness_center/directions_run/bolt/local_fire_department/workspace_premium`
- Profile → stats grid: 🔥🏆💪❄️ → `local_fire_department/emoji_events/fitness_center/ac_unit`
- Profile → workout log tile: 🏋️ → `fitness_center`
- Summary → banners: ❄️→`ac_unit`, 🏆→`emoji_events`, 💪→`fitness_center`, 🎉→`celebration`
- Workout → tip: 💡 → `lightbulb_outline`
- Achievements → locked: 🔒 → `lock_outline`
- Settings → language dialog title: убран 🌐

**Добавлен `IconData icon` геттер в `BranchIdExtension` (enums.dart).**
**`BranchId.emoji` — сохранён** (используется в achievement_catalog.dart как контент).
**Флаги 🇷🇺/🇬🇧 в диалоге языка — сохранены** (интенциональные маркеры locale).
**Achievement emoji — сохранены** (часть игровой механики/контента).
**Toast-строки ✅ (`workoutSetDone`, `workoutExerciseDone`) — сохранены** (праздничный фидбек).

**L10n:** убраны эмодзи из 9 строк (`homeChallengeUnlocked`, `branchJourneyStartChallenge`,
`summarySubtitle`, `achievementsSecret`, `summaryAchievementsTitle`, `summaryBonusTitle`,
`summaryChallengeUnlockedTitle`, `summaryChallengePassedTitle`, `historyTypeChallenge`).
Добавлен ключ `progressInfo` (RU + EN).

Изменены файлы:
- `l10n/app_ru.arb`, `l10n/app_en.arb`
- `lib/data/models/enums.dart` — `IconData icon` геттер + `import flutter/material.dart`
- `lib/features/home/screens/home_screen.dart`
- `lib/features/home/screens/progress_screen.dart`
- `lib/features/home/screens/branch_journey_screen.dart`
- `lib/features/profile/screens/profile_screen.dart`
- `lib/features/profile/screens/achievements_screen.dart`
- `lib/features/workout/screens/summary_screen.dart`
- `lib/features/workout/screens/workout_screen.dart`
- `lib/features/settings/screens/settings_screen.dart`

### 2026-03-04 — сессия 35 (Android-вибрация, таймер, детали истории, редизайн Home + фиксы)

**1. Фикс вибрации на Android** — добавлено `<uses-permission android:name="android.permission.VIBRATE"/>` в `AndroidManifest.xml`.

**2. Таймер обратного отсчёта** — увеличен с 3 до 5 отображаемых секунд. Tick-звуки при `timerSec ∈ [2..6]` (без tick на последнем шаге), добавлены tick-звуки для timed-упражнений (не только rest).

**3. Детали истории тренировок** — тайлы в Profile → история стали тапабельными. Modal bottom sheet показывает: дата, тип, SP, длительность, список упражнений с результатами. Добавлены l10n ключи `historyDetailExercises`, `historyDetailReps`, `historyDetailSec`.

**4. Редизайн Home → bottom nav 3 вкладки** — `StatefulShellRoute.indexedStack` с вкладками: Тренировка (`/home`), Прогресс (`/progress`), Профиль (`/profile`). Создан `progress_screen.dart` с ветками прогрессии и challenge-карточками. Home упрощён до hero-блока с Горо и кнопкой тренировки.

**5. Тик-звуки для timed-упражнений** — добавлен `WorkoutPhase.exercise` в условие tick.

**6. Баг: данные профиля устаревали** — `StatefulShellRoute.indexedStack` хранит все вкладки живыми → `profileDataProvider` (autoDispose) не сбрасывался. Фикс: `_ref.invalidate(profileDataProvider)` добавлен в `_finishWorkout()`.

Изменены файлы:
- `android/app/src/main/AndroidManifest.xml` — VIBRATE permission
- `lib/features/workout/screens/workout_screen.dart` — tick condition
- `l10n/app_ru.arb`, `l10n/app_en.arb` — nav keys, progressTitle, history detail keys
- `lib/features/profile/screens/profile_screen.dart` — tappable tiles + detail bottom sheet
- `lib/features/home/screens/home_screen.dart` — полный редизайн (hero layout)
- `lib/features/home/screens/progress_screen.dart` — новый файл (ветки + challenge)
- `lib/core/router/app_router.dart` — StatefulShellRoute + _AppShell + /progress route
- `lib/features/workout/providers/workout_provider.dart` — invalidate profileDataProvider

### 2026-03-04 — сессия 34 (фикс: Challenge в бонусной тренировке)

**Баг:** если пользователь уже сделал дневную тренировку, а потом запускал Challenge,
прогресс ветки не продвигался — потому что вся прогрессия была внутри `if (isPrimary)`.

**Фикс** в `lib/features/workout/providers/workout_provider.dart` (`_finishWorkout`):
- `advanceStage` для challenge-упражнений (`stage > currentStage`) теперь вызывается
  **всегда**, независимо от isPrimary/bonus.
- `applyResult` для обычной прогрессии (`stage == currentStage`) по-прежнему только primary.
- Достижения за переход этапа (`checkAfterStageAdvance`) тоже убраны из-под `isPrimary`.

Изменены файлы:
- `lib/features/workout/providers/workout_provider.dart`

### 2026-03-04 — сессия 33 (фикс release-сборки Android)

**Два критических бага release APK, не воспроизводившихся в debug:**

**1. Drawable `ic_goro_notif` выбрасывался R8-шринкером.**
R8 не видит строковые ссылки из Dart-кода и считал drawable неиспользуемым.
Фикс: `android/app/src/main/res/raw/keep.xml` с `tools:keep="@drawable/ic_goro_notif"`.

**2. `flutter_local_notifications` — "Missing type parameter" из-за R8.**
Плагин использует Gson+TypeToken для сериализации запланированных уведомлений. R8 срезал
generic type parameters, вызывая RuntimeException при `zonedSchedule`.
Фикс: `android/app/proguard-rules.pro` с `-keep class com.dexterous.**` + `-keep... TypeToken`.
`android/app/build.gradle.kts` — добавлена ссылка на `proguardFiles(...)`.

**3. Инициализация уведомлений в `main()` до `runApp()`.**
На реальных устройствах platform channel вызовы до первого фрейма могут зависнуть.
Фикс: вся инициализация NotificationService перенесена в `postFrameCallback` в `initState`.

Изменены файлы:
- `lib/main.dart` — убраны `ns.init()` + `ns.scheduleAll()` из `main()`, перенесены в `postFrameCallback`
- `android/app/src/main/res/raw/keep.xml` — новый файл (keep drawable для R8)
- `android/app/proguard-rules.pro` — новый файл (ProGuard rules для flutter_local_notifications)
- `android/app/build.gradle.kts` — добавлен `proguardFiles` в release build type

### 2026-03-03 — сессия 32 (экран «О приложении»)

Добавлен экран `/about`, доступный из Settings → плитка «О приложении».

**Новая зависимость:** `url_launcher: ^6.3.0` (открытие mailto: и https: ссылок).

**Новые файлы:**
- `lib/features/settings/screens/about_screen.dart` — `StatelessWidget`, Горо idle v2 (h=120), версия 1.1.0, секции «ПОДДЕРЖКА» и «СДЕЛАНО НА», copyright «© 2026 pupptmstr»

**Изменённые файлы:**
- `pubspec.yaml` — добавлен `url_launcher: ^6.3.0`
- `android/app/src/main/AndroidManifest.xml` — добавлены `<queries>` для `mailto:` и `https:` (Android 11+)
- `lib/core/router/app_router.dart` — маршрут `/about` + import
- `lib/features/settings/screens/settings_screen.dart` — плитка «О приложении» перед debug-секцией
- `l10n/app_ru.arb`, `l10n/app_en.arb` — 9 новых ключей (`aboutTitle`, `aboutVersion`, `aboutSectionSupport`, `aboutContactUs`, `aboutContactUsSubtitle`, `aboutPrivacyPolicy`, `aboutBuiltWith`, `aboutCopyright`, `settingsAbout`)

**APK:** пересобран → `build/app/outputs/flutter-apk/caliday.apk` (57.7 MB)

### 2026-03-03 — сессия 31 (идеи: донат + экран «О приложении»)

Зафиксированы две новые идеи в разделе «Идеи для будущих версий»:

**Кнопка «Поддержать автора»:**
- Донат через нативные платёжные системы (Apple Pay / Google Pay)
- Технически: consumable In-App Purchase через пакет `in_app_purchase`
- Три тира: small / medium / large (~99₽ / 249₽ / 499₽)
- Ограничение Apple: внешние ссылки (PayPal, Patreon) запрещены §3.1.1

**Экран «О приложении» (`/about`):**
- Отдельный экран, доступный из Settings
- Содержимое: иконка + версия (`package_info_plus`), кнопка доната, ссылки (оценить / отзыв / privacy), копирайт
- Горо в idle-позе на экране
- Пакеты: `package_info_plus`, `in_app_review`, `url_launcher`

Изменены файлы: `docs/DEV_NOTES.md`

### 2026-03-02 — сессия 30 (Звук и вибрация)

**Реализован звук и вибрация во время тренировки.**

**Новые файлы:**
- `lib/core/services/sound_service.dart` — `SoundService` singleton: `tick()`, `ding()`, `pop()`, `complete()`
- `assets/sounds/tick.mp3`, `ding.mp3`, `pop.mp3`, `complete.mp3` — аудиоассеты

**Изменённые файлы:**
- `pubspec.yaml` — добавлен `audioplayers: ^6.1.0`; зарегистрирована папка `assets/sounds/`
- `lib/data/models/user_profile.dart` — `@HiveField(19) bool? soundEnabled`, `@HiveField(20) bool? hapticEnabled`
- `lib/data/models/user_profile.g.dart` — вручную: writeByte 16→18, поля soundEnabled/hapticEnabled
- `lib/features/settings/providers/settings_provider.dart` — `soundEnabled`, `hapticEnabled` в `SettingsState`; `setSoundEnabled()`, `setHapticEnabled()` в нотифере; `SoundService.instance.configure()` при загрузке и изменении
- `lib/features/settings/screens/settings_screen.dart` — два новых Switch в разделе ТРЕНИРОВКА
- `lib/features/workout/screens/workout_screen.dart` — tick в таймере при `timerSec <= 3` во время rest; `ref.listen` на фазы: ding (rest→exercise), pop (exercise→rest или смена exercise), complete (done)
- `l10n/app_ru.arb`, `l10n/app_en.arb` — ключи: `settingsSoundTitle`, `settingsSoundSubtitle`, `settingsHapticTitle`, `settingsHapticSubtitle`

**Архитектура:** `SoundService.instance.configure(soundEnabled, hapticEnabled)` вызывается из `SettingsNotifier` (при загрузке и изменении настроек). `SoundService` — синглтон как `NotificationService`, без Riverpod. Ошибки воспроизведения (отсутствие файлов) подавляются через try-catch.

**Backward compatibility:** `soundEnabled ?? true`, `hapticEnabled ?? true` — старые профили получают оба включёнными по умолчанию.

**Баг-фикс (сессия 30, патч):** Убран `await player.stop()` из `SoundService._play()`. `stop()` вызывал полный сброс Android MediaPlayer (`resetDrmState`/`cleanDrmObj`, ~100–200 мс) и потерю аудиофокуса (`AUDIOFOCUS_LOSS -1`) при каждом воспроизведении. Для tick-звука (50 мс, каждую секунду) это создавало гонку: звук отменялся до начала воспроизведения. `player.play()` самостоятельно обрабатывает рестарт без дорогого сброса.

### 2026-03-02 — сессия 29 (Достижения — 27 achievements)

**Реализована полная система достижений.**

**Новые файлы:**
- `lib/data/repositories/achievement_repository.dart` — `Box<DateTime>('achievements')`, ключ=id, значение=earnedAt
- `lib/data/static/achievement_catalog.dart` — 27 статических `Achievement` (id, emoji, isSecret)
- `lib/domain/services/achievement_service.dart` — pure service: `checkAfterWorkout`, `checkAfterStageAdvance` (принимают `Set<String> alreadyEarned`, возвращают новые IDs)
- `lib/core/extensions/achievement_l10n.dart` — switch-based name/desc helper
- `lib/features/profile/screens/achievements_screen.dart` — экран `/achievements` (секции Получено/Заблокировано, тап→BottomSheet)

**Изменённые файлы:**
- `lib/main.dart` — `Hive.openBox<DateTime>('achievements')`
- `lib/features/workout/providers/workout_provider.dart` — `WorkoutState.newAchievementIds`, вызов сервиса в `_finishWorkout`; исправлен порядок `workoutsToday` (до addLog)
- `lib/features/workout/screens/workout_screen.dart` — передаёт `newAchievementIds` в extras
- `lib/features/workout/screens/summary_screen.dart` — `_AchievementsEarnedBanner` (badge chips, тап→BottomSheet)
- `lib/features/profile/providers/profile_provider.dart` — `ProfileData.recentAchievementIds` (последние 5)
- `lib/features/profile/screens/profile_screen.dart` — секция Достижения с `_AchievementBadgeRow`, кнопка «Все достижения →»
- `lib/core/router/app_router.dart` — маршрут `/achievements`
- `l10n/app_ru.arb`, `l10n/app_en.arb` — 27×2 имён+описаний + 6 UI строк

**Архитектурная деталь:** `AchievementService` чисто вычислительный (no side effects). Persistence (`markEarned`) делает `WorkoutNotifier`. `alreadyEarned: Set<String>` обновляется между двумя вызовами, чтобы не дублировать.

**Hive:** `Box<DateTime>` — нативная поддержка, адаптер не нужен. Инициализация добавлена в `main.dart`.

### 2026-03-02 — сессия 28 (Бонусные тренировки)

**Реализованы бонусные тренировки** — пользователь может тренироваться несколько раз
в день. Первая тренировка (primary) — полный SP, стрик, прогрессия. Вторые и далее
(bonus) — ×0.5 SP, прогрессия и стрик не меняются.

**Изменённые файлы:**
- `lib/data/models/workout_log.dart` — добавлен `@HiveField(5) bool isPrimary`
- `lib/data/models/workout_log.g.dart` — вручную: writeByte 5→6, поле isPrimary
- `lib/data/repositories/workout_repository.dart` — `getCountForDate()`, `hasPrimaryWorkoutToday()`
- `lib/features/workout/providers/workout_provider.dart` — `isPrimary`, `workoutsToday` в `WorkoutState`; `_finishWorkout` разветвлён на primary/bonus
- `lib/features/workout/screens/workout_screen.dart` — передаёт `isPrimary`, `workoutsToday` в extras
- `lib/features/workout/screens/summary_screen.dart` — `_BonusWorkoutBanner` виджет
- `lib/features/home/screens/home_screen.dart` — `_WorkoutButton` всегда enabled; лейбл "Ещё раз" после выполнения
- `l10n/app_ru.arb`, `l10n/app_en.arb` — новые ключи: `homeWorkoutAgain`, `summaryBonusTitle`, `summaryBonusBody`, `summaryBonusCount`

**Совместимость:** старые логи без `isPrimary` читаются как `true` через `fields[5] as bool? ?? true`.

### 2026-03-02 — сессия 27 (систематизация backlog + дизайн Friends + Health/Watch + звук/вибрация)

**Систематизация backlog:** добавлена сводная таблица версий в начале раздела «Идеи
для будущих версий». Все нереализованные фичи разбиты по версиям 1.1 / 1.2 / 1.3 / 1.5.

**Дизайн Friends (v1.3)** — спецификация зафиксирована:
- Peer-to-peer без сервера: QR-обмен (`qr_flutter` + `mobile_scanner`) + BLE discovery (`flutter_blue_plus`)
- `FriendProfile` — Hive typeId 9, бокс `'friends'`
- `UserProfile` + 2 поля: `peerId` (@HiveField(17)), `displayName` (@HiveField(18))
- Экран `/friends`, секция в Profile, QR-генерация и сканирование
- Код не написан.

**Дизайн Health-интеграции (v1.3)** — спецификация зафиксирована:
- Пакет `health` (pub.dev) — единый API HealthKit + Health Connect
- Write: тип тренировки + длительность + калории (MET × вес × время)
- Read: масса тела, пульс в покое
- Settings-раздел «Здоровье», бейдж на Summary
- Код не написан.

**Дизайн интеграции смарт-часов (v1.3 базовая / v1.5 полная)**:
- v1.3: «бесплатное» зеркало через уведомления (ongoing rest timer, ID 5)
- v1.5: нативные WatchKit/SwiftUI + Wear OS Compose приложения
- Код не написан.

**Дизайн звука и вибрации во время тренировки (v1.2)** — спецификация зафиксирована:
- 4 момента: обратный отсчёт (тики), конец таймера (ding+heavy), засчитан подход (pop+medium), конец тренировки (мелодия+паттерн)
- Вибрация: `HapticFeedback` из Flutter SDK (без пакета)
- Звук: пакет `audioplayers`, 4 файла в `assets/sounds/`
- `SoundService` singleton, Settings: два toggle `soundEnabled` / `hapticEnabled`
- Код не написан.

**Изменённые файлы:** `docs/DEV_NOTES.md`

---

### 2026-03-01 — сессия 26 (форсированный Challenge + дизайн достижений)

**Дизайн достижений** — полная спецификация зафиксирована в DEV_NOTES (раздел «Достижения»):
- 27 достижений в 8 категориях (первые шаги, стрики, объём, ранги, прогрессия по веткам, секретное)
- Хранение: отдельный Hive-бокс `'achievements'` типа `Box<int>` (id → timestamp, адаптер не нужен)
- `AchievementRepository` + `AchievementService` — архитектура сервиса
- UI: баннер на Summary, секция «последние 5» на Profile, отдельный экран `/achievements`
- Код не написан.

**Изменённые файлы:** `docs/DEV_NOTES.md`

---

### 2026-03-01 — сессия 26 (форсированный Challenge с Branch Journey Screen)

**Реализован форсированный Challenge:** кнопка «🏆 Пройти испытание» появляется на строке текущего этапа в `BranchJourneyScreen`. Доступна всегда (без минимального порога), скрыта только на последнем этапе ветки. Нажатие устанавливает `challengeBranchProvider = branchId` и открывает `/workout` — та же механика, что и кнопка «Принять вызов» на Home Screen.

**Изменённые файлы:**
`lib/features/home/screens/branch_journey_screen.dart`, `l10n/app_ru.arb`, `l10n/app_en.arb`

**Следующий шаг:** Бонусные тренировки или Достижения.

---

### 2026-03-01 — сессия 25 (docs: DEV_NOTES cleanup + design brief update)

**DEV_NOTES.md:**
- Challenge redesign, выражения Горо, новые ветки — свёрнуты в краткие ✅-записи
- Таблица аксессуаров дополнена Pull/Legs/Balance (+9 позиций)
- Home screen описание обновлено (expression system + все ветки)
- ⚠️ WorkoutRepository: нужны `getAllForDate` / `getPrimaryForDate` для бонусных тренировок
- ⚠️ SPService: конфликт бонусов при реализации `isPrimary`
- Анимации упражнений: оба контекста (WorkoutScreen + Branch Journey v1.2)
- Новые разделы: Бонусные тренировки, Форсированный Challenge, Home Screen Widget

**caliday_design_concept.md:**
- Раздел 5 переработан: явно описаны два места использования анимаций
- §5.5 — полный список 43 анимаций (все 5 веток + 13 аксессуаров) с углом обзора и ключевым моментом
- Раздел 6: PNG-ассеты виджета + заглушка Бруно v1.2

**CLAUDE.md:** добавлено правило — commit messages на английском.

**Изменённые файлы:**
`docs/DEV_NOTES.md`, `docs/design-concept/caliday_design_concept.md`, `CLAUDE.md`

---

### 2026-03-01 — сессия 24 (Branch Journey Screen + DEV_NOTES cleanup)

**Branch Journey Screen** — экран «Путь прогрессии» для каждой ветки.

- `lib/features/home/screens/branch_journey_screen.dart` (новый экран)
- `ExerciseCatalog.progressionFor(branch)` — новый метод в `exercise_catalog.dart`
- Маршрут `/branch/:branchId` в `app_router.dart` (+ импорт `enums.dart`, `branch_journey_screen.dart`)
- `_BranchProgressCard` на Home: добавлен параметр `onTap`, обёрнут в `Material + InkWell`
- l10n: 7 новых ключей (`branchJourneyProgress`, `StageCompleted`, `StageCurrent`, `StageLocked`, `Params`, `ParamsTimed`)

**DEV_NOTES.md**: developer_options_screen ✅, маршруты актуализированы, онбординг 7 шагов, Branch Journey ✅.

**Изменённые файлы:**
`lib/data/static/exercise_catalog.dart`, `lib/core/router/app_router.dart`,
`lib/features/home/screens/home_screen.dart`,
`lib/features/home/screens/branch_journey_screen.dart` (NEW),
`l10n/app_ru.arb`, `l10n/app_en.arb`

**Следующий шаг:** Home Screen Widget или анимации упражнений.

---

### 2026-02-28 — сессия 23 (новые ветки прогрессии: Pull, Legs, Balance)

**Добавлены три новые ветки прогрессии + система ротации веток по дням.**

**Новые упражнения в каталоге (`exercise_catalog.dart`):**
- Pull (6 этапов, requiresEquipment: true): `pull_s1_australian` → `pull_s6_one_arm`
- Legs (5 этапов): `legs_s1_squat` → `legs_s5_pistol`
- Balance (6 этапов, timed): `bal_s1_one_leg_stand` → `bal_s6_free_hs`
- Новые аксессуары (stage=0): `warmup_dead_hang`, `warmup_leg_swings`, `warmup_wrist_circles`, `cooldown_lat_stretch`, `cooldown_quad_stretch`, `cooldown_downward_dog`

**Архитектурные изменения:**
- `Exercise.requiresEquipment: bool` — новое поле (default=false)
- `ExerciseCatalog.warmupFor(branch)` / `cooldownsFor(branch)` — новые методы выбора аксессуаров по ветке
- `ExerciseCatalog.forStage()` — переписан на switch expression, поддерживает все 5 веток
- `BranchIdExtension` в enums.dart — emoji, localizedName, stageCount, requiresEquipment
- `UserProfile.hasPullUpBar @HiveField(15) bool?` — флаг наличия турника (null = не спрошено)
- `UserProfile.activeBranches` — computed getter: [push, pull (если hasPullUpBar), core, legs, balance]
- `user_profile.g.dart` — writeByte 15→16, добавлен hasPullUpBar
- `WorkoutGeneratorService.generateDaily()` — детерминированная ротация веток по dayIndex; N веток зависит от preferredMinutes (≤5→2, 10→3, ≥15→все); sets из progress
- `HomeData` — заменены pushProgress/coreProgress на `progressMap: Map<BranchId, SkillProgress>`
- `HomeScreen` — динамические карточки на основе `profile.activeBranches`; `_BranchProgressCard` принимает `branch: BranchId` вместо emoji/branchName/totalStages
- `WorkoutNotifier._buildPlan` — передаёт `profile.activeBranches` в generateDaily
- Онбординг: 7 шагов (lastStep: 5→6), новый шаг 5 «Турник дома»; инициализация Legs, Balance, Pull (если турник) в completeOnboarding
- Settings: секция «ОБОРУДОВАНИЕ» с Switch турника; `SettingsState.hasPullUpBar`, `setHasPullUpBar()`
- l10n: ~100 новых ключей (ветки + упражнения + оборудование + онбординг)
- `exercise_l10n.dart` — добавлены все новые упражнения

**Изменённые файлы:**
`lib/data/models/exercise.dart`, `lib/data/static/exercise_catalog.dart`,
`lib/data/models/enums.dart`, `lib/data/models/user_profile.dart`,
`lib/data/models/user_profile.g.dart`,
`lib/domain/services/workout_generator_service.dart`,
`lib/features/home/providers/home_provider.dart`,
`lib/features/home/screens/home_screen.dart`,
`lib/features/workout/providers/workout_provider.dart`,
`lib/features/onboarding/providers/onboarding_provider.dart`,
`lib/features/onboarding/screens/onboarding_screen.dart`,
`lib/features/settings/providers/settings_provider.dart`,
`lib/features/settings/screens/settings_screen.dart`,
`lib/core/extensions/exercise_l10n.dart`,
`l10n/app_ru.arb`, `l10n/app_en.arb`

**Следующий шаг:** Branch Journey Screen или Home Screen Widget.

---

### 2026-02-28 — сессия 22 (тёмная тема + ручное переключение)

**Поддержка тёмной темы** с возможностью ручного выбора в настройках.

- **`darkTheme`** в `main.dart`: `ColorScheme.fromSeed(seedColor: 0xFF4DA6FF, brightness: Brightness.dark)`. Все экраны уже использовали `colorScheme.*` — дополнительных изменений не потребовалось. Намеренный хардкодный `#5C1A1A` (фон Скалы) оставлен.
- **`UserProfile.themeModeName`** — `@HiveField(14) String?` (null = системная, 'light', 'dark'). `user_profile.g.dart` обновлён вручную (writeByte 14→15).
- **`lib/core/providers/theme_provider.dart`** — `themeProvider = StateProvider<ThemeMode>`, `themeModeFromString`/`themeModeToString`.
- **`settingsProvider`** — новое поле `themeMode: ThemeMode`, метод `setThemeMode(ThemeMode)` сохраняет в профиль и обновляет `themeProvider`.
- **Settings screen** — новая секция «ТЕМА» с `SegmentedButton<ThemeMode>` (Системная / Светлая / Тёмная), расположена выше секции «ЯЗЫК».
- **l10n** — 4 новых ключа: `settingsSectionTheme`, `settingsThemeSystem`, `settingsThemeLight`, `settingsThemeDark`.

**Изменённые файлы:**
`lib/main.dart`, `lib/data/models/user_profile.dart`, `lib/data/models/user_profile.g.dart`,
`lib/core/providers/theme_provider.dart` (NEW), `lib/features/settings/providers/settings_provider.dart`,
`lib/features/settings/screens/settings_screen.dart`, `l10n/app_ru.arb`, `l10n/app_en.arb`

**Следующий шаг:** Branch Journey Screen или Home Screen Widget.

---

### 2026-02-28 — сессия 21 (система выражений Горо + Скала на Challenge-экране)

**Интегрированы новые дизайн-ассеты v1.1 и реализована динамическая система выражений Горо.**

**Новые ассеты:**
- `assets/goro/` ← 6 face SVG (`goro_face_happy/sad/angry/sleeping/excited/supportive.svg`) + `goro_flex_v2.svg` + `goro_idle_v2.svg`
- `assets/skala/` ← `skala_neutral.svg` + `skala_approve.svg` (новая папка, добавлена в pubspec.yaml)

**Новый провайдер — `GoroExpressionProvider`** (`lib/core/providers/goro_expression_provider.dart`):
- `enum GoroExpression { happy, sad, angry, sleeping, excited, supportive }`
- `extension GoroExpressionAsset` → `assetPath` (путь к SVG)
- `goroExpressionProvider = Provider.autoDispose<GoroExpression>` — вычисляет выражение по:
  - 23:00–06:00 → sleeping
  - hasWorkoutToday → happy
  - hour ≥ 22 && displayStreak > 0 → angry (стрик горит)
  - hour ≥ 20 → sad (вечер без тренировки)
  - daysSince ≥ 2 → supportive (возврат после пропуска)
  - default → happy
- Зависит от `userRepositoryProvider`, `workoutRepositoryProvider`, `displayStreakProvider`, `streakServiceProvider` (только data/domain слой, без импорта features)

**Изменения экранов:**
- **Home screen** — `goro_flex.svg` заменён на `AnimatedSwitcher` + `goroExpressionProvider` (динамическое выражение с анимацией 400ms)
- **Summary screen** — `goro_flex.svg` заменён на `goro_flex_v2.svg` (улучшенная анатомия)
- **Profile screen** — добавлен `goro_idle_v2.svg` (height=100) над картой ранга; добавлен импорт `flutter_svg`
- **Onboarding welcome** — `goro_face.svg` заменён на `goro_face_happy.svg`
- **Workout screen** — добавлен `_SkalaDisplay` виджет для Challenge-тренировок:
  - Показывается только когда `plan.setType == SetType.challenge`
  - `skala_neutral.svg` во время фазы упражнений, `skala_approve.svg` в фазе отдыха (AnimatedSwitcher)
  - Тёмно-красный контейнер-фон `#5C1A1A`, height=140

**Изменённые файлы:**
`pubspec.yaml`, `lib/core/providers/goro_expression_provider.dart` (NEW),
`lib/features/home/screens/home_screen.dart`, `lib/features/workout/screens/summary_screen.dart`,
`lib/features/profile/screens/profile_screen.dart`, `lib/features/onboarding/screens/onboarding_screen.dart`,
`lib/features/workout/screens/workout_screen.dart`

**Следующий шаг:** новые ветки прогрессии (Pull, Legs, Balance) или тёмная тема.

---

### 2026-02-28 — сессия 20 (редизайн системы Challenge)

**Проблема:** Challenge был сломан по трём причинам — провалить невозможно (advanceStage вызывался при любом результате), отказаться невозможно (превью в каждой тренировке), никакой торжественности.

**Новая схема:**
```
isChallengeUnlocked = false  →  обычная тренировка
isChallengeUnlocked = true   →  обычная тренировка БЕЗ превью
                                + ChallengeCard на Home (пользователь сам решает когда готов)
Challenge → провал           →  этап не меняется, ChallengeCard остаётся
Challenge → успех            →  advanceStage + баннер «Новый этап!» в Summary
```

**Ключевые изменения:**

- **`Exercise.challengeTargetReps: int`** — новое поле (default 0). Минимум повторений/секунд для прохождения Challenge. Заполнено для всех stage-упражнений кроме финальных и s1 (нет challenge-перехода из ниоткуда).

- **`WorkoutGeneratorService`** — удалён блок добавления превью из `generateDaily()`. Добавлен `generateChallenge(branch)`: разминка → текущий этап (1 сет) → следующий этап (challengeTargetReps) → заминка.

- **`challengeBranchProvider = StateProvider<BranchId?>`** — управляет типом тренировки. null = обычная; branch = Challenge для этой ветки. Сбрасывается автоматически в `_finishWorkout` и при выходе пользователем.

- **`WorkoutState`** — новые поля: `challengeUnlocked`, `challengePassed`, `newStageExerciseId`. Передаются в `/summary` через extras.

- **`_finishWorkout`** — исправлена логика: для упражнений с `stage > currentStage` проверяет `completedReps >= challengeTargetReps` (для timed — `actualDurationSec`). `advanceStage` только при успехе.

- **Home screen** — удалён badge «Challenge разблокирован!» из `_BranchProgressCard`. Добавлен `_ChallengeCard` (tertiaryContainer) с именем следующего упражнения, нормативом и кнопкой «Принять вызов».

- **Summary screen** — два новых баннера: `_ChallengeUnlockedBanner` (при первой разблокировке) и `_ChallengePassedBanner` (при успешном переходе этапа, показывает имя нового упражнения).

- **l10n** — 6 новых ключей: `homeChallengeButton`, `homeChallengeNormReps`, `homeChallengeNormSec`, `summaryChallengeUnlockedTitle/Body`, `summaryChallengePassedTitle/Body`. `homeChallengeUnlocked` обновлён.

**Изменённые файлы:**
`exercise.dart`, `exercise_catalog.dart`, `workout_generator_service.dart`, `workout_provider.dart`, `workout_screen.dart`, `home_screen.dart`, `summary_screen.dart`, `l10n/app_ru.arb`, `l10n/app_en.arb`

**Следующий шаг:** система выражений Горо (шаги 1–5) или Скала на Challenge-экране.

---

### 2026-02-27 — сессия 18 (мелкие фиксы v1.1: стрик, язык, уведомления, минуты, цель)

**Реализованы все запланированные мелкие фиксы:**

- **Автоопределение языка** (`locale_provider.dart`) — `platformDispatcher.locale.languageCode` как fallback вместо хардкода `'ru'`. Первый запуск → язык системы; повторный → `profile.locale ?? системный`.

- **`displayStreak`** — новый `displayStreakProvider` в `streak_service.dart`. Вычисляет отображаемый стрик без мутации Hive (Вариант A): days ≤ 1 → stored, days == 2 + freeze → stored, иначе → 0. `homeDataProvider` и `profileDataProvider` используют провайдер; оба экрана показывают корректный стрик.

- **Уведомление о сгоревшем стрике (ID 4)** — `NotificationService.scheduleStreakLost(profile)`: планирует на следующее утро (notificationHour + 30 мин), только если `currentStreak >= 2`, текст содержит длину стрика. `cancelDayReminders()` теперь отменяет и ID 4. Вызывается из `_finishWorkout` после каждой тренировки.

- **`preferredWorkoutMinutes`** — `@HiveField(12) int?` в `UserProfile`. Онбординг сохраняет. Генератор: 5 мин → 1 подход, 10 мин → стандарт, ≥ 15 мин → +1 подход (cap 3). `WorkoutNotifier` читает из профиля при старте.

- **Пикер минут в Settings** — новая секция "ТРЕНИРОВКА" с анимированными чипами 5 / 10 / 15. Тап → мгновенное сохранение в Hive через `settingsProvider`.

- **`FitnessGoal` в Hive** — перенесён из `onboarding_provider.dart` в `data/models/enums.dart` (`@HiveType(typeId: 8)`). Адаптер написан вручную в `enums.g.dart`. Зарегистрирован в `main.dart`. `UserProfile @HiveField(13) FitnessGoal? fitnessGoal` — сохраняется при онбординге. Логика использования — отложена до появления новых веток.

**Изменённые файлы:**
`locale_provider.dart`, `streak_service.dart`, `home_provider.dart`, `profile_provider.dart`, `profile_screen.dart`, `home_screen.dart`, `notification_service.dart`, `workout_provider.dart`, `user_profile.dart`, `user_profile.g.dart`, `enums.dart`, `enums.g.dart`, `main.dart`, `onboarding_provider.dart`, `onboarding_screen.dart`, `settings_provider.dart`, `settings_screen.dart`, `l10n/app_ru.arb`, `l10n/app_en.arb`

**Следующий шаг:** система выражений Горо (шаги 1–5) или редизайн Challenge-системы.

---

### 2026-02-28 — сессия 20b (мелкие фиксы: ориентация экрана, DeveloperOptions overflow)

**Блокировка портретной ориентации:**
`main.dart` — добавлен вызов `SystemChrome.setPreferredOrientations([portraitUp, portraitDown])` сразу после `WidgetsFlutterBinding.ensureInitialized()`. Импорт: `package:flutter/services.dart`. Горизонтальная ориентация заблокирована до тех пор, пока UI не будет адаптирован.

В `DEV_NOTES.md` (раздел «v1.2 — Идеи») добавлена заметка о будущей поддержке landscape: убрать блокировку и переработать раскладки через `LayoutBuilder` / двухколоночный layout при `maxWidth > 600`.

**Фикс overflow в DeveloperOptionsScreen:**
`_ChipRow<T>` (горизонтальный ряд чипов) вызывал `RenderFlex overflowed by 60px` на строке «Последняя тренировка» (5 чипов: Сегодня/Вчера/2 дня/3 дня/Никогда). Заменён на `_DevDropdown<T>` — обёртка над стандартным `DropdownButton`. Применено к трём местам: «Последняя тренировка», «Заморозки», «Подходы». `_DevRow` возвращён к оригинальному Row-макету.

**Изменённые файлы:** `lib/main.dart`, `lib/features/settings/screens/developer_options_screen.dart`

---

### 2026-02-28 — сессия 19 (DeveloperOptionsScreen)

**Реализован экран «Возможности разработчика»** (только `kDebugMode`), доступный из Settings через плитку «Возможности разработчика».

**Новый файл:**
- `lib/features/settings/screens/developer_options_screen.dart` — `ConsumerStatefulWidget`, 5 секций

**Секции экрана:**
- **ПРОФИЛЬ:** степпер стрика (0-365), чипы lastWorkoutDate (Сегодня/Вчера/2 дня/3 дня/Никогда), степпер SP (шаг 100, tap-to-edit), чипы заморозок (0-3), dropdown ранга + кнопка «Сохранить профиль»
- **ПРОГРЕСС ВЕТОК:** для каждой ветки — степпер этапа (max: Push=7, Core=6, остальные=5-6), степпер повторений, чипы подходов 1/2/3, switch challenge + кнопка «Сохранить»
- **ЖУРНАЛ ТРЕНИРОВОК:** счётчик, удалить сегодня, добавить фейковую (date picker), удалить все (с подтверждением)
- **УВЕДОМЛЕНИЯ:** 4 кнопки «→ сейчас» (утро/вечер/угроза/потеря стрика), показать запланированные
- **ПРИЛОЖЕНИЕ:** дамп состояния (диалог), полный сброс → онбординг (с подтверждением, очищает все Hive-боксы)

**Изменённые файлы:**
- `workout_repository.dart` — добавлен `deleteAll()`
- `notification_service.dart` — добавлены `debugShowMorning/Evening/StreakThreat/StreakLost(profile)`, приватный `_debugFireNow(...)`, публичный `pendingRequests()`
- `app_router.dart` — маршрут `/dev-options` под `if (kDebugMode)`
- `settings_screen.dart` — 3 старых debug-тайла заменены одним; удалены ненужные импорты

**Следующий шаг:** система выражений Горо (шаги 1–5) или редизайн Challenge-системы.

---

### 2026-02-27 — сессия 17 (приёмка ассетов дизайнера v1.1)

**Получено от дизайнера** (`docs/caliday_design_v1_1/`):
- `goro_face_happy/sad/angry/sleeping/excited/supportive.svg` — 6 выражений лица Горо
- `goro_idle_v2.svg`, `goro_flex_v2.svg` — редизайн базовых поз (реалистичные пропорции гориллы:
  сагиттальный гребень, массивные надбровные дуги, knuckle-кисти, barrel-shape торс)
- `skala_neutral.svg` — Скала со скрещенными руками, нейтральный взгляд
- `skala_approve.svg` — Скала с foreshortened большим пальцем, золотые искры

**Обновлена документация:**
- `docs/tz_designer_v1_1.md` — Блоки 1 и 3 отмечены ✅ Сдано, добавлена таблица поставки
- `docs/design-concept/caliday_design_concept.md` — Скала ✅, палитра `#5C1A1A→#3A0C0C`,
  таблицы файлов разбиты на v1.0 / v1.1-готовые / v1.1-ожидаемые
- `docs/DEV_NOTES.md` — добавлен раздел «Дизайн-ассеты v1.1» с планом интеграции (5 шагов),
  цветами Скалы, структурой SVG-слоёв

Код не написан. **Следующий разработческий шаг:** реализовать `GoroExpressionProvider` (шаги 1-5 выше).

---

### 2026-02-27 — сессия 16 (архитектурные решения v1.1, обновление документации)

Обсуждены и зафиксированы в DEV_NOTES следующие решения (код не написан):

- **Экран «Возможности разработчика»:** `DeveloperOptionsScreen` (только kDebugMode),
  доступен из Settings. Прямые контролы для каждого поля состояния — не хардкодные сценарии.
  Разделы: Профиль, Прогресс веток, Журнал тренировок, Уведомления, Приложение.
- **Редизайн Challenge:** отдельная кнопка на Home, реальный норматив `challengeTargetReps`
  в `Exercise`, провал = остаёмся на этапе, баннеры разблокировки и перехода в Summary.
- **Отображаемый стрик (Вариант A):** `displayStreak` вычисляется на лету в `homeDataProvider`
  без мутации Hive. Home использует его вместо `profile.currentStreak` напрямую.
- **Автоопределение языка:** использовать `platformDispatcher.locale.languageCode` в `main.dart`
  как дефолт для `localeProvider` — вместо хардкода `'ru'`.
- **Уведомление о сгоревшем стрике:** новый ID 4 `streak_lost`, планируется на следующее утро
  после завершения тренировки, отменяется при следующей.
- **Tech debt `workoutMinutes`:** ответ онбординга не передаётся в `UserProfile` — зафиксировано
  как задача: добавить `@HiveField(12) preferredWorkoutMinutes`, использовать в генераторе.
- **Новые ветки v1.1:** Pull (6 этапов, нужен турник), Legs (5), Balance (6) — детальные таблицы
  упражнений и технические задачи описаны в разделе «Идеи для будущих версий».

### 2026-02-27 — сессия 15 (локализация RU+EN, v1.1.0+2)

**Архитектура локализации:**
- `flutter_localizations` + `intl ^0.20.0` в `pubspec.yaml`; `flutter: generate: true`
- `.arb`-файлы: `l10n/app_ru.arb` (шаблон), `l10n/app_en.arb` — ~145 ключей
- `l10n.yaml`: `arb-dir: l10n`, `output-dir: lib/l10n`, генерация через `flutter gen-l10n`
- `package:caliday/l10n/app_localizations.dart` — правильный путь импорта (НЕ `flutter_gen`)
- `lib/core/extensions/build_context_l10n.dart` — расширение `context.l10n`
- `lib/core/extensions/exercise_l10n.dart` — `ExerciseL10n.name/description/tip(l10n, id)`
- `lib/core/providers/locale_provider.dart` — `StateProvider<String>`, читает `profile.locale ?? 'ru'`
- `RankLocalization` extension в `enums.dart` — `rank.localizedName(l10n)`
- Enum-расширения для онбординга (в `onboarding_screen.dart`): `FitnessFrequencyL10n`, `PushupCountL10n`, `WorkoutMinutesL10n`, `FitnessGoalL10n`, `_TimeLabelL10n`

**Модель данных:**
- `UserProfile`: добавлено `@HiveField(11) String? locale` (null = 'ru', совместимо со старыми данными)
- `user_profile.g.dart`: вручную обновлён — `writeByte(11→12)`, добавлена запись поля locale

**UI:**
- `MaterialApp.router`: `locale: Locale(locale)`, `supportedLocales/localizationsDelegates` из `AppLocalizations`
- Settings: секция «Язык» — `SimpleDialog` с `RadioGroup<String>` (RadioListTile без deprecated `groupValue/onChanged`)
- Onboarding step 0: `Stack` + `Positioned` overlay с переключателем `[RU | EN]`
- Все хардкодные строки во всех экранах заменены на `l10n.*`
- Даты в Profile → `intl.DateFormat('d MMMM', locale).format(date)` (locale-aware)

**Уведомления:**
- `NotificationService`: `_notifStrings` static const Map<String, Map<String, String>>
- `scheduleAll(profile)` читает `profile.locale ?? 'ru'` для выбора строк (нет BuildContext)

**Результат:** `flutter analyze` → No issues found

---

**Как добавить новый язык:**
1. Скопировать `l10n/app_ru.arb` в `l10n/app_XX.arb` (где `XX` — код языка)
2. Перевести все строки в новом файле
3. Добавить `XX` в `preferred-supported-locales` в `l10n.yaml`
4. Запустить `flutter gen-l10n`
5. Добавить `_LangButton` и `RadioListTile` в settings_screen.dart + onboarding_screen.dart
6. Добавить locale в `_notifStrings` в `notification_service.dart`

---

### 2026-02-27 — сессия 14 (иконка уведомления Android)
- **`ic_goro_notif.xml`** заменён — ручной силуэт головы Горо (~6 путей) → горилла-эмодзи 🦍 (431 путь)
  - Источник: Android Vector Drawable горилла-эмодзи (160×159 viewport)
  - Конвертация: Python-скрипт — удалён фон (`M0 0L0 159L160 159L160 0L0 0z`), все `fillColor` → `#FFFFFF`, stroke-атрибуты удалены
  - Итоговый файл: `android/app/src/main/res/drawable/ic_goro_notif.xml`, размер 24dp×24dp
  - Превью: `docs/ic_goro_notif_preview.html`
- `flutter clean` + переустановка → монохромная горилла в статус-баре ✅

### 2026-02-27 — сессия 13 (заморозки: уведомления об использовании + debug)
- **Уведомление об использовании заморозки:**
  - `applyWorkout(profile, date)` теперь возвращает `bool` (была ли потрачена заморозка)
  - `WorkoutState.freezeUsed: bool` — новое поле, пробрасывается в summary extras
  - `SummaryScreen`: баннер `_FreezeUsedBanner` («Заморозка сохранила стрик!»)
  - Если оба события одновременно — баннеры разделены `SizedBox(height: 10)`
- **Debug-кнопки в Settings (kDebugMode):**
  - `[DEBUG] Стрик → 6, сброс тренировки` — streak=6, lastWorkoutDate=вчера, удаляет сегодняшний лог
  - `[DEBUG] Симулировать пропуск дня` — lastWorkoutDate=позавчера, удаляет сегодняшний лог
- `WorkoutRepository.deleteForDate(date)` — новый метод удаления лога по дате
- `flutter analyze` → No issues found

### 2026-02-27 — сессия 12 (заморозки стрика — зарабатывание)
- **Механика получения заморозок:**
  - `StreakService.tryAwardFreeze(profile)` — 1 заморозка каждые 7 дней стрика, макс. 3
  - `WorkoutNotifier._finishWorkout` вызывает `tryAwardFreeze` после `applyWorkout`
  - `WorkoutState.freezeEarned: bool` — пробрасывается в summary extras
  - `SummaryScreen`: баннер `_FreezeEarnedBanner` (❄️ «Получена заморозка стрика!»)
- Чеклист v1.0 полностью закрыт ✅
- `flutter analyze` → No issues found

### 2026-02-25 — сессия 11 (дизайн Горо + полировка)
- **Дизайн-концепция полностью внедрена:**
  - Бренд-цвет #58CC02 → #4DA6FF: `main.dart` seedColor, оба `launch_background.xml`, iOS `LaunchScreen.storyboard`, `adaptive_icon_background`
  - Горо добавлен на Home (`goro_flex`, h=140), Summary (вместо 🎉), Onboarding Welcome (вместо 🏋️, заголовок "Привет! Я Горо")
  - Иконка приложения: `caliday_icon_face.svg` → `icon.png` (rsvg-convert 1024×1024) → `flutter_launcher_icons`
  - `icon_foreground.png` — Горо без фона для Android adaptive icon
  - `remove_alpha_ios: true` в pubspec — убирает альфа-канал iOS иконок
- **Android notification icon:**
  - Создан `drawable/ic_goro_notif.xml` — Vector Drawable (силуэт головы Горо, белый)
  - `NotificationService`: `AndroidInitializationSettings('ic_goro_notif')` + `AndroidNotificationDetails(icon: 'ic_goro_notif')`
  - Small icon в статус-баре отображает монохромную горилла-эмодзи 🦍 ✅
  - Large icon в шторке = адаптивная иконка приложения (Горо на синем) ✅
  - `ic_goro_notif.xml` — 431-путёвый Vector Drawable из эмодзи, все пути `#FFFFFF`, фон удалён
- **Имя приложения:** `android:label="caliday"` → `android:label="CaliDay"` в AndroidManifest.xml
- **Gradle:** root `build.gradle.kts` — subprojects переопределяют Java/Kotlin до VERSION_17 (подавляет предупреждения "Java 8 obsolete"); используется `compilerOptions { jvmTarget.set(JvmTarget.JVM_17) }`
- `flutter analyze` → No issues found

### 2026-02-25 — сессия 10
- iOS-уведомления: добавлен `UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate` в `AppDelegate.swift` (требование flutter_local_notifications README). Без этой строки `UNUserNotificationCenterDelegate` методы никогда не вызываются → уведомления молча дропаются.
- Добавлен `import UserNotifications` в AppDelegate.swift
- Уведомления на iOS подтверждены работающими ✅
- Time picker: заменён `showTimePicker` (Material clock) на `showModalBottomSheet` + `CupertinoDatePicker` — скроллируемые барабаны в стиле iOS, работает на обеих платформах

### 2026-02-25 — сессия 9
- Android-фиксы для запуска на реальном устройстве/эмуляторе:
  - `build.gradle.kts`: включён `isCoreLibraryDesugaringEnabled = true` + зависимость `desugar_jdk_libs:2.1.4` (требование flutter_local_notifications)
  - `flutter_timezone` обновлён с `^1.0.4` до `^5.0.0` (старая версия использовала удалённый Android API `Registrar`); в v5 поле `.identifier` вместо `.name`
  - `AndroidManifest.xml`: добавлены `POST_NOTIFICATIONS` + `RECEIVE_BOOT_COMPLETED`
- Home screen: stats row обёрнут в `Flexible` — исправлен overflow ранга
- Уведомления на Android — исправлена корневая причина молчаливого провала:
  - `scheduleAll()` в `main()` запускался ДО выдачи разрешения → все `zonedSchedule` молча падали
  - Исправление: `requestPermissionIfNeeded()` возвращает `bool`; после выдачи разрешения `scheduleAll()` вызывается повторно из `CaliDayApp.initState` через `addPostFrameCallback`
  - `CaliDayApp` переведён в `ConsumerStatefulWidget` (нужна активная Activity для диалога на Android 13+)
  - Debug-тест заменён с `zonedSchedule` (5 сек) на мгновенный `show()` — надёжнее на эмуляторе
- Уведомления на Android подтверждены работающими ✅
- `flutter analyze` → No issues found

### 2026-02-24 — сессия 8
- Уведомления: NotificationService (singleton) в lib/core/services/
- Инициализация + расписание на старте приложения (main.dart)
- Три типа: утреннее (user-configured time), вечерний дожим (20:00), угроза стрику (22:00)
- SettingsNotifier._save() → scheduleAll(); первое включение → requestPermission()
- После завершения тренировки: cancelDayReminders() отменяет вечерние ID 2 и 3
- Новые зависимости: timezone ^0.9.4, flutter_timezone ^1.0.4
- `flutter analyze` → No issues found

### 2026-02-24 — сессия 7
- Исправлено: межупражнений отдых (isInterExerciseRest) — теперь между упражнениями
  показывается экран «Упражнение выполнено!» с названием следующего
- Исправлено: layout overflow — заменён Spacer() на Expanded(SingleChildScrollView)
  + фиксированная нижняя панель в WorkoutScreen
- `flutter analyze` → No issues found

### 2026-02-24 — сессия 6
- Profile экран: rank-карточка с прогресс-баром до следующего ранга, stats-сетка (стрик/рекорд/трен/заморозки), история последних 7 тренировок
- Settings экран: master-toggle уведомлений, time picker, вечерний дожим, угроза стрику — всё сохраняется в UserProfile
- Роутер: /profile и /settings подключены, _Placeholder удалён
- `flutter analyze` → No issues found

### 2026-02-24 — сессия 5
- Home экран: реальные BranchProgressCard (прогресс-бар, стадия, challenge-бейдж)
- Workout экран: полный state machine (exercise / rest / done), reps-счётчик, круговой таймер
- Summary экран: SP, время, кол-во упражнений, кнопка «Домой»
- Роутер: wire WorkoutScreen + SummaryScreen с GoRouter extras
- `flutter analyze` → No issues found

### 2026-02-24 — сессия 4
- Навигация: go_router + RouterNotifier + isOnboardingCompleteProvider
- Онбординг: 6 шагов, OnboardingState/Notifier, калибровка уровня
- Placeholder home screen
- `flutter analyze` → No issues found

### 2026-02-24 — сессия 3
- Создан доменный слой: `WorkoutPlan`, `SPService`, `StreakService`, `ProgressionService`, `WorkoutGeneratorService`
- `flutter analyze` → No issues found

### 2026-02-24 — сессия 2
- Созданы репозитории: `UserRepository`, `SkillProgressRepository`, `WorkoutRepository`
- `flutter analyze` → No issues found

### 2026-02-24 — сессия 1
- Создан слой данных: 5 моделей + enums, каталог упражнений, `main.dart`
- Сгенерированы Hive-адаптеры (`dart run build_runner build`)
- `flutter analyze` → No issues found