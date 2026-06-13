import SwiftUI

struct WeeklyActivityChartViewModel {
    let series: ActivityChartSeries
    let configuration: ActivityChartConfiguration

    var points: [ActivityChartPoint] {
        let colors = configuration.colorMode.pointColors(
            for: series.points,
            highlightedIndex: highlightedIndex,
            maxValue: maxValue
        )

        return series.points.enumerated().map { index, point in
            var coloredPoint = point
            if colors.indices.contains(index) {
                coloredPoint.tint = colors[index]
            }
            return coloredPoint
        }
    }

    var lineColors: [Color] {
        configuration.colorMode.lineColors(
            for: series.points,
            maxValue: maxValue
        )
    }

    var title: String {
        configuration.title
    }

    var subtitle: String {
        configuration.subtitle ?? configuration.range.title
    }

    var maxValue: Double {
        max(configuration.maxValue ?? series.points.map(\.value).max() ?? WeeklyActivityChartDefaults.maxValue, 1)
    }

    var highlightedIndex: Int? {
        if let index = configuration.highlightedIndex, points.indices.contains(index) {
            return index
        }

        return nil
    }

    var trend: ActivityTrend? {
        if let override = configuration.trendOverride {
            return override
        }

        guard let comparison = series.comparison else {
            return nil
        }

        let previousTotal = comparison.total
        guard previousTotal > 0 else {
            return nil
        }

        let currentTotal = WeeklyActivityStats(points: points).total
        let percentage = ((currentTotal - previousTotal) / previousTotal) * 100
        return ActivityTrend(
            percentage: percentage,
            caption: comparison.caption ?? configuration.range.comparisonCaption
        )
    }
}
