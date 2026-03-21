# CaliDay — Архитектура и технические решения

Справочный документ. Содержит стабильные решения, принятые в проекте.
Обновляется после реализации фич — финальные решения фиксируются здесь.

> **Живые заметки и история:** `docs/DEV_NOTES.md`
> **Дизайн-концепция:** `docs/design-concept/caliday_design_concept.md`

---

## Описание проекта

Мобильное приложение для домашних тренировок с игровой механикой прогрессии.
Пользователь проходит от базовых упражнений (отжимания с колен) до продвинутой
калистеники (стойка на руках) через короткие ежедневные сеты по 5-15 минут.

**Принципы:** все данные локально, нет бэкенда, бесплатное, без рекламы.

---

## Технический стек

| Слой | Решение |
|------|---------|
| UI | Flutter (Dart) |
| State management | Riverpod |
| Локальное хранение | Hive |
| Навигация | go_router |
| Уведомления | flutter_local_notifications |
| Анимации | Lottie (`lottie: ^3.3.2`) |
| Аудио | `audioplayers: ^6.1.0` |
| Виджет рабочего стола | `home_widget: ^0.9.0` |
| Deep links | `app_links: ^6.4.1` |
| Health | `health: ^12.0.0` |
| Целевые платформы | iOS (первичная), Android (вторичная) |

---

## Архитектура

Feature-first структура с разделением на слои:

```
lib/
├── main.dart                          ← Hive init, ProviderScope, locale, deep links
├── l10n/                              ← СГЕНЕРИРОВАНО flutter gen-l10n (не редактировать)
├── core/
│   ├── router/app_router.dart         ← GoRouter + RouterNotifier
│   ├── services/
│   │   ├── notification_service.dart  ← NotificationService singleton
│   │   ├── sound_service.dart         ← SoundService singleton
│   │   ├── health_service.dart        ← HealthService singleton
│   │   └── widget_service.dart        ← WidgetService singleton
│   ├── providers/
│   │   ├── locale_provider.dart       ← StateProvider<String>
│   │   └── goro_expression_provider.dart
│   └── extensions/
│       ├── build_context_l10n.dart    ← context.l10n shortcut
│       └── exercise_l10n.dart         ← ExerciseL10n static helper
├── data/
│   ├── models/
│   │   ├── enums.dart + enums.g.dart  ← BranchId, SetType, ExerciseType, Rank, FitnessGoal
│   │   ├── exercise.dart              ← статическая модель (без Hive)
│   │   ├── exercise_result.dart + .g.dart
│   │   ├── skill_progress.dart + .g.dart
│   │   ├── user_profile.dart + .g.dart
│   │   └── workout_log.dart + .g.dart
│   ├── repositories/
│   │   ├── user_repository.dart
│   │   ├── skill_progress_repository.dart
│   │   ├── workout_repository.dart
│   │   └── achievement_repository.dart
│   └── static/
│       ├── exercise_catalog.dart      ← Push(7)+Pull(6)+Core(6)+Legs(5)+Balance(6) + warmup/cooldown
│       └── achievement_catalog.dart   ← 27 достижений
├── domain/
│   ├── models/workout_plan.dart       ← WorkoutPlan, PlannedExercise
│   └── services/
│       ├── sp_service.dart
│       ├── streak_service.dart
│       ├── progression_service.dart
│       ├── workout_generator_service.dart
│       └── achievement_service.dart
└── features/
    ├── home/screens/
    │   ├── home_screen.dart           ← вкладка Тренировка
    │   ├── progress_screen.dart       ← вкладка Прогресс (ветки)
    │   └── branch_journey_screen.dart ← /branch/:branchId
    ├── workout/
    │   ├── providers/workout_provider.dart
    │   └── screens/
    │       ├── workout_screen.dart
    │       └── summary_screen.dart
    ├── profile/screens/
    │   ├── profile_screen.dart
    │   └── achievements_screen.dart   ← /achievements
    ├── settings/
    │   ├── providers/settings_provider.dart
    │   └── screens/
    │       ├── settings_screen.dart
    │       └── developer_options_screen.dart ← только kDebugMode
    ├── onboarding/screens/onboarding_screen.dart
    └── about/screens/about_screen.dart ← /about
```

