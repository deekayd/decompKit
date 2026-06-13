import Foundation

@MainActor
final class ComponentCatalogViewModel {
    let chartTitle = "Графики"
    let chartSymbolName = "chart.xyaxis.line"

    func makeChartGalleryViewModel() -> ChartGalleryViewModel {
        ChartGalleryViewModel(presets: WeeklyActivityChartDemoPreset.presets)
    }
}
