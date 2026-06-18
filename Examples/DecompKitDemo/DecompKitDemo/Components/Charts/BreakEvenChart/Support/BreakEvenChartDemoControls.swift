import Foundation
import DecompKit

enum BreakEvenChartDemoControls {
    static let fixedCostRange: ClosedRange<Double> = 8_000...28_000
    static let variableCostRange: ClosedRange<Double> = 6...18
    static let revenueRange: ClosedRange<Double> = 18...38
    static let maxUnitsRange: ClosedRange<Double> = 1_400...3_200
    static let plotHeightRange: ClosedRange<Double> = 240...430
    static let defaultPlotHeight = Double(BreakEvenChartDefaults.plotHeight)
}
