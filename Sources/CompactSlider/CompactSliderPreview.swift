// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

#if DEBUG
import SwiftUI

struct CompactSliderGridPreview: View {
    @State private var point = CGPoint(x: 50, y: 50)
    @State private var polarPoint = CompactSliderPolarPoint.zero
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    
                    if #available(macOS 12.0, iOS 15, watchOS 8, *) {
                        Text("\(Int(point.x)) x \(Int(point.y))")
                            .monospacedDigit()
                    }
                    
                    Spacer()
                }
                
                Divider()
                
                gridSliders()
                Divider()
                circularGridSliders()
            }
            .padding()
        }
        .accentColor(.purple)
    }
    
    @ViewBuilder
    func gridSliders() -> some View {
        CompactSlider(
            point: $point,
            in: CGPoint(x: 0, y: 0) ... CGPoint(x: 100, y: 100),
            step: CGPoint(x: 10, y: 10)
        )
        .compactSliderStyle(default: .grid())
        .compactSliderBackground {
            GridBackgroundView(configuration: $0, padding: $1)
                .saturation($0.focusState.isFocused ? 1 : 0)
        }
        .frame(width: 150, height: 150)
        
        CompactSlider(
            point: $point,
            in: CGPoint(x: 0, y: 0) ... CGPoint(x: 100, y: 100),
            step: CGPoint(x: 10, y: 10)
        )
        .compactSliderStyle(
            default: .grid(cornerRadius: 16, padding: .all(4))
        )
        .compactSliderBackground {
            GridBackgroundView(
                configuration: $0,
                padding: $1,
                backgroundColor: .white.opacity(0.6),
                handleColor: .white,
                guidelineColor: .white,
                normalizedBacklightRadius: 0,
                gridFill: LinearGradient(
                    colors: [
                        Color(red: 0.1020, green: 0.1647, blue: 0.1804),
                        Color(red: 0.3294, green: 0.4471, blue: 0.4235),
                        Color(red: 0.8431, green: 0.3529, blue: 0.3725)
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                ),
                gridSize: 2.5
            )
        }
        .frame(width: 100, height: 100)
        .accentColor(.white)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }
    
    @ViewBuilder
    private func circularGridSliders() -> some View {
        CompactSlider(polarPoint: $polarPoint)
            .compactSliderBackground { configuration, padding in
                ZStack {
                    Circle()
                        .fill(
                            AngularGradient(
                                colors: [
                                    Color(hue: 0, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.1, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.2, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.3, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.4, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.5, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.6, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.7, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.8, saturation: 0.8, brightness: 1),
                                    Color(hue: 0.9, saturation: 0.8, brightness: 1),
                                    Color(hue: 1, saturation: 0.8, brightness: 1),
                                ],
                                center: .center
                            )
                        )
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.black, .black.opacity(0)],
                                center: .center,
                                startRadius: 40,
                                endRadius: 150
                            )
                        )
                    
                    Circle()
                        .stroke(Defaults.label.opacity(0.1), lineWidth: 1)
                }
            }
            .frame(width: 150, height: 150)
    }
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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    
                    if #available(macOS 12.0, iOS 15, watchOS 8.0, *) {
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
                
                #if !os(watchOS)
                Picker(selection: $layoutDirection) {
                    Text("Left-to-Right").tag(LayoutDirection.leftToRight)
                    Text("Right-to-Left").tag(LayoutDirection.rightToLeft)
                } label: { EmptyView() }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 20)
                #endif
                
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
        }
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
            scaleStyle: .init(
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
            scaleStyle: .init(
                line: .init(
                    length: nil,
                    skipEdges: false,
                    padding: .horizontal(4)
                ),
                secondaryLine: .init(
                    color: Defaults.secondaryScaleLineColor,
                    length: nil,
                    skipEdges: false,
                    padding: .horizontal(8)
                )
            ),
            cornerRadius: 0
        ))
        .verticalGradientMask()
        
        CompactSlider(value: $centerProgress, in: -20 ... 20, step: 1)
            .compactSliderStyle(default: .scrollable(
                .vertical,
                scaleStyle: .init(
                    line: .init(
                        length: nil,
                        padding: .horizontal(8)
                    ),
                    secondaryLine: .init(
                        color: Defaults.secondaryScaleLineColor,
                        length: nil,
                        padding: .horizontal(8)
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
                        padding: .horizontal(4)
                    ),
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
                scaleStyle: .init(
                    line: .init(length: nil, padding: .horizontal(4)),
                    secondaryLine: .init(
                        color: Defaults.secondaryScaleLineColor,
                        length: nil,
                        padding: .horizontal(8)
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
                scaleStyle: .init(
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

#Preview("Grid") {
    CompactSliderGridPreview()
            #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
#endif
