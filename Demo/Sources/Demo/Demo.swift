// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

#if os(macOS) || os(iOS) || targetEnvironment(macCatalyst)
import SwiftUI
import CompactSlider

struct CompactSliderDemo: View {
    enum `Type` {
        case horizontal
        case customHorizontal
        case capsuleHorizontal
        case vertical
        case capsuleVertical
    }
    
    @State private var layoutDirection: LayoutDirection = .leftToRight
    @State private var progress: Double = 0.3
    @State private var stepProgresses: [Double] = [0.3, 0.3, 0.3]
    @State private var degree: Double = 0
    @State private var value: Double = 5
    @State private var fromProgress: Double = 0.2
    @State private var toProgress: Double = 0.7
    @State private var progresses: [Double] = [0.3, 0.5, 0.9]
    
    let type: `Type`
    
    init(type: `Type`) {
        self.type = type
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Picker(selection: $layoutDirection) {
                Text("Left-to-Right").tag(LayoutDirection.leftToRight)
                Text("Right-to-Left").tag(LayoutDirection.rightToLeft)
            } label: { EmptyView() }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
            
            HStack {
                Spacer()
                
                Text("\(progress, format: .percent.precision(.fractionLength(0)))")
                Text("\(Int(value))")
                Text("\(fromProgress, format: .percent.precision(.fractionLength(0)))-\(toProgress, format: .percent.precision(.fractionLength(0)))")
                
                Spacer()
                Text("Multi:")
                ForEach(progresses, id: \.self) { p in
                    Text("\(Int(p * 100))%")
                }
                Spacer()
            }
            
            Divider()
            
            switch type {
            case .horizontal:
                Text("Base").foregroundStyle(.secondary)
                baseHorizontalSliders()
                Divider()
                Text("Range").foregroundStyle(.secondary)
                rangeHorizontalSliders()
                Divider()
                Text("Scrollable").foregroundStyle(.secondary)
                scrollableHorizontalSliders()
            case .capsuleHorizontal:
                capsuleHorizontalSliders()
            case .customHorizontal:
                customHorizontalSliders()
            case .vertical:
                HStack(spacing: 16) {
                    VStack(spacing: 16) {
                        Text("Base")
                        HStack(spacing: 16) {
                            baseVerticalSliders()
                                .frame(maxWidth: 30)
                        }
                    }
                    Divider()
                    VStack(spacing: 16) {
                        Text("Advanced")
                        HStack(spacing: 16) {
                            verticalSliders()
                                .frame(maxWidth: 30)
                        }
                    }
                }
            case .capsuleVertical:
                HStack(spacing: 8) {
                    capsuleVerticalSliders()
                }
            }
        }
        .padding()
        .monospacedDigit()
        .accentColor(.purple)
        .environment(\.layoutDirection, layoutDirection)
    }
    
    private func baseHorizontalSliders() -> some View {
        Group {
            CompactSlider(value: $progress).compactSliderStyle(default: .horizontal(.leading))
            CompactSlider(value: $progress).compactSliderStyle(default: .horizontal(.center))
            CompactSlider(value: $progress).compactSliderStyle(default: .horizontal(.trailing))
            
            Group {
                HStack {
                    Text("Step: 10%").frame(minWidth: 50)
                    CompactSlider(value: $stepProgresses[0], step: 0.1)
                        .compactSliderStyle(default: .horizontal(.leading))
                }
                HStack {
                    Text("Step: 5%").frame(minWidth: 50)
                    CompactSlider(value: $stepProgresses[1], step: 0.05)
                        .compactSliderStyle(default: .horizontal(.center))
                }
                HStack {
                    Text("Step: 1%").frame(minWidth: 50)
                    CompactSlider(value: $stepProgresses[2], step: 0.01)
                        .compactSliderStyle(default: .horizontal(.trailing))
                }
            }
            .font(.footnote).foregroundStyle(.secondary)
        }
        .frame(maxHeight: 30)
    }
    
    private func rangeHorizontalSliders() -> some View {
        Group {
            CompactSlider(from: $fromProgress, to: $toProgress)
                .compactSliderStyle(default: .horizontal(.leading))
            CompactSlider(from: $fromProgress, to: $toProgress)
                .compactSliderStyle(default: .horizontal(.center))
            CompactSlider(from: $fromProgress, to: $toProgress)
                .compactSliderStyle(default: .horizontal(.trailing))
        }
        .frame(maxHeight: 20)
    }
    
    @ViewBuilder
    private func scrollableHorizontalSliders() -> some View {
        CompactSlider(value: $progress, step: 0.02)
            .compactSliderStyle(default: .scrollable())
            .compactSliderOptionsByAdding(.withoutBackground, .loopValues)
            .horizontalGradientMask()
            .frame(maxHeight: 20)
    }
    
    @ViewBuilder
    private func capsuleHorizontalSliders() -> some View {
        Group {
            horizontalSlidersSet()
                .compactSliderHandleStyle(.circle(visibility: .always, radius: 10))
            Divider()
            CompactSlider(value: $progress)
                .compactSliderStyle(default: .scrollable())
                .compactSliderHandleStyle(.circle(visibility: .always, radius: 10))
                .compactSliderOptionsByAdding(.withoutBackground)
            Divider()
            horizontalSlidersSet()
                .compactSliderHandleStyle(.circle(visibility: .always, progressAlignment: .inside, radius: 10))
            Divider()
            horizontalSlidersSet()
                .compactSliderHandleStyle(.circle(visibility: .always, progressAlignment: .outside, radius: 10))
        }
        .compactSliderProgress { _ in
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .blue.opacity(0.5), location: 0),
                            .init(color: .purple.opacity(0.5), location: 1),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .compactSliderBackground { configuration, padding in
            Capsule()
                .fill(Defaults.backgroundColor)
        }
        .accentColor(.yellow.opacity(0.5))
        
        Divider()
        
        Group {
            horizontalSlidersSet()
                .compactSliderHandleStyle(.rectangle(visibility: .always, progressAlignment: .center, width: 20))
            Divider()
            horizontalSlidersSet()
                .compactSliderHandleStyle(.rectangle(visibility: .always, progressAlignment: .inside, width: 20))
            Divider()
            horizontalSlidersSet()
                .compactSliderHandleStyle(.rectangle(visibility: .always, progressAlignment: .outside, width: 20))
        }
        .compactSliderProgress { _ in
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .blue.opacity(0.5), location: 0),
                            .init(color: .purple.opacity(0.5), location: 1),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .accentColor(.yellow.opacity(0.5))
    }
    
    @ViewBuilder
    private func horizontalSlidersSet() -> some View {
        CompactSlider(value: $progress).compactSliderStyle(default: .horizontal(.leading))
        CompactSlider(value: $progress).compactSliderStyle(default: .horizontal(.center))
        CompactSlider(value: $progress).compactSliderStyle(default: .horizontal(.trailing))
        CompactSlider(from: $fromProgress, to: $toProgress)
    }
    
    @ViewBuilder
    private func customHorizontalSliders() -> some View {
        Group {
            CompactSlider(from: $fromProgress, to: $toProgress)
                .compactSliderStyle(default: .horizontal(clipShapeStyle: .none))
                .compactSliderHandleStyle(.rectangle(visibility: .always, progressAlignment: .inside, width: 20))
                .compactSliderProgress { _ in
                    Capsule()
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: .blue.opacity(0.5), location: 0),
                                    .init(color: .purple.opacity(0.5), location: 1),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .compactSliderHandle { _, _, _, index in
                    Circle()
                        .fill(index == 1 ? Color.purple : .blue)
                }
                .compactSliderBackground { _, _ in
                    Capsule()
                        .fill(Defaults.backgroundColor)
                        .frame(maxHeight: 8)
                }
            
            Group {
                CompactSlider(values: $progresses)
                CompactSlider(values: $progresses, step: 0.05)
                    .compactSliderScale(
                        visibility: .always,
                        .linear(count: 21, lineLength: 8, skipFirst: 1, skipLast: 1)
                    )
            }
            .compactSliderHandle { configuration, style, progress, _ in
                HandleView(
                    configuration: configuration,
                    style: .rectangle(
                        visibility: .always,
                        color: Color(hue: progress, saturation: 0.8, brightness: 0.8),
                        width: style.width
                    )
                )
                .shadow(color: Color(hue: progress, saturation: 0.8, brightness: 1), radius: 5)
            }
            .compactSliderBackground { config, _ in
                RoundedRectangle(cornerRadius: Defaults.cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hue: 0, saturation: 0.8, brightness: 0.8),
                                Color(hue: 0.2, saturation: 0.8, brightness: 0.8),
                                Color(hue: 0.4, saturation: 0.8, brightness: 0.8),
                                Color(hue: 0.6, saturation: 0.8, brightness: 0.8),
                                Color(hue: 0.8, saturation: 0.8, brightness: 0.8),
                                Color(hue: 1, saturation: 0.8, brightness: 0.8),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(config.colorScheme == .dark ? 0.1 : 0.2)
            }
        }
        .frame(height: 20)
        
        VStack {
            Text("\(Int(degree))º")
                .offset(x: 2)
            CompactSlider(value: $degree, in: 0 ... 360, step: 5)
                .compactSliderOptionsByAdding(.withoutBackground, .loopValues)
                .compactSliderHandleStyle(.rectangle(color: Color.white, width: 1))
                .compactSliderStyle(default: .scrollable())
                .compactSliderScale(
                    visibility: .always,
                    alignment: .bottom,
                    .linear(count: 19, lineLength: 20),
                    .linear(count: 73, color: Defaults.secondaryScaleLineColor, lineLength: 10, skip: .each(4)),
                    .labels(
                        visibility: .hideNearCurrentValue(threshold: 0.03),
                        alignment: .top,
                        offset: CGPoint(x: 2, y: 0),
                        labels: [0: "0º", 0.5: "180º"]
                    )
                )
                .frame(height: 40)
                .padding(.horizontal, -50)
                .clipShape(Rectangle())
                .horizontalGradientMask()
        }
        .padding(.bottom)
        
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .horizontal(clipShapeStyle: .none))
            .compactSliderHandleStyle(.symbol("heart.fill", visibility: .always, width: 20))
            .compactSliderProgress { configuration in
                Capsule()
                    .fill(Color.pink.opacity(0.5))
                    .frame(height: 6)
            }
            .compactSliderBackground { configuration, padding in
                Capsule()
                    .fill(Defaults.backgroundColor)
                    .frame(height: 6)
            }
            .frame(height: 30)
            .font(.system(size: 30))
            .accentColor(.pink)
    }
    
    @ViewBuilder
    private func baseVerticalSliders() -> some View {
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .vertical())
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .vertical(.center))
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .vertical(.top))
        
        Divider()
        
        CompactSlider(from: $fromProgress, to: $toProgress)
            .compactSliderStyle(default: .vertical(.top))
        CompactSlider(from: $fromProgress, to: $toProgress)
            .compactSliderStyle(default: .vertical(.center))
        CompactSlider(from: $fromProgress, to: $toProgress)
            .compactSliderStyle(default: .vertical(.bottom))
    }
    
    @ViewBuilder
    private func capsuleVerticalSliders() -> some View {
        Group {
            verticalSlidersSet()
                .compactSliderHandleStyle(.circle(visibility: .always, radius: 10))
            Divider()
            CompactSlider(value: $progress)
                .compactSliderStyle(default: .scrollable(.vertical))
                .compactSliderHandleStyle(.circle(visibility: .always, radius: 10))
                .compactSliderOptionsByAdding(.withoutBackground)
            Divider()
            verticalSlidersSet()
                .compactSliderHandleStyle(.circle(visibility: .always, progressAlignment: .inside, radius: 10))
            Divider()
            verticalSlidersSet()
                .compactSliderHandleStyle(.circle(visibility: .always, progressAlignment: .outside, radius: 10))
        }
        .compactSliderProgress { _ in
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .blue.opacity(0.5), location: 0),
                            .init(color: .purple.opacity(0.5), location: 1),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .compactSliderBackground { _, _ in
            Capsule().fill(Defaults.backgroundColor)
        }
        .accentColor(.yellow.opacity(0.5))
        
        Divider()
        
        Group {
            verticalSlidersSet()
                .compactSliderHandleStyle(.rectangle(visibility: .always, progressAlignment: .center, width: 20))
            Divider()
            verticalSlidersSet()
                .compactSliderHandleStyle(.rectangle(visibility: .always, progressAlignment: .inside, width: 20))
            Divider()
            verticalSlidersSet()
                .compactSliderHandleStyle(.rectangle(visibility: .always, progressAlignment: .outside, width: 20))
        }
        .compactSliderProgress { _ in
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .blue.opacity(0.5), location: 0),
                            .init(color: .purple.opacity(0.5), location: 1),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
        .accentColor(.yellow.opacity(0.5))
    }
    
    @ViewBuilder
    private func verticalSlidersSet() -> some View {
        CompactSlider(value: $progress).compactSliderStyle(default: .vertical(.top))
        CompactSlider(value: $progress).compactSliderStyle(default: .vertical(.center))
        CompactSlider(value: $progress).compactSliderStyle(default: .vertical(.bottom))
        CompactSlider(from: $fromProgress, to: $toProgress).compactSliderStyle(default: .vertical())
    }
    
    @ViewBuilder
    private func verticalSliders() -> some View {
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .scrollable(.vertical, clipShapeStyle: .rectangle))
            .compactSliderOptionsByAdding(.loopValues)
            .verticalGradientMask()
        
        CompactSlider(value: $value, in: -20 ... 20, step: 1)
            .compactSliderStyle(default: .scrollable(.vertical))
            .verticalGradientMask()
        
        CompactSlider(from: $fromProgress, to: $toProgress)
            .compactSliderStyle(default: .vertical(clipShapeStyle: .none))
            .compactSliderHandleStyle(.rectangle(visibility: .always, progressAlignment: .inside, width: 30))
            .compactSliderProgress { _ in
                Capsule()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .blue.opacity(0.5), location: 0),
                                .init(color: .purple.opacity(0.5), location: 1),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .compactSliderHandle { _, _, _, index in
                Circle()
                    .fill(index == 1 ? Color.purple : .blue)
            }
            .compactSliderBackground { _, _ in
                Capsule()
                    .fill(Defaults.backgroundColor)
                    .frame(maxWidth: 10)
            }
        
        Group {
            CompactSlider(values: $progresses)
            CompactSlider(values: $progresses, step: 0.05)
                .compactSliderScale(
                    visibility: .always,
                    .linear(axis: .vertical, count: 21, lineLength: 8, skipFirst: 1, skipLast: 1)
                )
        }
        .compactSliderStyle(default: .vertical())
        .compactSliderHandle { configuration, style, progress, _ in
            HandleView(
                configuration: configuration,
                style: .rectangle(
                    visibility: .always,
                    color: Color(hue: progress, saturation: 0.8, brightness: 0.8),
                    width: style.width
                )
            )
            .shadow(color: Color(hue: progress, saturation: 0.8, brightness: 1), radius: 5)
        }
        .compactSliderBackground { config, _ in
            RoundedRectangle(cornerRadius: Defaults.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hue: 0, saturation: 0.8, brightness: 0.8),
                            Color(hue: 0.2, saturation: 0.8, brightness: 0.8),
                            Color(hue: 0.4, saturation: 0.8, brightness: 0.8),
                            Color(hue: 0.6, saturation: 0.8, brightness: 0.8),
                            Color(hue: 0.8, saturation: 0.8, brightness: 0.8),
                            Color(hue: 1, saturation: 0.8, brightness: 0.8),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(config.colorScheme == .dark ? 0.2 : 0.2)
        }
    }
}

#Preview("Horizontal") {
    CompactSliderDemo(type: .horizontal)
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
#Preview("Capsule Horizontal") {
    CompactSliderDemo(type: .capsuleHorizontal)
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
#Preview("Custom Horizontal") {
    CompactSliderDemo(type: .customHorizontal)
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
#Preview("Vertical") {
    CompactSliderDemo(type: .vertical)
        #if os(macOS)
        .frame(width: 600, height: 500, alignment: .top)
        #endif
}
#Preview("Capsule Vertical") {
    CompactSliderDemo(type: .capsuleVertical)
        #if os(macOS)
        .frame(width: 800, height: 500, alignment: .top)
        #endif
}
#endif
