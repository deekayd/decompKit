import Foundation

@MainActor
final class ComponentCatalogViewModel {
    let chartTitle = "Графики"
    let chartSubtitle = "Activity, break-even"
    let chartSymbolName = "chart.xyaxis.line"

    func makeChartGalleryViewModel() -> ChartGalleryViewModel {
        ChartGalleryViewModel(items: ChartDemoItem.all)
    }
}
