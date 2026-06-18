import SwiftUI

public struct BreakEvenChartStyle {
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
    public var revenueColor: Color
    public var costColor: Color
    public var breakEvenColor: Color
    public var profitColor: Color
    public var lossColor: Color
    public var cornerRadius: CGFloat

    public init(
        backgroundTop: Color = Color(red: 0.02, green: 0.04, blue: 0.06),
        backgroundBottom: Color = Color(red: 0.00, green: 0.02, blue: 0.04),
        backgroundGlow: Color = Color(red: 0.22, green: 0.95, blue: 0.48),
        borderColors: [Color] = [
            Color.white.opacity(0.18),
            Color(red: 0.18, green: 0.28, blue: 0.36).opacity(0.80),
            Color(red: 0.05, green: 0.10, blue: 0.13).opacity(0.90)
        ],
        titleColor: Color = .white,
        secondaryTextColor: Color = Color(red: 0.72, green: 0.77, blue: 0.84),
        gridColor: Color = Color.white.opacity(0.11),
        axisColor: Color = Color.white.opacity(0.20),
        cardBackground: Color = Color.white.opacity(0.07),
        cardBorder: Color = Color.white.opacity(0.13),
        revenueColor: Color = Color(red: 0.34, green: 0.92, blue: 0.48),
        costColor: Color = Color(red: 1.00, green: 0.39, blue: 0.34),
        breakEvenColor: Color = Color(red: 1.00, green: 0.72, blue: 0.24),
        profitColor: Color = Color(red: 0.30, green: 0.92, blue: 0.50),
        lossColor: Color = Color(red: 1.00, green: 0.35, blue: 0.32),
        cornerRadius: CGFloat = BreakEvenChartDefaults.cardCornerRadius
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
        self.revenueColor = revenueColor
        self.costColor = costColor
        self.breakEvenColor = breakEvenColor
        self.profitColor = profitColor
        self.lossColor = lossColor
        self.cornerRadius = cornerRadius
    }

    public static var neon: BreakEvenChartStyle {
        BreakEvenChartStyle()
    }

    public static var graphite: BreakEvenChartStyle {
        BreakEvenChartStyle(
            backgroundTop: Color(red: 0.04, green: 0.05, blue: 0.07),
            backgroundBottom: Color(red: 0.02, green: 0.02, blue: 0.03),
            backgroundGlow: Color(red: 0.40, green: 0.52, blue: 0.64),
            borderColors: [
                Color(red: 0.24, green: 0.27, blue: 0.34).opacity(0.95),
                Color(red: 0.08, green: 0.09, blue: 0.12).opacity(0.90),
                Color(red: 0.18, green: 0.20, blue: 0.26).opacity(0.92)
            ],
            secondaryTextColor: Color(red: 0.70, green: 0.74, blue: 0.82),
            gridColor: Color.white.opacity(0.08),
            axisColor: Color.white.opacity(0.16),
            revenueColor: Color(red: 0.46, green: 0.86, blue: 0.66),
            costColor: Color(red: 1.00, green: 0.50, blue: 0.48),
            breakEvenColor: Color(red: 1.00, green: 0.74, blue: 0.28)
        )
    }

    public static var financial: BreakEvenChartStyle {
        BreakEvenChartStyle(
            backgroundTop: Color(red: 0.98, green: 0.97, blue: 0.94),
            backgroundBottom: Color(red: 0.91, green: 0.94, blue: 0.92),
            backgroundGlow: Color(red: 0.24, green: 0.58, blue: 0.44),
            borderColors: [
                Color(red: 0.74, green: 0.78, blue: 0.75),
                Color(red: 0.88, green: 0.90, blue: 0.86)
            ],
            titleColor: Color(red: 0.10, green: 0.13, blue: 0.16),
            secondaryTextColor: Color(red: 0.38, green: 0.43, blue: 0.48),
            gridColor: Color.black.opacity(0.08),
            axisColor: Color.black.opacity(0.18),
            cardBackground: Color.white.opacity(0.76),
            cardBorder: Color.black.opacity(0.10),
            revenueColor: Color(red: 0.14, green: 0.48, blue: 0.88),
            costColor: Color(red: 0.76, green: 0.40, blue: 0.28),
            breakEvenColor: Color(red: 0.86, green: 0.55, blue: 0.12),
            profitColor: Color(red: 0.18, green: 0.58, blue: 0.38),
            lossColor: Color(red: 0.80, green: 0.30, blue: 0.28)
        )
    }
}
