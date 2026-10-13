import SwiftUI
import WidgetKit

// The look agreed with the owner (2026-10-12, the mock-up of build/widget_mock):
// the brand-blue gradient of Home's hero, Goro without his tile on a soft glow,
// the streak always orange, done in green; the Streak widget on a dark ember.

extension Color {
    init(hex: UInt32) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255)
    }

    static let brandBlue = Color(hex: 0x4DA6FF)
    static let brandBlueDark = Color(hex: 0x2B7DE9)
    static let brandBlueDeep = Color(hex: 0x1A5FA8)
    static let energy = Color(hex: 0xFF9500)
    static let success = Color(hex: 0x34C759)
    static let ice = Color(hex: 0xA8D8FF)
    static let gold = Color(hex: 0xFFD60A)
}

enum Backgrounds {
    static let brand = LinearGradient(colors: [.brandBlue, .brandBlueDark, .brandBlueDeep],
                                      startPoint: .topLeading, endPoint: .bottomTrailing)
    static let rank = LinearGradient(colors: [.brandBlue, .brandBlueDark],
                                     startPoint: .topLeading, endPoint: .bottomTrailing)
    static let night = LinearGradient(colors: [Color(hex: 0x28336E), Color(hex: 0x141B44), Color(hex: 0x0B1030)],
                                      startPoint: .topLeading, endPoint: .bottomTrailing)
    static let ember = RadialGradient(colors: [Color(hex: 0x6A3A05), Color(hex: 0x3A1F02), Color(hex: 0x1D1000)],
                                      center: UnitPoint(x: 0.5, y: 0.38), startRadius: 0, endRadius: 130)
}

extension View {
    /// The widget's own background: the container on iOS 17+ (it fills the
    /// rounded corners and the system margins), behind padded content on 16.
    @ViewBuilder
    func widgetBackground<B: View>(_ background: B) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget) { background }
        } else {
            padding(16).background(background)
        }
    }
}

// MARK: - Pieces

struct GoroArt: View {
    let name: String
    var glow = true

    var body: some View {
        ZStack {
            if glow {
                // Fades out at the inscribed circle, so the frame's edges never show.
                GeometryReader { geo in
                    RadialGradient(colors: [Color.ice.opacity(0.5), Color.ice.opacity(0)],
                                   center: .center, startRadius: 0,
                                   endRadius: min(geo.size.width, geo.size.height) / 2)
                }
            }
            Image(name).resizable().scaledToFit()
        }
    }
}

struct StreakChip: View {
    let streak: Int
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "flame.fill").font(.system(size: 11, weight: .bold))
            Text("\(streak)").font(.system(size: 13, weight: .heavy))
        }
        .foregroundColor(.energy)
        .padding(.horizontal, 8).padding(.vertical, 3)
        .background(Capsule().fill(Color.white.opacity(0.92)))
    }
}

struct FreezeChip: View {
    let count: Int
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "snowflake").font(.system(size: 10, weight: .bold))
            Text("\(count)").font(.system(size: 13, weight: .heavy))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8).padding(.vertical, 3)
        .background(Capsule().fill(Color.ice.opacity(0.28)))
    }
}

struct SPChip: View {
    let sp: Int
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "bolt.fill").font(.system(size: 10, weight: .bold))
            Text("\(sp)").font(.system(size: 13, weight: .heavy))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8).padding(.vertical, 3)
        .background(Capsule().fill(Color.white.opacity(0.2)))
    }
}

/// Seven days, Monday first: orange the trained ones, a ring round today.
struct WeekStrip: View {
    let week: [(String, Bool, Bool)]
    var dot: CGFloat = 17
    var spacing: CGFloat = 6
    var dimEmpty = Color.white.opacity(0.22)

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<week.count, id: \.self) { i in
                let (letter, trained, today) = week[i]
                VStack(spacing: 3) {
                    Circle()
                        .fill(trained ? Color.energy : dimEmpty)
                        .frame(width: dot, height: dot)
                        .shadow(color: trained ? Color.energy.opacity(0.6) : .clear, radius: 4)
                        .overlay(Circle().stroke(Color.white, lineWidth: today ? 2 : 0).padding(-2.5))
                    Text(letter).font(.system(size: dot * 0.56, weight: .bold)).opacity(0.9)
                }
            }
        }
    }
}

struct ProgressBar: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.25))
                Capsule()
                    .fill(LinearGradient(colors: [.white, .ice], startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(7, geo.size.width * min(max(value, 0), 1)))
            }
        }
        .frame(height: 7)
    }
}

struct Caps: View {
    let text: String
    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 10.5, weight: .heavy))
            .tracking(0.8)
            .opacity(0.75)
            .lineLimit(1)
    }
}

