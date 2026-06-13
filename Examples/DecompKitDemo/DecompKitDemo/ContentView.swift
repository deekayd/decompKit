import SwiftUI
import DecompKit

struct ContentView: View {
    private let presets = DemoChartPreset.presets

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(presets) { preset in
                        NavigationLink {
                            DemoChartDetailView(preset: preset)
                        } label: {
                            DemoChartPreviewRow(preset: preset)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(18)
            }
            .navigationTitle("UI Components")
            .background(Color(.systemBackground))
        }
    }
}

private struct DemoChartPreviewRow: View {
    let preset: DemoChartPreset

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(preset.title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)

                    Text(preset.range.title)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            WeeklyActivityChartCard(
                series: preset.series,
                configuration: preset.previewConfiguration
            )
            .frame(maxWidth: .infinity)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

private struct DemoChartDetailView: View {
    let preset: DemoChartPreset

    @State private var range: ActivityChartRange
    @State private var theme = DemoChartTheme.neon
    @State private var points: [ActivityChartPoint]
    @State private var comparisonValues: [Double]
    @State private var highlightBadgeSpacing = WeeklyActivityChartDefaults.highlightBadgeSpacing
    @State private var plotHeight = WeeklyActivityChartDefaults.plotHeight
    @State private var highlightedPointIndex: Int
    @State private var showsHighlight = true
    @State private var showsHeader = true

    init(preset: DemoChartPreset) {
        self.preset = preset
        _range = State(initialValue: preset.range)
        _points = State(initialValue: preset.points)
        _comparisonValues = State(initialValue: preset.comparisonValues)
        _highlightedPointIndex = State(initialValue: min(DemoControls.defaultHighlightedIndex, max(0, preset.points.count - 1)))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                WeeklyActivityChartCard(
                    series: series,
                    configuration: configuration
                )

                controls
            }
            .padding(18)
        }
        .navigationTitle(preset.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .onChange(of: range) { newRange in
            points = WeeklyActivityChartSamples.points(for: newRange)
            comparisonValues = WeeklyActivityChartSamples.comparisonValues(for: newRange)
            highlightedPointIndex = min(highlightedPointIndex, max(0, points.count - 1))
        }
    }

    private var series: ActivityChartSeries {
        ActivityChartSeries(
            points: points,
            comparison: ActivityChartComparison(previousValues: comparisonValues)
        )
    }

    private var configuration: ActivityChartConfiguration {
        ActivityChartConfiguration(
            title: preset.title,
            range: range,
            maxValue: WeeklyActivityChartDefaults.maxValue,
            highlightedIndex: showsHighlight ? highlightedPointIndex : nil,
            highlightBadgeSpacing: highlightBadgeSpacing,
            plotHeight: plotHeight,
            showsHeader: showsHeader,
            style: theme.style
        )
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Configuration")
                .font(.system(size: 18, weight: .semibold, design: .rounded))

            Picker("Range", selection: $range) {
                ForEach(ActivityChartRange.allCases) { range in
                    Text(range.title).tag(range)
                }
            }
            .pickerStyle(.segmented)

            Picker("Theme", selection: $theme) {
                ForEach(DemoChartTheme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }
            .pickerStyle(.segmented)

            Picker("Highlight point", selection: $highlightedPointIndex) {
                ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                    Text(point.label).tag(index)
                }
            }
            .pickerStyle(.menu)
            .disabled(showsHighlight == false)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Highlight spacing")
                    Spacer()
                    Text("\(Int(highlightBadgeSpacing)) pt")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))

                Slider(value: $highlightBadgeSpacing, in: DemoControls.highlightSpacingRange, step: 1)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Plot height")
                    Spacer()
                    Text("\(Int(plotHeight)) pt")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                .font(.system(size: 14, weight: .medium, design: .rounded))

                Slider(value: $plotHeight, in: DemoControls.plotHeightRange, step: 1)
            }

            Toggle("Show highlight badge", isOn: $showsHighlight)
            Toggle("Show chart header", isOn: $showsHeader)

            Button {
                randomizeData()
            } label: {
                Label("Randomize data", systemImage: "shuffle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private func randomizeData() {
        points = points.map { point in
            ActivityChartPoint(
                id: point.id,
                label: point.label,
                value: Double.random(in: 32...98),
                tint: point.tint
            )
        }

        comparisonValues = comparisonValues.map { _ in
            Double.random(in: 26...86)
        }
    }
}

private struct DemoChartPreset: Identifiable {
    let id: String
    let title: String
    let range: ActivityChartRange
    let points: [ActivityChartPoint]
    let comparisonValues: [Double]

    var series: ActivityChartSeries {
        ActivityChartSeries(
            points: points,
            comparison: ActivityChartComparison(previousValues: comparisonValues)
        )
    }

    var previewConfiguration: ActivityChartConfiguration {
        ActivityChartConfiguration(
            title: title,
            range: range,
            maxValue: 100,
            highlightedIndex: nil,
            plotHeight: 190,
            showsHeader: false,
            style: .neon
        )
    }

    static var presets: [DemoChartPreset] {
        ActivityChartRange.allCases.map { range in
            DemoChartPreset(
                id: range.id,
                title: "Activity Chart",
                range: range,
                points: WeeklyActivityChartSamples.points(for: range),
                comparisonValues: WeeklyActivityChartSamples.comparisonValues(for: range)
            )
        }
    }
}

private enum DemoChartTheme: String, CaseIterable, Identifiable {
    case neon
    case aurora
    case graphite

    var id: String { rawValue }

    var title: String {
        switch self {
        case .neon:
            "Neon"
        case .aurora:
            "Aurora"
        case .graphite:
            "Graphite"
        }
    }

    var style: WeeklyActivityChartStyle {
        switch self {
        case .neon:
            .neon
        case .aurora:
            .aurora
        case .graphite:
            .graphite
        }
    }
}

private enum DemoControls {
    static let defaultHighlightedIndex = 5
    static let highlightSpacingRange: ClosedRange<CGFloat> = 8...64
    static let plotHeightRange: ClosedRange<CGFloat> = 260...430
}

#Preview {
    ContentView()
}
