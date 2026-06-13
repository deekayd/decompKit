import SwiftUI
import DecompKit

struct WeeklyActivityChartDetailView: View {
    @StateObject private var viewModel: WeeklyActivityChartDetailViewModel

    init(viewModel: WeeklyActivityChartDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                WeeklyActivityChartCard(
                    series: viewModel.series,
                    configuration: viewModel.configuration
                )

                controls
            }
            .padding(18)
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Configuration")
                .font(.system(size: 18, weight: .semibold, design: .rounded))

            Picker("Configuration section", selection: $viewModel.selectedConfigurationTab) {
                ForEach(WeeklyActivityChartConfigurationTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)

            configurationTabContent
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    @ViewBuilder
    private var configurationTabContent: some View {
        switch viewModel.selectedConfigurationTab {
        case .data:
            dataControls
        case .layout:
            layoutControls
        case .visibility:
            visibilityControls
        }
    }

    private var dataControls: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Range", selection: $viewModel.range) {
                ForEach(ActivityChartRange.allCases) { range in
                    Text(range.title).tag(range)
                }
            }
            .pickerStyle(.segmented)

            Picker("Theme", selection: $viewModel.theme) {
                ForEach(WeeklyActivityChartDemoTheme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }
            .pickerStyle(.segmented)

            Picker("Chart colors", selection: $viewModel.colorMode) {
                ForEach(WeeklyActivityChartDemoColorMode.allCases) { colorMode in
                    Label(colorMode.title, systemImage: colorMode.symbolName)
                        .tag(colorMode)
                }
            }
            .pickerStyle(.menu)

            Button {
                viewModel.randomizeData()
            } label: {
                Label("Randomize data", systemImage: "shuffle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.top, 2)
    }

    private var layoutControls: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Highlight point", selection: $viewModel.highlightedPointIndex) {
                ForEach(Array(viewModel.points.enumerated()), id: \.offset) { index, point in
                    Text(point.label).tag(index)
                }
            }
            .pickerStyle(.menu)
            .disabled(viewModel.showsHighlight == false)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Highlight spacing")
                    Spacer()
                    Text("\(Int(viewModel.highlightBadgeSpacing)) pt")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))

                Slider(
                    value: $viewModel.highlightBadgeSpacing,
                    in: WeeklyActivityChartDemoControls.highlightSpacingRange,
                    step: 1
                )
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Plot height")
                    Spacer()
                    Text("\(Int(viewModel.plotHeight)) pt")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))

                Slider(
                    value: $viewModel.plotHeight,
                    in: WeeklyActivityChartDemoControls.plotHeightRange,
                    step: 1
                )
            }
        }
        .padding(.top, 2)
    }

    private var visibilityControls: some View {
        VStack(alignment: .leading, spacing: 14) {
            Toggle("Show highlight badge", isOn: $viewModel.showsHighlight)
            Toggle("Show chart header", isOn: $viewModel.showsHeader)
        }
        .padding(.top, 6)
    }
}
