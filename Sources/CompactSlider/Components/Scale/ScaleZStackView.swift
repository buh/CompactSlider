// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct ScaleZStackView: View {
    let configuration: CompactSliderStyleConfiguration
    let alignment: Alignment
    let shapeStyles: [ScaleShapeStyle]
    
    var body: some View {
        ZStack(alignment: alignment) {
            ForEach(shapeStyles, id: \.self) {
                ScaleView(configuration: configuration, shapeStyle: $0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

#Preview {
    ScaleZStackView(
        configuration: .preview(size: .init(width: 300, height: 300)),
        alignment: .center,
        shapeStyles: [
            .linear(count: 11, lineLength: 20),
            .linear(count: 51, lineLength: 10, skip: .each(5)),
            .labels(alignment: .top, labels: [0: "0", 0.5: "50%", 1: "100%"])
        ]
    )
    .frame(width: 300, height: 300)
    .padding()
}
