import Foundation

enum ChartDemoItem: Identifiable {
    case weeklyActivity(WeeklyActivityChartDemoPreset)
    case breakEven(BreakEvenChartDemoPreset)

    var id: String {
        switch self {
        case let .weeklyActivity(preset):
            preset.id
        case let .breakEven(preset):
            preset.id
        }
    }

    var title: String {
        switch self {
        case let .weeklyActivity(preset):
            preset.title
        case let .breakEven(preset):
            preset.title
        }
    }

    var subtitle: String {
        switch self {
        case let .weeklyActivity(preset):
            preset.subtitle
        case let .breakEven(preset):
            preset.subtitle
        }
    }

    static var all: [ChartDemoItem] {
        WeeklyActivityChartDemoPreset.presets.map(ChartDemoItem.weeklyActivity)
        + BreakEvenChartDemoPreset.presets.map(ChartDemoItem.breakEven)
    }
}
