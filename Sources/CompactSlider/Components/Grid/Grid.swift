// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct Grid: Shape {
    let countX: Int
    let countY: Int
    let holeRadius: CGFloat
    var padding: EdgeInsets = .zero
    
    public func path(in rect: CGRect) -> Path {
        Path { path in
            path.addRect(rect)
            
            let paddingX: CGFloat = (
                rect.width - padding.leading - padding.trailing - CGFloat(countX) * 2 * holeRadius
            ) / CGFloat(countX + 1)
            
            let paddingY: CGFloat = (
                rect.height - padding.top - padding.bottom - CGFloat(countY) * 2 * holeRadius
            ) / CGFloat(countY + 1)
            
            guard paddingX > 0 && paddingY > 0 else {
                return
            }
            
            for x in 0 ..< countX {
                for y in 0 ..< countY {
                    let rect = CGRect(
                        x: padding.leading + paddingX + CGFloat(x) * (2 * holeRadius + paddingX),
                        y: padding.top + paddingY + CGFloat(y) * (2 * holeRadius + paddingY),
                        width: 2 * holeRadius,
                        height: 2 * holeRadius
                    )
                    
                    path.addEllipse(in: rect)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Grid(countX: 10, countY: 10, holeRadius: 5, padding: .all(10))
            .fill(
                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
                style: .init(eoFill: true)
            )
            .frame(width: 200, height: 200)
    }
    .background(Defaults.backgroundColor)
    .padding(20)
#if os(macOS)
    .frame(width: 400, height: 800, alignment: .top)
#endif
}
