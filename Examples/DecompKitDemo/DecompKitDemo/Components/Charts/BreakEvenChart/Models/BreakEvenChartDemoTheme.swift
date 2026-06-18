import DecompKit

enum BreakEvenChartDemoTheme: String, CaseIterable, Identifiable {
    case neon
    case graphite
    case financial

    var id: String { rawValue }

    var title: String {
        switch self {
        case .neon:
            "Neon"
        case .graphite:
            "Graphite"
        case .financial:
            "Finance"
        }
    }

    var style: BreakEvenChartStyle {
        switch self {
        case .neon:
            .neon
        case .graphite:
            .graphite
        case .financial:
            .financial
        }
    }
}
