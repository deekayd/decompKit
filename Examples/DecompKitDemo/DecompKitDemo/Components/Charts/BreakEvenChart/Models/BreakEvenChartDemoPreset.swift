import DecompKit
import SwiftUI

struct BreakEvenChartDemoPreset: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let economics: BreakEvenUnitEconomics

    var series: BreakEvenChartSeries {
        economics.makeSeries()
    }

    var previewConfiguration: BreakEvenChartConfiguration {
        BreakEvenChartConfiguration(
            title: title,
            subtitle: subtitle,
            maxValue: 72_000,
            plotHeight: 250,
            showsHeader: false,
            showsLegend: true,
            showsProfitLossBand: true,
            showsMetricSummary: false,
            valueFormat: .compactCurrency(code: "USD"),
            unitsFormat: .compactNumber(suffix: "units"),
            style: .neon
        )
    }

    static var presets: [BreakEvenChartDemoPreset] {
        [.breakEvenPoint]
    }

    private static var breakEvenPoint: BreakEvenChartDemoPreset {
        BreakEvenChartDemoPreset(
            id: "break-even-chart",
            title: "Break-even Chart",
            subtitle: "Revenue, costs, and payback point",
            economics: BreakEvenUnitEconomics(
                fixedCost: 15_000,
                variableCostPerUnit: 11,
                revenuePerUnit: 24,
                maxUnits: 2_200,
                stepCount: 8
            )
        )
    }
}
