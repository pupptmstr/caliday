import SwiftUI
import WidgetKit

// MARK: - Data model

struct CaliDayEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let totalSP: Int
    let workoutDoneToday: Bool
}

// MARK: - Timeline provider

struct CaliDayProvider: TimelineProvider {
    func placeholder(in context: Context) -> CaliDayEntry {
        CaliDayEntry(date: Date(), streak: 7, totalSP: 340, workoutDoneToday: false)
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
            workoutDoneToday: defaults.bool(forKey: "workoutDoneToday")
        )
    }
}

// MARK: - Widget view

struct CaliDayWidgetEntryView: View {
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
                            .foregroundColor(Color(red: 1.0, green: 0.584, blue: 0.0)) // #FF9500
                            .font(.system(size: 13, weight: .semibold))
                        Text("\(entry.streak)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(Color(red: 1.0, green: 0.878, blue: 0.4)) // #FFE066
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

// MARK: - Widget configuration

@main
struct CaliDayWidget: Widget {
    let kind: String = "CaliDayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CaliDayProvider()) { entry in
            CaliDayWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("CaliDay")
        .description("Стрик и SP одним взглядом.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    CaliDayWidget()
} timeline: {
    CaliDayEntry(date: .now, streak: 12, totalSP: 340, workoutDoneToday: false)
    CaliDayEntry(date: .now, streak: 12, totalSP: 380, workoutDoneToday: true)
}
