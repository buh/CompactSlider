// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public enum GridType: Equatable, Sendable {
    case square
    case circle
}

public struct Grid: Shape {
    let type: GridType
    let countX: Int
    let countY: Int
    let size: CGFloat
    let padding: EdgeInsets
    let inverse: Bool
    
    public init(
        type: GridType = .circle,
        countX: Int,
        countY: Int,
        size: CGFloat,
        padding: EdgeInsets = .zero,
        inverse: Bool = false
    ) {
        self.type = type
        self.countX = countX
        self.countY = countY
        self.size = size
        self.padding = padding
        self.inverse = inverse
    }
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            if inverse {
                path.addRect(rect)
            }
            
            let paddingX: CGFloat = (
                rect.width - padding.horizontal - CGFloat(countX) * size
            ) / CGFloat(countX - 1)
            
            let paddingY: CGFloat = (
                rect.height - padding.vertical - CGFloat(countY) * size
            ) / CGFloat(countY - 1)
            
            guard paddingX > 0 && paddingY > 0 else {
                return
            }
            
            for x in 0 ..< countX {
                for y in 0 ..< countY {
                    let rect = CGRect(
                        x: padding.leading + CGFloat(x) * (size + paddingX),
                        y: padding.top + CGFloat(y) * (size + paddingY),
                        width: size,
                        height: size
                    )
                    
                    if type == .circle {
                        path.addEllipse(in: rect)
                    } else {
                        path.addRect(rect)
                    }
                }
            }
        }
    }
}

#Preview {
    VStack {
        Grid(countX: 10, countY: 10, size: 10, inverse: true)
            .fill(
                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
                style: .init(eoFill: true)
            )
            .frame(width: 200, height: 200)
        
        Grid(countX: 10, countY: 10, size: 10, padding: .all(10), inverse: true)
            .fill(
                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
                style: .init(eoFill: true)
            )
            .frame(width: 200, height: 200)
        
        Grid(countX: 10, countY: 10, size: 10, padding: .all(10))
            .fill(
                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .frame(width: 200, height: 200)
    }
    .background(Defaults.backgroundColor)
    .padding(20)
    #if os(macOS)
    .frame(width: 400, height: 800, alignment: .top)
    #endif
}
