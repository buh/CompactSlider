// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A simple handle view. It can be a rectangle, rounded rectangle, circle, capsule, or a system symbol.
///
/// - SeeAlso: `HandleStyle`.
public struct HandleView: View {
    let style: HandleStyle
    
    public init(configuration: CompactSliderStyleConfiguration, style: HandleStyle) {
        self.style = style.byType(configuration.type)
    }
    
    public var body: some View {
        if let strokeStyle = style.strokeStyle {
            strokeShape(strokeStyle)
        } else {
            fillShape()
        }
    }
    
    @ViewBuilder
    private func fillShape() -> some View {
        switch style.type {
        case .rectangle:
            Rectangle().fill(style.color)
        case .roundedRectangle:
            RoundedRectangle(cornerRadius: style.cornerRadius).fill(style.color)
        case .circle:
            Circle().fill(style.color)
        case .capsule:
            Capsule().fill(style.color)
        case .symbol(let name):
            symbol(name)
        case .default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func strokeShape(_ strokeStyle: StrokeStyle) -> some View {
        switch style.type {
        case .rectangle:
            Rectangle().stroke(style.color, style: strokeStyle)
        case .roundedRectangle:
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(style.color, style: strokeStyle)
        case .circle:
            Circle().stroke(style.color, style: strokeStyle)
        case .capsule:
            Capsule().stroke(style.color, style: strokeStyle)
        case .symbol(let name):
            symbol(name)
        case .default:
            EmptyView()
        }
    }
    
    func symbol(_ name: String) -> some View {
        Image(systemName: name)
            .foregroundStyle(style.color)
    }
}
