import SwiftUI
import DecompKit

struct WeeklyActivityChartDemoPreset: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let range: ActivityChartRange
    let points: [ActivityChartPoint]
    let comparisonValues: [Double]

    var series: ActivityChartSeries {
        ActivityChartSeries(
            points: points,
            comparison: ActivityChartComparison(previousValues: comparisonValues)
        )
    }

    var previewConfiguration: ActivityChartConfiguration {
        ActivityChartConfiguration(
            title: title,
            range: range,
            maxValue: 100,
            highlightedIndex: nil,
            plotHeight: 190,
            showsHeader: false,
            style: .neon,
            colorMode: .spectrum
        )
    }

    static var presets: [WeeklyActivityChartDemoPreset] {
        [.activityChart]
    }

    private static var activityChart: WeeklyActivityChartDemoPreset {
        let range = ActivityChartRange.week

        return WeeklyActivityChartDemoPreset(
            id: "activity-chart",
            title: "Activity Chart",
            subtitle: "Интерактивный пример",
            range: range,
            points: WeeklyActivityChartSamples.points(for: range),
            comparisonValues: WeeklyActivityChartSamples.comparisonValues(for: range)
        )
    }
}
