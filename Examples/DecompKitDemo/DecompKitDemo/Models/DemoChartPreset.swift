import SwiftUI
import DecompKit

struct DemoChartPreset: Identifiable {
    let id: String
    let title: String
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

    static var presets: [DemoChartPreset] {
        ActivityChartRange.allCases.map { range in
            DemoChartPreset(
                id: range.id,
                title: "Activity Chart",
                range: range,
                points: WeeklyActivityChartSamples.points(for: range),
                comparisonValues: WeeklyActivityChartSamples.comparisonValues(for: range)
            )
        }
    }
}
