# CaliDay — Заметки разработки

Живой документ. Содержит текущий статус, активные спеки фич в работе и историю изменений.
**Стабильные решения и архитектура → `docs/ARCHITECTURE.md`**

---

## Текущий статус

**Версия:** v1.3 (реализовано)
**Следующий приоритет:** v1.4 — Друзья (BLE/QR)

Последняя сборка APK: `build/app/outputs/flutter-apk/caliday.apk` (~57 MB)

| Слой | Статус |
|------|--------|
| Модели данных + Hive | ✅ |
| ExerciseCatalog (все 5 веток) | ✅ |
| Репозитории (User, SkillProgress, Workout, Achievement) | ✅ |
| Доменные сервисы | ✅ |
| Навигация (GoRouter + bottom nav) | ✅ |
| Онбординг (7 шагов) | ✅ |
| Home / Progress / Profile / Settings | ✅ |
| Workout / Summary | ✅ |
| BranchJourney / Achievements / About / DevOptions | ✅ |
| Уведомления (4 типа) | ✅ |
| Тёмная тема | ✅ |
| Горо (6 выражений) + Скала | ✅ |
| Lottie анимации (Push, 7/7) | ✅ |
| Звук + вибрация | ✅ |
| Home Screen Widget (iOS + Android) | ✅ |
| Health Integration (iOS + Android) | ✅ |
| L10n (RU + EN) | ✅ |

---

## Активные спеки (идеи в проработке)

### v1.4 — Друзья (Friends) — спроектировано

#### Концепция

Социальная фича без сервера. Данные хранятся локально; обмен peer-to-peer при физической встрече
через QR-код или Bluetooth LE. При каждой новой встрече snapshot друга обновляется.

#### Механика обмена

**A. QR-код** — генерируется QR с JSON-снапшотом профиля, друг сканирует.

**B. Bluetooth LE** — приложение в фоне рекламирует BLE-сервис `caliday-peer`.
При открытии экрана «Друзья» — сканирование 30 сек, найденные CaliDay-устройства в «Рядом сейчас».

#### Данные снапшота (FriendProfile)

```dart
// HiveType 9 — typeId зарезервирован
@HiveType(typeId: 9)
class FriendProfile {
  @HiveField(0) final String id;              // UUID
  @HiveField(1) final String displayName;
  @HiveField(2) final int totalSP;
  @HiveField(3) final int currentStreak;
  @HiveField(4) final int longestStreak;
  @HiveField(5) final int rankIndex;
  @HiveField(6) final Map<String, int> branchStages;
  @HiveField(7) final DateTime profileDate;
  @HiveField(8) final DateTime lastSynced;
}
```

Hive box: `'friends'` (`Box<FriendProfile>`).

#### QR формат (< 1KB)

```json
{
  "v": 1, "id": "uuid", "name": "Имя",
  "sp": 3400, "streak": 14, "longestStreak": 28, "rank": 2,
  "stages": {"push": 3, "core": 2}, "date": 1740000000
}
```

URL scheme: `caliday://friend?data=<base64url>`

#### Технические задачи

| # | Задача |
|---|--------|
| 1 | `FriendProfile` модель + Hive adapter (typeId=9) |
| 2 | `UserProfile.peerId` (@HiveField(17)) + `displayName` (@HiveField(18)) — поля уже есть |
| 3 | `FriendRepository` — Hive box `'friends'` |
| 4 | QR-генерация: `qr_flutter` |
| 5 | QR-сканирование: `mobile_scanner` |
| 6 | BLE-сканирование: `flutter_blue_plus` |
| 7 | BLE-GATT обмен данными |
| 8 | `FriendsScreen` + `FriendDetailBottomSheet` |
| 9 | Profile: секция «Друзья» |
| 10 | Settings: поле «Имя» + toggle видимости |
| 11 | l10n строки |
| 12 | `app_router.dart`: маршрут `/friends` |

