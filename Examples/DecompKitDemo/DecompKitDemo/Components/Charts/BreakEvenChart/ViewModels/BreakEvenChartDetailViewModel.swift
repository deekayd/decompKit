import Combine
import DecompKit
import Foundation
import SwiftUI

@MainActor
final class BreakEvenChartDetailViewModel: ObservableObject {
    let preset: BreakEvenChartDemoPreset

    @Published var theme = BreakEvenChartDemoTheme.neon
    @Published var fixedCost: Double
    @Published var variableCostPerUnit: Double
    @Published var revenuePerUnit: Double
    @Published var maxUnits: Double
    @Published var plotHeight = BreakEvenChartDemoControls.defaultPlotHeight
    @Published var showsLegend = true
    @Published var showsProfitLossBand = true
    @Published var showsMetricSummary = true
    @Published var showsBreakEvenGuides = true
    @Published var showsHeader = true

    init(preset: BreakEvenChartDemoPreset) {
        self.preset = preset
        self.fixedCost = preset.economics.fixedCost
        self.variableCostPerUnit = preset.economics.variableCostPerUnit
        self.revenuePerUnit = preset.economics.revenuePerUnit
        self.maxUnits = preset.economics.maxUnits
    }

    var title: String {
        preset.title
    }

    var economics: BreakEvenUnitEconomics {
        BreakEvenUnitEconomics(
            fixedCost: fixedCost,
            variableCostPerUnit: variableCostPerUnit,
            revenuePerUnit: max(revenuePerUnit, variableCostPerUnit + 1),
            maxUnits: maxUnits,
            stepCount: preset.economics.stepCount
        )
    }

    var series: BreakEvenChartSeries {
        economics.makeSeries()
    }

    var configuration: BreakEvenChartConfiguration {
        BreakEvenChartConfiguration(
            title: preset.title,
            subtitle: preset.subtitle,
            maxValue: nil,
            plotHeight: CGFloat(plotHeight),
            showsHeader: showsHeader,
            showsLegend: showsLegend,
            showsProfitLossBand: showsProfitLossBand,
            showsMetricSummary: showsMetricSummary,
            showsBreakEvenGuides: showsBreakEvenGuides,
            valueFormat: .compactCurrency(code: "USD"),
            unitsFormat: .compactNumber(suffix: "units"),
            style: theme.style
        )
    }

    func randomizeScenario() {
        fixedCost = Double.random(in: BreakEvenChartDemoControls.fixedCostRange)
        variableCostPerUnit = Double.random(in: BreakEvenChartDemoControls.variableCostRange)
        revenuePerUnit = Double.random(in: max(variableCostPerUnit + 4, 20)...BreakEvenChartDemoControls.revenueRange.upperBound)
        maxUnits = Double.random(in: BreakEvenChartDemoControls.maxUnitsRange)
    }
}
