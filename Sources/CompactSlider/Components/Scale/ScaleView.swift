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
    let alignment: Axis
    let steps: Int
    let configuration: ScaleStyle
    
    init(
        alignment: Axis = .horizontal,
        steps: Int = 0,
        configuration: ScaleStyle = ScaleStyle()
    ) {
        self.alignment = alignment
        self.steps = steps
        self.configuration = configuration
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if steps == 0, let secondaryLine = configuration.secondaryLine {
                Scale(alignment: alignment, count: 49)
                    .stroke(secondaryLine.color, lineWidth: secondaryLine.thickness)
                    .frame(
                        width: (alignment == .vertical ? secondaryLine.length : nil),
                        height: (alignment == .horizontal ? secondaryLine.length : nil)
                    )
            }
            
            Scale(alignment: alignment, count: steps > 0 ? steps : 9)
                .stroke(configuration.line.color, lineWidth: configuration.line.thickness)
                .frame(
                    width: (alignment == .vertical ? configuration.line.length : nil),
                    height: (alignment == .horizontal ? configuration.line.length : nil)
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
            .background(Defaults.label.opacity(0.1))
            
            ZStack {
                ScaleView(
                    configuration: .init(
                        line: .init(length: 25, thickness: 2),
                        secondaryLine: .init(length: 15, thickness: 2)
                    )
                )
                    .frame(height: 50, alignment: .top)
            }
            .background(Defaults.label.opacity(0.1))
            
            ZStack {
                ScaleView(configuration: .init(line: .init(length: 10), secondaryLine: nil))
                    .frame(height: 50, alignment: .top)
            }
            .background(Defaults.label.opacity(0.1))
            
            ScaleView(steps: 30)
                .frame(height: 50, alignment: .top)
                .background(Defaults.label.opacity(0.1))
            
            ScaleView(steps: 10, configuration: .init(line: .init(length: 25, thickness: 5)))
                .frame(height: 50, alignment: .top)
                .background(Defaults.label.opacity(0.1))
        }
    }
    .frame(width: 300)
    .padding()
}