// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

#if DEBUG
#Preview {
    CompactSliderPreview()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}

struct CompactSliderPreview: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var layoutDirection: LayoutDirection = .leftToRight
    @State private var progress: Double = 0.3
    @State private var degree: Double = 90
    @State private var centerProgress: Double = 5
    @State private var fromProgress: Double = 0.3
    @State private var toProgress: Double = 0.7
    @State private var progresses: [Double] = [0.2, 0.5, 0.8]
    @State private var point = CGPoint(x: 50, y: 50)
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                if #available(macOS 12.0, iOS 15, *) {
                    Group {
                        Text("\(progress, format: .percent.precision(.fractionLength(0)))")
                        Text("\(Int(centerProgress))")
                        Text("\(fromProgress, format: .percent.precision(.fractionLength(0)))-\(toProgress, format: .percent.precision(.fractionLength(0)))")
                    }
                    .monospacedDigit()
                }
                
                Spacer()
                Text("Multi:")
                ForEach(progresses, id: \.self) { p in
                    Text("\(Int(p * 100))%")
                }
                Spacer()
            }
            
            Picker(selection: $layoutDirection) {
                Text("Left-to-Right").tag(LayoutDirection.leftToRight)
                Text("Right-to-Left").tag(LayoutDirection.rightToLeft)
            } label: { EmptyView() }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
            
            ZStack {
                Group {
                    CompactSlider(
                        point: $point,
                        in: CGPoint(x: 0, y: 0) ... CGPoint(x: 100, y: 100),
                        step: CGPoint(x: 5, y: 5)
                    )
                    .compactSliderStyle(default: .grid(
                        cornerRadius: 16,
                        handleStyle: .init(width: 6)
                    ))
                }
                .frame(width: 100, height: 100)
                
                if #available(macOS 12.0, iOS 15, *) {
                    Text("\(Int(point.x)) x \(Int(point.y))")
                        .offset(x: 100)
                        .monospacedDigit()
                }
            }
            
            Group {
                CompactSlider(
                    value: $degree,
                    in: 0 ... 360,
                    step: 5,
                    options: [.dragGestureMinimumDistance(0), .scrollWheel, .withoutBackground, .loopValues]
                )
                .compactSliderStyle(default: .scrollable(
                    cornerRadius: 0,
                    handleStyle: .init(width: 1, cornerRadius: 0),
                    scaleStyle: .init(
                        alignment: .bottom,
                        line: .init(length: 16, skipEdges: false),
                        secondaryLine: .init(color: Defaults.secondaryScaleLineColor, length: 8, skipEdges: false)
                    )
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
                        cornerRadius: 0,
                        handleStyle: .init(visibility: .always, width: 30),
                        scaleStyle: nil
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
                    .compactSliderBackground { _ in
                        Capsule()
                            .fill(Defaults.backgroundColor)
                            .frame(maxHeight: 10)
                    }
                
                CompactSlider(values: $progresses)
                    .compactSliderHandle { _, style, progress, _ in
                        HandleView(
                            style: .init(
                                visibility: .always,
                                color: Color(hue: progress, saturation: 0.8, brightness: 0.8),
                                width: style.width,
                                cornerRadius: 0
                            )
                        )
                        .shadow(color: Color(hue: progress, saturation: 0.8, brightness: 1), radius: 5)
                    }
                    .compactSliderBackground { _ in
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
            .frame(maxHeight: 30)
            
            // MARK: - Vertical
            
            HStack(spacing: 16) {
                Group {
                    CompactSlider(
                        value: $progress,
                        options: [.dragGestureMinimumDistance(0), .scrollWheel, .loopValues]
                    )
                    .compactSliderStyle(default: .scrollable(
                        .vertical,
                        cornerRadius: 0,
                        handleStyle: .init(width: 2),
                        scaleStyle: .init(
                            line: .init(
                                length: nil,
                                skipEdges: false,
                                padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                            ),
                            secondaryLine: .init(
                                color: Defaults.secondaryScaleLineColor,
                                length: nil,
                                skipEdges: false,
                                padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                            )
                        )
                    ))
                    .verticalGradientMask()
                    
                    CompactSlider(value: $centerProgress, in: -20 ... 20, step: 1)
                        .compactSliderStyle(default: .scrollable(
                            .vertical,
                            handleStyle: .init(width: 2),
                            scaleStyle: .init(
                                line: .init(
                                    length: nil,
                                    padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                                ),
                                secondaryLine: .init(
                                    color: Defaults.secondaryScaleLineColor,
                                    length: nil,
                                    padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                                )
                            )
                        ))
                        .verticalGradientMask()
                    
                    CompactSlider(value: $progress)
                        .compactSliderStyle(default: .vertical(
                            .bottom,
                            scaleStyle: .init(
                                line: .init(
                                    length: nil,
                                    padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                                ),
                                secondaryLine: .init(
                                    color: Defaults.secondaryScaleLineColor,
                                    length: nil,
                                    padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                                )
                            )
                        ))
                    
                    CompactSlider(value: $progress)
                        .compactSliderStyle(default: .vertical(.center))

                    CompactSlider(value: $centerProgress, in: -20 ... 20, step: 1)
                        .compactSliderStyle(default: .vertical(
                            .center,
                            scaleStyle: .init(
                                line: .init(length: nil, padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)),
                                secondaryLine: .init(
                                    color: Defaults.secondaryScaleLineColor,
                                    length: nil,
                                    padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                                )
                            )
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
                            cornerRadius: 0,
                            handleStyle: .init(visibility: .always, width: 30),
                            scaleStyle: nil
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
                        .compactSliderBackground { _ in
                            Capsule()
                                .fill(Defaults.backgroundColor)
                                .frame(maxWidth: 10)
                        }
                    
                    CompactSlider(values: $progresses)
                        .compactSliderStyle(default: .vertical(
                            scaleStyle: .init(
                                line: .init(
                                    color: Defaults.label.opacity(0.2),
                                    length: nil,
                                    padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                                ),
                                secondaryLine: nil
                            )
                        ))
                        .compactSliderHandle { _, style, progress, _ in
                            HandleView(
                                style: .init(
                                    visibility: .always,
                                    color: Color(hue: progress, saturation: 0.8, brightness: 0.8),
                                    width: style.width,
                                    cornerRadius: 0
                                )
                            )
                            .shadow(color: Color(hue: progress, saturation: 0.8, brightness: 1), radius: 5)
                        }
                        .compactSliderBackground { _ in
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
                .frame(maxWidth: 30)
            }
        }
        .padding()
        .accentColor(.purple)
        .environment(\.layoutDirection, layoutDirection)
    }
}
#endif
