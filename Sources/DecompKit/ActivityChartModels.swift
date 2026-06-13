import SwiftUI

public struct ActivityChartPoint: Identifiable {
    public let id: String
    public var label: String
    public var value: Double
    public var tint: Color

    public init(
        id: String = UUID().uuidString,
        label: String,
        value: Double,
        tint: Color
    ) {
        self.id = id
        self.label = label
        self.value = value
        self.tint = tint
    }
}

public enum ActivityChartRange: String, CaseIterable, Identifiable {
    case week
    case months
    case years

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .week:
            "This Week"
        case .months:
            "Last 7 Months"
        case .years:
            "Last 7 Years"
        }
    }

    public var comparisonCaption: String {
        switch self {
        case .week:
            "vs last week"
        case .months:
            "vs previous 7 months"
        case .years:
            "vs previous 7 years"
        }
    }
}

public struct ActivityTrend: Equatable {
    public var percentage: Double
    public var caption: String

    public init(percentage: Double, caption: String) {
        self.percentage = percentage
        self.caption = caption
    }
}

public struct ActivityChartComparison {
    public var previousValues: [Double]
    public var previousTotal: Double?
    public var caption: String?

    public init(
        previousValues: [Double],
        caption: String? = nil
    ) {
        self.previousValues = previousValues
        self.previousTotal = nil
        self.caption = caption
    }

    public init(
        previousTotal: Double,
        caption: String? = nil
    ) {
        self.previousValues = []
        self.previousTotal = previousTotal
        self.caption = caption
    }

    public var total: Double {
        previousTotal ?? previousValues.reduce(0, +)
    }
}

public struct ActivityChartSeries {
    public var points: [ActivityChartPoint]
    public var comparison: ActivityChartComparison?

    public init(
        points: [ActivityChartPoint],
        comparison: ActivityChartComparison? = nil
    ) {
        self.points = points
        self.comparison = comparison
    }
}

public struct ActivityChartConfiguration {
    public var title: String
    public var subtitle: String?
    public var range: ActivityChartRange
    public var maxValue: Double?
    public var highlightedIndex: Int?
    public var highlightBadgeSpacing: CGFloat
    public var plotHeight: CGFloat
    public var showsHeader: Bool
    public var style: WeeklyActivityChartStyle
    public var trendOverride: ActivityTrend?

    public init(
        title: String = "Weekly Progress",
        subtitle: String? = nil,
        range: ActivityChartRange = .week,
        maxValue: Double? = nil,
        highlightedIndex: Int? = nil,
        highlightBadgeSpacing: CGFloat = WeeklyActivityChartDefaults.highlightBadgeSpacing,
        plotHeight: CGFloat = WeeklyActivityChartDefaults.plotHeight,
        showsHeader: Bool = true,
        style: WeeklyActivityChartStyle = .neon,
        trendOverride: ActivityTrend? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.range = range
        self.maxValue = maxValue
        self.highlightedIndex = highlightedIndex
        self.highlightBadgeSpacing = max(0, highlightBadgeSpacing)
        self.plotHeight = max(WeeklyActivityChartDefaults.minimumPlotHeight, plotHeight)
        self.showsHeader = showsHeader
        self.style = style
        self.trendOverride = trendOverride
    }
}

public struct WeeklyActivityStats: Equatable {
    public var total: Double
    public var average: Double
    public var highestIndex: Int?

    public init(points: [ActivityChartPoint]) {
        total = points.reduce(0) { $0 + $1.value }
        average = points.isEmpty ? 0 : total / Double(points.count)
        highestIndex = points
            .enumerated()
            .max { $0.element.value < $1.element.value }?
            .offset
    }

    public init(total: Double, average: Double, highestIndex: Int?) {
        self.total = total
        self.average = average
        self.highestIndex = highestIndex
    }
}
