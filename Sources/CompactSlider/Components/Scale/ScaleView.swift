// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A view for the scale.
///
/// The scale can be linear, circular or with labels. Labels can be useful to show the value for a specific percentage.
/// ```
///       50%
/// |------•------|
/// ```
/// - Note: The scale will be duplicated if the `loopValues` option is enabled.
public struct ScaleView: View {
    @Environment(\.compactSliderOptions) var compactSliderOptions
    @Environment(\.handleStyle) var handleStyle
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
            let skipCurrentValue,
            let startFromCenter
        ):
            LinearScaleShape(
                axis: axis,
                count: count,
                thickness: strokeStyle.lineWidth,
                skip: skip,
                skipFirst: skipFirst,
                skipLast: skipLast,
                skipOne: skipCurrentValue ? linearSkipOne : nil,
                startFromCenter: startFromCenter
            )
            .stroke(shapeStyle.color, style: strokeStyle)
            .padding(
                axis == .horizontal ? .horizontal : .vertical,
                compactSliderOptions.contains(.loopValues) || configuration.type.isScrollable
                    ? 0
                    : handleStyle.width / 2
            )
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
    
    private var linearSkipOne: Int? {
        guard case .linear(_, let axis, let count, _, _, _, _, _, _) = shapeStyle.style, count > 1 else {
            return nil
        }
        
        for p in configuration.progress.progresses {
            if let skipOne = checkLinearSkipOneForProgress(p, axis: axis, count: count) {
                return skipOne
            }
        }
        
        return nil
    }
    
    private func checkLinearSkipOneForProgress(_ progress: Double, axis: Axis, count: Int) -> Int? {
        let currentOffset: CGFloat
        let spacer: CGFloat
        
        switch axis {
        case .horizontal:
            currentOffset = configuration.size.width * progress
            spacer = configuration.size.width / CGFloat(count - 1)
        case .vertical:
            currentOffset = configuration.size.height * progress
            spacer = configuration.size.height / CGFloat(count - 1)
        }
        
        if spacer > 0, count > 1 {
            let index = currentOffset / spacer
            return abs(index.rounded() - index) < 0.01 ? Int(index.rounded()) : nil
        }
        
        return nil
    }
}

#Preview {
    VStack(spacing: 16) {
        ScaleView(
            configuration: .preview(size: .init(width: 200, height: 50)),
            shapeStyle: .labels(alignment: .bottom, labels: [0: "0", 0.5: "50%", 1: "100%"])
        )
        .frame(width: 200, height: 50)
        
        ScaleView(configuration: .preview(), shapeStyle: .linear(count: 20, lineLength: 20))
        
        HStack {
            ScaleView(configuration: .preview(), shapeStyle: .linear(axis: .vertical, count: 20, lineLength: 20))
            ScaleView(configuration: .preview(), shapeStyle: .circular(step: .degrees(45)))
            ScaleView(configuration: .preview(), shapeStyle: .circular(step: .degrees(45), minRadius: 0.5))
        }
        .frame(maxHeight: 150)
        
        ZStack {
            ScaleView(configuration: .preview(), shapeStyle: .circular(count: 4, minRadius: 0.2, maxRadius: 0.4))
            ScaleView(configuration: .preview(), shapeStyle: .circular(count: 8, minRadius: 0.5, maxRadius: 0.7))
            ScaleView(configuration: .preview(), shapeStyle: .circular(count: 16, minRadius: 0.8))
        }
        .frame(maxHeight: 150)
    }
    .padding()
    #if os(macOS)
    .frame(width: 400, height: 800, alignment: .top)
    #endif
}
