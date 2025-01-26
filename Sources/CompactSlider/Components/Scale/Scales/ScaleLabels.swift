// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ScaleLabels: View {
    let configuration: CompactSliderStyleConfiguration
    let axis: Axis
    let alignment: Alignment
    var color: Color = Color.secondary
    var offset: CGPoint = .zero
    let labels: [Double: String]
    
    var body: some View {
        ZStack {
            ForEach(Array(labels.keys), id: \.self) { key in
                Text(labels[key] ?? "")
                    .offset(
                        x: axis == .horizontal
                            ? configuration.size.width * key - configuration.size.width / 2 + offset.x
                            : 0,
                        y: axis == .vertical
                            ? configuration.size.height * key - configuration.size.width / 2 + offset.y
                            : 0
                    )
            }
            .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

#Preview {
    ScaleLabels(
        configuration: .preview(size: CGSize(width: 100, height: 100)),
        axis: .horizontal,
        alignment: .top,
        labels: [0: "0", 0.5: "50%", 1: "100%"]
    )
    .frame(width: 150, height: 150)
    .border(.blue)
    .padding()
}