---

## Ключевые концепции

### Сет (Set / Workout)
Короткое занятие: 3-6 упражнений, 5-15 минут. Типы: `Daily`, `Skill`, `Challenge`.

### Ветки прогрессии (Branches)
5 веток: Push, Pull, Core, Legs, Balance. Каждая — линейка этапов от простого к сложному.
Pull требует турник (`requiresEquipment = true`). `UserProfile.activeBranches` — computed getter,
фильтрует Pull если `hasPullUpBar == false`.

### Прогрессия внутри этапа
Повторения ↑ → Подходы ↑ (с ресетом повторений) → Отдых ↓ → Challenge-тест → Следующий этап.

### Геймификация
- **SP (Strength Points)** — очки за упражнения
- **Streak** — дни подряд; заморозки (макс. 3, зарабатывается каждые 7 дней стрика)
- **Ранги:** Новичок → Любитель → Спортсмен → Атлет → Мастер → Легенда
- **Достижения** — 27 штук, проверяются после каждой тренировки и перехода этапа
- **Бонусные тренировки** — можно делать несколько тренировок в день (50% SP, прогрессия не двигается)

### Основная vs Бонусная тренировка
`WorkoutLog.isPrimary`: true = первая за день (полные SP, двигает прогрессию); false = 50% SP.
Определяется при старте: есть ли уже `WorkoutLog` за сегодня → `isPrimary = false`.

---

## Данные и Hive

### Hive typeId-ы (нельзя менять после релиза)

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
| 9 | `FriendProfile` (зарезервировано, v1.4) |

### UserProfile HiveFields

| Field | Тип | Описание |
|-------|-----|----------|
| @0..13 | base | currentStreak, totalSP, rank, lastWorkoutDate, и др. |
| @14 | String? | themeModeName (null=system, 'light', 'dark') |
| @15 | bool? | hasPullUpBar |
| @16 | — | зарезервировано, не используется |
| @17 | String? | peerId (v1.4 Friends) |
| @18 | String? | displayName (v1.4 Friends) |
| @19 | bool? | soundEnabled (null → true) |
| @20 | bool? | hapticEnabled (null → true) |
| @21 | bool? | healthWorkoutsEnabled |
| @22 | bool? | healthWeightEnabled |

### WorkoutLog HiveFields
| Field | Тип | Описание |
|-------|-----|----------|
| @0..4 | base | date, setType, exercises, spEarned, durationSec |
| @5 | bool | isPrimary — false = бонусная тренировка |

### Hive boxes
- `'user'` — `Box<UserProfile>`
- `'skill_progress'` — `Box<SkillProgress>`
- `'workout_log'` — `Box<WorkoutLog>`
- `'achievements'` — `Box<int>` (millisecondsSinceEpoch, ключ = achievementId)

### Модель Exercise
`Exercise` — статическая `const`-модель, **не хранится в Hive**.
Загружается из `ExerciseCatalog`. `stage = 0` = warmup/cooldown.

---

## Каталог упражнений

### Rank пороги SP
| Ранг | SP |
|------|----|
| Новичок | 0 |
| Любитель | 500 |
| Спортсмен | 2 000 |
| Атлет | 5 000 |
| Мастер | 15 000 |
| Легенда | 50 000 |

### Ветка Push (7 этапов)
| Этап | ID | Название | Lottie |
|------|----|----------|--------|
| 1 | `push_s1_wall_pushup` | Отжимания от стены | ✅ |
| 2 | `push_s2_knee_pushup` | Отжимания с колен | ✅ |
| 3 | `push_s3_full_pushup` | Полные отжимания | ✅ |
| 4 | `push_s4_diamond_pushup` | Алмазные отжимания | ✅ |
| 5 | `push_s5_wide_pushup` | Широкие отжимания | ✅ |
| 6 | `push_s6_archer_pushup` | Отжимания лучника | ✅ |
| 7 | `push_s7_handstand_pushup` | Отжимания в стойке | ✅ |

