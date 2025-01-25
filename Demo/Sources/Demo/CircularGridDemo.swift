// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

#if os(macOS) || os(iOS) || targetEnvironment(macCatalyst)
import SwiftUI
import CompactSlider

struct CompactSliderCircularGridDemo: View {
    @State private var layoutDirection: LayoutDirection = .leftToRight
    @State private var point: CompactSliderPolarPoint = .zero
    @State private var brightness = 0.5
    
    var body: some View {
        VStack(spacing: 16) {
            Picker(selection: $layoutDirection) {
                Text("Left-to-Right").tag(LayoutDirection.leftToRight)
                Text("Right-to-Left").tag(LayoutDirection.rightToLeft)
            } label: { EmptyView() }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
            
            HStack(spacing: 16) {
                Spacer()
                
                Text("\(Int(point.angle.degrees))º x \(point.normalizedRadius, format: .percent.precision(.fractionLength(0)))")
                
                Spacer()
            }
            .monospacedDigit()
            
            Divider()
            
            circularGridSliders()
        }
        .padding()
        .accentColor(.purple)
        .environment(\.layoutDirection, layoutDirection)
    }
    
    @ViewBuilder
    func circularGridSliders() -> some View {
        HStack {
            CompactSlider(
                polarPoint: $point,
                step: .init(angle: .degrees(5), normalizedRadius: 0.05)
            )
            .frame(width: 200, height: 200)
            
            CompactSlider(
                polarPoint: $point,
                step: .init(angle: .degrees(5), normalizedRadius: 0.05)
            )
            .frame(width: 100, height: 100)
        }
        
        Divider()
        
        Text("Color Picker")
        
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(
                    hue: point.angle.degrees / 360,
                    saturation: point.normalizedRadius,
                    brightness: brightness
                ))
                .aspectRatio(.init(width: 1, height: 1), contentMode: .fit)
            
            CompactSlider(
                polarPoint: $point,
                step: .init(angle: .degrees(5), normalizedRadius: 0.05)
            )
            .compactSliderHandle(handleView: { _, handleStyle, _, _ in
                ZStack {
                    HandleView(style: handleStyle)
                    Circle()
                        .stroke(Defaults.label, lineWidth: 1)
                }
            })
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
                        .opacity(brightness)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(
                                        hue: 0,
                                        saturation: 0,
                                        brightness: brightness
                                    ).opacity(1 - brightness),
                                    .black.opacity(0)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                }
            }
            .accentColor(Color(
                hue: point.angle.degrees / 360,
                saturation: point.normalizedRadius,
                brightness: brightness
            ))
            .frame(width: 150, height: 150)
            
            CompactSlider(value: $brightness)
                .compactSliderStyle(default: .vertical(.bottom))
                .frame(width: 30)
        }
        .frame(maxHeight: 150)
    }
}

#Preview("Circular Grid") {
    CompactSliderCircularGridDemo()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
#endif
