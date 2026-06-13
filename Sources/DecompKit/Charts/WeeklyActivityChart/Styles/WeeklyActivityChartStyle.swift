import SwiftUI

public struct WeeklyActivityChartStyle {
    public var backgroundTop: Color
    public var backgroundBottom: Color
    public var backgroundGlow: Color
    public var borderColors: [Color]
    public var titleColor: Color
    public var secondaryTextColor: Color
    public var gridColor: Color
    public var axisColor: Color
    public var cardBackground: Color
    public var cardBorder: Color
    public var positiveColor: Color
    public var negativeColor: Color
    public var cornerRadius: CGFloat

    public init(
        backgroundTop: Color = Color(red: 0.02, green: 0.03, blue: 0.09),
        backgroundBottom: Color = Color(red: 0.08, green: 0.03, blue: 0.16),
        backgroundGlow: Color = Color(red: 0.74, green: 0.15, blue: 0.95),
        borderColors: [Color] = [
            Color(red: 0.18, green: 0.22, blue: 0.34).opacity(0.95),
            Color(red: 0.07, green: 0.08, blue: 0.16).opacity(0.88),
            Color(red: 0.15, green: 0.09, blue: 0.24).opacity(0.94)
        ],
        titleColor: Color = .white,
        secondaryTextColor: Color = Color(red: 0.72, green: 0.72, blue: 0.88),
        gridColor: Color = Color.white.opacity(0.10),
        axisColor: Color = Color.white.opacity(0.18),
        cardBackground: Color = Color.white.opacity(0.07),
        cardBorder: Color = Color.white.opacity(0.12),
        positiveColor: Color = Color(red: 0.18, green: 1.00, blue: 0.58),
        negativeColor: Color = Color(red: 1.00, green: 0.31, blue: 0.43),
        cornerRadius: CGFloat = WeeklyActivityChartDefaults.cardCornerRadius
    ) {
        self.backgroundTop = backgroundTop
        self.backgroundBottom = backgroundBottom
        self.backgroundGlow = backgroundGlow
        self.borderColors = borderColors
        self.titleColor = titleColor
        self.secondaryTextColor = secondaryTextColor
        self.gridColor = gridColor
        self.axisColor = axisColor
        self.cardBackground = cardBackground
        self.cardBorder = cardBorder
        self.positiveColor = positiveColor
        self.negativeColor = negativeColor
        self.cornerRadius = cornerRadius
    }

    public static var neon: WeeklyActivityChartStyle {
        WeeklyActivityChartStyle()
    }

    public static var aurora: WeeklyActivityChartStyle {
        WeeklyActivityChartStyle(
            backgroundTop: Color(red: 0.01, green: 0.07, blue: 0.11),
            backgroundBottom: Color(red: 0.03, green: 0.10, blue: 0.16),
            backgroundGlow: Color(red: 0.10, green: 0.92, blue: 0.72),
            borderColors: [
                Color(red: 0.16, green: 0.27, blue: 0.32).opacity(0.96),
                Color(red: 0.04, green: 0.12, blue: 0.16).opacity(0.88),
                Color(red: 0.08, green: 0.22, blue: 0.20).opacity(0.94)
            ],
            secondaryTextColor: Color(red: 0.68, green: 0.84, blue: 0.86),
            gridColor: Color.white.opacity(0.09),
            axisColor: Color.white.opacity(0.16),
            cardBackground: Color.white.opacity(0.06),
            cardBorder: Color.white.opacity(0.12),
            positiveColor: Color(red: 0.20, green: 1.00, blue: 0.70),
            negativeColor: Color(red: 1.00, green: 0.36, blue: 0.50)
        )
    }

    public static var graphite: WeeklyActivityChartStyle {
        WeeklyActivityChartStyle(
            backgroundTop: Color(red: 0.04, green: 0.05, blue: 0.08),
            backgroundBottom: Color(red: 0.02, green: 0.03, blue: 0.05),
            backgroundGlow: Color(red: 0.42, green: 0.52, blue: 0.70),
            borderColors: [
                Color(red: 0.24, green: 0.27, blue: 0.34).opacity(0.95),
                Color(red: 0.07, green: 0.08, blue: 0.11).opacity(0.90),
                Color(red: 0.17, green: 0.19, blue: 0.25).opacity(0.92)
            ],
            secondaryTextColor: Color(red: 0.70, green: 0.74, blue: 0.82),
            gridColor: Color.white.opacity(0.08),
            axisColor: Color.white.opacity(0.16),
            cardBackground: Color.white.opacity(0.06),
            cardBorder: Color.white.opacity(0.12),
            positiveColor: Color(red: 0.38, green: 0.92, blue: 0.62),
            negativeColor: Color(red: 1.00, green: 0.42, blue: 0.48)
        )
    }
}
