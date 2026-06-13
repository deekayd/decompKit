import Foundation

@MainActor
final class ChartGalleryViewModel {
    let presets: [DemoChartPreset]

    init(presets: [DemoChartPreset]) {
        self.presets = presets
    }

    func makeDetailViewModel(for preset: DemoChartPreset) -> ChartDetailViewModel {
        ChartDetailViewModel(preset: preset)
    }
}
