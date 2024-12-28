// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// ScaleView shows the scale based on number of marks.
///
/// Scales are grouped and they need an additional help to layout.
/// Usage case:
/// ```
/// ZStack {
///     ScaleView()
///         .frame(height: 50, alignment: .top)
/// }
/// ```
struct ScaleView: View {
    let direction: CompactSliderDirection
    let steps: Int
    let configuration: ScaleConfiguration
    
    init(
        direction: CompactSliderDirection = .horizontal,
        steps: Int = 0,
        configuration: ScaleConfiguration = ScaleConfiguration()
    ) {
        self.direction = direction
        self.steps = steps
        self.configuration = configuration
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if steps == 0, configuration.secondaryLineWidth > 0 {
                Scale(direction: direction, count: 49)
                    .stroke(configuration.secondaryScaleColor, lineWidth: configuration.secondaryLineWidth)
                    .frame(
                        width: (direction == .vertical ? configuration.secondaryScaleLength : nil),
                        height: (direction == .horizontal ? configuration.secondaryScaleLength : nil)
                    )
            }
            
            Scale(direction: direction, count: steps > 0 ? steps : 9)
                .stroke(configuration.scaleColor, lineWidth: configuration.lineWidth)
                .frame(
                    width: (direction == .vertical ? configuration.scaleLength : nil),
                    height: (direction == .horizontal ? configuration.scaleLength : nil)
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(configuration.padding)
    }
}

#Preview {
    HStack {
        VStack(spacing: 20) {
            ZStack {
                ScaleView()
                    .frame(height: 50, alignment: .top)
            }
            .background(Color.label.opacity(0.1))
            
            ZStack {
                ScaleView(configuration: .init(scaleLength: 25, secondaryScaleLength: 15, lineWidth: 2))
                    .frame(height: 50, alignment: .top)
            }
            .background(Color.label.opacity(0.1))
            
            ZStack {
                ScaleView(configuration: .init(scaleLength: 10, secondaryScaleLength: nil))
                    .frame(height: 50, alignment: .top)
            }
            .background(Color.label.opacity(0.1))
            
            ScaleView(steps: 30)
                .frame(height: 50, alignment: .top)
                .background(Color.label.opacity(0.1))
            
            ScaleView(steps: 10, configuration: .init(scaleLength: 25, lineWidth: 5))
                .frame(height: 50, alignment: .top)
                .background(Color.label.opacity(0.1))
        }
        
        ScaleView(direction: .vertical, configuration: .init(scaleLength: 25, secondaryScaleLength: 15))
            .frame(width: 50, alignment: .leading)
            .background(Color.secondary.opacity(0.1))
    }
    .frame(width: 300)
    .padding()
}
