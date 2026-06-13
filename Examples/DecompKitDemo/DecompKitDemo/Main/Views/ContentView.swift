import SwiftUI

struct ContentView: View {
    private let viewModel = ComponentCatalogViewModel()

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ChartGalleryView(
                        viewModel: viewModel.makeChartGalleryViewModel()
                    )
                } label: {
                    Label(viewModel.chartTitle, systemImage: viewModel.chartSymbolName)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("UI Components")
        }
    }
}

#Preview {
    ContentView()
}
