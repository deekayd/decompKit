import Foundation

@MainActor
final class ComponentCatalogViewModel {
    let chartTitle = "Графики"
    let chartSubtitle = "WeeklyActivityChart"
    let chartSymbolName = "chart.xyaxis.line"

    func makeChartGalleryViewModel() -> ChartGalleryViewModel {
        ChartGalleryViewModel(presets: WeeklyActivityChartDemoPreset.presets)
    }
}
