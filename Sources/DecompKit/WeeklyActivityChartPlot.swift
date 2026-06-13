import SwiftUI

struct ActivityChartPlot: View {
    let viewModel: WeeklyActivityChartViewModel
    let isAnimated: Bool

    private var points: [ActivityChartPoint] {
        viewModel.points
    }

    private var style: WeeklyActivityChartStyle {
        viewModel.configuration.style
    }

    private var tickValues: [Double] {
        let step = viewModel.maxValue / Double(WeeklyActivityChartLayout.chartGridStepCount)
        return (0...WeeklyActivityChartLayout.chartGridStepCount).map { viewModel.maxValue - Double($0) * step }
    }

    var body: some View {
        GeometryReader { geometry in
            let plot = ChartPlotLayout(size: geometry.size, hasHighlight: viewModel.highlightedIndex != nil)
            let coordinates = makeCoordinates(in: plot.rect)
            let edgeCoordinates = makeEdgeCoordinates(from: coordinates, in: plot.rect)
            let extendedCoordinates = makeExtendedCoordinates(from: coordinates, edgeCoordinates: edgeCoordinates)
            let areaCoordinates = makeAreaCoordinates(from: extendedCoordinates, baseline: plot.rect.maxY)
            let canvasWidth = max(1, geometry.size.width)
            let gradientColors = points.map(\.tint)

            ZStack {
                grid(in: plot)
                verticalGuides(in: plot, coordinates: coordinates)

                if extendedCoordinates.count > 1 {
                    ChartAreaShape(points: areaCoordinates, baseline: plot.rect.maxY)
                        .fill(
                            edgeAwareHorizontalGradient(
                                colors: gradientColors,
                                opacity: WeeklyActivityChartLayout.areaPrimaryOpacity,
                                coordinates: coordinates,
                                edgeCoordinates: edgeCoordinates,
                                canvasWidth: canvasWidth
                            )
                        )
                        .mask(
                            areaDepthMask(
                                topOpacity: WeeklyActivityChartLayout.areaPrimaryTopMaskOpacity,
                                middleOpacity: WeeklyActivityChartLayout.areaPrimaryMiddleMaskOpacity,
                                bottomOpacity: WeeklyActivityChartLayout.areaPrimaryBottomMaskOpacity
                            )
                        )
                        .opacity(isAnimated ? 1 : 0)

                    ChartAreaShape(points: areaCoordinates, baseline: plot.rect.maxY)
                        .fill(
                            edgeAwareHorizontalGradient(
                                colors: gradientColors,
                                opacity: WeeklyActivityChartLayout.areaSecondaryOpacity,
                                coordinates: coordinates,
                                edgeCoordinates: edgeCoordinates,
                                canvasWidth: canvasWidth
                            )
                        )
                        .mask(
                            areaDepthMask(
                                topOpacity: WeeklyActivityChartLayout.areaSecondaryTopMaskOpacity,
                                middleOpacity: WeeklyActivityChartLayout.areaSecondaryMiddleMaskOpacity,
                                bottomOpacity: WeeklyActivityChartLayout.areaSecondaryBottomMaskOpacity
                            )
                        )
                        .opacity(isAnimated ? 1 : 0)

                    ChartLineShape(points: extendedCoordinates)
                        .trim(from: 0, to: isAnimated ? 1 : 0)
                        .stroke(
                            edgeAwareHorizontalGradient(
                                colors: gradientColors,
                                opacity: 1,
                                coordinates: coordinates,
                                edgeCoordinates: edgeCoordinates,
                                canvasWidth: canvasWidth
                            ),
                            style: StrokeStyle(
                                lineWidth: WeeklyActivityChartLayout.lineWidth,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                }

                pointGlows(coordinates: coordinates)
                highlightGuide(in: plot, coordinates: coordinates)
                markers(coordinates: coordinates)
                highlight(in: plot, coordinates: coordinates)
                bottomLabels(in: plot, coordinates: coordinates)
            }
        }
    }

    private func makeCoordinates(in rect: CGRect) -> [CGPoint] {
        guard points.isEmpty == false else { return [] }

        if points.count == 1 {
            let y = rect.maxY - CGFloat(clamp(points[0].value / viewModel.maxValue, min: 0, max: 1)) * rect.height
            return [CGPoint(x: rect.midX, y: y)]
        }

        let segmentCount = CGFloat(points.count - 1)
        let extensionFactor = WeeklyActivityChartLayout.edgeExtensionFactor
        let dataWidth = rect.width / (1 + extensionFactor * 2 / segmentCount)
        let edgeInset = dataWidth / segmentCount * extensionFactor

        return points.enumerated().map { index, point in
            let progress = CGFloat(index) / CGFloat(points.count - 1)
            let x = rect.minX + edgeInset + dataWidth * progress
            let y = rect.maxY - CGFloat(clamp(point.value / viewModel.maxValue, min: 0, max: 1)) * rect.height
            return CGPoint(x: x, y: y)
        }
    }

    private func makeEdgeCoordinates(
        from coordinates: [CGPoint],
        in rect: CGRect
    ) -> (left: [CGPoint]?, right: [CGPoint]?) {
        guard coordinates.count > 1,
              let first = coordinates.first,
              let second = coordinates.dropFirst().first,
              let previous = coordinates.dropLast().last,
              let last = coordinates.last else {
            return (nil, nil)
        }

        let extensionFactor = WeeklyActivityChartLayout.edgeExtensionFactor
        let leftVector = CGPoint(x: first.x - second.x, y: first.y - second.y)
        let rightVector = CGPoint(x: last.x - previous.x, y: last.y - previous.y)
        let leftPoint = CGPoint(
            x: max(rect.minX, first.x + leftVector.x * extensionFactor),
            y: clamp(first.y + leftVector.y * extensionFactor, min: rect.minY, max: rect.maxY)
        )
        let rightPoint = CGPoint(
            x: min(rect.maxX, last.x + rightVector.x * extensionFactor),
            y: clamp(last.y + rightVector.y * extensionFactor, min: rect.minY, max: rect.maxY)
        )

        return ([leftPoint, first], [last, rightPoint])
    }

    private func makeExtendedCoordinates(
        from coordinates: [CGPoint],
        edgeCoordinates: (left: [CGPoint]?, right: [CGPoint]?)
    ) -> [CGPoint] {
        var extended = coordinates

        if let leftPoint = edgeCoordinates.left?.first {
            extended.insert(leftPoint, at: 0)
        }

        if let rightPoint = edgeCoordinates.right?.last {
            extended.append(rightPoint)
        }

        return extended
    }

    private func makeAreaCoordinates(from coordinates: [CGPoint], baseline: CGFloat) -> [CGPoint] {
        coordinates.map { point in
            CGPoint(
                x: point.x,
                y: min(point.y + WeeklyActivityChartLayout.areaTopInset, baseline)
            )
        }
    }

    private func edgeAwareHorizontalGradient(
        colors: [Color],
        opacity: Double,
        coordinates: [CGPoint],
        edgeCoordinates: (left: [CGPoint]?, right: [CGPoint]?),
        canvasWidth: CGFloat
    ) -> LinearGradient {
        let fallback = style.titleColor

        guard colors.isEmpty == false else {
            return LinearGradient(
                colors: [fallback.opacity(0), fallback.opacity(opacity), fallback.opacity(0)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }

        guard colors.count > 1, coordinates.count == colors.count else {
            return LinearGradient(
                colors: [colors[0].opacity(0), colors[0].opacity(opacity), colors[0].opacity(0)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }

        var stops: [Gradient.Stop] = []

        if let leftFadeX = edgeCoordinates.left?.first?.x,
           let firstX = coordinates.first?.x {
            stops.append(
                Gradient.Stop(
                    color: colors[0].opacity(0),
                    location: gradientLocation(for: leftFadeX, canvasWidth: canvasWidth)
                )
            )
            stops.append(
                Gradient.Stop(
                    color: colors[0].opacity(opacity * WeeklyActivityChartLayout.edgeFadeFirstOpacityMultiplier),
                    location: gradientLocation(
                        for: leftFadeX + (firstX - leftFadeX) * WeeklyActivityChartLayout.edgeFadeFirstLocation,
                        canvasWidth: canvasWidth
                    )
                )
            )
            stops.append(
                Gradient.Stop(
                    color: colors[0].opacity(opacity * WeeklyActivityChartLayout.edgeFadeSecondOpacityMultiplier),
                    location: gradientLocation(
                        for: leftFadeX + (firstX - leftFadeX) * WeeklyActivityChartLayout.edgeFadeSecondLocation,
                        canvasWidth: canvasWidth
                    )
                )
            )
        }

        for (index, color) in colors.enumerated() {
            stops.append(
                Gradient.Stop(
                    color: color.opacity(opacity),
                    location: gradientLocation(for: coordinates[index].x, canvasWidth: canvasWidth)
                )
            )
        }

        if let rightFadeX = edgeCoordinates.right?.last?.x,
           let lastX = coordinates.last?.x {
            stops.append(
                Gradient.Stop(
                    color: colors[colors.count - 1].opacity(opacity * WeeklyActivityChartLayout.rightFadeFirstOpacityMultiplier),
                    location: gradientLocation(
                        for: lastX + (rightFadeX - lastX) * WeeklyActivityChartLayout.rightFadeFirstLocation,
                        canvasWidth: canvasWidth
                    )
                )
            )
            stops.append(
                Gradient.Stop(
                    color: colors[colors.count - 1].opacity(opacity * WeeklyActivityChartLayout.rightFadeSecondOpacityMultiplier),
                    location: gradientLocation(
                        for: lastX + (rightFadeX - lastX) * WeeklyActivityChartLayout.rightFadeSecondLocation,
                        canvasWidth: canvasWidth
                    )
                )
            )
            stops.append(
                Gradient.Stop(
                    color: colors[colors.count - 1].opacity(0),
                    location: gradientLocation(for: rightFadeX, canvasWidth: canvasWidth)
                )
            )
        }

        return LinearGradient(
            stops: stops,
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private func gradientLocation(for x: CGFloat, canvasWidth: CGFloat) -> Double {
        Double(clamp(x / canvasWidth, min: 0, max: 1))
    }

    private func areaDepthMask(
        topOpacity: Double,
        middleOpacity: Double,
        bottomOpacity: Double
    ) -> LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: .white.opacity(topOpacity), location: 0),
                Gradient.Stop(color: .white.opacity(topOpacity), location: WeeklyActivityChartLayout.areaMaskTopHoldLocation),
                Gradient.Stop(color: .white.opacity(middleOpacity), location: WeeklyActivityChartLayout.areaMaskMiddleLocation),
                Gradient.Stop(color: .white.opacity(bottomOpacity), location: WeeklyActivityChartLayout.areaMaskBottomLocation),
                Gradient.Stop(color: .clear, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func grid(in plot: ChartPlotLayout) -> some View {
        ZStack {
            ForEach(tickValues, id: \.self) { value in
                let y = plot.yPosition(for: value, maxValue: viewModel.maxValue)

                Path { path in
                    path.move(to: CGPoint(x: plot.rect.minX, y: y))
                    path.addLine(to: CGPoint(x: plot.rect.maxX, y: y))
                }
                .stroke(
                    style.gridColor,
                    style: StrokeStyle(
                        lineWidth: WeeklyActivityChartLayout.gridLineWidth,
                        dash: WeeklyActivityChartLayout.gridDash
                    )
                )
            }

            Path { path in
                path.move(to: CGPoint(x: plot.rect.minX, y: plot.rect.maxY))
                path.addLine(to: CGPoint(x: plot.rect.maxX, y: plot.rect.maxY))
            }
            .stroke(style.axisColor, lineWidth: WeeklyActivityChartLayout.axisLineWidth)
        }
    }

    private func verticalGuides(in plot: ChartPlotLayout, coordinates: [CGPoint]) -> some View {
        ZStack {
            ForEach(Array(coordinates.enumerated()), id: \.offset) { index, point in
                if index != viewModel.highlightedIndex {
                    Path { path in
                        path.move(to: CGPoint(x: point.x, y: point.y + WeeklyActivityChartLayout.verticalGuideTopGap))
                        path.addLine(to: CGPoint(x: point.x, y: plot.rect.maxY))
                    }
                    .stroke(
                        points[index].tint.opacity(WeeklyActivityChartLayout.verticalGuideOpacity),
                        style: StrokeStyle(
                            lineWidth: WeeklyActivityChartLayout.verticalGuideLineWidth,
                            dash: WeeklyActivityChartLayout.verticalGuideDash
                        )
                    )
                }
            }
        }
    }

    private func highlightGuide(in plot: ChartPlotLayout, coordinates: [CGPoint]) -> some View {
        ZStack {
            if let highlightedIndex = viewModel.highlightedIndex,
               coordinates.indices.contains(highlightedIndex) {
                let coordinate = coordinates[highlightedIndex]

                Path { path in
                    path.move(to: CGPoint(x: coordinate.x, y: plot.rect.maxY))
                    path.addLine(to: CGPoint(x: coordinate.x, y: coordinate.y))
                }
                .stroke(
                    Color.white.opacity(WeeklyActivityChartLayout.guideOpacity),
                    style: StrokeStyle(
                        lineWidth: WeeklyActivityChartLayout.guideLineWidth,
                        lineCap: .round,
                        dash: WeeklyActivityChartLayout.guideDash
                    )
                )
            }
        }
    }

    private func pointGlows(coordinates: [CGPoint]) -> some View {
        ZStack {
            ForEach(Array(coordinates.enumerated()), id: \.offset) { index, coordinate in
                let chartPoint = points[index]
                let isHighlighted = index == viewModel.highlightedIndex
                let glowSize = isHighlighted
                    ? WeeklyActivityChartLayout.highlightedPointGlowSize
                    : WeeklyActivityChartLayout.pointGlowSize

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                chartPoint.tint.opacity(
                                    isHighlighted
                                        ? WeeklyActivityChartLayout.highlightedPointGlowStartOpacity
                                        : WeeklyActivityChartLayout.pointGlowStartOpacity
                                ),
                                chartPoint.tint.opacity(
                                    isHighlighted
                                        ? WeeklyActivityChartLayout.highlightedPointGlowMiddleOpacity
                                        : WeeklyActivityChartLayout.pointGlowMiddleOpacity
                                ),
                                chartPoint.tint.opacity(0)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: glowSize / 2
                        )
                    )
                    .frame(width: glowSize, height: glowSize)
                    .blur(
                        radius: isHighlighted
                            ? WeeklyActivityChartLayout.highlightedPointGlowBlurRadius
                            : WeeklyActivityChartLayout.pointGlowBlurRadius
                    )
                    .opacity(isAnimated ? 1 : 0)
                    .position(coordinate)
            }
        }
    }

    private func markers(coordinates: [CGPoint]) -> some View {
        ZStack {
            ForEach(Array(coordinates.enumerated()), id: \.offset) { index, point in
                let chartPoint = points[index]
                let isHighlighted = index == viewModel.highlightedIndex
                let markerSize = isHighlighted
                    ? WeeklyActivityChartLayout.highlightedMarkerSize
                    : WeeklyActivityChartLayout.markerSize

                ZStack {
                    if isHighlighted {
                        Circle()
                            .stroke(
                                chartPoint.tint.opacity(WeeklyActivityChartLayout.highlightedInnerRingOpacity),
                                lineWidth: WeeklyActivityChartLayout.highlightedInnerRingWidth
                            )
                            .frame(
                                width: WeeklyActivityChartLayout.highlightedInnerRingSize,
                                height: WeeklyActivityChartLayout.highlightedInnerRingSize
                            )
                        Circle()
                            .stroke(
                                chartPoint.tint.opacity(WeeklyActivityChartLayout.highlightedOuterRingOpacity),
                                lineWidth: WeeklyActivityChartLayout.highlightedOuterRingWidth
                            )
                            .frame(
                                width: WeeklyActivityChartLayout.highlightedOuterRingSize,
                                height: WeeklyActivityChartLayout.highlightedOuterRingSize
                            )
                    }

                    Circle()
                        .fill(chartPoint.tint)
                        .frame(width: markerSize, height: markerSize)
                        .shadow(
                            color: chartPoint.tint.opacity(WeeklyActivityChartLayout.markerShadowOpacity),
                            radius: isHighlighted
                                ? WeeklyActivityChartLayout.highlightedMarkerShadowRadius
                                : WeeklyActivityChartLayout.markerShadowRadius
                        )

                    Circle()
                        .stroke(
                            Color.white,
                            lineWidth: isHighlighted
                                ? WeeklyActivityChartLayout.highlightedMarkerStrokeWidth
                                : WeeklyActivityChartLayout.markerStrokeWidth
                        )
                        .frame(width: markerSize, height: markerSize)
                }
                .scaleEffect(isAnimated ? 1 : WeeklyActivityChartLayout.markerInitialScale)
                .opacity(isAnimated ? 1 : 0)
                .position(point)

                if isHighlighted == false {
                    Text(formatPointValue(chartPoint.value))
                        .font(.system(size: WeeklyActivityChartLayout.pointValueFontSize, weight: .semibold, design: .rounded))
                        .foregroundStyle(style.titleColor.opacity(WeeklyActivityChartLayout.pointValueOpacity))
                        .position(x: point.x, y: point.y - WeeklyActivityChartLayout.pointValueYOffset)
                }
            }
        }
    }

    private func highlight(in plot: ChartPlotLayout, coordinates: [CGPoint]) -> some View {
        ZStack {
            if let highlightedIndex = viewModel.highlightedIndex,
               coordinates.indices.contains(highlightedIndex) {
                let coordinate = coordinates[highlightedIndex]
                let point = points[highlightedIndex]
                let badgeGap = viewModel.configuration.highlightBadgeSpacing
                let badgeHeight = WeeklyActivityChartLayout.badgeHeight
                let markerRadius = WeeklyActivityChartLayout.markerRadius
                let badgeY = max(
                    badgeHeight / 2,
                    coordinate.y - markerRadius - badgeGap - badgeHeight / 2
                )
                let badgeX = clamp(
                    coordinate.x,
                    min: plot.rect.minX + WeeklyActivityChartLayout.badgeEdgeInset,
                    max: plot.rect.maxX - WeeklyActivityChartLayout.badgeEdgeInset
                )

                Path { path in
                    path.move(
                        to: CGPoint(
                            x: coordinate.x,
                            y: badgeY + badgeHeight / 2 + WeeklyActivityChartLayout.badgeConnectorTopGap
                        )
                    )
                    path.addLine(
                        to: CGPoint(
                            x: coordinate.x,
                            y: coordinate.y - markerRadius - WeeklyActivityChartLayout.badgeConnectorBottomGap
                        )
                    )
                }
                .stroke(
                    Color.white.opacity(WeeklyActivityChartLayout.guideOpacity),
                    style: StrokeStyle(
                        lineWidth: WeeklyActivityChartLayout.guideLineWidth,
                        lineCap: .round,
                        dash: WeeklyActivityChartLayout.guideDash
                    )
                )

                HighlightBadge(point: point, style: style)
                    .position(x: badgeX, y: badgeY)
            }
        }
    }

    private func bottomLabels(in plot: ChartPlotLayout, coordinates: [CGPoint]) -> some View {
        ZStack {
            ForEach(Array(coordinates.enumerated()), id: \.offset) { index, coordinate in
                let labelWidth = min(
                    WeeklyActivityChartLayout.bottomLabelMaxWidth,
                    max(
                        WeeklyActivityChartLayout.bottomLabelMinWidth,
                        plot.rect.width / CGFloat(max(points.count, 1))
                    )
                )
                let labelSize = plot.rect.width < WeeklyActivityChartLayout.bottomLabelCompactWidthThreshold
                    ? WeeklyActivityChartLayout.bottomLabelCompactFontSize
                    : WeeklyActivityChartLayout.bottomLabelRegularFontSize

                VStack(spacing: WeeklyActivityChartLayout.bottomLabelSpacing) {
                    Text(points[index].label)
                        .font(.system(size: labelSize, weight: .medium, design: .rounded))
                        .foregroundStyle(style.titleColor.opacity(WeeklyActivityChartLayout.bottomLabelTextOpacity))
                        .lineLimit(1)
                        .minimumScaleFactor(WeeklyActivityChartLayout.bottomLabelMinimumScale)

                    Circle()
                        .fill(points[index].tint)
                        .frame(
                            width: WeeklyActivityChartLayout.bottomLabelSwatchSize,
                            height: WeeklyActivityChartLayout.bottomLabelSwatchSize
                        )
                        .shadow(
                            color: points[index].tint.opacity(WeeklyActivityChartLayout.bottomLabelSwatchShadowOpacity),
                            radius: WeeklyActivityChartLayout.bottomLabelSwatchShadowRadius
                        )
                }
                .frame(width: labelWidth)
                .position(x: coordinate.x, y: plot.rect.maxY + WeeklyActivityChartLayout.bottomLabelYOffset)
            }
        }
    }

    private func formatPointValue(_ value: Double) -> String {
        value.rounded() == value ? String(Int(value)) : String(format: "%.1f", value)
    }
}

private struct ChartPlotLayout {
    let size: CGSize
    let rect: CGRect

    init(size: CGSize, hasHighlight: Bool) {
        self.size = size

        let topInset: CGFloat
        if hasHighlight {
            topInset = size.height < WeeklyActivityChartLayout.compactHeightThreshold
                ? WeeklyActivityChartLayout.compactTopInset
                : WeeklyActivityChartLayout.regularTopInset
        } else {
            topInset = size.height < WeeklyActivityChartLayout.compactHeightThreshold
                ? WeeklyActivityChartLayout.compactTopInsetWithoutHighlight
                : WeeklyActivityChartLayout.regularTopInsetWithoutHighlight
        }
        let bottomInset = size.height < WeeklyActivityChartLayout.compactHeightThreshold
            ? WeeklyActivityChartLayout.compactBottomInset
            : WeeklyActivityChartLayout.regularBottomInset
        let horizontalInset = WeeklyActivityChartLayout.horizontalPlotInset

        rect = CGRect(
            x: horizontalInset,
            y: topInset,
            width: max(1, size.width - horizontalInset * 2),
            height: max(1, size.height - topInset - bottomInset)
        )
    }

    func yPosition(for value: Double, maxValue: Double) -> CGFloat {
        let progress = CGFloat(clamp(value / maxValue, min: 0, max: 1))
        return rect.maxY - progress * rect.height
    }
}

private struct ChartLineShape: Shape {
    var points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        smoothPath(points: points)
    }
}

private struct ChartAreaShape: Shape {
    var points: [CGPoint]
    var baseline: CGFloat

    func path(in rect: CGRect) -> Path {
        guard let first = points.first, let last = points.last else { return Path() }

        var path = smoothPath(points: points)
        path.addLine(to: CGPoint(x: last.x, y: baseline))
        path.addLine(to: CGPoint(x: first.x, y: baseline))
        path.closeSubpath()
        return path
    }
}

private func smoothPath(points: [CGPoint]) -> Path {
    var path = Path()

    guard let first = points.first else { return path }
    path.move(to: first)

    guard points.count > 1 else {
        path.addLine(to: first)
        return path
    }

    for index in 0..<(points.count - 1) {
        let p1 = points[index]
        let p2 = points[index + 1]
        let midX = (p1.x + p2.x) / 2
        let control1 = CGPoint(x: midX, y: p1.y)
        let control2 = CGPoint(x: midX, y: p2.y)

        path.addCurve(to: p2, control1: control1, control2: control2)
    }

    return path
}

private func clamp<T: Comparable>(_ value: T, min minimum: T, max maximum: T) -> T {
    Swift.min(Swift.max(value, minimum), maximum)
}
