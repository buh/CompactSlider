// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct CompactSliderPreview: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var layoutDirection: LayoutDirection = .leftToRight
    @State private var progress: Double = 0.3
    @State private var degree: Double = 90
    @State private var centerProgress: Double = 5
    @State private var fromProgress: Double = 0.3
    @State private var toProgress: Double = 0.7
    @State private var progresses: [Double] = [0.2, 0.5, 0.8]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                Text("\(progress, format: .percent.precision(.fractionLength(0)))")
                Text("\(Int(centerProgress))")
                Text("\(fromProgress, format: .percent.precision(.fractionLength(0)))-\(toProgress, format: .percent.precision(.fractionLength(0)))")
                
                Spacer()
                Text("Multi:")
                ForEach(progresses, id: \.self) { p in
                    Text("\(Int(p * 100))%")
                }
                Spacer()
            }
            .monospacedDigit()
            
            Picker(selection: $layoutDirection) {
                Text("Left-to-Right").tag(LayoutDirection.leftToRight)
                Text("Right-to-Left").tag(LayoutDirection.rightToLeft)
            } label: { EmptyView() }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
            
            Divider()
            
            Group {
                horizontalSliders()
            }
            .frame(maxHeight: 30)
            
            Divider()
            // MARK: - Vertical
            
            HStack(spacing: 16) {
                Group {
                    verticalSliders()
                }
                .frame(maxWidth: 30, minHeight: 100)
            }
        }
        .padding()
        .accentColor(.purple)
        .environment(\.layoutDirection, layoutDirection)
    }
    
    @ViewBuilder
    private func horizontalSliders() -> some View {
        CompactSlider(
            value: $degree,
            in: 0 ... 360,
            step: 5,
            options: [.dragGestureMinimumDistance(0), .scrollWheel, .withoutBackground, .loopValues]
        )
        .compactSliderStyle(default: .scrollable(
            handleStyle: .rectangle(),
            scaleStyle: .atSide(
                alignment: .bottom,
                line: .init(length: 16, skipEdges: false),
                secondaryLine: .init(color: Defaults.secondaryScaleLineColor, length: 8, skipEdges: false)
            ),
            cornerRadius: 0
        ))
        .horizontalGradientMask()
        .overlay(
            Text("\(Int(degree))º")
                .offset(x: 2, y: -24)
        )
        .padding(.top, 12)
        .frame(height: 40)
        
        CompactSlider(value: $progress)
        
        CompactSlider(value: $centerProgress, in: -19 ... 19, step: 1, options: [.dragGestureMinimumDistance(0), .snapToSteps, .scrollWheel])
            .compactSliderStyle(default: .horizontal(.center))
        
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .horizontal(.trailing))
        
        CompactSlider(from: $fromProgress, to: $toProgress)
        
        CompactSlider(from: $fromProgress, to: $toProgress)
            .compactSliderStyle(default: .horizontal(
                handleStyle: HandleStyle.rectangle(visibility: .always, width: 30),
                scaleStyle: nil,
                cornerRadius: 0
            ))
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
                    .frame(maxHeight: 10)
            }
        
        CompactSlider(values: $progresses)
            .compactSliderHandle { _, style, progress, _ in
                HandleView(
                    style: .rectangle(
                        visibility: .always,
                        color: Color(hue: progress, saturation: 0.8, brightness: 0.8),
                        width: style.width
                    )
                )
                .shadow(color: Color(hue: progress, saturation: 0.8, brightness: 1), radius: 5)
            }
            .compactSliderBackground { _, _ in
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
                    .opacity(colorScheme == .dark ? 0.1 : 0.2)
            }
    }
    
    @ViewBuilder
    private func verticalSliders() -> some View {
        CompactSlider(
            value: $progress,
            options: [.dragGestureMinimumDistance(0), .scrollWheel, .loopValues]
        )
        .compactSliderStyle(default: .scrollable(
            .vertical,
            scaleStyle: .centered(),
            cornerRadius: 0
        ))
        .verticalGradientMask()
        
        CompactSlider(value: $centerProgress, in: -20 ... 20, step: 1)
            .compactSliderStyle(default: .scrollable(
                .vertical,
                scaleStyle: .centered(
                    line: .init(
                        length: nil,
                        padding: .horizontal(8)
                    )
                )
            ))
            .verticalGradientMask()
        
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .vertical(
                .bottom,
                scaleStyle: .centered(
                    secondaryLine: .init(
                        color: Defaults.secondaryScaleLineColor,
                        length: nil,
                        padding: .horizontal(4)
                    )
                )
            ))
        
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .vertical(.center))
        
        CompactSlider(value: $centerProgress, in: -20 ... 20, step: 1)
            .compactSliderStyle(default: .vertical(
                .center,
                scaleStyle: .centered()
            ))
        
        CompactSlider(value: $progress)
            .compactSliderStyle(default: .vertical(.top))
            .compactSliderScale { _, _ in
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(maxWidth: 3)
            }
        
        CompactSlider(from: $fromProgress, to: $toProgress)
            .compactSliderStyle(default: .vertical())
        
        CompactSlider(from: $fromProgress, to: $toProgress)
            .compactSliderStyle(default: .vertical(
                handleStyle: HandleStyle.rectangle(visibility: .always, width: 30),
                scaleStyle: nil,
                cornerRadius: 0
            ))
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
        
        CompactSlider(values: $progresses)
            .compactSliderStyle(default: .vertical(
                scaleStyle: .centered(
                    line: .init(
                        color: Defaults.label.opacity(0.2),
                        length: nil,
                        padding: .horizontal(4)
                    ),
                    secondaryLine: nil
                )
            ))
            .compactSliderHandle { _, style, progress, _ in
                HandleView(
                    style: .rectangle(
                        visibility: .always,
                        color: Color(hue: progress, saturation: 0.8, brightness: 0.8),
                        width: style.width
                    )
                )
                .shadow(color: Color(hue: progress, saturation: 0.8, brightness: 1), radius: 5)
            }
            .compactSliderBackground { _, _ in
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
                    .opacity(colorScheme == .dark ? 0.1 : 0.2)
            }
    }
}

#Preview("Slider") {
    CompactSliderPreview()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
