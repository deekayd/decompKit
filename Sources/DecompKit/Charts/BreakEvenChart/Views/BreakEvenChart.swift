import SwiftUI

public struct BreakEvenChart: View {
    private let viewModel: BreakEvenChartViewModel

    @State private var isAnimated = false

    public init(
        series: BreakEvenChartSeries,
        configuration: BreakEvenChartConfiguration = BreakEvenChartConfiguration()
    ) {
        self.viewModel = BreakEvenChartViewModel(series: series, configuration: configuration)
    }

    public init(
        economics: BreakEvenUnitEconomics,
        configuration: BreakEvenChartConfiguration = BreakEvenChartConfiguration()
    ) {
        self.viewModel = BreakEvenChartViewModel(series: economics.makeSeries(), configuration: configuration)
    }

    public var body: some View {
        BreakEvenChartCard(viewModel: viewModel, isAnimated: isAnimated)
            .padding(.horizontal, BreakEvenChartLayout.cardOuterHorizontalPadding)
            .padding(.vertical, BreakEvenChartLayout.cardOuterVerticalPadding)
            .shadow(
                color: viewModel.configuration.style.backgroundGlow.opacity(BreakEvenChartLayout.cardShadowOpacity),
                radius: BreakEvenChartLayout.cardShadowRadius,
                x: 0,
                y: BreakEvenChartLayout.cardShadowYOffset
            )
            .onAppear {
                withAnimation(.easeOut(duration: BreakEvenChartLayout.animationDuration)) {
                    isAnimated = true
                }
            }
    }
}

public struct BreakEvenChartCard: View {
    private let viewModel: BreakEvenChartViewModel
    private let isAnimated: Bool

    @State private var internalAnimation = false

    public init(
        series: BreakEvenChartSeries,
        configuration: BreakEvenChartConfiguration = BreakEvenChartConfiguration()
    ) {
        self.viewModel = BreakEvenChartViewModel(series: series, configuration: configuration)
        self.isAnimated = true
    }

    public init(
        economics: BreakEvenUnitEconomics,
        configuration: BreakEvenChartConfiguration = BreakEvenChartConfiguration()
    ) {
        self.viewModel = BreakEvenChartViewModel(series: economics.makeSeries(), configuration: configuration)
        self.isAnimated = true
    }

    init(
        viewModel: BreakEvenChartViewModel,
        isAnimated: Bool
    ) {
        self.viewModel = viewModel
        self.isAnimated = isAnimated
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: BreakEvenChartLayout.headerSpacing) {
            if viewModel.configuration.showsHeader {
                header
            }

            if viewModel.configuration.showsLegend {
                BreakEvenLegend(style: viewModel.configuration.style)
            }

            BreakEvenChartPlot(
                viewModel: viewModel,
                isAnimated: isAnimated && internalAnimation
            )
            .frame(height: viewModel.configuration.plotHeight)

            if viewModel.configuration.showsProfitLossBand {
                BreakEvenProfitLossBand(
                    progress: viewModel.breakEvenProgress,
                    style: viewModel.configuration.style
                )
            }

            if viewModel.configuration.showsMetricSummary {
                metricSummary
            }
        }
        .padding(.horizontal, BreakEvenChartLayout.cardHorizontalPadding)
        .padding(.top, BreakEvenChartLayout.cardTopPadding)
        .padding(.bottom, BreakEvenChartLayout.cardBottomPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BreakEvenChartPanelBackground(style: viewModel.configuration.style))
        .overlay(BreakEvenChartPanelBorder(style: viewModel.configuration.style))
        .clipShape(
            RoundedRectangle(
                cornerRadius: viewModel.configuration.style.cornerRadius,
                style: .continuous
            )
        )
        .onAppear {
            withAnimation(.easeOut(duration: BreakEvenChartLayout.animationDuration)) {
                internalAnimation = true
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(viewModel.configuration.style.revenueColor.opacity(0.16))

                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: BreakEvenChartLayout.headerIconSymbolSize, weight: .bold))
                    .foregroundStyle(viewModel.configuration.style.revenueColor)
            }
            .frame(width: BreakEvenChartLayout.headerIconSize, height: BreakEvenChartLayout.headerIconSize)

            VStack(alignment: .leading, spacing: BreakEvenChartLayout.headerColumnSpacing) {
                Text(viewModel.title)
                    .font(.system(size: BreakEvenChartLayout.headerTitleSize, weight: .bold, design: .rounded))
                    .foregroundStyle(viewModel.configuration.style.titleColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.74)

                Text(viewModel.subtitle)
                    .font(.system(size: BreakEvenChartLayout.headerSubtitleSize, weight: .semibold, design: .rounded))
                    .foregroundStyle(viewModel.configuration.style.secondaryTextColor)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
    }

    private var metricSummary: some View {
        HStack(spacing: 10) {
            BreakEvenMetricCard(
                title: "Loss before break-even",
                value: viewModel.valueText(viewModel.lossBeforeBreakEven),
                systemImage: "chart.line.downtrend.xyaxis",
                tint: viewModel.configuration.style.lossColor,
                style: viewModel.configuration.style
            )

            BreakEvenMetricCard(
                title: "Break-even point",
                value: viewModel.breakEven.map { viewModel.unitsText($0.units) } ?? "-",
                systemImage: "scope",
                tint: viewModel.configuration.style.breakEvenColor,
                style: viewModel.configuration.style
            )

            BreakEvenMetricCard(
                title: "Profit after break-even",
                value: viewModel.valueText(viewModel.profitAfterBreakEven),
                systemImage: "chart.line.uptrend.xyaxis",
                tint: viewModel.configuration.style.profitColor,
                style: viewModel.configuration.style
            )
        }
    }
}

public struct BreakEvenChartShowcase: View {
    public init() {}

    public var body: some View {
        BreakEvenChartCard(
            series: BreakEvenChartSamples.series,
            configuration: BreakEvenChartSamples.configuration
        )
    }
}
