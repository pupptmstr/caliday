import SwiftUI
import WidgetKit

// The home-screen and lock-screen widgets (agreed with the owner 2026-10-12):
// Today, Goro, Streak and Rank. What they show comes from the app
// (WidgetState.swift reads it), how they look is WidgetViews.swift. The kinds
// are listed in WidgetService.iOSKinds; "TreniDayWidget" is the Today widget.

@main
struct TreniDayWidgets: WidgetBundle {
    var body: some Widget {
        TodayWidget()
        GoroWidget()
        StreakWidget()
        RankWidget()
    }
}

struct TodayWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TreniDayWidget", provider: Provider()) { TodayView(entry: $0) }
            .configurationDisplayName(gallery("today").name)
            .description(gallery("today").description)
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular])
    }
}

struct GoroWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TreniDayGoroWidget", provider: Provider()) { GoroView(entry: $0) }
            .configurationDisplayName(gallery("goro").name)
            .description(gallery("goro").description)
            .supportedFamilies([.systemSmall])
    }
}

struct StreakWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TreniDayStreakWidget", provider: Provider()) { StreakView(entry: $0) }
            .configurationDisplayName(gallery("streak").name)
            .description(gallery("streak").description)
            .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryInline])
    }
}

struct RankWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "TreniDayRankWidget", provider: Provider()) { RankView(entry: $0) }
            .configurationDisplayName(gallery("rank").name)
            .description(gallery("rank").description)
            .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
    }
}

/// The widget gallery shows the names and descriptions before the app has
/// ever run, so the app cannot hand them over like the other texts: a table
/// per app language (the codes of `appLanguages`; a test in
/// widget_service_test.dart keeps them in step), English for any other.
private func gallery(_ widget: String) -> (name: String, description: String) {
    let texts: [String: [String: (String, String)]] = [
        "ru": [
            "today": ("Сегодня", "План на сегодня, серия и неделя."),
            "goro": ("Горо", "Настроение Горо следует за твоим днём."),
            "streak": ("Серия", "Серия, неделя и заморозки."),
            "rank": ("Ранг", "Ранг, SP и путь до следующего."),
        ],
        "en": [
            "today": ("Today", "Today's plan, your streak and the week."),
            "goro": ("Goro", "Goro's mood follows your day."),
            "streak": ("Streak", "Your streak, the week and the freezes."),
            "rank": ("Rank", "Your rank, SP and the way to the next one."),
        ],
        "de": [
            "today": ("Heute", "Der Plan für heute, deine Serie und die Woche."),
            "goro": ("Goro", "Goros Laune folgt deinem Tag."),
            "streak": ("Serie", "Deine Serie, die Woche und dein Schutz."),
            "rank": ("Rang", "Dein Rang, deine SP und der Weg zum nächsten."),
        ],
        "es": [
            "today": ("Hoy", "El plan de hoy, tu racha y la semana."),
            "goro": ("Goro", "El humor de Goro sigue tu día."),
            "streak": ("Racha", "Tu racha, la semana y tus protectores."),
            "rank": ("Rango", "Tu rango, tus SP y el camino al siguiente."),
        ],
    ]
    let code = Locale.preferredLanguages.first.map { String($0.prefix(2)) } ?? "en"
    let entry = (texts[code] ?? texts["en"]!)[widget] ?? ("TreniDay", "")
    return (entry.0, entry.1)
}
