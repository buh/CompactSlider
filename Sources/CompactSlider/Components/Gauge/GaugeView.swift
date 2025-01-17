// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct GaugeView: View {
    let gaugeStyle: GaugeStyle
    
    public var body: some View {
        Circle()
            .trim(
                from: gaugeStyle.fromAngle.degrees / 360,
                to: gaugeStyle.toAngle.degrees / 360
            )
            .stroke(gaugeStyle.fillStyle, style: gaugeStyle.strokeStyle)
            .padding(gaugeStyle.strokeStyle.lineWidth / 2)
            .rotationEffect(.degrees(90))
    }
}

#Preview {
    ZStack {
        GaugeView(gaugeStyle: .init(
            fillStyle: AngularGradient(colors: [.blue, .green, .yellow, .red], center: .center),
            lineWidth: 10
        ))
        .reversedMask {
            Circle()
                .fill(Color.black)
                .padding(-2)
                .frame(width: 10, height: 10)
                .offset(x: -50 + 5)
        }
        
        Circle()
            .fill(Color.green)
            .frame(width: 10, height: 10)
            .offset(x: -50 + 5)
    }
    .frame(width: 100, height: 100)
    .padding()
}
