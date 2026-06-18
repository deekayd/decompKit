import SwiftUI

struct BreakEvenChartPlot: View {
    let viewModel: BreakEvenChartViewModel
    let isAnimated: Bool

    private var style: BreakEvenChartStyle {
        viewModel.configuration.style
    }

    var body: some View {
        GeometryReader { geometry in
            let plot = BreakEvenPlotLayout(size: geometry.size)
            let plottedPoints = makePlottedPoints(in: plot.rect)
            let revenuePoints = plottedPoints.map(\.revenuePoint)
            let costPoints = plottedPoints.map(\.costPoint)
            let markerCoordinate = makeMarkerCoordinate(in: plot.rect)

            ZStack {
                grid(in: plot)
                breakEvenAreas(in: plot.rect)

                if revenuePoints.count > 1 {
                    BreakEvenLineShape(points: costPoints)
                        .trim(from: 0, to: isAnimated ? 1 : 0)
                        .stroke(
                            style.costColor,
                            style: StrokeStyle(
                                lineWidth: BreakEvenChartLayout.lineWidth,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .shadow(color: style.costColor.opacity(0.24), radius: 8)

                    BreakEvenLineShape(points: revenuePoints)
                        .trim(from: 0, to: isAnimated ? 1 : 0)
                        .stroke(
                            style.revenueColor,
                            style: StrokeStyle(
                                lineWidth: BreakEvenChartLayout.lineWidth,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .shadow(color: style.revenueColor.opacity(0.30), radius: 10)
                }

                if let markerCoordinate, let marker = viewModel.breakEven {
                    if viewModel.configuration.showsBreakEvenGuides {
                        breakEvenGuides(in: plot.rect, coordinate: markerCoordinate)
                    }

                    breakEvenMarker(at: markerCoordinate)

                    BreakEvenMarkerBadge(
                        marker: marker,
                        valueText: viewModel.valueText(marker.value),
                        unitsText: viewModel.unitsText(marker.units),
                        style: style
                    )
                    .position(
                        x: breakEvenClamp(
                            markerCoordinate.x - 28,
                            min: plot.rect.minX + BreakEvenChartLayout.badgeWidth / 2,
                            max: plot.rect.maxX - BreakEvenChartLayout.badgeWidth / 2
                        ),
                        y: breakEvenClamp(
                            markerCoordinate.y - 76,
                            min: plot.rect.minY + BreakEvenChartLayout.badgeHeight / 2,
                            max: plot.rect.maxY - BreakEvenChartLayout.badgeHeight / 2
                        )
                    )
                    .opacity(isAnimated ? 1 : 0)
                    .scaleEffect(isAnimated ? 1 : 0.92)
                }
            }
        }
    }

    private func grid(in plot: BreakEvenPlotLayout) -> some View {
        ZStack {
            ForEach(Array(yTicks.enumerated()), id: \.offset) { _, value in
                let y = plot.yPosition(for: value, maxValue: viewModel.maxValue)

                Path { path in
                    path.move(to: CGPoint(x: plot.rect.minX, y: y))
                    path.addLine(to: CGPoint(x: plot.rect.maxX, y: y))
                }
                .stroke(
                    style.gridColor,
                    style: StrokeStyle(
                        lineWidth: BreakEvenChartLayout.gridLineWidth,
                        dash: BreakEvenChartLayout.gridDash
                    )
                )

                Text(viewModel.valueText(value))
                    .font(.system(size: BreakEvenChartLayout.axisLabelSize, weight: .medium, design: .rounded))
                    .foregroundStyle(style.secondaryTextColor)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(width: BreakEvenChartLayout.plotLeftInset - 8, alignment: .trailing)
                    .position(x: (BreakEvenChartLayout.plotLeftInset - 8) / 2, y: y)
            }

            ForEach(Array(xTicks.enumerated()), id: \.offset) { _, value in
                let x = plot.xPosition(for: value, maxUnits: viewModel.maxUnits)

                Path { path in
                    path.move(to: CGPoint(x: x, y: plot.rect.minY))
                    path.addLine(to: CGPoint(x: x, y: plot.rect.maxY))
                }
                .stroke(
                    style.gridColor.opacity(0.75),
                    style: StrokeStyle(
                        lineWidth: BreakEvenChartLayout.gridLineWidth,
                        dash: BreakEvenChartLayout.gridDash
                    )
                )

                Text(viewModel.unitsText(value))
                    .font(.system(size: BreakEvenChartLayout.axisLabelSize, weight: .medium, design: .rounded))
                    .foregroundStyle(style.secondaryTextColor)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.70)
                    .frame(width: 76, alignment: .center)
                    .position(x: x, y: plot.rect.maxY + 23)
            }

            Path { path in
                path.move(to: CGPoint(x: plot.rect.minX, y: plot.rect.minY))
                path.addLine(to: CGPoint(x: plot.rect.minX, y: plot.rect.maxY))
                path.addLine(to: CGPoint(x: plot.rect.maxX, y: plot.rect.maxY))
            }
            .stroke(style.axisColor, lineWidth: BreakEvenChartLayout.axisLineWidth)
        }
    }

    private func breakEvenAreas(in rect: CGRect) -> some View {
        ZStack {
            if let marker = viewModel.breakEven {
                let markerPoint = BreakEvenChartPoint(
                    units: marker.units,
                    revenue: marker.value,
                    totalCost: marker.value
                )
                let lossPoints = viewModel.points.filter { $0.units < marker.units } + [markerPoint]
                let profitPoints = [markerPoint] + viewModel.points.filter { $0.units > marker.units }

                if lossPoints.count > 1 {
                    BreakEvenAreaShape(
                        upper: lossPoints.map { plotPoint(for: $0.units, value: $0.totalCost, in: rect) },
                        lower: lossPoints.map { plotPoint(for: $0.units, value: $0.revenue, in: rect) }
                    )
                    .fill(areaFill(color: style.lossColor))
                    .opacity(isAnimated ? 1 : 0)
                }

                if profitPoints.count > 1 {
                    BreakEvenAreaShape(
                        upper: profitPoints.map { plotPoint(for: $0.units, value: $0.revenue, in: rect) },
                        lower: profitPoints.map { plotPoint(for: $0.units, value: $0.totalCost, in: rect) }
                    )
                    .fill(areaFill(color: style.profitColor))
                    .opacity(isAnimated ? 1 : 0)
                }
            }
        }
    }

    private func areaFill(color: Color) -> LinearGradient {
        LinearGradient(
            colors: [
                color.opacity(BreakEvenChartLayout.areaOpacity),
                color.opacity(BreakEvenChartLayout.areaOpacity * 0.42),
                color.opacity(0.04)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func breakEvenGuides(in rect: CGRect, coordinate: CGPoint) -> some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: rect.minX, y: coordinate.y))
                path.addLine(to: CGPoint(x: coordinate.x, y: coordinate.y))
                path.move(to: CGPoint(x: coordinate.x, y: coordinate.y))
                path.addLine(to: CGPoint(x: coordinate.x, y: rect.maxY))
            }
            .stroke(
                style.breakEvenColor,
                style: StrokeStyle(
                    lineWidth: BreakEvenChartLayout.guideLineWidth,
                    lineCap: .round,
                    dash: BreakEvenChartLayout.guideDash
                )
            )
            .opacity(isAnimated ? 0.88 : 0)
        }
    }

    private func breakEvenMarker(at coordinate: CGPoint) -> some View {
        ZStack {
            Circle()
                .fill(style.breakEvenColor.opacity(0.16))
                .frame(width: BreakEvenChartLayout.markerHaloSize, height: BreakEvenChartLayout.markerHaloSize)

            Circle()
                .stroke(style.breakEvenColor.opacity(0.72), lineWidth: 2)
                .frame(width: BreakEvenChartLayout.markerHaloSize * 0.58, height: BreakEvenChartLayout.markerHaloSize * 0.58)

            Circle()
                .fill(style.titleColor)
                .frame(width: BreakEvenChartLayout.markerSize, height: BreakEvenChartLayout.markerSize)
                .overlay(
                    Circle()
                        .stroke(style.breakEvenColor, lineWidth: 3)
                )
        }
        .position(coordinate)
        .shadow(color: style.breakEvenColor.opacity(0.44), radius: BreakEvenChartLayout.markerShadowRadius)
        .scaleEffect(isAnimated ? 1 : 0.2)
        .opacity(isAnimated ? 1 : 0)
    }

    private func makePlottedPoints(in rect: CGRect) -> [BreakEvenPlottedPoint] {
        viewModel.points.map { point in
            BreakEvenPlottedPoint(
                data: point,
                revenuePoint: plotPoint(for: point.units, value: point.revenue, in: rect),
                costPoint: plotPoint(for: point.units, value: point.totalCost, in: rect)
            )
        }
    }

    private func makeMarkerCoordinate(in rect: CGRect) -> CGPoint? {
        guard let marker = viewModel.breakEven else { return nil }
        return plotPoint(for: marker.units, value: marker.value, in: rect)
    }

    private func plotPoint(for units: Double, value: Double, in rect: CGRect) -> CGPoint {
        let x = rect.minX + CGFloat(breakEvenClamp(units / viewModel.maxUnits, min: 0, max: 1)) * rect.width
        let y = rect.maxY - CGFloat(breakEvenClamp(value / viewModel.maxValue, min: 0, max: 1)) * rect.height
        return CGPoint(x: x, y: y)
    }

    private var yTicks: [Double] {
        let step = viewModel.maxValue / Double(BreakEvenChartLayout.gridStepCount)
        return (0...BreakEvenChartLayout.gridStepCount)
            .map { viewModel.maxValue - Double($0) * step }
    }

    private var xTicks: [Double] {
        let step = viewModel.maxUnits / Double(BreakEvenChartLayout.gridStepCount)
        return (0...BreakEvenChartLayout.gridStepCount)
            .map { Double($0) * step }
    }
}

private struct BreakEvenPlottedPoint {
    let data: BreakEvenChartPoint
    let revenuePoint: CGPoint
    let costPoint: CGPoint
}

private struct BreakEvenPlotLayout {
    let size: CGSize
    let rect: CGRect

