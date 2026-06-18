import SwiftUI

struct ChartGalleryView: View {
    let viewModel: ChartGalleryViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        destination(for: item)
                    } label: {
                        preview(for: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(18)
        }
        .navigationTitle("Графики")
        .background(Color(.systemBackground))
    }

    @ViewBuilder
    private func destination(for item: ChartDemoItem) -> some View {
        switch item {
        case let .weeklyActivity(preset):
            WeeklyActivityChartDetailView(
                viewModel: viewModel.makeDetailViewModel(for: preset)
            )
        case let .breakEven(preset):
            BreakEvenChartDetailView(
                viewModel: viewModel.makeDetailViewModel(for: preset)
            )
        }
    }

    @ViewBuilder
    private func preview(for item: ChartDemoItem) -> some View {
        switch item {
        case let .weeklyActivity(preset):
            WeeklyActivityChartPreviewRow(preset: preset)
        case let .breakEven(preset):
            BreakEvenChartPreviewRow(preset: preset)
        }
    }
}
