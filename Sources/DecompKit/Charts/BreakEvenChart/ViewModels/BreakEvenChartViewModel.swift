import Foundation
import SwiftUI

struct BreakEvenChartViewModel {
    let series: BreakEvenChartSeries
    let configuration: BreakEvenChartConfiguration

    var points: [BreakEvenChartPoint] {
        series.points
            .filter { $0.units >= 0 }
            .sorted { $0.units < $1.units }
    }

    var title: String {
        configuration.title
    }

    var subtitle: String {
        configuration.subtitle ?? "Revenue vs total costs"
    }

    var maxUnits: Double {
        let pointMax = points.map(\.units).max() ?? 1
        return max(configuration.maxUnits ?? pointMax, 1)
    }

    var maxValue: Double {
        let pointMax = points
            .flatMap { [$0.revenue, $0.totalCost] }
            .max() ?? 1

        let markerValue = breakEven?.value ?? 0
        return max(configuration.maxValue ?? max(pointMax, markerValue) * 1.12, 1)
    }

    var breakEven: BreakEvenMarker? {
        if let override = series.breakEvenOverride {
            return override
        }

        return computedBreakEven
    }

    var breakEvenProgress: Double {
        guard let breakEven else { return 0.5 }
        return breakEvenClamp(breakEven.units / maxUnits, min: 0, max: 1)
    }

    var lossBeforeBreakEven: Double {
        let relevantPoints: [BreakEvenChartPoint]

        if let breakEven {
            relevantPoints = points.filter { $0.units <= breakEven.units }
        } else {
            relevantPoints = points
        }

        return max(0, relevantPoints.map { $0.totalCost - $0.revenue }.max() ?? 0)
    }

    var profitAfterBreakEven: Double {
        guard let last = points.last else { return 0 }
        return max(0, last.revenue - last.totalCost)
    }

    func valueText(_ value: Double) -> String {
        configuration.valueFormat.string(for: value)
    }

    func unitsText(_ value: Double) -> String {
        configuration.unitsFormat.string(for: value)
    }

    private var computedBreakEven: BreakEvenMarker? {
        let sortedPoints = points
        guard sortedPoints.count > 1 else { return nil }

        for point in sortedPoints {
            if abs(point.revenue - point.totalCost) < 0.0001 {
                return BreakEvenMarker(
                    units: point.units,
                    value: point.revenue
                )
            }
        }

        for index in 0..<(sortedPoints.count - 1) {
            let current = sortedPoints[index]
            let next = sortedPoints[index + 1]
            let currentDifference = current.revenue - current.totalCost
            let nextDifference = next.revenue - next.totalCost

            if currentDifference == 0 || nextDifference == 0 {
                continue
            }

            guard currentDifference.sign != nextDifference.sign else {
                continue
            }

            let revenueDelta = next.revenue - current.revenue
            let costDelta = next.totalCost - current.totalCost
            let denominator = revenueDelta - costDelta

            guard abs(denominator) > 0.0001 else {
                continue
            }

            let progress = (current.totalCost - current.revenue) / denominator
            guard progress >= 0, progress <= 1 else {
                continue
            }

            let units = current.units + (next.units - current.units) * progress
            let value = current.revenue + revenueDelta * progress
            return BreakEvenMarker(units: units, value: value)
        }

        return nil
    }
}

func breakEvenClamp<T: Comparable>(_ value: T, min minimum: T, max maximum: T) -> T {
    Swift.max(minimum, Swift.min(value, maximum))
}
