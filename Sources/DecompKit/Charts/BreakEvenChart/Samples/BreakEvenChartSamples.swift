import Foundation

public enum BreakEvenChartSamples {
    public static var economics: BreakEvenUnitEconomics {
        BreakEvenUnitEconomics(
            fixedCost: 15_000,
            variableCostPerUnit: 11,
            revenuePerUnit: 24,
            maxUnits: 2_200,
            stepCount: 8
        )
    }

    public static var series: BreakEvenChartSeries {
        economics.makeSeries()
    }

    public static var configuration: BreakEvenChartConfiguration {
        BreakEvenChartConfiguration(
            title: "Break-even Point",
            subtitle: "Revenue vs total costs",
            maxValue: 72_000,
            plotHeight: 350,
            valueFormat: .compactCurrency(code: "USD"),
            unitsFormat: .compactNumber(suffix: "units"),
            style: .neon
        )
    }
}
