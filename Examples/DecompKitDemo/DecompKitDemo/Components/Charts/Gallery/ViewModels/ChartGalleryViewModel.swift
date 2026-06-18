import Foundation

@MainActor
final class ChartGalleryViewModel {
    let items: [ChartDemoItem]

    init(items: [ChartDemoItem]) {
        self.items = items
    }

    func makeDetailViewModel(for preset: WeeklyActivityChartDemoPreset) -> WeeklyActivityChartDetailViewModel {
        WeeklyActivityChartDetailViewModel(preset: preset)
    }

    func makeDetailViewModel(for preset: BreakEvenChartDemoPreset) -> BreakEvenChartDetailViewModel {
        BreakEvenChartDetailViewModel(preset: preset)
    }
}