### Ветка Pull (6 этапов, требует турник)
| Этап | ID | Название |
|------|----|----------|
| 1 | `pull_s1_australian` | Австралийские подтягивания |
| 2 | `pull_s2_negative` | Негативные подтягивания |
| 3 | `pull_s3_pullup` | Подтягивания |
| 4 | `pull_s4_close_grip` | Подтягивания узким хватом |
| 5 | `pull_s5_archer` | Подтягивания лучника |
| 6 | `pull_s6_one_arm` | Подтягивания на одной руке |

### Ветка Core (6 этапов)
| Этап | ID | Название |
|------|----|----------|
| 1 | `core_s1_crunches` | Скручивания |
| 2 | `core_s2_plank` | Планка |
| 3 | `core_s3_lying_leg_raise` | Подъёмы ног лёжа |
| 4 | `core_s4_hanging_leg_raise` | Подъёмы ног в висе |
| 5 | `core_s5_l_sit` | Уголок (L-sit) |
| 6 | `core_s6_dragon_flag` | Драконовый флаг |

### Ветка Legs (5 этапов)
| Этап | ID | Название |
|------|----|----------|
| 1 | `legs_s1_squat` | Приседания |
| 2 | `legs_s2_lunge` | Выпады |
| 3 | `legs_s3_bulgarian` | Болгарские приседания |
| 4 | `legs_s4_assisted_pistol` | Пистолетик с опорой |
| 5 | `legs_s5_pistol` | Пистолетик |

### Ветка Balance (6 этапов)
| Этап | ID | Название |
|------|----|----------|
| 1 | `bal_s1_one_leg_stand` | Стойка на одной ноге |
| 2 | `bal_s2_one_arm_plank` | Планка на одной руке |
| 3 | `bal_s3_crow_prep` | Подвод к позе ворона |
| 4 | `bal_s4_crow_pose` | Поза ворона |
| 5 | `bal_s5_wall_hs` | Стойка у стены |
| 6 | `bal_s6_free_hs` | Свободная стойка |

---

## Сервисы (доменный слой)

### SPService
- `forExercise(result, exercise)` — SP за упражнение; warmup/cooldown (stage=0) → 0
- `forWorkout(...)` — суммирует SP; primary = ×1.5 (daily bonus) × 1.1 (completion); bonus = ×0.5
- `applyToProfile(profile, sp)` — мутирует профиль: SP + ранг

### StreakService
- `applyWorkout(profile, date)` → bool — обновляет стрик; при пропуске 1 дня тратит заморозку
- `tryAwardFreeze(profile)` → bool — +1 заморозка каждые 7 дней (макс. 3)
- `isStreakAtRisk(profile)` — true если сегодня не тренировался
- `daysSinceLastWorkout(profile)` — счётчик

**displayStreak (важно):** вычисляется в `homeDataProvider` на лету, не мутируя Hive:
```
days <= 1                          → profile.currentStreak
days == 2 && freezeCount > 0       → profile.currentStreak  (заморозка спасёт при следующей тренировке)
иначе                              → 0
```

### ProgressionService
- `applyResult(progress, exercise, result)` → bool (true = challenge разблокирован)
- `advanceStage(progress, nextExercise)` — переход этапа после challenge
- `applyRegression(progress, exercise, daysSkipped)` — откат при пропуске 3+ дней
- `nextExercise(progress)` — следующий этап из каталога

### WorkoutGeneratorService
- `generateDaily({activeBranches, preferredMinutes, dayIndexOverride?})` — ротация веток по dayIndex (дни с 2020-01-01). N веток: min(2,total) при ≤5мин, min(3,total) при 10мин, total при ≥15мин
- `generateChallenge(branch)` — warmup → текущий этап (1 лёгкий сет) → следующий этап (challengeTargetReps) → cooldown