/// "✓ Done · +45 SP"
struct DoneLine: View {
    let text: String
    var size: CGFloat = 12.5
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: size + 2))
                .foregroundStyle(.white, Color.success)
            Text(text).font(.system(size: size, weight: .bold)).lineLimit(1).minimumScaleFactor(0.75)
        }
    }
}

extension WidgetEntry {
    /// "Done · +45 SP"; just "Done" for a day without SP (a warm-up only).
    var doneShort: String {
        snap.spToday > 0 ? "\(snap.doneLabel) · +\(snap.spToday) SP" : snap.doneLabel
    }

    /// The pose of the day, or Goro flexing once the day's workout is done.
    var todayArt: String { done ? "goro_flex" : pose() }
}

// MARK: - Today

struct TodayView: View {
    @Environment(\.widgetFamily) var family
    let entry: WidgetEntry

    var body: some View {
        Group {
            switch family {
            case .systemMedium: medium
            case .systemLarge: large
            case .accessoryRectangular: lockScreen
            default: small
            }
        }
        .foregroundColor(.white)
        .widgetURL(URL(string: "treniday://workout"))
    }

    @ViewBuilder private var caption: some View {
        if entry.done {
            DoneLine(text: entry.doneShort)
        } else if entry.isSnapshotDay && entry.snap.planCount > 0 {
            Text(entry.snap.planSummary)
                .font(.system(size: 12.5, weight: .bold))
                .lineLimit(2).minimumScaleFactor(0.8)
        } else {
            Text(entry.snap.trainLabel).font(.system(size: 12.5, weight: .bold)).lineLimit(2)
        }
    }

    private var small: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                StreakChip(streak: entry.streak)
                Spacer(minLength: 0)
                if entry.snap.freezes > 0 { FreezeChip(count: entry.snap.freezes) }
            }
            GoroArt(name: entry.todayArt).frame(maxWidth: .infinity, maxHeight: .infinity)
            caption
        }
        .widgetBackground(Backgrounds.brand)
    }

    private var medium: some View {
        HStack(spacing: 10) {
            GoroArt(name: entry.todayArt).frame(width: 128)
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 6) {
                    HStack(spacing: 2) {
                        Image(systemName: "flame.fill").font(.system(size: 20, weight: .bold))
                        Text("\(entry.streak)").font(.system(size: 28, weight: .black))
                    }
                    .foregroundColor(.energy)
                    Text(entry.streakUnit).font(.system(size: 13, weight: .bold)).opacity(0.8).lineLimit(1)
                    Spacer(minLength: 0)
                    if entry.snap.freezes > 0 { FreezeChip(count: entry.snap.freezes) }
                }
                Spacer(minLength: 2)
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill").font(.system(size: 11, weight: .bold))
                    Text("\(entry.snap.totalSP) SP · \(entry.snap.rankName)").lineLimit(1)
                }
                .font(.system(size: 13, weight: .bold)).opacity(0.85)
                Spacer(minLength: 4)
                WeekStrip(week: entry.week, dot: 16, spacing: 7)
                Spacer(minLength: 4)
                if entry.done {
                    DoneLine(text: entry.doneShort, size: 13)
                } else if entry.isSnapshotDay && entry.snap.planCount > 0 {
                    HStack(spacing: 5) {
                        Image(systemName: "play.fill").font(.system(size: 10, weight: .bold))
                        Text(entry.snap.planSummary).font(.system(size: 12.5, weight: .heavy))
                            .lineLimit(1).minimumScaleFactor(0.75)
                    }
                    .foregroundColor(.brandBlueDeep)
                    .padding(.horizontal, 11).padding(.vertical, 6)
                    .background(Capsule().fill(Color.white.opacity(0.95)))
                } else {
                    Text(entry.snap.trainLabel).font(.system(size: 13, weight: .heavy)).lineLimit(1)
                }
            }
        }
        .widgetBackground(Backgrounds.brand)
    }

    private var large: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 10) {
                GoroArt(name: entry.todayArt).frame(width: 112, height: 112)
                VStack(alignment: .leading, spacing: 4) {
                    Caps(text: entry.snap.courseName)
                    Text(entry.snap.todayTitle).font(.system(size: 26, weight: .black)).lineLimit(1)
                    HStack(spacing: 6) {
                        StreakChip(streak: entry.streak)
                        SPChip(sp: entry.snap.totalSP)
                        if entry.snap.freezes > 0 { FreezeChip(count: entry.snap.freezes) }
                    }
                }
                Spacer(minLength: 0)
            }
            WeekStrip(week: entry.week, dot: 17, spacing: 22).frame(maxWidth: .infinity)
            Rectangle().fill(Color.white.opacity(0.2)).frame(height: 1)
            largeMiddle
            Spacer(minLength: 0)
            HStack {
                Text(entry.snap.rankGoal).font(.system(size: 12, weight: .heavy)).lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 6)
                Text(entry.snap.rankName).font(.system(size: 12, weight: .bold)).opacity(0.75).lineLimit(1)
            }
            ProgressBar(value: entry.snap.rankProgress)
        }
        .widgetBackground(Backgrounds.brand)
    }

    @ViewBuilder private var largeMiddle: some View {
        if entry.done {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 7) {
                    Image(systemName: "checkmark.circle.fill").font(.system(size: 20))
                        .foregroundStyle(.white, Color.success)
                    Text(entry.snap.doneTitle).font(.system(size: 17, weight: .black)).lineLimit(1)
                }
                if entry.isSnapshotDay && entry.snap.spToday > 0 {
                    Text(entry.snap.spTodayText).font(.system(size: 14, weight: .bold)).opacity(0.85)
                        .padding(.leading, 27)
                }
                if entry.isSnapshotDay {
                    if !entry.snap.growthLines.isEmpty {
                        Caps(text: entry.snap.growthTitle).padding(.top, 4)
                        Lines(lines: Array(entry.snap.growthLines.prefix(4)))
                    }
                }
            }
        } else if entry.isSnapshotDay && entry.snap.planCount > 0 {
            VStack(alignment: .leading, spacing: 6) {
                Caps(text: entry.snap.planSummary)
                Lines(lines: Array(entry.snap.planLines.prefix(5)))
                if entry.snap.planCount > 5 {
                    Text("+\(entry.snap.planCount - 5)").font(.system(size: 12, weight: .bold)).opacity(0.7)
                        .padding(.leading, 14)
                }
            }
        } else {
            Text(entry.snap.trainLabel).font(.system(size: 17, weight: .black))
        }
    }

    private var lockScreen: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                Text("\(entry.streak) · \(entry.snap.totalSP) SP")
            }
            .font(.system(size: 15, weight: .heavy))
            Group {
                if entry.done {
                    Text(entry.doneShort)
                } else if entry.isSnapshotDay && entry.snap.planCount > 0 {
                    Text(entry.snap.planSummary)
                } else {
                    Text(entry.snap.trainLabel)
                }
            }
            .font(.system(size: 13, weight: .semibold))
            .lineLimit(2)
            .opacity(0.85)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetBackground(AccessoryWidgetBackground())
    }
}

