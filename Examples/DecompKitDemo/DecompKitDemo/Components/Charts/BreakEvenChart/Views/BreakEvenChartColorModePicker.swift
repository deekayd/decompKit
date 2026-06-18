import SwiftUI

struct BreakEvenChartColorModePicker: View {
    @Binding var selection: BreakEvenChartDemoColorMode

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Chart colors")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(BreakEvenChartDemoColorMode.allCases) { colorMode in
                    Button {
                        withAnimation(.snappy(duration: 0.18)) {
                            selection = colorMode
                        }
                    } label: {
                        BreakEvenChartColorModeCard(
                            colorMode: colorMode,
                            isSelected: selection == colorMode
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct BreakEvenChartColorModeCard: View {
    let colorMode: BreakEvenChartDemoColorMode
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                swatch

                Spacer(minLength: 4)

                Image(systemName: isSelected ? "checkmark.circle.fill" : colorMode.symbolName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
                    .frame(width: 20, height: 20)
            }

            Text(colorMode.title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
        .background(cardBackground)
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    @ViewBuilder
    private var swatch: some View {
        switch colorMode {
        case .original:
            BreakEvenDotSwatch(colors: colorMode.swatchColors)
        case .monoFocus:
            BreakEvenFocusSwatch(colors: colorMode.swatchColors)
        case .twoTone:
            BreakEvenSplitSwatch(colors: colorMode.swatchColors)
        case .gradient:
            BreakEvenGradientSwatch(colors: colorMode.swatchColors)
        case .status:
            BreakEvenStatusSwatch(colors: colorMode.swatchColors)
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(isSelected ? Color.accentColor.opacity(0.14) : Color(.tertiarySystemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isSelected ? Color.accentColor.opacity(0.78) : Color.primary.opacity(0.07),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
    }
}

private struct BreakEvenDotSwatch: View {
    let colors: [Color]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 24)
        .background(
            Capsule()
                .fill(Color.primary.opacity(0.06))
        )
    }
}

private struct BreakEvenFocusSwatch: View {
    let colors: [Color]

    var body: some View {
        HStack(spacing: 6) {
            Capsule()
                .fill(colors.first ?? .secondary)
                .frame(width: 30, height: 6)

            Circle()
                .fill(colors.last ?? .accentColor)
                .frame(width: 13, height: 13)
        }
        .frame(height: 24)
    }
}

private struct BreakEvenSplitSwatch: View {
    let colors: [Color]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                color
            }
        }
        .frame(width: 46, height: 20)
        .clipShape(Capsule())
    }
}

private struct BreakEvenGradientSwatch: View {
    let colors: [Color]

    var body: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: colors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 50, height: 20)
    }
}

private struct BreakEvenStatusSwatch: View {
    let colors: [Color]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(color)
                    .frame(width: 12, height: 18)
            }
        }
        .frame(height: 24)
    }
}

#Preview {
    @Previewable @State var selection = BreakEvenChartDemoColorMode.original

    BreakEvenChartColorModePicker(selection: $selection)
        .padding()
}
