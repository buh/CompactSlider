// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CircularScaleShape: Shape {
    var step: Angle = .degrees(3)
    var minRadius: Double = 0.0
    var maxRadius: Double = 1.0
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = rect.size.minValue / 2
            let degreesRange = stride(from: 0.0, to: 360.0, by: step.degrees)
            
            for degrees in degreesRange {
                let angle = Angle(degrees: degrees)
                
                if minRadius > 0, minRadius < maxRadius {
                    path.move(to: CGPoint(
                        angle: angle,
                        radius: radius * minRadius,
                        in: rect
                    ))
                } else {
                    path.move(to: center)
                }
                
                if maxRadius > 0 {
                    path.addLine(to: CGPoint(
                        angle: angle,
                        radius: radius * maxRadius,
                        in: rect
                    ))
                }
            }
        }
    }
}

#Preview {
    CircularScaleShape(minRadius: 0.8)
        .stroke(style: .init(lineWidth: 1))
        .background(Defaults.backgroundColor)
        .padding(20)
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