/// "Name ··· 3 × 12" rows of the large widget.
struct Lines: View {
    let lines: [(String, String)]
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(0..<lines.count, id: \.self) { i in
                HStack(spacing: 8) {
                    Circle().fill(Color.ice).frame(width: 6, height: 6)
                    Text(lines[i].0).font(.system(size: 13.5, weight: .semibold)).lineLimit(1)
                    Spacer(minLength: 6)
                    Text(lines[i].1).font(.system(size: 13, weight: .semibold)).opacity(0.8).lineLimit(1)
                }
            }
        }
    }
}

// MARK: - Goro

struct GoroView: View {
    let entry: WidgetEntry

    var body: some View {
        let asleep = entry.mood == "sleeping"
        ZStack(alignment: .bottomLeading) {
            GoroArt(name: entry.face)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            StreakChip(streak: entry.streak)
        }
        .widgetBackground(asleep
            ? AnyView(ZStack { Backgrounds.night; Stars() })
            : AnyView(Backgrounds.brand))
        .widgetURL(URL(string: "treniday://home"))
    }
}

struct Stars: View {
    var body: some View {
        GeometryReader { geo in
            let spots: [(CGFloat, CGFloat, CGFloat, Double)] = [
                (0.08, 0.06, 3, 0.8), (0.86, 0.12, 2, 0.7), (0.72, 0.02, 3, 0.6),
                (0.16, 0.34, 2, 0.5), (0.94, 0.42, 2, 0.6), (0.6, 0.2, 2, 0.4),
            ]
            ForEach(0..<spots.count, id: \.self) { i in
                let (x, y, r, o) = spots[i]
                Circle().fill(Color.white.opacity(o)).frame(width: r, height: r)
                    .position(x: geo.size.width * x, y: geo.size.height * y)
            }
        }
    }
}

// MARK: - Streak

struct StreakView: View {
    @Environment(\.widgetFamily) var family
    let entry: WidgetEntry

    var body: some View {
        Group {
            switch family {
            case .accessoryCircular: circular
            case .accessoryInline: inline
            default: small
            }
        }
        .widgetURL(URL(string: "treniday://calendar"))
    }

