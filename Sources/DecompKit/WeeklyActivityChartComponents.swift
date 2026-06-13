import SwiftUI

struct ChartPanelBackground: View {
    let style: WeeklyActivityChartStyle

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

struct ChartPanelBorder: View {
    let cornerRadius: CGFloat
    let lineWidth: CGFloat
    let style: WeeklyActivityChartStyle

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: style.borderColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: lineWidth
                )

            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(
                                color: Color(red: 0.35, green: 0.52, blue: 1.00)
                                    .opacity(WeeklyActivityChartLayout.borderGlowStartOpacity),
                                location: 0
                            ),
                            Gradient.Stop(
                                color: Color(red: 0.72, green: 0.32, blue: 1.00)
                                    .opacity(WeeklyActivityChartLayout.borderGlowEndOpacity),
                                location: 1
                            )
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: lineWidth + WeeklyActivityChartLayout.borderGlowLineWidthDelta
                )
                .opacity(WeeklyActivityChartLayout.borderGlowOpacity)
        }
    }
}

struct TrendBadge: View {
    let percentage: Double
    let caption: String
    let style: WeeklyActivityChartStyle

    private var tint: Color {
        percentage >= 0 ? style.positiveColor : style.negativeColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: WeeklyActivityChartLayout.trendBadgeSpacing) {
            HStack(spacing: WeeklyActivityChartLayout.trendBadgeValueSpacing) {
                Image(systemName: percentage >= 0 ? "arrow.up.right" : "arrow.down.right")
                    .font(.system(size: WeeklyActivityChartLayout.trendBadgeIconSize, weight: .bold))

                Text(percentText)
                    .font(.system(size: WeeklyActivityChartLayout.trendBadgeValueSize, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }
            .foregroundStyle(tint)

            Text(caption)
                .font(.system(size: WeeklyActivityChartLayout.trendBadgeCaptionSize, weight: .medium, design: .rounded))
                .foregroundStyle(style.secondaryTextColor)
                .lineLimit(1)
        }
        .padding(.horizontal, WeeklyActivityChartLayout.trendBadgeHorizontalPadding)
        .padding(.vertical, WeeklyActivityChartLayout.trendBadgeVerticalPadding)
        .frame(width: WeeklyActivityChartLayout.trendBadgeWidth, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: WeeklyActivityChartLayout.trendBadgeCornerRadius, style: .continuous)
                .fill(Color(red: 0.05, green: 0.07, blue: 0.16).opacity(WeeklyActivityChartLayout.trendBadgeBackgroundOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: WeeklyActivityChartLayout.trendBadgeCornerRadius, style: .continuous)
                .stroke(
                    style.cardBorder.opacity(WeeklyActivityChartLayout.trendBadgeBorderOpacity),
                    lineWidth: WeeklyActivityChartLayout.trendBadgeBorderLineWidth
                )
        )
    }

    private var percentText: String {
        let sign = percentage >= 0 ? "+" : "-"
        let value = abs(percentage)
        let formatted = value.rounded() == value ? String(Int(value)) : String(format: "%.1f", value)
        return "\(sign)\(formatted)%"
    }
}

struct HighlightBadge: View {
    let point: ActivityChartPoint
    let style: WeeklyActivityChartStyle

    var body: some View {
        VStack(spacing: WeeklyActivityChartLayout.badgeTextSpacing) {
            Text(point.label)
                .font(.system(size: WeeklyActivityChartLayout.badgeLabelSize, weight: .bold, design: .rounded))
                .foregroundStyle(point.tint)

            Text(formatPointValue(point.value))
                .font(.system(size: WeeklyActivityChartLayout.badgeValueSize, weight: .bold, design: .rounded))
                .foregroundStyle(style.titleColor)
                .monospacedDigit()
        }
        .frame(width: WeeklyActivityChartLayout.badgeWidth, height: WeeklyActivityChartLayout.badgeHeight)
        .background(
            RoundedRectangle(cornerRadius: WeeklyActivityChartLayout.badgeCornerRadius, style: .continuous)
                .fill(style.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: WeeklyActivityChartLayout.badgeCornerRadius, style: .continuous)
                .stroke(
                    point.tint.opacity(WeeklyActivityChartLayout.badgeBorderOpacity),
                    lineWidth: WeeklyActivityChartLayout.badgeBorderLineWidth
                )
        )
        .shadow(
            color: point.tint.opacity(WeeklyActivityChartLayout.badgeShadowOpacity),
            radius: WeeklyActivityChartLayout.badgeShadowRadius
        )
    }

    private func formatPointValue(_ value: Double) -> String {
        value.rounded() == value ? String(Int(value)) : String(format: "%.1f", value)
    }
}
