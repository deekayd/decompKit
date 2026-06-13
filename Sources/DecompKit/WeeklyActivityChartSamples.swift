import SwiftUI

public enum WeeklyActivityChartSamples {
    public static var points: [ActivityChartPoint] {
        [
            ActivityChartPoint(id: "mon", label: "Mon", value: 40, tint: Color(red: 0.05, green: 0.66, blue: 0.96)),
            ActivityChartPoint(id: "tue", label: "Tue", value: 65, tint: Color(red: 0.08, green: 0.45, blue: 1.00)),
            ActivityChartPoint(id: "wed", label: "Wed", value: 48, tint: Color(red: 0.43, green: 0.24, blue: 1.00)),
            ActivityChartPoint(id: "thu", label: "Thu", value: 80, tint: Color(red: 0.58, green: 0.20, blue: 1.00)),
            ActivityChartPoint(id: "fri", label: "Fri", value: 72, tint: Color(red: 0.78, green: 0.16, blue: 0.96)),
            ActivityChartPoint(id: "sat", label: "Sat", value: 95, tint: Color(red: 1.00, green: 0.15, blue: 0.78)),
            ActivityChartPoint(id: "sun", label: "Sun", value: 85, tint: Color(red: 1.00, green: 0.24, blue: 0.52))
        ]
    }

    public static var previousWeekPoints: [Double] {
        [34, 55, 44, 66, 63, 79, 53]
    }

    public static var series: ActivityChartSeries {
        ActivityChartSeries(
            points: points,
            comparison: ActivityChartComparison(previousValues: previousWeekPoints)
        )
    }

    public static func points(for range: ActivityChartRange) -> [ActivityChartPoint] {
        switch range {
        case .week:
            points
        case .months:
            makePoints(
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"],
                values: [38, 52, 45, 70, 64, 88, 76]
            )
        case .years:
            makePoints(
                labels: ["2020", "2021", "2022", "2023", "2024", "2025", "2026"],
                values: [32, 46, 57, 51, 68, 83, 91]
            )
        }
    }

    public static func comparisonValues(for range: ActivityChartRange) -> [Double] {
        switch range {
        case .week:
            previousWeekPoints
        case .months:
            [31, 42, 40, 58, 61, 70, 66]
        case .years:
            [25, 35, 43, 48, 55, 70, 78]
        }
    }

    private static func makePoints(labels: [String], values: [Double]) -> [ActivityChartPoint] {
        zip(labels, values).enumerated().map { index, element in
            ActivityChartPoint(
                id: element.0.lowercased(),
                label: element.0,
                value: element.1,
                tint: palette[index % palette.count]
            )
        }
    }

    private static var palette: [Color] {
        [
            Color(red: 0.05, green: 0.66, blue: 0.96),
            Color(red: 0.08, green: 0.45, blue: 1.00),
            Color(red: 0.43, green: 0.24, blue: 1.00),
            Color(red: 0.58, green: 0.20, blue: 1.00),
            Color(red: 0.78, green: 0.16, blue: 0.96),
            Color(red: 1.00, green: 0.15, blue: 0.78),
            Color(red: 1.00, green: 0.24, blue: 0.52)
        ]
    }
}
