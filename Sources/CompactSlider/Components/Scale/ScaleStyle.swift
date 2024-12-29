// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A scale style.
public struct ScaleStyle: Equatable {
    let visibility: Visibility
    let line: Line
    let secondaryLine: Line?
    let padding: EdgeInsets
    
    public init(
        visibility: Visibility = .hoveringOrDragging,
        line: Line = .primary,
        secondaryLine: Line? = .secondary,
        padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) {
        self.visibility = visibility
        self.line = line
        self.secondaryLine = secondaryLine
        self.padding = padding
    }
}

public extension ScaleStyle {
    struct Line: Equatable {
        let color: Color
        let length: CGFloat?
        let thickness: CGFloat
        
        public init(
            color: Color = Defaults.label.opacity(Defaults.scaleLineOpacity),
            length: CGFloat?,
            thickness: CGFloat = Defaults.scaleLineThickness
        ) {
            self.color = color
            self.length = length
            self.thickness = thickness
        }
    }
}

public extension ScaleStyle.Line {
    static let primary = ScaleStyle.Line(
        color: Defaults.label.opacity(Defaults.scaleLineOpacity),
        length: Defaults.scaleLineLength
    )
    
    static let secondary = ScaleStyle.Line(
        color: Defaults.label.opacity(Defaults.secondaryScaleLineOpacity),
        length: Defaults.secondaryScaleLineLength
    )
}
