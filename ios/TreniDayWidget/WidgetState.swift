import Foundation
import WidgetKit

/// What the app last wrote to the App Group (`WidgetSnapshot.build` in
/// lib/core/services/widget_snapshot.dart). Every text is the app's, in its
/// language; the widgets add none of their own.
struct Snapshot {
    var day = ""
    var streak = 0
    var freezes = 0
    var lastWorkoutDay = ""
    var trainedDays: Set<String> = []
    var streakText = ""
    var streakZeroText = ""
    var weekdays: [String] = []
    var totalSP = 0
    var spToday = 0
    var rankName = ""
    var rankProgress = 0.0
    var rankGoal = ""
    var courseName = ""
    var planCount = 0
    var planSummary = ""
    var planLines: [(String, String)] = []
    var growthLines: [(String, String)] = []
    var todayTitle = ""
    var streakTitle = ""
    var rankTitle = ""
    var growthTitle = ""
    var trainLabel = ""
    var doneLabel = ""
    var doneTitle = ""
    var spTodayText = ""

    static func read() -> Snapshot {
        let d = UserDefaults(suiteName: "group.com.pupptmstr.treniday") ?? .standard
        func text(_ key: String) -> String { d.string(forKey: key) ?? "" }
        func lines(_ key: String) -> [(String, String)] {
            text(key).split(separator: "\n").map { line in
                let parts = line.split(separator: "\t", maxSplits: 1).map(String.init)
                return (parts.first ?? "", parts.count > 1 ? parts[1] : "")
            }
        }
        var s = Snapshot()
        s.day = text("day")
        s.streak = d.integer(forKey: "streak")
        s.freezes = d.integer(forKey: "freezes")
        s.lastWorkoutDay = text("lastWorkoutDay")
        s.trainedDays = Set(text("trainedDays").split(separator: ",").map(String.init))
        s.streakText = text("streakText")
        s.streakZeroText = text("streakZeroText")
        s.weekdays = text("weekdays").split(separator: ",").map(String.init)
        s.totalSP = d.integer(forKey: "totalSP")
        s.spToday = d.integer(forKey: "spToday")
        s.rankName = text("rankName")
        s.rankProgress = Double(d.integer(forKey: "rankProgress")) / 1000
        s.rankGoal = text("rankGoal")
        s.courseName = text("courseName")
        s.planCount = d.integer(forKey: "planCount")
        s.planSummary = text("planSummary")
        s.planLines = lines("planLines")
        s.growthLines = lines("growthLines")
        s.todayTitle = text("todayTitle")
        s.streakTitle = text("streakTitle")
        s.rankTitle = text("rankTitle")
        s.growthTitle = text("growthTitle")
        s.trainLabel = text("trainLabel")
        s.doneLabel = text("doneLabel")
        s.doneTitle = text("doneTitle")
        s.spTodayText = text("spTodayText")
        return s
    }

    /// The widget gallery, before the app has ever written anything: numbers
    /// and Goro, no words.
    static let sample: Snapshot = {
        var s = Snapshot()
        s.streak = 12
        s.freezes = 2
        s.totalSP = 1240
        s.rankProgress = 0.49
        s.weekdays = ["M", "T", "W", "T", "F", "S", "S"]
        return s
    }()
}

/// The snapshot as seen at [date]: the app's rules of the day, mirrored from
/// Dart (`HomeData.displayStreak`, `goroExpressionProvider`) and in
/// `WidgetState.kt` — change all three together.
struct WidgetEntry: TimelineEntry {
    let date: Date
    let snap: Snapshot
    var isSample = false

    private var calendar: Calendar { Calendar.current }

    var today: String { Days.key(date) }

    /// The plan, the SP and the growth of the snapshot are today's.
    var isSnapshotDay: Bool { snap.day == today }

    /// Any workout today.
    var done: Bool { snap.trainedDays.contains(today) }

