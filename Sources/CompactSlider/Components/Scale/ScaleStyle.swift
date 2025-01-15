// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A scale style.
public struct ScaleStyle: Equatable {
    let visibility: Visibility
    let alignment: Alignment
    let minSpace: CGFloat = 2
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
    
    func skipedEdges(_ value: Bool) -> Self {
        var secondaryLine: Line?
        
        if let line = self.secondaryLine {
            secondaryLine = .init(
                color: line.color,
                length: line.length,
                thickness: line.thickness,
                skipEdges: value,
                padding: line.padding
            )
        }
        
        return ScaleStyle(
            visibility: visibility,
            alignment: alignment,
            line: .init(
                color: line.color,
                length: line.length,
                thickness: line.thickness,
                skipEdges: value,
                padding: line.padding
            ),
            secondaryLine: secondaryLine
        )
    }
}

extension ScaleStyle {
    public struct Line: Equatable {
        let color: Color
        let length: CGFloat?
        let thickness: CGFloat
        let skipEdges: Bool
        let padding: EdgeInsets
        
        public init(
            color: Color = Defaults.scaleLineColor,
            length: CGFloat?,
            thickness: CGFloat = Defaults.scaleLineThickness,
            skipEdges: Bool = true,
            padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        ) {
            self.color = color
            self.length = length
            self.thickness = thickness
            self.skipEdges = skipEdges
            self.padding = padding
        }
    }
}

extension ScaleStyle.Line {
    public static let primary = ScaleStyle.Line(
        color: Defaults.scaleLineColor,
        length: Defaults.scaleLineLength
    )
    
    public static let secondary = ScaleStyle.Line(
        color: Defaults.secondaryScaleLineColor,
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