    private var small: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                Image(systemName: "flame.fill").font(.system(size: 12, weight: .bold))
                Text(entry.snap.streakTitle.uppercased()).font(.system(size: 11.5, weight: .heavy)).tracking(0.6)
                    .lineLimit(1)
                Spacer(minLength: 2)
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: "snowflake").font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.ice.opacity(i < entry.snap.freezes ? 1 : 0.28))
                    }
                }
            }
            .foregroundColor(.energy)
            Spacer(minLength: 0)
            Text("\(entry.streak)")
                .font(.system(size: 52, weight: .black))
                .foregroundColor(.energy)
                .shadow(color: Color.energy.opacity(0.55), radius: 9)
                .lineLimit(1).minimumScaleFactor(0.6)
            Text(entry.streakUnit).font(.system(size: 14, weight: .bold)).foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
            Spacer(minLength: 4)
            WeekStrip(week: entry.week, dot: 13, spacing: 4, dimEmpty: Color.white.opacity(0.16))
                .foregroundColor(.white)
        }
        .widgetBackground(ZStack {
            Backgrounds.ember
            RadialGradient(colors: [Color.energy.opacity(0.4), Color.energy.opacity(0)],
                           center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 70)
        })
    }

    private var circular: some View {
        VStack(spacing: 0) {
            Image(systemName: "flame.fill").font(.system(size: 17, weight: .bold))
            Text("\(entry.streak)").font(.system(size: 20, weight: .heavy)).lineLimit(1).minimumScaleFactor(0.6)
        }
        .widgetBackground(AccessoryWidgetBackground())
    }

    private var inline: some View {
        Label("\(entry.streakText) · \(entry.snap.rankName)", systemImage: "flame.fill")
    }
}

// MARK: - Rank

struct RankView: View {
    @Environment(\.widgetFamily) var family
    let entry: WidgetEntry

    var body: some View {
        Group {
            switch family {
            case .systemMedium: medium
            case .accessoryCircular: circular
            default: small
            }
        }
        .foregroundColor(.white)
        .widgetURL(URL(string: "treniday://profile"))
    }

    private var title: some View {
        HStack(spacing: 5) {
            Image(systemName: "medal.fill").font(.system(size: 15)).foregroundColor(.gold)
            Caps(text: entry.snap.rankTitle)
        }
    }

    private var small: some View {
        ZStack(alignment: .topTrailing) {
            GoroArt(name: entry.pose(shift: 3)).frame(width: 78, height: 78).offset(x: 6, y: -6)
            VStack(alignment: .leading, spacing: 2) {
                title
                Spacer(minLength: 0)
                Text(entry.snap.rankName).font(.system(size: 20, weight: .black)).lineLimit(1)
                    .minimumScaleFactor(0.7)
                HStack(spacing: 3) {
                    Image(systemName: "bolt.fill").font(.system(size: 10, weight: .bold))
                    Text("\(entry.snap.totalSP) SP")
                }
                .font(.system(size: 12.5, weight: .bold)).opacity(0.85)
                ProgressBar(value: entry.snap.rankProgress).padding(.vertical, 4)
                Text(entry.snap.rankGoal).font(.system(size: 10.5, weight: .bold)).opacity(0.85)
                    .lineLimit(2).minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .widgetBackground(Backgrounds.rank)
    }

    private var medium: some View {
        HStack(spacing: 12) {
            GoroArt(name: entry.pose(shift: 3)).frame(width: 128)
            VStack(alignment: .leading, spacing: 3) {
                title
                Text(entry.snap.rankName).font(.system(size: 28, weight: .black)).lineLimit(1)
                    .minimumScaleFactor(0.7)
                HStack(spacing: 3) {
                    Image(systemName: "bolt.fill").font(.system(size: 11, weight: .bold))
                    Text("\(entry.snap.totalSP) SP")
                }
                .font(.system(size: 14, weight: .bold)).opacity(0.85)
                Spacer(minLength: 4)
                ProgressBar(value: entry.snap.rankProgress)
                Text(entry.snap.rankGoal).font(.system(size: 12, weight: .heavy)).lineLimit(2)
                    .minimumScaleFactor(0.8).padding(.top, 3)
            }
        }
        .widgetBackground(Backgrounds.rank)
    }

    private var circular: some View {
        Gauge(value: entry.snap.rankProgress) {
            Image(systemName: "medal.fill")
        } currentValueLabel: {
            Image(systemName: "medal.fill").font(.system(size: 18))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .widgetBackground(AccessoryWidgetBackground())
    }
}
