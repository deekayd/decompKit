import SwiftUI

struct BreakEvenChartPanelBackground: View {
    let style: BreakEvenChartStyle

    var body: some View {
        LinearGradient(
            colors: [
                style.backgroundTop,
                style.backgroundBottom
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct BreakEvenChartPanelBorder: View {
    let style: BreakEvenChartStyle

    var body: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
            .stroke(
                LinearGradient(
                    colors: style.borderColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.4
            )
    }
}

struct BreakEvenLegend: View {
    let style: BreakEvenChartStyle

    var body: some View {
        HStack(spacing: BreakEvenChartLayout.legendSpacing) {
            legendItem(title: "Revenue", color: style.revenueColor)
            legendItem(title: "Total Costs", color: style.costColor)
            Spacer(minLength: 0)
        }
    }

    private func legendItem(title: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: BreakEvenChartLayout.legendDotSize, height: BreakEvenChartLayout.legendDotSize)
                .shadow(color: color.opacity(0.55), radius: 6)

            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(style.titleColor)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
    }
}

struct BreakEvenProfitLossBand: View {
    let progress: Double
    let style: BreakEvenChartStyle

    var body: some View {
        GeometryReader { geometry in
            let width = max(1, geometry.size.width)
            let splitWidth = width * CGFloat(breakEvenClamp(progress, min: 0.12, max: 0.88))

            HStack(spacing: 0) {
                bandSegment(
                    title: "Loss",
                    systemImage: "chart.line.downtrend.xyaxis",
                    color: style.lossColor
                )
                .frame(width: splitWidth)

                bandSegment(
                    title: "Profit",
                    systemImage: "chart.line.uptrend.xyaxis",
                    color: style.profitColor
                )
            }
            .clipShape(
                RoundedRectangle(cornerRadius: BreakEvenChartLayout.bandCornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BreakEvenChartLayout.bandCornerRadius, style: .continuous)
                    .stroke(style.cardBorder, lineWidth: 1)
            )
        }
        .frame(height: BreakEvenChartLayout.bandHeight)
    }

    private func bandSegment(
        title: String,
        systemImage: String,
        color: Color
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .bold))

            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .foregroundStyle(color)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color.opacity(0.13))
    }
}

struct BreakEvenMetricCard: View {
    let title: String
    let value: String
    let systemImage: String
    let tint: Color
    let style: BreakEvenChartStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 9) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.18))

                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(tint)
                }
                .frame(width: BreakEvenChartLayout.metricIconSize, height: BreakEvenChartLayout.metricIconSize)

                Text(title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(style.secondaryTextColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)
            }

            Spacer(minLength: 0)

            Text(value)
                .font(.system(size: 21, weight: .bold, design: .rounded))
                .foregroundStyle(tint)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.70)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: BreakEvenChartLayout.metricCardHeight, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: BreakEvenChartLayout.metricCardCornerRadius, style: .continuous)
                .fill(style.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: BreakEvenChartLayout.metricCardCornerRadius, style: .continuous)
                .stroke(style.cardBorder, lineWidth: 1)
        )
    }
}

struct BreakEvenMarkerBadge: View {
    let marker: BreakEvenMarker
    let valueText: String
    let unitsText: String
    let style: BreakEvenChartStyle

    var body: some View {
        VStack(spacing: 4) {
            Text(marker.label)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(style.breakEvenColor)
                .lineLimit(1)

            Text(valueText)
                .font(.system(size: 23, weight: .bold, design: .rounded))
                .foregroundStyle(style.titleColor)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.78)

            Text(unitsText)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(style.titleColor.opacity(0.88))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .padding(.horizontal, 12)
        .frame(width: BreakEvenChartLayout.badgeWidth, height: BreakEvenChartLayout.badgeHeight)
        .background(
            RoundedRectangle(cornerRadius: BreakEvenChartLayout.badgeCornerRadius, style: .continuous)
                .fill(style.cardBackground.opacity(0.96))
        )
        .overlay(
            RoundedRectangle(cornerRadius: BreakEvenChartLayout.badgeCornerRadius, style: .continuous)
                .stroke(style.breakEvenColor.opacity(0.70), lineWidth: 1.2)
        )
        .shadow(color: style.breakEvenColor.opacity(0.25), radius: 16)
    }
}
