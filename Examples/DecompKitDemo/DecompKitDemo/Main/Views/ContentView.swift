import SwiftUI

struct ContentView: View {
    private let viewModel = ComponentCatalogViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    chartLink
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
            .background(Color(.systemBackground))
            .navigationTitle("UI Components")
        }
    }

    private var chartLink: some View {
        NavigationLink {
            ChartGalleryView(
                viewModel: viewModel.makeChartGalleryViewModel()
            )
        } label: {
            ComponentCatalogCard(
                title: viewModel.chartTitle,
                subtitle: viewModel.chartSubtitle,
                symbolName: viewModel.chartSymbolName
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