### AchievementService
- `checkAfterWorkout({profile, log, totalWorkouts, achievementRepo})` → `List<String>` новые
- `checkAfterStageAdvance({branch, newStage, allProgress, achievementRepo})` → `List<String>` новые

### SoundService (singleton)
- Методы: `tick()`, `ding()`, `pop()`, `complete()`
- **НЕ использовать `await player.stop()` перед play()** — вызывает сброс Android MediaPlayer (~100-200мс). `player.play()` сам обрабатывает рестарт.
- Конфигурируется из `SettingsNotifier` при загрузке и изменении настроек

### Паттерн мутации
Все сервисы **мутируют** переданные объекты (`UserProfile`, `SkillProgress`) на месте.
Сохранение — ответственность вызывающего кода через репозитории.

---

## Навигация

### Bottom nav (StatefulShellRoute.indexedStack)
- `/home` — Тренировка (HomeScreen)
- `/progress` — Прогресс (ProgressScreen с ветками)
- `/profile` — Профиль (ProfileScreen)

### Top-level маршруты (без bottom nav)
- `/onboarding` — онбординг (redirect если профиль есть)
- `/workout` — тренировка
- `/summary` — итоги
- `/branch/:branchId` — путь прогрессии ветки
- `/achievements` — все достижения
- `/settings` — настройки
- `/about` — о приложении
- `/dev-options` — devtools (только `kDebugMode`)

### Флоу тренировки
```
home → push(/workout) → pushReplacement(/summary) → go(/home)
```
После завершения: `_ref.invalidate(homeDataProvider)` + `_ref.invalidate(profileDataProvider)`

### WorkoutState при phase == done
- `spEarned`, `freezeEarned`, `freezeUsed`
- `challengeUnlocked`, `challengePassed`, `newStageExerciseId`
- `healthSaved: bool`

### Запуск Challenge
1. Home → ChallengeCard кнопка (`isChallengeUnlocked == true`)
2. BranchJourney → кнопка «Пройти испытание» на текущем этапе (всегда доступно)
Оба входа ведут к одному флоу: `challengeBranchProvider = branch` → `/workout`.

### RouterNotifier
- `isOnboardingCompleteProvider` — `StateProvider<bool>`, инициализируется из `userRepository.hasProfile`
- Deep link guard: `if (state.uri.scheme == 'caliday') return '/workout';` в redirect

---

## Онбординг (7 шагов)

| Шаг | Содержание |
|-----|-----------|
| 0 | Welcome — Горо + описание |
| 1 | Как часто занимаешься спортом? |
| 2 | Сколько отжиманий? (калибровка Push) |
| 3 | Сколько минут в день? (→ `preferredWorkoutMinutes`) |
| 4 | К чему стремишься? |
| 5 | Есть ли турник дома? (→ `hasPullUpBar`) |
| 6 | Во сколько напомнить? |

**Калибровка Push:** 0 отж. → s1 r3; 1-5 → s2 r5; 5-15 → s3 r5; 15+ → s3 r10 sets=2

---

## Дизайн-система

### Маскот Горо
Горилла в flat-стиле, голубая повязка. Ассеты в `assets/goro/`:
- `goro_face_[happy/sad/angry/sleeping/excited/supportive].svg` — 6 выражений
- `goro_flex_v2.svg` — промо
- `goro_idle_v2.svg` — idle

Размещение:
- **Home** — AnimatedSwitcher по expression (h=140)
- **Summary** — `goro_flex_v2` (h=120)
- **Profile** — `goro_idle_v2` (h=100)
- **Onboarding welcome** — `goro_face_happy` (h=120)
- **About** — `goro_idle_v2` (h=100)

**GoroExpressionProvider логика:**
`sleeping(23-6h)` > `happy(workoutToday)` > `angry(22h+,streak>0)` > `sad(20h+)` > `supportive(daysSince≥2)` > `happy`

### Скала (Бык)
`assets/skala/skala_neutral.svg` + `skala_approve.svg` — на WorkoutScreen Challenge-фазе, фон `#5C1A1A`.

### Цветовая палитра

