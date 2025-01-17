// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
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
public struct ScaleView: View {
    let style: ScaleStyle
    let alignment: Axis
    let startFromCenter: Bool
    let steps: Int
    
    public init(
        style: ScaleStyle = .linear(),
        alignment: Axis = .horizontal,
        startFromCenter: Bool = false,
        steps: Int = 0
    ) {
        self.style = style
        self.alignment = alignment
        self.startFromCenter = startFromCenter
        self.steps = steps == 0 ? 49 : steps
    }
    
    public var body: some View {
        ZStack(alignment: style.alignment) {
            if let secondaryLine = style.secondaryLine, steps >= 22 {
                Scale(
                    alignment: alignment,
                    count: steps,
                    lineWidth: secondaryLine.thickness,
                    minSpacing: style.minSpace,
                    skip: .each(5),
                    skipEdges: secondaryLine.skipEdges,
                    startFromCenter: startFromCenter
                )
                .stroke(secondaryLine.color, lineWidth: secondaryLine.thickness)
                .frame(
                    width: (alignment == .vertical ? secondaryLine.length : nil),
                    height: (alignment == .horizontal ? secondaryLine.length : nil)
                )
                .padding(secondaryLine.padding)
            }
            
            Scale(
                alignment: alignment,
                count: steps,
                lineWidth: style.line.thickness,
                minSpacing: style.minSpace,
                skip: steps >= 22 ? .except(5) : nil,
                skipEdges: style.line.skipEdges,
                startFromCenter: startFromCenter
            )
            .stroke(style.line.color, lineWidth: style.line.thickness)
            .frame(
                width: (alignment == .vertical ? style.line.length : nil),
                height: (alignment == .horizontal ? style.line.length : nil)
            )
            .padding(style.line.padding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: style.alignment)
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
                ScaleView(style: .linear(
                    line: .init(length: 20, skipEdges: false),
                    secondaryLine: .init(color: Defaults.secondaryScaleLineColor, length: 10, skipEdges: false)
                ))
                .frame(height: 50, alignment: .top)
            }
            .background(Defaults.label.opacity(0.1))

            ZStack {
                ScaleView(style: .linear(
                    line: .init(length: 25, thickness: 2),
                    secondaryLine: .init(length: 15, thickness: 2)
                ))
                .frame(height: 50, alignment: .top)
            }
            .background(Defaults.label.opacity(0.1))
            
            ZStack {
                ScaleView(style: .linear(line: .init(length: 10), secondaryLine: nil))
                    .frame(height: 50, alignment: .top)
            }
            .background(Defaults.label.opacity(0.1))
            
            ScaleView(steps: 30)
                .frame(height: 50, alignment: .top)
                .background(Defaults.label.opacity(0.1))
            
            ScaleView(style: .linear(line: .init(length: 25, thickness: 5)), steps: 10)
                .frame(height: 50, alignment: .top)
                .background(Defaults.label.opacity(0.1))
        }
    }
    .frame(width: 300)
    .padding()
}
