import DecompKit
import SwiftUI

struct BreakEvenChartDetailView: View {
    @StateObject private var viewModel: BreakEvenChartDetailViewModel

    init(viewModel: BreakEvenChartDetailViewModel) {
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
        BreakEvenChartCard(
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

            configurationSection("Economics") {
                economicsControls
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

    private var economicsControls: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                viewModel.randomizeScenario()
            } label: {
                Label("Randomize scenario", systemImage: "shuffle")
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

            sliderRow(
                title: "Fixed cost",
                value: $viewModel.fixedCost,
                range: BreakEvenChartDemoControls.fixedCostRange,
                step: 500,
                displayValue: "$\(Int(viewModel.fixedCost / 1_000))k"
            )

            sliderRow(
                title: "Variable cost",
                value: $viewModel.variableCostPerUnit,
                range: BreakEvenChartDemoControls.variableCostRange,
                step: 1,
                displayValue: "$\(Int(viewModel.variableCostPerUnit))/unit"
            )

            sliderRow(
                title: "Revenue",
                value: $viewModel.revenuePerUnit,
                range: BreakEvenChartDemoControls.revenueRange,
                step: 1,
                displayValue: "$\(Int(viewModel.revenuePerUnit))/unit"
            )

            sliderRow(
                title: "Max units",
                value: $viewModel.maxUnits,
                range: BreakEvenChartDemoControls.maxUnitsRange,
                step: 100,
                displayValue: "\(Int(viewModel.maxUnits))"
            )
        }
    }

    private var appearanceControls: some View {
        Picker("Theme", selection: $viewModel.theme) {
            ForEach(BreakEvenChartDemoTheme.allCases) { theme in
                Text(theme.title).tag(theme)
            }
        }
        .pickerStyle(.segmented)
    }

    private var layoutControls: some View {
        sliderRow(
            title: "Plot height",
            value: $viewModel.plotHeight,
            range: BreakEvenChartDemoControls.plotHeightRange,
            step: 1,
            displayValue: "\(Int(viewModel.plotHeight)) pt"
        )
    }

    private var visibilityControls: some View {
        VStack(alignment: .leading, spacing: 14) {
            Toggle("Show chart header", isOn: $viewModel.showsHeader)
            Toggle("Show legend", isOn: $viewModel.showsLegend)
            Toggle("Show profit/loss band", isOn: $viewModel.showsProfitLossBand)
            Toggle("Show metric summary", isOn: $viewModel.showsMetricSummary)
            Toggle("Show break-even guides", isOn: $viewModel.showsBreakEvenGuides)
        }
    }

    private func sliderRow(
        title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double,
        displayValue: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                Spacer()
                Text(displayValue)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            .font(.system(size: 14, weight: .medium, design: .rounded))

            Slider(value: value, in: range, step: step)
        }
    }
}
