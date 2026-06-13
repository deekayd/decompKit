import SwiftUI

public struct WeeklyActivityChart: View {
    private let viewModel: WeeklyActivityChartViewModel

    @State private var isAnimated = false

    public init(
        series: ActivityChartSeries,
        configuration: ActivityChartConfiguration = ActivityChartConfiguration()
    ) {
        self.viewModel = WeeklyActivityChartViewModel(series: series, configuration: configuration)
    }

    public var body: some View {
        WeeklyActivityChartCard(viewModel: viewModel, isAnimated: isAnimated)
            .padding(.horizontal, WeeklyActivityChartLayout.cardOuterHorizontalPadding)
            .padding(.vertical, WeeklyActivityChartLayout.cardOuterVerticalPadding)
            .shadow(
                color: viewModel.configuration.style.backgroundGlow.opacity(WeeklyActivityChartLayout.cardShadowOpacity),
                radius: WeeklyActivityChartLayout.cardShadowRadius,
                x: 0,
                y: WeeklyActivityChartLayout.cardShadowYOffset
            )
            .onAppear {
                withAnimation(.easeOut(duration: WeeklyActivityChartLayout.animationDuration)) {
                    isAnimated = true
                }
            }
    }
}

public struct WeeklyActivityChartCard: View {
    private let viewModel: WeeklyActivityChartViewModel
    private let isAnimated: Bool

    @State private var internalAnimation = false

    public init(
        series: ActivityChartSeries,
        configuration: ActivityChartConfiguration = ActivityChartConfiguration()
    ) {
        self.viewModel = WeeklyActivityChartViewModel(series: series, configuration: configuration)
        self.isAnimated = true
    }

    init(
        viewModel: WeeklyActivityChartViewModel,
        isAnimated: Bool
    ) {
        self.viewModel = viewModel
        self.isAnimated = isAnimated
    }

    public init(
        points: [ActivityChartPoint],
        maxValue: Double = WeeklyActivityChartDefaults.maxValue,
        trendPercentage: Double = WeeklyActivityChartDefaults.trendPercentage,
        highlightedIndex: Int? = nil,
        highlightBadgeSpacing: CGFloat = WeeklyActivityChartDefaults.highlightBadgeSpacing,
        style: WeeklyActivityChartStyle = .neon
    ) {
        let configuration = ActivityChartConfiguration(
            maxValue: maxValue,
            highlightedIndex: highlightedIndex,
            highlightBadgeSpacing: highlightBadgeSpacing,
            style: style,
            trendOverride: ActivityTrend(
                percentage: trendPercentage,
                caption: ActivityChartRange.week.comparisonCaption
            )
        )
        self.viewModel = WeeklyActivityChartViewModel(
            series: ActivityChartSeries(points: points),
            configuration: configuration
        )
        self.isAnimated = true
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: WeeklyActivityChartLayout.headerSpacing) {
            if viewModel.configuration.showsHeader {
                header
            }

            ActivityChartPlot(
                viewModel: viewModel,
                isAnimated: isAnimated && internalAnimation
            )
            .frame(height: viewModel.configuration.plotHeight)
        }
        .padding(.horizontal, WeeklyActivityChartLayout.cardHorizontalPadding)
        .padding(.top, WeeklyActivityChartLayout.cardTopPadding)
        .padding(.bottom, WeeklyActivityChartLayout.cardBottomPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ChartPanelBackground(style: viewModel.configuration.style))
        .overlay(
            ChartPanelBorder(
                cornerRadius: viewModel.configuration.style.cornerRadius,
                lineWidth: WeeklyActivityChartLayout.cardBorderLineWidth,
                style: viewModel.configuration.style
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: viewModel.configuration.style.cornerRadius,
                style: .continuous
            )
        )
        .onAppear {
            withAnimation(.easeOut(duration: WeeklyActivityChartLayout.animationDuration)) {
                internalAnimation = true
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: WeeklyActivityChartLayout.headerTrendSpacing) {
            VStack(alignment: .leading, spacing: WeeklyActivityChartLayout.headerColumnSpacing) {
                Text(viewModel.title)
                    .font(.system(size: WeeklyActivityChartLayout.headerTitleSize, weight: .bold, design: .rounded))
                    .foregroundStyle(viewModel.configuration.style.titleColor)
                    .lineLimit(2)
                    .minimumScaleFactor(WeeklyActivityChartLayout.headerTitleMinimumScale)

                Text(viewModel.subtitle)
                    .font(.system(size: WeeklyActivityChartLayout.headerSubtitleSize, weight: .medium, design: .rounded))
                    .foregroundStyle(viewModel.configuration.style.secondaryTextColor)
            }

            Spacer(minLength: WeeklyActivityChartLayout.headerSpacerMinLength)

            if let trend = viewModel.trend {
                TrendBadge(
                    percentage: trend.percentage,
                    caption: trend.caption,
                    style: viewModel.configuration.style
                )
            }
        }
    }
}

public struct WeeklyActivityChartMobileLayout: View {
    private let viewModel: WeeklyActivityChartViewModel

    public init(
        series: ActivityChartSeries,
        configuration: ActivityChartConfiguration = ActivityChartConfiguration()
    ) {
        self.viewModel = WeeklyActivityChartViewModel(series: series, configuration: configuration)
    }

    public init(
        points: [ActivityChartPoint],
        maxValue: Double = WeeklyActivityChartDefaults.maxValue,
        trendPercentage: Double = WeeklyActivityChartDefaults.trendPercentage,
        highlightedIndex: Int? = nil,
        highlightBadgeSpacing: CGFloat = WeeklyActivityChartDefaults.highlightBadgeSpacing,
        style: WeeklyActivityChartStyle = .neon
    ) {
        let configuration = ActivityChartConfiguration(
            maxValue: maxValue,
            highlightedIndex: highlightedIndex,
            highlightBadgeSpacing: highlightBadgeSpacing,
            style: style,
            trendOverride: ActivityTrend(
                percentage: trendPercentage,
                caption: ActivityChartRange.week.comparisonCaption
            )
        )
        self.viewModel = WeeklyActivityChartViewModel(
            series: ActivityChartSeries(points: points),
            configuration: configuration
        )
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            WeeklyActivityChartCard(viewModel: viewModel, isAnimated: true)
                .padding(.horizontal, WeeklyActivityChartLayout.mobileHorizontalPadding)
                .padding(.vertical, WeeklyActivityChartLayout.mobileVerticalPadding)
        }
    }
}

public struct WeeklyActivityChartShowcase: View {
    public init() {}

    public var body: some View {
        WeeklyActivityChart(
            series: WeeklyActivityChartSamples.series,
            configuration: ActivityChartConfiguration(highlightedIndex: WeeklyActivityChartLayout.sampleHighlightedIndex)
        )
    }
}

public struct WeeklyActivityChartMobileShowcase: View {
    public init() {}

    public var body: some View {
        WeeklyActivityChartMobileLayout(
            series: WeeklyActivityChartSamples.series,
            configuration: ActivityChartConfiguration(highlightedIndex: WeeklyActivityChartLayout.sampleHighlightedIndex)
        )
    }
}