| Роль | HEX |
|------|-----|
| Primary | `#4DA6FF` |
| Primary Dark | `#2B7DE9` |
| Primary Light (повязка Горо) | `#A8D8FF` |
| Energy (стрики) | `#FF9500` |
| Success (прогресс) | `#34C759` |
| Challenge bg | `#5C1A1A` |

### Иконка приложения
- `assets/icon/icon.png` — 1024×1024 (iOS)
- `assets/icon/icon_foreground.png` — без фона (Android adaptive)
- `remove_alpha_ios: true` в `flutter_launcher_icons`
- Notification: `android/app/src/main/res/drawable/ic_goro_notif.xml` (Vector Drawable, белый силуэт)

### Emoji policy
- **UI chrome** → Material Icons во всех виджетах (последовательно заменено)
- `BranchId.icon` геттер → `IconData` (в `enums.dart`)
- `BranchId.emoji` — сохранён для `achievement_catalog.dart` (контент)
- Флаги 🇷🇺/🇬🇧 в language dialog — intentional
- Achievement emoji в тайлах — игровой контент, сохранить
- Toast ✅ — праздничный фидбек, сохранить

---

## Уведомления

| ID | Ключ | Когда |
|----|------|-------|
| 1 | `morning` | Утреннее напоминание |
| 2 | `evening` | Вечернее напоминание |
| 3 | `streak_at_risk` | Угроза стрику (~22:00 если не тренировался) |
| 4 | `streak_lost` | Потеря стрика (следующее утро +30мин, если streak≥2) |
| 5 | `rest_timer` | (v1.3, не реализовано) |

---

## Home Screen Widget

- Small (2×2): Горо + streak + SP
- Medium (4×2): Горо + streak + SP + ранг + статус «Готово»
- Deep link: `caliday://workout`
- SharedPreferences keys: `streak`, `totalSP`, `workoutDoneToday`, `rankName`, `lastUpdated`
- App Group ID (iOS): `group.com.pupptmstr.caliday`
- Android receivers: `CaliDayWidgetReceiver` (small), `CaliDayWidgetMediumReceiver` (medium)

**iOS требует ручных шагов в Xcode:**
1. File → New → Target → Widget Extension → `CaliDayWidget`
2. Заменить `.swift` из `ios/CaliDayWidget/CaliDayWidget.swift`
3. Добавить PNG-ассеты из `ios/CaliDayWidget/Assets.xcassets/`
4. Runner target → Signing & Capabilities → App Groups → `group.com.pupptmstr.caliday`

---

## Health Integration

- **Пишем:** workout session (`STRENGTH_TRAINING`) + калории (MET 5.5 × 70кг × часы)
- **Читаем:** масса тела (опционально, для точного расчёта калорий)
- Все функции opt-in через Settings → ЗДОРОВЬЕ
- `HealthService.instance.configure()` обёрнут в `.timeout(5s)` (иначе зависает на splash)

**Критично для Android:**
- `MainActivity` расширяет `FlutterFragmentActivity` (не `FlutterActivity`)
- `activity-alias` с `HEALTH_PERMISSIONS` в AndroidManifest обязателен для диалога разрешений

**iOS:** capability HealthKit нужно добавить вручную в Xcode (Runner → Signing & Capabilities → + → HealthKit)

---

## Android специфика

- `minSdk = 26` (health package требует API 26+)
- `build.gradle.kts`: `isCoreLibraryDesugaringEnabled = true` + `desugar_jdk_libs:2.1.4`
- Root `build.gradle.kts`: `compilerOptions { jvmTarget.set(JvmTarget.JVM_17) }`, **не** `kotlinOptions` (compile error)
- `flutter_timezone ^5.0.0`: поле `.identifier` (не `.name`)
- `build_runner` зафиксирован на `^2.4.13` (`^2.4.14` несовместим с `hive_generator ^2.0.1`)
- NotificationService init — ТОЛЬКО в `postFrameCallback`, не в `main()` до `runApp()`
- AndroidManifest: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `SCHEDULE_EXACT_ALARM`, `VIBRATE`
- Proguard: `keep.xml` (drawable) + `proguard-rules.pro` (dexterous + TypeToken)

