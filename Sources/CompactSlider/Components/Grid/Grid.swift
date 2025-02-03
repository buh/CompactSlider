// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A grid shape type.
public enum GridType: Equatable, Sendable {
    case square
    case circle
}

/// A grid shape. It can be a square or a circle.
///
/// If it needs to to render in reverse order, set `inverse` to `true` and make `eoFill` to `true`.
/// For example:
/// ```swift
/// Grid(countX: 10, countY: 10, size: 10, inverse: true)
///    .fill(Color.blue, style: .init(eoFill: true))
/// ```
public struct Grid: Shape {
    /// A grid shape type.
    let type: GridType
    /// The number of shapes in the X-axis.
    let countX: Int
    /// The number of shapes in the Y-axis.
    let countY: Int
    /// The size of grid shapes.
    let size: CGFloat
    /// The padding from the edges.
    let padding: EdgeInsets
    /// Enable to render in reverse order, using `eoFill`.
    let inverse: Bool
    
    /// Create a grid shape.
    ///
    /// - Parameters:
    ///   - type: a grid shape type (default is `.circle`).
    ///   - countX: the number of shapes in the X-axis.
    ///   - countY: the number of shapes in the Y-axis.
    ///   - size: the size of grid shapes.
    ///   - padding: the padding from the edges (default is `.zero`).
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
