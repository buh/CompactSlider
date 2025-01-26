// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct ScaleView: View {
    let configuration: CompactSliderStyleConfiguration
    let shapeStyle: ScaleShapeStyle
    
    public var body: some View {
        switch shapeStyle.style {
        case .linear(
            let strokeStyle,
            let axis,
            let count,
            let lineLength,
            let skip,
            let skipFirst,
            let skipLast,
            let startFromCenter
        ):
            LinearScaleShape(
                axis: axis,
                count: count,
                thickness: strokeStyle.lineWidth,
                skip: skip,
                skipFirst: skipFirst,
                skipLast: skipLast,
                startFromCenter: startFromCenter
            )
            .stroke(shapeStyle.color, style: strokeStyle)
            .frame(
                width: (axis == .vertical ? lineLength : nil),
                height: (axis == .horizontal ? lineLength : nil)
            )
        case .circular(
            let strokeStyle,
            let step,
            let minRadius,
            let maxRadius
        ):
            CircularScaleShape(step: step, minRadius: minRadius, maxRadius: maxRadius)
                .stroke(shapeStyle.color, style: strokeStyle)
        case .labels(let visibility, let axis, let alignment, let offset, let labels):
            ScaleLabels(
                configuration: configuration,
                visibility: visibility,
                axis: axis,
                alignment: alignment,
                color: shapeStyle.color,
                offset: offset,
                labels: labels
            )
        }
    }
}

#Preview {
    VStack {
        ScaleView(configuration: .preview(), shapeStyle: .linear(count: 20, lineLength: 20))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    #if os(macOS)
    .frame(width: 400, height: 800, alignment: .top)
    #endif
}
