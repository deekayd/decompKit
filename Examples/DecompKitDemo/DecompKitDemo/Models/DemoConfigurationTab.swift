enum DemoConfigurationTab: String, CaseIterable, Identifiable {
    case data
    case layout
    case visibility

    var id: String { rawValue }

    var title: String {
        switch self {
        case .data:
            "Data"
        case .layout:
            "Layout"
        case .visibility:
            "Display"
        }
    }
}
