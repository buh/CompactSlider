// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A shape that draws a scale of possible values.
public struct LinearScaleShape: Shape {
    let axis: Axis
    let count: Int
    let thickness: CGFloat
    let skip: Skip?
    let skipFirst: Int
    let skipLast: Int
    let skipOne: Int?
    let startFromCenter: Bool
    
    public init(
        axis: Axis = .horizontal,
        count: Int,
        thickness: CGFloat = 1,
        skip: Skip? = nil,
        skipFirst: Int = 0,
        skipLast: Int = 0,
        skipOne: Int? = nil,
        startFromCenter: Bool = false
    ) {
        self.axis = axis
        self.count = count
        self.thickness = thickness
        self.skip = skip
        self.skipFirst = skipFirst
        self.skipLast = skipLast
        self.skipOne = skipOne
        self.startFromCenter = startFromCenter
    }
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            guard count > 1 else { return }
            
            let isHorizontal = axis == .horizontal
            let length = isHorizontal ? rect.width : rect.height
            let spacing = (length - max(0, thickness) * CGFloat(count - 1)) / CGFloat(count - 1)
            
            guard spacing > 1 else {
                path.addRect(
                    CGRect(
                        x: rect.origin.x,
                        y: rect.origin.y,
                        width: isHorizontal ? rect.width : thickness,
                        height: isHorizontal ? thickness : rect.height
                    )
                )
                
                return
            }
            
            let centerOffset: CGFloat = startFromCenter && count % 2 == 0 ? (spacing / 2 + thickness).pixelPerfect() : 0
            var offset = centerOffset
            var i = 1
            
            while offset <= (isHorizontal ? rect.maxX : rect.maxY) {
                if needsToDraw(i) {
                    if isHorizontal {
                        path.move(to: .init(x: offset, y: 0))
                        path.addLine(to: .init(x: offset, y: rect.maxY))
                    } else {
                        path.move(to: .init(x: 0, y: offset))
                        path.addLine(to: .init(x: rect.maxX, y: offset))
                    }
                }
                
                offset = centerOffset + (CGFloat(i) * (spacing + thickness)).pixelPerfect()
                i += 1
            }
        }
    }
    
    private func needsToDraw(_ index: Int) -> Bool {
        if let skipOne, skipOne == (index - 1) {
            return false
        }
        
        if skipFirst > 0, (index < (skipFirst + 1)) {
            return false
        }
        
        if skipLast > 0, (index > (count - skipLast)) {
            return false
        }

        return skip?.needsToSkip(index - 1) != true
    }
}

extension LinearScaleShape {
    public enum Skip: Hashable, Sendable {
        case each(Int)
        case except(Int)
        
        func needsToSkip(_ index: Int) -> Bool {
            switch self {
            case .each(let each):
                if each > 1 {
                    return (index % each) == 0
                }
            case .except(let except):
                if except > 1 {
                    return (index % except) != 0
                }
            }
            
            return false
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        Group {
            LinearScaleShape(count: 11, thickness: 1, startFromCenter: true).stroke(lineWidth: 1)
            LinearScaleShape(count: 12, thickness: 1, startFromCenter: true).stroke(lineWidth: 1)
            LinearScaleShape(count: 13, thickness: 1, startFromCenter: true).stroke(lineWidth: 1)
            LinearScaleShape(count: 14, thickness: 1, startFromCenter: true).stroke(lineWidth: 1)
            Divider()
            LinearScaleShape(count: 12, thickness: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 3, thickness: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 12, thickness: 1, skip: .each(2), startFromCenter: true).stroke(lineWidth: 1)
            LinearScaleShape(count: 12, thickness: 1, skip: .except(2), startFromCenter: true).stroke(lineWidth: 1)
            LinearScaleShape(count: 2, thickness: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 4, thickness: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 5, thickness: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 6, thickness: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 7, thickness: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 8, thickness: 1).stroke(lineWidth: 1)
            Divider()
            LinearScaleShape(count: 9, thickness: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skipFirst: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skipFirst: 2).stroke(lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skipLast: 1).stroke(lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skipLast: 2).stroke(lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skipFirst: 1, skipLast: 1).stroke(lineWidth: 1)
            Divider()
            LinearScaleShape(count: 9, thickness: 1, skip: .each(2)).stroke(Color.blue, lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skip: .except(2)).stroke(Color.red, lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skip: .each(3)).stroke(Color.blue, lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skip: .except(3)).stroke(Color.red, lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skip: .each(4)).stroke(Color.blue, lineWidth: 1)
            LinearScaleShape(count: 9, thickness: 1, skip: .except(4)).stroke(Color.red, lineWidth: 1)
        }
        Divider()
        Group {
            LinearScaleShape(count: 11, thickness: 20, startFromCenter: true).stroke(lineWidth: 20)
            LinearScaleShape(count: 12, thickness: 20, startFromCenter: true).stroke(lineWidth: 20)
            LinearScaleShape(count: 13, thickness: 20, startFromCenter: true).stroke(lineWidth: 20)
            LinearScaleShape(count: 14, thickness: 20, startFromCenter: true).stroke(lineWidth: 20)
            Divider()
            LinearScaleShape(count: 2, thickness: 20).stroke(lineWidth: 20)
            LinearScaleShape(count: 3, thickness: 20).stroke(lineWidth: 20)
            LinearScaleShape(count: 4, thickness: 20).stroke(lineWidth: 20)
            LinearScaleShape(count: 5, thickness: 20).stroke(lineWidth: 20)
            LinearScaleShape(count: 6, thickness: 20).stroke(lineWidth: 20)
            LinearScaleShape(count: 7, thickness: 20).stroke(lineWidth: 20)
            LinearScaleShape(count: 8, thickness: 20).stroke(lineWidth: 20)
            LinearScaleShape(count: 9, thickness: 20).stroke(lineWidth: 20)
            Divider()
            LinearScaleShape(count: 9, thickness: 20, skip: .each(2)).stroke(Color.blue, lineWidth: 20)
            LinearScaleShape(count: 9, thickness: 20, skip: .except(2)).stroke(Color.red, lineWidth: 20)
            LinearScaleShape(count: 9, thickness: 20, skip: .each(3)).stroke(Color.blue, lineWidth: 20)
            LinearScaleShape(count: 9, thickness: 20, skip: .except(3)).stroke(Color.red, lineWidth: 20)
            LinearScaleShape(count: 9, thickness: 20, skip: .each(4)).stroke(Color.blue, lineWidth: 20)
            LinearScaleShape(count: 9, thickness: 20, skip: .except(4)).stroke(Color.red, lineWidth: 20)
        }
    }
    .background(Defaults.backgroundColor)
    .padding(20)
    #if os(macOS)
    .frame(width: 400, height: 800, alignment: .top)
    #endif
}
