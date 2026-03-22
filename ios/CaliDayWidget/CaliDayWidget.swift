import SwiftUI
import WidgetKit

// MARK: - Data model

struct CaliDayEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let totalSP: Int
    let workoutDoneToday: Bool
    let rankName: String
}

// MARK: - Timeline provider

struct CaliDayProvider: TimelineProvider {
    func placeholder(in context: Context) -> CaliDayEntry {
        CaliDayEntry(date: Date(), streak: 7, totalSP: 340, workoutDoneToday: false, rankName: "Атлет")
    }

    func getSnapshot(in context: Context, completion: @escaping (CaliDayEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CaliDayEntry>) -> Void) {
        let entry = readEntry()
        // Refresh every 30 minutes.
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func readEntry() -> CaliDayEntry {
        let defaults = UserDefaults(suiteName: "group.com.pupptmstr.caliday") ?? UserDefaults.standard
        return CaliDayEntry(
            date: Date(),
            streak: defaults.integer(forKey: "streak"),
            totalSP: defaults.integer(forKey: "totalSP"),
            workoutDoneToday: defaults.bool(forKey: "workoutDoneToday"),
            rankName: defaults.string(forKey: "rankName") ?? ""
        )
    }
}

// MARK: - Small widget view (systemSmall)

struct CaliDaySmallView: View {
    var entry: CaliDayEntry

    var body: some View {
        Link(destination: URL(string: "caliday://workout")!) {
            ZStack {
                Color(red: 0.102, green: 0.145, blue: 0.204) // #1A2535

                VStack(spacing: 6) {
                    Image(entry.workoutDoneToday ? "GoroFlex" : "GoroIdle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)

                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.584, blue: 0.0))
                            .font(.system(size: 13, weight: .semibold))
                        Text("\(entry.streak)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.878, blue: 0.4))
                            .font(.system(size: 12, weight: .semibold))
                        Text("\(entry.totalSP) SP")
                            .font(.system(size: 12))
                            .foregroundColor(Color(white: 0.8))
                    }
                }
            }
        }
    }
}

// MARK: - Medium widget view (systemMedium)

struct CaliDayMediumView: View {
    var entry: CaliDayEntry

    var body: some View {
        Link(destination: URL(string: "caliday://workout")!) {
            ZStack {
                Color(red: 0.102, green: 0.145, blue: 0.204) // #1A2535

                HStack(spacing: 0) {
                    // Left: Goro mascot
                    Image(entry.workoutDoneToday ? "GoroFlex" : "GoroIdle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .padding(.leading, 16)

                    // Vertical divider
                    Rectangle()
                        .fill(Color(white: 0.22))
                        .frame(width: 1)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)

                    // Right: Stats
                    VStack(alignment: .leading, spacing: 8) {
                        // Streak
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.584, blue: 0.0))
                                .font(.system(size: 16, weight: .semibold))
                            Text("\(entry.streak)")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }

                        // SP
                        HStack(spacing: 6) {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.878, blue: 0.4))
                                .font(.system(size: 14, weight: .semibold))
                            Text("\(entry.totalSP) SP")
                                .font(.system(size: 18))
                                .foregroundColor(Color(white: 0.8))
                        }

                        // Rank
                        if !entry.rankName.isEmpty {
                            HStack(spacing: 5) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
                                    .font(.system(size: 12, weight: .semibold))
                                Text(entry.rankName)
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
                            }
                        }

                        // Done status
                        if entry.workoutDoneToday {
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(red: 0.298, green: 0.686, blue: 0.314))
                                    .font(.system(size: 11))
                                Text("Готово")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(red: 0.298, green: 0.686, blue: 0.314))
                            }
                        }
                    }

                    Spacer()
                }
            }
        }
    }
}

// MARK: - Entry view dispatcher

struct CaliDayWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: CaliDayEntry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            CaliDayMediumView(entry: entry)
        default:
            CaliDaySmallView(entry: entry)
        }
    }
}

// MARK: - Widget configuration

@main
struct CaliDayWidget: Widget {
    let kind: String = "CaliDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaliDayProvider()) { entry in
            CaliDayWidgetEntryView(entry: entry)
                .modifier(WidgetBackgroundModifier())
        }
        .configurationDisplayName("CaliDay")
        .description("Стрик и SP одним взглядом.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

private let widgetBackground = Color(red: 0.102, green: 0.145, blue: 0.204)

// containerBackground (iOS 17+) fills the system-managed container including
// rounded corners. On iOS 14–16 the ZStack background color does the same job.
private struct WidgetBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.containerBackground(widgetBackground, for: .widget)
        } else {
            content
        }
    }
}

// MARK: - Previews

struct CaliDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CaliDayWidgetEntryView(
                entry: CaliDayEntry(date: Date(), streak: 12, totalSP: 340, workoutDoneToday: false, rankName: "Атлет")
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            CaliDayWidgetEntryView(
                entry: CaliDayEntry(date: Date(), streak: 12, totalSP: 380, workoutDoneToday: true, rankName: "Мастер")
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