### Android уведомления
- Small icon (монохромный, статус-бар): `AndroidInitializationSettings('ic_goro_notif')` + `drawable/ic_goro_notif.xml`
- Large icon (цветной, шторка, Android 12+): adaptive icon приложения, добавляется автоматически
- Имя `ic_notification` нельзя использовать (конфликт с ресурсом внутри пакета)

### Android виджет
- Glance → **AppWidgetProvider + RemoteViews** (Glance требует Compose Compiler Plugin, который не включён во Flutter-проектах по умолчанию)
- `updateWidget(qualifiedAndroidName: ...)` — использовать `qualifiedAndroidName`, не `androidName` (иначе пакет добавляет packageName дважды)

---

## Стиль кода и соглашения

- **Commit messages — всегда на английском**
- Dart — official Dart style guide
- Виджеты — предпочитать `StatelessWidget` + Riverpod `ConsumerWidget`
- Именование файлов: `snake_case`
- Именование классов: `PascalCase`
- Комментарии к публичным API на английском
- UI-строки на русском (через l10n, арб-файлы)
- Без мусора: не добавлять docstrings/комментарии к коду который не трогаешь

### Ключевые паттерны

- `homeDataProvider = Provider.autoDispose` + `_ref.invalidate(homeDataProvider)` после тренировки
- `workoutProvider = StateNotifierProvider.autoDispose` — план генерируется при открытии
- Сервисы мутируют HiveObject на месте, сохранение — ответственность вызывающего
- `ExerciseResult.completedReps` = кол-во повторений в **последнем** подходе (MVP)
- Challenge в бонусной тренировке: `advanceStage` вызывается ВСЕГДА (не зависит от `isPrimary`)
- Deep link guard: `if (state.uri.scheme == 'caliday') return '/workout';` в RouterNotifier redirect
- Workout → `canPop()` перед `pop()`: `context.canPop() ? context.pop() : context.go('/home')`

---

## Команды

```bash
flutter run                       # Запуск
flutter test                      # Тесты
flutter analyze                   # Линтер
dart run build_runner build       # Кодогенерация (Hive adapters)
dart run flutter_launcher_icons   # Генерация иконок приложения
flutter gen-l10n                  # Генерация l10n (или flutter run)
flutter build apk --release       # Android release APK
flutter build ipa                 # iOS archive
```

---

## Backlog фич

| Версия | Фича | Статус |
|--------|------|--------|
| v1.0 | MVP (Push + Core, стрики, SP, уведомления, онбординг) | ✅ |
| v1.1 | Достижения (27 штук) | ✅ |
| v1.1 | Бонусные тренировки | ✅ |
| v1.1 | Lottie анимации Push (7/7 этапов) | ✅ |
| v1.1 | Тёмная тема | ✅ |
| v1.1 | Новые ветки Pull, Legs, Balance | ✅ |
| v1.2 | Звук + вибрация | ✅ |
| v1.2 | История тренировок (детальный просмотр) | ✅ |
| v1.2 | Редизайн Home (bottom nav 3 вкладки) | ✅ |
| v1.2 | Замена emoji → Material Icons | ✅ |
| v1.2 | Заморозки стрика | ✅ |
| v1.2 | Экран «О приложении» | ✅ |
| v1.3 | Home Screen Widget (iOS + Android) | ✅ |
| v1.3 | Apple Health / Health Connect | ✅ |
| v1.4 | Друзья (BLE/QR, без сервера) | 📐 спроектировано |
| v1.4 | Базовая интеграция часы (уведомления) | 📐 спроектировано |
| v1.5 | Полноценное приложение на часы | 💡 идея |
| ? | Lottie анимации Core ветки | 🔒 ждёт ассетов |
| ? | Кнопка «Поддержать автора» (IAP) | 💡 идея |

Обозначения: ✅ реализовано · 📐 спроектировано (в DEV_NOTES) · 🔒 ждёт ресурса · 💡 идея