Разрешения:
- iOS: `NSBluetoothAlwaysUsageDescription`, `NSCameraUsageDescription`
- Android: `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `CAMERA`

---

### v1.4 — Базовая интеграция часов (уведомления) — спроектировано

#### Концепция

Не отдельное приложение — «зеркало» через уведомления.
Apple Watch и Wear OS автоматически отражают уведомления с телефона.

#### Реализация

1. **Rest timer notification** (ID 5) — `ongoing` уведомление при отдыхе:
   - Заголовок: «Отдых: X сек», Body: следующее упражнение
   - Android: `setOngoing(true)` + `setUsesChronometer(true)`
   - iOS: `interruptionLevel = timeSensitive`
   - Отменяется при нажатии «Готово»

2. **Current exercise notification** — при старте упражнения:
   - «Push · Алмазные отжимания · 3 × 8»

3. `WorkoutNotifier` → `NotificationService.showRestTimer(durationSec, nextExercise)`

---

### v1.5 — Полноценное приложение на часы — идея

Apple Watch (WatchKit + SwiftUI) + Wear OS (Compose for Wear OS).
Запуск тренировки, счётчик повторений (Crown), таймер, пульс (HealthKit).
**Не Flutter** — нативный код + Method Channel.
Браться после того как Health-интеграция устоялась и есть аудитория.

---

### Кнопка «Поддержать автора» — идея

IAP через StoreKit 2 (iOS) и Google Play Billing (Android).
Пакет: `in_app_purchase` (официальный Flutter).

Продукты (consumable):
- `tip_small` — ~99₽ / $0.99
- `tip_medium` — ~249₽ / $2.99
- `tip_large` — ~499₽ / $4.99

Размещение: Settings → О приложении.
Браться после первого реального релиза.

---

### Lottie анимации Core ветки — ждёт ассетов от дизайнера

6 анимаций (core_s1..s6). Формат: Lottie JSON в `assets/animations/`.
Интеграция аналогична Push ветке — `Exercise.animationPath` уже есть.

---

## История изменений

### 2026-03-21 — реструктуризация документации

**Разделили DEV_NOTES на два документа:**
- `docs/ARCHITECTURE.md` — справочник архитектуры, технических решений, API сервисов, каталогов
- `docs/DEV_NOTES.md` — живые заметки: статус, спеки в работе, история

**Обновлены:** `CLAUDE.md`, `.claude/commands/` (скиллы для повторяющихся операций).

Файлы: `docs/ARCHITECTURE.md` (новый), `docs/DEV_NOTES.md` (переписан), `CLAUDE.md`, `.claude/commands/*.md`

---

### 2026-03-05 — сессия 39 (Health Integration: HealthKit / Health Connect)

**Реализована интеграция с Apple Health (iOS) и Google Health Connect (Android).**
После завершения тренировки CaliDay записывает сессию силовой тренировки + калории (MET-формула).
Opt-in через Настройки → ЗДОРОВЬЕ.

**Новые файлы:**
- `lib/core/services/health_service.dart` — `HealthService` singleton

**Изменённые файлы:**
- `pubspec.yaml` — `health: ^12.0.0`
- `lib/data/models/user_profile.dart` — `@HiveField(21) healthWorkoutsEnabled`, `@HiveField(22) healthWeightEnabled`
- `lib/data/models/user_profile.g.dart` — обновлён adapter
- `lib/features/settings/providers/settings_provider.dart` — новые поля + setters
- `lib/features/settings/screens/settings_screen.dart` — раздел ЗДОРОВЬЕ
- `lib/features/workout/providers/workout_provider.dart` — `healthSaved: bool` + вызов HealthService
- `lib/features/workout/screens/workout_screen.dart` — `healthSaved` в extras
- `lib/features/workout/screens/summary_screen.dart` — `_HealthSavedBadge`
- `lib/main.dart` — `HealthService.instance.configure()` в postFrameCallback
- `ios/Runner/Info.plist` — NSHealth*UsageDescription
- `android/app/src/main/AndroidManifest.xml` — Health Connect permissions, queries, activity-alias
- `android/app/build.gradle.kts` — `minSdk = 26`
- `android/app/src/main/kotlin/.../MainActivity.kt` — `FlutterActivity` → `FlutterFragmentActivity`
- `l10n/app_ru.arb`, `l10n/app_en.arb` — 6 новых строк

**Ключевые проблемы:**
- `MainActivity` должна расширять `FlutterFragmentActivity` (→`ComponentActivity`), иначе `HealthPlugin.onAttachedToActivity` падает с `ClassCastException`
- `configure()` обёрнут в `.timeout(5s)` — без таймаута зависает на splash при повторном запуске
- `activity-alias` с `HEALTH_PERMISSIONS` обязателен для диалога разрешений Health Connect
- iOS: capability HealthKit нужно добавить вручную в Xcode

---

### 2026-03-05 — сессия 38b (Medium виджет 4×2)

**Добавлен второй виджет: 4×2. Layout: Горо слева + стрик + SP + статус справа.**

**Новые файлы:**
- `android/.../res/xml/caliday_widget_medium_info.xml`
- `android/.../res/layout/caliday_widget_medium_layout.xml`
- `android/.../kotlin/.../CaliDayWidgetMediumReceiver.kt`

**Изменённые файлы:**
- `android/.../AndroidManifest.xml` — receiver medium
- `lib/core/services/widget_service.dart` — `_androidNameMedium`, `update()` вызывает оба виджета, `rankLabel()` helper
- `ios/CaliDayWidget/CaliDayWidget.swift` — `CaliDaySmallView`, `CaliDayMediumView`, диспетчер по `@Environment(\.widgetFamily)`

**Проблема:** `HomeWidget.updateWidget(androidName: qualifiedName)` добавлял packageName дважды → `ClassNotFoundException`. Решение: `qualifiedAndroidName:` вместо `androidName:`.

---

### 2026-03-05 — сессия 38 (Android виджет: Glance → AppWidgetProvider)

**Исправлен рантайм-краш Android-виджета. Glance → классический AppWidgetProvider + RemoteViews.**

**Проблема:** `NoSuchMethodError: No static method provideContent(GlanceAppWidget, Function0, Continuation)`.
**Причина:** Flutter не включает Compose Compiler Plugin (`buildFeatures.compose = false`), лямбда генерируется как `Function0` вместо `Function2<Composer, Int, Unit>`.
**Решение:** `AppWidgetProvider` + XML layout — не требует Compose.

Дополнительные фиксы:
- `GoException: no routes for location: caliday://workout/` → guard в RouterNotifier redirect
- `GoError: There is nothing to pop` → `context.canPop() ? context.pop() : context.go('/home')`

---

### 2026-03-05 — сессия 37 (Home Screen Widget: Flutter + Android + iOS)

**Реализован Home Screen Widget Small (2×2): Горо (idle/flex) + стрик + SP. Тап → `caliday://workout`.**

**Новые зависимости:** `home_widget: ^0.9.0`, `app_links: ^6.4.1`

**Новые файлы:**
- `lib/core/services/widget_service.dart`
- `android/.../CaliDayWidgetReceiver.kt`
- `android/.../res/xml/caliday_widget_info.xml`
- `android/.../res/layout/caliday_widget_layout.xml`
- `android/.../res/drawable/ic_widget_fire.xml`, `ic_widget_bolt.xml`
- `ios/CaliDayWidget/CaliDayWidget.swift`
- PNG ассеты: goro_idle/flex в drawable-* и iOS xcassets

**Изменённые файлы:**
- `pubspec.yaml` — `home_widget`, `app_links`
- `lib/main.dart` — WidgetService.init() + AppLinks deep link stream
- `lib/features/workout/providers/workout_provider.dart` — WidgetService.update() после тренировки
- `android/.../AndroidManifest.xml` — deep link intent-filter, widget receiver
- `ios/Runner/Info.plist` — CFBundleURLTypes scheme `caliday`

iOS: требует ручной настройки в Xcode (Widget Extension target + App Group).

---

### 2026-03-04 — сессия 36 (инфо-баннер на Progress + замена emoji на Material Icons)

**1.** Карточка-подсказка вверху Progress tab: ветки необязательны.
**2.** Замена emoji на Material Icons по всему UI. `BranchId.icon` геттер добавлен в `enums.dart`.

**Изменённые файлы:** `l10n/app_ru.arb`, `l10n/app_en.arb`, `lib/data/models/enums.dart`,
`home_screen.dart`, `progress_screen.dart`, `branch_journey_screen.dart`,
`profile_screen.dart`, `achievements_screen.dart`, `summary_screen.dart`,
`workout_screen.dart`, `settings_screen.dart`

---

### 2026-03-04 — сессия 35 (Android-вибрация, таймер, история, редизайн Home)

**1. Фикс вибрации** — `VIBRATE` permission в AndroidManifest.

**2. Таймер** — увеличен до 5 секунд (было 3). Tick при `timerSec ∈ [2..6]`, также для timed-упражнений.

**3. История тренировок** — тайлы стали тапабельными, modal bottom sheet с деталями (упражнения, повторения).

**4. Редизайн Home** — `StatefulShellRoute.indexedStack`, 3 вкладки: Тренировка/Прогресс/Профиль.
Создан `progress_screen.dart`. Home упрощён до hero-блока с Горо.

**Проблема:** `profileDataProvider` (autoDispose) не сбрасывался при `indexedStack` — все вкладки живые.
Фикс: `_ref.invalidate(profileDataProvider)` добавлен в `_finishWorkout()`.

**Изменённые файлы:**
- `android/.../AndroidManifest.xml` — VIBRATE
- `lib/features/workout/screens/workout_screen.dart`
- `lib/core/services/sound_service.dart`
- `lib/features/profile/screens/profile_screen.dart`
- `lib/core/router/app_router.dart` — StatefulShellRoute.indexedStack
- `lib/features/home/screens/progress_screen.dart` (новый)
- `lib/features/home/screens/home_screen.dart`
- `lib/features/workout/providers/workout_provider.dart`
- `l10n/app_ru.arb`, `l10n/app_en.arb`

---

### 2026-03-03 — сессия 31 (Lottie анимации Push + рефакторинг прогрессии)

**Интегрированы Lottie анимации для всех 7 этапов Push.**

**Каталог Push приведён в соответствие с ассетами:**
- Stage 5: Archer Pushup → **Wide Pushup** (`push_s5_wide_pushup`)
- Stage 6: One-Arm Pushup → **Archer Pushup** (`push_s6_archer_pushup`)

**Новые зависимости:** `lottie: ^3.3.2`
**Новые ассеты:** `assets/animations/` (7 JSON)
**Поле модели:** `Exercise.animationPath: String?`

**Изменённые файлы:**
- `pubspec.yaml`, `lib/data/models/exercise.dart`
- `lib/data/static/exercise_catalog.dart` — Push s5/s6 + animationPath
- `lib/core/extensions/exercise_l10n.dart` — новые ID
- `l10n/app_ru.arb`, `l10n/app_en.arb`
- `lib/features/workout/screens/workout_screen.dart` — Lottie widget

---

### Ранние сессии (сводно, до сессии 30)

**Сессии 18-30** — реализованы в рамках v1.1 и v1.2:
- Достижения (27 штук): `AchievementRepository`, `AchievementService`, `achievement_catalog.dart`, `AchievementsScreen`
- Бонусные тренировки: `WorkoutLog.isPrimary`, `@HiveField(5)`
- Тёмная тема: `themeProvider`, `UserProfile.themeModeName (@HiveField(14))`
- Горо выражения: `GoroExpressionProvider`, 6 SVG, `AnimatedSwitcher` на Home
- Скала (бык) на Challenge: `skala_neutral/approve.svg`, `_SkalaDisplay`, фон `#5C1A1A`
- Challenge редизайн: `challengeBranchProvider`, `generateChallenge()`, провал/успех разделены
- Форсированный Challenge с BranchJourney: кнопка на текущем этапе
- Новые ветки: Pull (requiresEquipment), Legs, Balance; `activeBranches` computed getter
- Онбординг шаг 5 (турник), Settings: переключатель Pull
- `displayStreakProvider` — вычисляется на лету без мутации Hive
- Уведомление о потере стрика (ID 4)
- Звук + вибрация: `SoundService` singleton, `audioplayers ^6.1.0`, 4 ассета
- Экран `DeveloperOptionsScreen` (`/dev-options`, только `kDebugMode`)
- Экран `AboutScreen` (`/about`): `url_launcher ^6.3.0`, Горо idle v2
- Экран `BranchJourneyScreen` (`/branch/:branchId`): timeline этапов
- Android release build: `keep.xml` + `proguard-rules.pro` + `postFrameCallback` init
- Заморозки стрика: earn каждые 7 дней, auto-spend при пропуске 1 дня, cap=3
- L10n (RU + EN): ~145 ключей
- `StatefulShellRoute.indexedStack`: bottom nav с 3 вкладками