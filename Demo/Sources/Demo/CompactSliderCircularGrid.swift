// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct CompactSliderCircularGridPreview: View {
    @State private var point: CompactSliderPolarPoint = .zero
    
    var body: some View {
        VStack(spacing: 16) {
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
    }
    
    @ViewBuilder
    func circularGridSliders() -> some View {
        CompactSlider(
            polarPoint: $point,
            step: .init(angle: .degrees(5), normalizedRadius: 0.05)
        )
        .frame(width: 150, height: 150)
        
        CompactSlider(polarPoint: $point)
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

#Preview("Circular Grid") {
    CompactSliderCircularGridPreview()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
