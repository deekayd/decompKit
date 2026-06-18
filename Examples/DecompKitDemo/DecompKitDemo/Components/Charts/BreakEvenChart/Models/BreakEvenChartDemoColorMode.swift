import DecompKit
import SwiftUI

enum BreakEvenChartDemoColorMode: String, CaseIterable, Identifiable {
    case original
    case monoFocus
    case twoTone
    case gradient
    case status

    var id: String { rawValue }

    var title: String {
        switch self {
        case .original:
            "Original"
        case .monoFocus:
            "Mono Focus"
        case .twoTone:
            "Two Tone"
        case .gradient:
            "Gradient"
        case .status:
            "Status"
        }
    }

    var symbolName: String {
        switch self {
        case .original:
            "circle.grid.3x3.fill"
        case .monoFocus:
            "smallcircle.filled.circle"
        case .twoTone:
            "circle.lefthalf.filled"
        case .gradient:
            "paintpalette.fill"
        case .status:
            "checkmark.seal.fill"
        }
    }

    var swatchColors: [Color] {
        switch self {
        case .original:
            [
                Color(red: 0.34, green: 0.92, blue: 0.48),
                Color(red: 1.00, green: 0.39, blue: 0.34),
                Color(red: 1.00, green: 0.72, blue: 0.24)
            ]
        case .monoFocus:
            [
                Color.white.opacity(0.54),
                Color(red: 1.00, green: 0.74, blue: 0.26)
            ]
        case .twoTone:
            [
                Color(red: 0.15, green: 0.72, blue: 1.00),
                Color(red: 1.00, green: 0.46, blue: 0.38)
            ]
        case .gradient:
            [
                Color(red: 0.20, green: 0.90, blue: 1.00),
                Color(red: 0.30, green: 0.96, blue: 0.52),
                Color(red: 1.00, green: 0.75, blue: 0.26),
                Color(red: 1.00, green: 0.34, blue: 0.44)
            ]
        case .status:
            [
                Color(red: 1.00, green: 0.34, blue: 0.34),
                Color(red: 1.00, green: 0.72, blue: 0.24),
                Color(red: 0.30, green: 0.92, blue: 0.50)
            ]
        }
    }

    func style(from base: BreakEvenChartStyle) -> BreakEvenChartStyle {
        var style = base

        switch self {
        case .original:
            return style
        case .monoFocus:
            style.revenueColor = Color.white.opacity(0.78)
            style.costColor = Color.white.opacity(0.38)
            style.breakEvenColor = Color(red: 1.00, green: 0.74, blue: 0.26)
            style.profitColor = Color.white.opacity(0.48)
            style.lossColor = Color.white.opacity(0.30)
        case .twoTone:
            style.revenueColor = Color(red: 0.15, green: 0.72, blue: 1.00)
            style.costColor = Color(red: 1.00, green: 0.46, blue: 0.38)
            style.breakEvenColor = Color(red: 1.00, green: 0.76, blue: 0.30)
            style.profitColor = Color(red: 0.15, green: 0.72, blue: 1.00)
            style.lossColor = Color(red: 1.00, green: 0.46, blue: 0.38)
        case .gradient:
            style.revenueColor = Color(red: 0.30, green: 0.96, blue: 0.52)
            style.costColor = Color(red: 1.00, green: 0.34, blue: 0.44)
            style.breakEvenColor = Color(red: 1.00, green: 0.75, blue: 0.26)
            style.profitColor = Color(red: 0.20, green: 0.90, blue: 1.00)
            style.lossColor = Color(red: 1.00, green: 0.42, blue: 0.66)
        case .status:
            style.revenueColor = Color(red: 0.30, green: 0.92, blue: 0.50)
            style.costColor = Color(red: 1.00, green: 0.34, blue: 0.34)
            style.breakEvenColor = Color(red: 1.00, green: 0.72, blue: 0.24)
            style.profitColor = Color(red: 0.30, green: 0.92, blue: 0.50)
            style.lossColor = Color(red: 1.00, green: 0.34, blue: 0.34)
        }

        return style
    }
}
