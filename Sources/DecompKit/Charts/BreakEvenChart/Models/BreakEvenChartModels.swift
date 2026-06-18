import Foundation
import SwiftUI

public struct BreakEvenChartPoint: Identifiable {
    public let id: String
    public var units: Double
    public var revenue: Double
    public var totalCost: Double
    public var label: String?

    public init(
        id: String = UUID().uuidString,
        units: Double,
        revenue: Double,
        totalCost: Double,
        label: String? = nil
    ) {
        self.id = id
        self.units = max(0, units)
        self.revenue = max(0, revenue)
        self.totalCost = max(0, totalCost)
        self.label = label
    }
}

public struct BreakEvenMarker {
    public var units: Double
    public var value: Double
    public var label: String

    public init(
        units: Double,
        value: Double,
        label: String = "Break-even"
    ) {
        self.units = max(0, units)
        self.value = max(0, value)
        self.label = label
    }
}

public struct BreakEvenChartSeries {
    public var points: [BreakEvenChartPoint]
    public var breakEvenOverride: BreakEvenMarker?

    public init(
        points: [BreakEvenChartPoint],
        breakEvenOverride: BreakEvenMarker? = nil
    ) {
        self.points = points
        self.breakEvenOverride = breakEvenOverride
    }
}

public struct BreakEvenUnitEconomics {
    public var fixedCost: Double
    public var variableCostPerUnit: Double
    public var revenuePerUnit: Double
    public var maxUnits: Double
    public var stepCount: Int

    public init(
        fixedCost: Double,
        variableCostPerUnit: Double,
        revenuePerUnit: Double,
        maxUnits: Double,
        stepCount: Int = 7
    ) {
        self.fixedCost = max(0, fixedCost)
        self.variableCostPerUnit = max(0, variableCostPerUnit)
        self.revenuePerUnit = max(0, revenuePerUnit)
        self.maxUnits = max(1, maxUnits)
        self.stepCount = max(2, stepCount)
    }

    public func makeSeries() -> BreakEvenChartSeries {
        let pointCount = max(2, stepCount)
        let segmentCount = Double(pointCount - 1)

        let points = (0..<pointCount).map { index in
            let units = maxUnits * Double(index) / segmentCount
            return BreakEvenChartPoint(
                units: units,
                revenue: units * revenuePerUnit,
                totalCost: fixedCost + units * variableCostPerUnit
            )
        }

        return BreakEvenChartSeries(points: points)
    }
}

public enum BreakEvenValueFormat {
    case number
    case compactNumber(suffix: String)
    case currency(code: String)
    case compactCurrency(code: String)
}

public enum BreakEvenUnitsFormat {
    case number
    case compactNumber(suffix: String)
}

public struct BreakEvenChartConfiguration {
    public var title: String
    public var subtitle: String?
    public var maxUnits: Double?
    public var maxValue: Double?
    public var plotHeight: CGFloat
    public var showsHeader: Bool
    public var showsLegend: Bool
    public var showsProfitLossBand: Bool
    public var showsMetricSummary: Bool
    public var showsBreakEvenGuides: Bool
    public var valueFormat: BreakEvenValueFormat
    public var unitsFormat: BreakEvenUnitsFormat
    public var style: BreakEvenChartStyle

    public init(
        title: String = "Break-even Point",
        subtitle: String? = "Revenue vs total costs",
        maxUnits: Double? = nil,
        maxValue: Double? = nil,
        plotHeight: CGFloat = BreakEvenChartDefaults.plotHeight,
        showsHeader: Bool = true,
        showsLegend: Bool = true,
        showsProfitLossBand: Bool = true,
        showsMetricSummary: Bool = true,
        showsBreakEvenGuides: Bool = true,
        valueFormat: BreakEvenValueFormat = .compactCurrency(code: "USD"),
        unitsFormat: BreakEvenUnitsFormat = .compactNumber(suffix: "units"),
        style: BreakEvenChartStyle = .neon
    ) {
        self.title = title
        self.subtitle = subtitle
        self.maxUnits = maxUnits
        self.maxValue = maxValue
        self.plotHeight = max(BreakEvenChartDefaults.minimumPlotHeight, plotHeight)
        self.showsHeader = showsHeader
        self.showsLegend = showsLegend
        self.showsProfitLossBand = showsProfitLossBand
        self.showsMetricSummary = showsMetricSummary
        self.showsBreakEvenGuides = showsBreakEvenGuides
        self.valueFormat = valueFormat
        self.unitsFormat = unitsFormat
        self.style = style
    }
}

extension BreakEvenValueFormat {
    func string(for value: Double) -> String {
        switch self {
        case .number:
            return wholeNumberText(value)
        case let .compactNumber(suffix):
            return [compactNumberText(value), suffix]
                .filter { $0.isEmpty == false }
                .joined(separator: " ")
        case let .currency(code):
            return currencySymbol(for: code) + wholeNumberText(value)
        case let .compactCurrency(code):
            return currencySymbol(for: code) + compactNumberText(value)
        }
    }
}

extension BreakEvenUnitsFormat {
    func string(for value: Double) -> String {
        switch self {
        case .number:
            return wholeNumberText(value)
        case let .compactNumber(suffix):
            return [compactNumberText(value), suffix]
                .filter { $0.isEmpty == false }
                .joined(separator: " ")
        }
    }
}

private func wholeNumberText(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: value)) ?? "\(Int(value.rounded()))"
}

private func compactNumberText(_ value: Double) -> String {
    let sign = value < 0 ? "-" : ""
    let absolute = abs(value)

    if absolute >= 1_000_000 {
        return sign + trimmedDecimal(absolute / 1_000_000) + "M"
    }

    if absolute >= 1_000 {
        return sign + trimmedDecimal(absolute / 1_000) + "k"
    }

    return sign + wholeNumberText(absolute)
}

private func trimmedDecimal(_ value: Double) -> String {
    let text = String(format: "%.1f", value)
    return text.hasSuffix(".0") ? String(text.dropLast(2)) : text
}

private func currencySymbol(for code: String) -> String {
    switch code.uppercased() {
    case "USD":
        return "$"
    case "EUR":
        return "€"
    case "GBP":
        return "£"
    default:
        return code.uppercased() + " "
    }
}
