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
public struct ScaleView: View {
    let style: ScaleStyle
    let alignment: Axis
    let steps: Int
    
    public init(
        style: ScaleStyle = ScaleStyle(),
        alignment: Axis = .horizontal,
        steps: Int = 0
    ) {
        self.style = style
        self.alignment = alignment
        self.steps = steps
    }
    
    var count: Int {
        guard steps > 0 else { return 9 }
        
        return steps > 39 && style.secondaryLine != nil ? steps / 5 : steps
    }
    
    var secondaryCount: Int {
        guard steps > 0 else { return 49 }
        
        return steps > 39 ? steps : 0
    }
    
    public var body: some View {
        ZStack(alignment: style.alignment) {
            if let secondaryLine = style.secondaryLine, secondaryCount > 0 {
                Scale(alignment: alignment, count: secondaryCount)
                    .stroke(secondaryLine.color, lineWidth: secondaryLine.thickness)
                    .frame(
                        width: (alignment == .vertical ? secondaryLine.length : nil),
                        height: (alignment == .horizontal ? secondaryLine.length : nil)
                    )
                    .padding(secondaryLine.padding)
            }
            
            Scale(alignment: alignment, count: count)
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
                ScaleView(style: .init(
                    line: .init(length: 25, thickness: 2),
                    secondaryLine: .init(length: 15, thickness: 2)
                ))
                .frame(height: 50, alignment: .top)
            }
            .background(Defaults.label.opacity(0.1))
            
            ZStack {
                ScaleView(style: .init(line: .init(length: 10), secondaryLine: nil))
                    .frame(height: 50, alignment: .top)
            }
            .background(Defaults.label.opacity(0.1))
            
            ScaleView(steps: 30)
                .frame(height: 50, alignment: .top)
                .background(Defaults.label.opacity(0.1))
            
            ScaleView(style: .init(line: .init(length: 25, thickness: 5)), steps: 10)
                .frame(height: 50, alignment: .top)
                .background(Defaults.label.opacity(0.1))
        }
    }
    .frame(width: 300)
    .padding()
}
