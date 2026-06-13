import SwiftUI

struct ChartGalleryView: View {
    let viewModel: ChartGalleryViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.presets) { preset in
                    NavigationLink {
                        ChartDetailView(
                            viewModel: viewModel.makeDetailViewModel(for: preset)
                        )
                    } label: {
                        DemoChartPreviewRow(preset: preset)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(18)
        }
        .navigationTitle("Графики")
        .background(Color(.systemBackground))
    }
}
