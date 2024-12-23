// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension CompactSlider {
    /// A scale visibility determines the rules for showing the scale.
    public enum ScaleVisibility {
        case hovering, always, hidden
    }
}

public enum ScaleAlignment: Sendable {
    case horizontal
    case vertical
}

/// A shape that draws a scale of possible values.
struct Scale: Shape {
    var alignment: ScaleAlignment = .horizontal
    let count: Int
    var minSpacing: CGFloat = 3
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            guard count > 0, minSpacing > 1 else { return }
            
            let isHorizontal = alignment == .horizontal
            let length = isHorizontal ? rect.width : rect.height
            let spacing = max(minSpacing, length / CGFloat(count + 1))
            var i = spacing
            
            for _ in 0..<count {
                if isHorizontal {
                    path.move(to: .init(x: i, y: 0))
                    path.addLine(to: .init(x: i, y: rect.maxY))
                } else {
                    path.move(to: .init(x: 0, y: i))
                    path.addLine(to: .init(x: rect.maxX, y: i))
                }
                
                i += spacing
                
                if i > (isHorizontal ? rect.maxX : rect.maxY) {
                    break
                }
            }
        }
    }
}

/// ScaleView shows the scale based on number of marks.
///
/// Scales are grouped and they need an additional help to layout.
/// Usage case:
/// ```
/// ZStack {
///     ScaleView().frame(height: 50, alignment: .top)
/// }
/// ```
struct ScaleView: View {
    @Environment(\.compactSliderSecondaryAppearance) var secondaryAppearance
    
    var alignment: ScaleAlignment = .horizontal
    var steps: Int = 0
    var scaleLength: CGFloat = .scaleLength
    var secondaryScaleLength: CGFloat = .secondaryScaleLength
    var lineWidth: CGFloat = .scaleLineWidth
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Scale(alignment: alignment, count: steps > 0 ? steps : 49)
                .stroke(
                    steps > 0 ? secondaryAppearance.scaleColor : secondaryAppearance.secondaryScaleColor,
                    lineWidth: lineWidth
                )
                .frame(
                    width: (alignment == .vertical ? (steps > 0 ? scaleLength : secondaryScaleLength) : nil),
                    height: (alignment == .horizontal ? (steps > 0 ? scaleLength : secondaryScaleLength) : nil)
                )
            
            if steps == 0 {
                Scale(alignment: alignment, count: 9)
                    .stroke(secondaryAppearance.scaleColor, lineWidth: lineWidth)
                    .frame(
                        width: (alignment == .vertical ? scaleLength : nil),
                        height: (alignment == .horizontal ? scaleLength : nil)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
                ScaleView(scaleLength: 25, secondaryScaleLength: 15, lineWidth: 2)
                    .frame(height: 50, alignment: .top)
            }
            .background(Color.label.opacity(0.1))
            
            ZStack {
                ScaleView(scaleLength: 0, secondaryScaleLength: 0)
                    .frame(height: 50, alignment: .top)
            }
            .background(Color.label.opacity(0.1))
            
            ScaleView(steps: 30)
                .frame(height: 50, alignment: .top)
                .background(Color.label.opacity(0.1))
            
            ScaleView(steps: 10, scaleLength: 25, lineWidth: 5)
                .frame(height: 50, alignment: .top)
                .background(Color.label.opacity(0.1))
        }
        
        ScaleView(alignment: .vertical, scaleLength: 25, secondaryScaleLength: 15)
            .frame(width: 50, alignment: .leading)
            .background(Color.secondary.opacity(0.1))
    }
    .frame(width: 300)
    .padding()
}
