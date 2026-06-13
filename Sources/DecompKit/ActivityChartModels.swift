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

public enum ActivityChartColorMode {
    case source
    case monotone(base: Color, highlight: Color)
    case twoTone(start: Color, end: Color)
    case gradient(colors: [Color])
    case semantic(low: Color, medium: Color, high: Color)

    public static var focused: ActivityChartColorMode {
        .monotone(
            base: Color.white.opacity(0.48),
            highlight: Color(red: 0.18, green: 1.00, blue: 0.58)
        )
    }

    public static var ocean: ActivityChartColorMode {
        .twoTone(
            start: Color(red: 0.12, green: 0.84, blue: 1.00),
            end: Color(red: 0.53, green: 0.36, blue: 1.00)
        )
    }

    public static var spectrum: ActivityChartColorMode {
        .gradient(
            colors: [
                Color(red: 0.10, green: 0.82, blue: 1.00),
                Color(red: 0.20, green: 1.00, blue: 0.60),
                Color(red: 1.00, green: 0.78, blue: 0.20),
                Color(red: 1.00, green: 0.36, blue: 0.62)
            ]
        )
    }

    public static var status: ActivityChartColorMode {
        .semantic(
            low: Color(red: 1.00, green: 0.35, blue: 0.42),
            medium: Color(red: 1.00, green: 0.76, blue: 0.24),
            high: Color(red: 0.22, green: 0.92, blue: 0.58)
        )
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
    public var colorMode: ActivityChartColorMode
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
        colorMode: ActivityChartColorMode = .source,
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
        self.colorMode = colorMode
        self.trendOverride = trendOverride
    }
}

extension ActivityChartColorMode {
    func pointColors(
        for points: [ActivityChartPoint],
        highlightedIndex: Int?,
        maxValue: Double
    ) -> [Color] {
        guard points.isEmpty == false else { return [] }

        switch self {
        case .source:
            return points.map(\.tint)
        case let .monotone(base, highlight):
            return points.indices.map { index in
                index == highlightedIndex ? highlight : base
            }
        case let .twoTone(start, end):
            return paletteColors([start, end], count: points.count)
        case let .gradient(colors):
            return colors.isEmpty ? points.map(\.tint) : paletteColors(colors, count: points.count)
        case let .semantic(low, medium, high):
            return points.map { point in
                semanticColor(
                    for: point.value,
                    maxValue: maxValue,
                    low: low,
                    medium: medium,
                    high: high
                )
            }
        }
    }

    func lineColors(
        for points: [ActivityChartPoint],
        maxValue: Double
    ) -> [Color] {
        guard points.isEmpty == false else { return [] }

        switch self {
        case .source:
            return points.map(\.tint)
        case let .monotone(base, _):
            return Array(repeating: base, count: points.count)
        case let .twoTone(start, end):
            return [start, end]
        case let .gradient(colors):
            return colors.isEmpty ? points.map(\.tint) : colors
        case let .semantic(low, medium, high):
            return points.map { point in
                semanticColor(
                    for: point.value,
                    maxValue: maxValue,
                    low: low,
                    medium: medium,
                    high: high
                )
            }
        }
    }

    private func paletteColors(_ colors: [Color], count: Int) -> [Color] {
        guard count > 0 else { return [] }
        guard colors.isEmpty == false else {
            return Array(repeating: .white, count: count)
        }
        guard colors.count > 1 else {
            return Array(repeating: colors[0], count: count)
        }
        guard count > 1 else { return [colors[0]] }

        return (0..<count).map { index in
            let progress = Double(index) / Double(count - 1)
            let colorIndex = Int((progress * Double(colors.count - 1)).rounded())
            return colors[min(colorIndex, colors.count - 1)]
        }
    }

    private func semanticColor(
        for value: Double,
        maxValue: Double,
        low: Color,
        medium: Color,
        high: Color
    ) -> Color {
        let progress = maxValue > 0 ? value / maxValue : 0

        if progress < 0.45 {
            return low
        }

        if progress < 0.75 {
            return medium
        }

        return high
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
