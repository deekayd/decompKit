# DecompKit

Open-source SwiftUI components from the DecompAI ecosystem.

DecompKit is a polished component kit for building expressive, production-ready SwiftUI interfaces without starting every custom visual from scratch.

The first component is `WeeklyActivityChart`: a glowing line and area chart with smooth curves, configurable ranges, trend comparison, highlighted data points, and a customizable neon style.

## Repository Layout

This repository is the Swift Package module.

```text
Package.swift
Sources/DecompKit/
Tests/DecompKitTests/
Examples/DecompKitDemo/
```

Open `Package.swift` to work on the library. Open `Examples/DecompKitDemo/DecompKitDemo.xcodeproj` only when you want to run the demo app.

The chart implementation is split into:

```text
ActivityChartModels.swift
WeeklyActivityChart.swift
WeeklyActivityChartPlot.swift
WeeklyActivityChartComponents.swift
WeeklyActivityChartViewModel.swift
WeeklyActivityChartStyle.swift
WeeklyActivityChartConstants.swift
WeeklyActivityChartSamples.swift
```

## Requirements

- iOS 18+
- Swift 6.0+

## Installation

Add the package to your app in Xcode:

1. Open `File > Add Package Dependencies...`
2. Paste your repository URL.
3. Add the `DecompKit` product to your target.

Or add it to `Package.swift`:

```swift
.package(url: "https://github.com/deekayd/decompkit.git", from: "0.1.0")
```

```swift
.product(name: "DecompKit", package: "decompkit")
```

## Usage

For an iPhone-first chart layout:

```swift
import SwiftUI
import DecompKit

struct ActivityScreen: View {
    var body: some View {
        WeeklyActivityChartCard(
            series: WeeklyActivityChartSamples.series,
            configuration: ActivityChartConfiguration(highlightedIndex: 5)
        )
    }
}
```

Or pass your own data:

```swift
import SwiftUI
import DecompKit

struct DashboardView: View {
    let points = [
        ActivityChartPoint(label: "Mon", value: 42, tint: .cyan),
        ActivityChartPoint(label: "Tue", value: 68, tint: .blue),
        ActivityChartPoint(label: "Wed", value: 51, tint: .purple),
        ActivityChartPoint(label: "Thu", value: 88, tint: .pink)
    ]

    var body: some View {
        WeeklyActivityChartCard(
            series: ActivityChartSeries(
                points: points,
                comparison: ActivityChartComparison(previousTotal: 190)
            ),
            configuration: ActivityChartConfiguration(
                title: "Weekly Progress",
                range: .week,
                maxValue: 100,
                highlightedIndex: 3
            )
        )
        .padding()
    }
}
```

## Ranges

```swift
ActivityChartConfiguration(range: .week)   // This Week
ActivityChartConfiguration(range: .months) // Last 7 Months
ActivityChartConfiguration(range: .years)  // Last 7 Years
```

## Trend Calculation

To calculate the `+23%` badge, pass current points and either previous values or a previous total:

```swift
let series = ActivityChartSeries(
    points: currentPoints,
    comparison: ActivityChartComparison(previousValues: previousWeekValues)
)
```

The chart computes:

```text
(currentTotal - previousTotal) / previousTotal * 100
```

## Styling

```swift
let preset = WeeklyActivityChartStyle.aurora

let style = WeeklyActivityChartStyle(
    backgroundTop: Color(red: 0.02, green: 0.03, blue: 0.09),
    backgroundBottom: Color(red: 0.08, green: 0.03, blue: 0.16),
    borderColors: [
        Color(red: 0.18, green: 0.22, blue: 0.34),
        Color(red: 0.07, green: 0.08, blue: 0.16)
    ],
    positiveColor: .green
)
```

Available presets: `.neon`, `.aurora`, `.graphite`.

You can also tune chart behavior through `ActivityChartConfiguration`:

```swift
ActivityChartConfiguration(
    highlightBadgeSpacing: 36,
    plotHeight: 320,
    showsHeader: true,
    style: style,
    colorMode: .spectrum
)
```

Chart color modes:

```swift
ActivityChartConfiguration(colorMode: .source)   // colors from points
ActivityChartConfiguration(colorMode: .focused)  // monotone line, highlighted point stands out
ActivityChartConfiguration(colorMode: .ocean)    // two-tone chart
ActivityChartConfiguration(colorMode: .spectrum) // multi-color gradient
ActivityChartConfiguration(colorMode: .status)   // semantic low / medium / high colors
```

## Demo App

The example app starts with a component list. Open `Графики` to see chart previews; tapping a preview opens a full chart with controls for range, theme, chart color mode, plot height, highlighted point, highlight badge spacing, header visibility, highlighted point visibility, and randomized data.

## Roadmap

- More chart variants: rings, radial progress, compact sparklines.
- Interactive states: selected point, gesture-driven tooltips, haptics.
- DocC documentation and snapshot tests.

## License

MIT. See [LICENSE](LICENSE).
