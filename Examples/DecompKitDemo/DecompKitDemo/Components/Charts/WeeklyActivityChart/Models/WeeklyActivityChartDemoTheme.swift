import DecompKit

enum WeeklyActivityChartDemoTheme: String, CaseIterable, Identifiable {
    case neon
    case aurora
    case graphite

    var id: String { rawValue }

    var title: String {
        switch self {
        case .neon:
            "Neon"
        case .aurora:
            "Aurora"
        case .graphite:
            "Graphite"
        }
    }

    var style: WeeklyActivityChartStyle {
        switch self {
        case .neon:
            .neon
        case .aurora:
            .aurora
        case .graphite:
            .graphite
        }
    }
}
