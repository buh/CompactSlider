// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A shape that draws a scale of possible values.
struct Scale: Shape {
    var alignment: Axis = .horizontal
    let count: Int
    var lineWidth: CGFloat = 1
    var minSpacing: CGFloat = 3
    var skip: Skip? = nil
    var skipEdges: Bool = false
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            guard count > 1, minSpacing > 1 else { return }
            
            let isHorizontal = alignment == .horizontal
            let length = isHorizontal ? rect.width : rect.height
            let spacing = (length - max(0, lineWidth) * CGFloat(count - 1)) / CGFloat(count - 1)
            
            guard spacing > minSpacing else { return }
            
            var offset: CGFloat = 0
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
                
                offset = CGFloat(i) * (spacing + lineWidth)
                offset = (offset * ScreenInfo.scale).rounded(.towardZero) / ScreenInfo.scale
                i += 1
            }
        }
    }
    
    func needsToDraw(_ index: Int) -> Bool {
        if skipEdges, (index == 1 || index == count) {
            return false
        }
        
        return skip?.needsToSkip(index) != true
    }
}

extension Scale {
    enum Skip {
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
    VStack {
        Group {
            Scale(count: 2, lineWidth: 1).stroke(lineWidth: 1)
            Scale(count: 3, lineWidth: 1).stroke(lineWidth: 1)
            Scale(count: 4, lineWidth: 1).stroke(lineWidth: 1)
            Scale(count: 5, lineWidth: 1).stroke(lineWidth: 1)
            Scale(count: 6, lineWidth: 1).stroke(lineWidth: 1)
            Scale(count: 7, lineWidth: 1).stroke(lineWidth: 1)
            Scale(count: 8, lineWidth: 1).stroke(lineWidth: 1)
            Scale(count: 9, lineWidth: 1, skipEdges: true).stroke(lineWidth: 1)
            Scale(count: 9, lineWidth: 1, skip: .each(2)).stroke(Color.blue, lineWidth: 1)
            Scale(count: 9, lineWidth: 1, skip: .except(2)).stroke(Color.red, lineWidth: 1)
            Scale(count: 9, lineWidth: 1, skip: .each(3)).stroke(Color.blue, lineWidth: 1)
            Scale(count: 9, lineWidth: 1, skip: .except(3)).stroke(Color.red, lineWidth: 1)
            Scale(count: 9, lineWidth: 1, skip: .each(4)).stroke(Color.blue, lineWidth: 1)
            Scale(count: 9, lineWidth: 1, skip: .except(4)).stroke(Color.red, lineWidth: 1)
        }
        Group {
            Scale(count: 2, lineWidth: 20).stroke(lineWidth: 20)
            Scale(count: 3, lineWidth: 20).stroke(lineWidth: 20)
            Scale(count: 4, lineWidth: 20).stroke(lineWidth: 20)
            Scale(count: 5, lineWidth: 20).stroke(lineWidth: 20)
            Scale(count: 6, lineWidth: 20).stroke(lineWidth: 20)
            Scale(count: 7, lineWidth: 20).stroke(lineWidth: 20)
            Scale(count: 8, lineWidth: 20).stroke(lineWidth: 20)
            Scale(count: 9, lineWidth: 20).stroke(lineWidth: 20)
            Scale(count: 9, lineWidth: 20, skip: .each(2)).stroke(Color.blue, lineWidth: 20)
            Scale(count: 9, lineWidth: 20, skip: .except(2)).stroke(Color.red, lineWidth: 20)
            Scale(count: 9, lineWidth: 20, skip: .each(3)).stroke(Color.blue, lineWidth: 20)
            Scale(count: 9, lineWidth: 20, skip: .except(3)).stroke(Color.red, lineWidth: 20)
            Scale(count: 9, lineWidth: 20, skip: .each(4)).stroke(Color.blue, lineWidth: 20)
            Scale(count: 9, lineWidth: 20, skip: .except(4)).stroke(Color.red, lineWidth: 20)
        }
    }
    .background(Defaults.backgroundColor)
    .padding(20)
    #if os(macOS)
    .frame(width: 400, height: 800, alignment: .top)
    #endif
}
