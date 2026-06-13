import SwiftUI
import DecompKit
import Combine

@MainActor
final class ChartDetailViewModel: ObservableObject {
    let preset: DemoChartPreset

    @Published var theme = DemoChartTheme.neon
    @Published var colorMode = DemoChartColorMode.original
    @Published var points: [ActivityChartPoint]
    @Published var comparisonValues: [Double]
    @Published var highlightBadgeSpacing = WeeklyActivityChartDefaults.highlightBadgeSpacing
    @Published var plotHeight = WeeklyActivityChartDefaults.plotHeight
    @Published var highlightedPointIndex: Int
    @Published var showsHighlight = true
    @Published var showsHeader = true
    @Published var selectedConfigurationTab = DemoConfigurationTab.data

    @Published var range: ActivityChartRange {
        didSet {
            updateData(for: range)
        }
    }

    init(preset: DemoChartPreset) {
        self.preset = preset
        self.range = preset.range
        self.points = preset.points
        self.comparisonValues = preset.comparisonValues
        self.highlightedPointIndex = min(
            DemoControls.defaultHighlightedIndex,
            max(0, preset.points.count - 1)
        )
    }

    var title: String {
        preset.title
    }

    var series: ActivityChartSeries {
        ActivityChartSeries(
            points: points,
            comparison: ActivityChartComparison(previousValues: comparisonValues)
        )
    }

    var configuration: ActivityChartConfiguration {
        ActivityChartConfiguration(
            title: preset.title,
            range: range,
            maxValue: WeeklyActivityChartDefaults.maxValue,
            highlightedIndex: showsHighlight ? highlightedPointIndex : nil,
            highlightBadgeSpacing: highlightBadgeSpacing,
            plotHeight: plotHeight,
            showsHeader: showsHeader,
            style: theme.style,
            colorMode: colorMode.mode
        )
    }

    func randomizeData() {
        points = points.map { point in
            ActivityChartPoint(
                id: point.id,
                label: point.label,
                value: Double.random(in: 32...98),
                tint: point.tint
            )
        }

        comparisonValues = comparisonValues.map { _ in
            Double.random(in: 26...86)
        }
    }

    private func updateData(for range: ActivityChartRange) {
        points = WeeklyActivityChartSamples.points(for: range)
        comparisonValues = WeeklyActivityChartSamples.comparisonValues(for: range)
        highlightedPointIndex = min(highlightedPointIndex, max(0, points.count - 1))
    }
}
