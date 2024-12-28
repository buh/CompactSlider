// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A shape that draws a scale of possible values.
struct Scale: Shape {
    var alignment: Axis = .horizontal
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
