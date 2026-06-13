import XCTest
@testable import DecompKit

final class WeeklyActivityStatsTests: XCTestCase {
    func testStatsForSampleData() {
        let stats = WeeklyActivityStats(points: WeeklyActivityChartSamples.points)

        XCTAssertEqual(stats.total, 485)
        XCTAssertEqual(stats.average, 485.0 / 7.0, accuracy: 0.0001)
        XCTAssertEqual(stats.highestIndex, 5)
    }

    func testStatsForEmptyData() {
        let stats = WeeklyActivityStats(points: [])

        XCTAssertEqual(stats.total, 0)
        XCTAssertEqual(stats.average, 0)
        XCTAssertNil(stats.highestIndex)
    }

    func testViewModelCalculatesTrendFromPreviousValues() {
        let series = ActivityChartSeries(
            points: WeeklyActivityChartSamples.points,
            comparison: ActivityChartComparison(previousValues: [34, 55, 44, 66, 63, 79, 53])
        )
        let viewModel = WeeklyActivityChartViewModel(
            series: series,
            configuration: ActivityChartConfiguration(range: .week)
        )

        XCTAssertEqual(viewModel.trend?.percentage ?? 0, 23.0964, accuracy: 0.001)
        XCTAssertEqual(viewModel.trend?.caption, "vs last week")
    }

    func testConfigurationCanOverrideTrend() {
        let viewModel = WeeklyActivityChartViewModel(
            series: ActivityChartSeries(points: WeeklyActivityChartSamples.points),
            configuration: ActivityChartConfiguration(
                trendOverride: ActivityTrend(percentage: 12, caption: "custom comparison")
            )
        )

        XCTAssertEqual(viewModel.trend?.percentage, 12)
        XCTAssertEqual(viewModel.trend?.caption, "custom comparison")
    }
}
