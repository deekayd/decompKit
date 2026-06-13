import SwiftUI
import DecompKit

enum WeeklyActivityChartDemoColorMode: String, CaseIterable, Identifiable {
    case original
    case monotone
    case twoTone
    case gradient
    case status

    var id: String { rawValue }

    var title: String {
        switch self {
        case .original:
            "Original"
        case .monotone:
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
        case .monotone:
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
                Color(red: 0.10, green: 0.82, blue: 1.00),
                Color(red: 0.20, green: 1.00, blue: 0.60),
                Color(red: 1.00, green: 0.78, blue: 0.20),
                Color(red: 1.00, green: 0.36, blue: 0.62)
            ]
        case .monotone:
            [
                Color.white.opacity(0.50),
                Color(red: 0.18, green: 1.00, blue: 0.58)
            ]
        case .twoTone:
            [
                Color(red: 0.12, green: 0.84, blue: 1.00),
                Color(red: 0.53, green: 0.36, blue: 1.00)
            ]
        case .gradient:
            [
                Color(red: 0.10, green: 0.82, blue: 1.00),
                Color(red: 0.20, green: 1.00, blue: 0.60),
                Color(red: 1.00, green: 0.78, blue: 0.20),
                Color(red: 1.00, green: 0.36, blue: 0.62)
            ]
        case .status:
            [
                Color(red: 1.00, green: 0.35, blue: 0.42),
                Color(red: 1.00, green: 0.76, blue: 0.24),
                Color(red: 0.22, green: 0.92, blue: 0.58)
            ]
        }
    }

    var mode: ActivityChartColorMode {
        switch self {
        case .original:
            .source
        case .monotone:
            .focused
        case .twoTone:
            .ocean
        case .gradient:
            .spectrum
        case .status:
            .status
        }
    }
}
