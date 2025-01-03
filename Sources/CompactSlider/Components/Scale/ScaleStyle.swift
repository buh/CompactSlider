// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A scale style.
public struct ScaleStyle: Equatable {
    let visibility: Visibility
    let alignment: Alignment
    let line: Line
    let secondaryLine: Line?
    
    public init(
        visibility: Visibility = .hoveringOrDragging,
        alignment: Alignment = .topLeading,
        line: Line = .primary,
        secondaryLine: Line? = .secondary
    ) {
        self.visibility = visibility
        self.alignment = alignment
        self.line = line
        self.secondaryLine = secondaryLine
    }
}

public extension ScaleStyle {
    struct Line: Equatable {
        let color: Color
        let length: CGFloat?
        let thickness: CGFloat
        let padding: EdgeInsets
        
        public init(
            color: Color = Defaults.label.opacity(Defaults.scaleLineOpacity),
            length: CGFloat?,
            thickness: CGFloat = Defaults.scaleLineThickness,
            padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        ) {
            self.color = color
            self.length = length
            self.thickness = thickness
            self.padding = padding
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

// MARK: - Environment

struct ScaleStyleKey: EnvironmentKey {
    static var defaultValue: ScaleStyle? = ScaleStyle()
}

extension EnvironmentValues {
    var scaleStyle: ScaleStyle? {
        get { self[ScaleStyleKey.self] }
        set { self[ScaleStyleKey.self] = newValue }
    }
}