    init(size: CGSize) {
        self.size = size
        self.rect = CGRect(
            x: BreakEvenChartLayout.plotLeftInset,
            y: BreakEvenChartLayout.plotTopInset,
            width: max(1, size.width - BreakEvenChartLayout.plotLeftInset - BreakEvenChartLayout.plotRightInset),
            height: max(1, size.height - BreakEvenChartLayout.plotTopInset - BreakEvenChartLayout.plotBottomInset)
        )
    }

    func xPosition(for units: Double, maxUnits: Double) -> CGFloat {
        rect.minX + CGFloat(breakEvenClamp(units / max(maxUnits, 1), min: 0, max: 1)) * rect.width
    }

    func yPosition(for value: Double, maxValue: Double) -> CGFloat {
        rect.maxY - CGFloat(breakEvenClamp(value / max(maxValue, 1), min: 0, max: 1)) * rect.height
    }
}

private struct BreakEvenLineShape: Shape {
    let points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = points.first else { return path }

        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }

        return path
    }
}

private struct BreakEvenAreaShape: Shape {
    let upper: [CGPoint]
    let lower: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = upper.first, upper.count == lower.count else { return path }

        path.move(to: first)
        for point in upper.dropFirst() {
            path.addLine(to: point)
        }

        for point in lower.reversed() {
            path.addLine(to: point)
        }

        path.closeSubpath()
        return path
    }
}
