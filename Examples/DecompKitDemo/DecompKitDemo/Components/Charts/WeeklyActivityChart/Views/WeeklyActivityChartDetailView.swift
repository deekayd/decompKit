import SwiftUI
import DecompKit

struct WeeklyActivityChartDetailView: View {
    @StateObject private var viewModel: WeeklyActivityChartDetailViewModel

    init(viewModel: WeeklyActivityChartDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            stickyChart

            ScrollView(showsIndicators: false) {
                controls
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                    .padding(.bottom, 28)
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }

    private var stickyChart: some View {
        WeeklyActivityChartCard(
            series: viewModel.series,
            configuration: viewModel.configuration
        )
        .padding(.horizontal, 18)
        .padding(.top, 12)
        .padding(.bottom, 14)
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 8)
        )
        .zIndex(1)
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Configuration")
                .font(.system(size: 18, weight: .semibold, design: .rounded))

            configurationSection("Data") {
                dataControls
            }

            configurationSection("Appearance") {
                appearanceControls
            }

            configurationSection("Layout") {
                layoutControls
            }

            configurationSection("Display") {
                visibilityControls
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func configurationSection<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            content()

            if title != "Display" {
                Divider()
                    .padding(.top, 4)
            }
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

            Button {
                viewModel.randomizeData()
            } label: {
                Label("Randomize data", systemImage: "shuffle")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity, minHeight: 54)
            }
            .foregroundStyle(Color.accentColor)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.accentColor.opacity(0.13))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.accentColor.opacity(0.22), lineWidth: 1)
            )
            .buttonStyle(.plain)
        }
    }

    private var appearanceControls: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Theme", selection: $viewModel.theme) {
                ForEach(WeeklyActivityChartDemoTheme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }
            .pickerStyle(.segmented)

            WeeklyActivityChartColorModePicker(selection: $viewModel.colorMode)
        }
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
    }

    private var visibilityControls: some View {
        VStack(alignment: .leading, spacing: 14) {
            Toggle("Show highlight badge", isOn: $viewModel.showsHighlight)
            Toggle("Show chart header", isOn: $viewModel.showsHeader)
        }
    }
}