    /// Days since the last workout; -1 when there has been none.
    var daysSinceWorkout: Int {
        snap.lastWorkoutDay.isEmpty ? -1 : Days.between(snap.lastWorkoutDay, date)
    }

    /// The streak as the app shows it: kept for a day without training, two
    /// with a freeze left, else gone.
    var streak: Int {
        let days = daysSinceWorkout
        return days <= 1 || (days == 2 && snap.freezes > 0) ? snap.streak : 0
    }

    /// "12 days" for the shown streak.
    var streakText: String { streak == snap.streak ? snap.streakText : snap.streakZeroText }

    /// The words after the number in [streakText] ("days"), for the big number.
    var streakUnit: String {
        let text = streakText
        let number = String(streak)
        guard text.hasPrefix(number) else { return text }
        return String(text.dropFirst(number.count)).trimmingCharacters(in: .whitespaces)
    }

    /// Goro's face: asleep 23–6, happy after a workout, angry from 22 with a
    /// streak to lose, sad from 20, supportive after two days without one.
    var mood: String {
        let hour = calendar.component(.hour, from: date)
        if hour >= 23 || hour < 6 { return "sleeping" }
        if done { return "happy" }
        if hour >= 22 && streak > 0 { return "angry" }
        if hour >= 20 { return "sad" }
        if daysSinceWorkout >= 2 { return "supportive" }
        return "happy"
    }

    var face: String { "goro_face_\(mood)" }

    /// Goro's pose of the day; the Rank widget takes another one of the same
    /// day ([shift]).
    func pose(shift: Int = 0) -> String {
        let poses = ["one_arm_handstand", "flag", "one_arm_pullup", "barbell", "lotus", "banana"]
        let n = Days.between("2024-01-01", date) + shift
        return "goro_pose_\(poses[((n % poses.count) + poses.count) % poses.count])"
    }

    /// The week of [date], Monday first: (letter, trained, is today).
    var week: [(String, Bool, Bool)] {
        let start = calendar.startOfDay(for: date)
        let fromMonday = (calendar.component(.weekday, from: start) + 5) % 7
        return (0..<7).map { i in
            let day = calendar.date(byAdding: .day, value: i - fromMonday, to: start)!
            let key = Days.key(day)
            let letter = i < snap.weekdays.count ? snap.weekdays[i] : ""
            return (letter, snap.trainedDays.contains(key), key == today)
        }
    }
}

/// Calendar days as the app hands them over ("2026-10-12"), never times.
enum Days {
    private static let format: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static func key(_ date: Date) -> String {
        format.timeZone = .current
        return format.string(from: date)
    }

    /// Calendar days from [day] to [date] (a DST day is still one day).
    static func between(_ day: String, _ date: Date) -> Int {
        format.timeZone = .current
        guard let from = format.date(from: day) else { return -1 }
        let cal = Calendar.current
        return cal.dateComponents([.day], from: cal.startOfDay(for: from),
                                  to: cal.startOfDay(for: date)).day ?? -1
    }
}

/// One timeline for every widget: an entry now and one at each moment the
/// rules above change their answer (6, 20, 22, 23 and midnight), for a day.
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), snap: .sample, isSample: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        let snap = Snapshot.read()
        let empty = snap.day.isEmpty
        completion(WidgetEntry(date: Date(), snap: empty ? .sample : snap, isSample: empty))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let snap = Snapshot.read()
        let now = Date()
        let cal = Calendar.current
        let midnight = cal.startOfDay(for: now)
        var dates = [now]
        for dayOffset in 0...1 {
            guard let day = cal.date(byAdding: .day, value: dayOffset, to: midnight) else { continue }
            for hour in [0, 6, 20, 22, 23] {
                if let at = cal.date(bySettingHour: hour, minute: 0, second: 0, of: day), at > now {
                    dates.append(at)
                }
            }
        }
        completion(Timeline(entries: dates.map { WidgetEntry(date: $0, snap: snap) }, policy: .atEnd))
    }
}
