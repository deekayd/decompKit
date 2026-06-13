import Foundation

@MainActor
final class ChartGalleryViewModel {
    let presets: [WeeklyActivityChartDemoPreset]

    init(presets: [WeeklyActivityChartDemoPreset]) {
        self.presets = presets
    }

    func makeDetailViewModel(for preset: WeeklyActivityChartDemoPreset) -> WeeklyActivityChartDetailViewModel {
        WeeklyActivityChartDetailViewModel(preset: preset)
    }
}
