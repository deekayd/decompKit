import DecompKit

enum DemoChartColorMode: String, CaseIterable, Identifiable {
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
