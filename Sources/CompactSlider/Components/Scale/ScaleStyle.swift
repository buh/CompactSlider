// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A scale style.
public struct ScaleStyle: Equatable {
    public let visibility: Visibility
    public let alignment: Alignment
    public let minSpace: CGFloat = 2
    public let line: Line
    public let secondaryLine: Line?
    
    init(
        visibility: Visibility,
        alignment: Alignment,
        line: Line,
        secondaryLine: Line?
    ) {
        self.visibility = visibility
        self.alignment = alignment
        self.line = line
        self.secondaryLine = secondaryLine
    }
    
    static public func linear(
        visibility: Visibility = .hoveringOrDragging,
        alignment: Alignment = .center,
        line: Line = .primaryCentered,
        secondaryLine: Line? = .secondaryCentered
    ) -> ScaleStyle {
        ScaleStyle(
            visibility: visibility,
            alignment: alignment,
            line: line,
            secondaryLine: secondaryLine
        )
    }
    
    static public func atSide(
        visibility: Visibility = .hoveringOrDragging,
        alignment: Alignment = .topLeading,
        line: Line = .primaryAtSide,
        secondaryLine: Line? = .secondaryAtSide
    ) -> ScaleStyle {
        ScaleStyle(
            visibility: visibility,
            alignment: alignment,
            line: line,
            secondaryLine: secondaryLine
        )
    }
    
    static public func centered(
        visibility: Visibility = .hoveringOrDragging,
        alignment: Alignment = .center,
        line: Line = .primaryCentered,
        secondaryLine: Line? = .secondaryCentered
    ) -> ScaleStyle {
        ScaleStyle(
            visibility: visibility,
            alignment: alignment,
            line: line,
            secondaryLine: secondaryLine
        )
    }
    
    static public func circular(
        visibility: Visibility = .always,
        line: Line = .circular
    ) -> ScaleStyle {
        ScaleStyle(
            visibility: visibility,
            alignment: .center,
            line: line,
            secondaryLine: nil
        )
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
            length: CGFloat? = nil,
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
    public static let primaryAtSide = ScaleStyle.Line(
        length: Defaults.scaleLineLength
    )
    
    public static let secondaryAtSide = ScaleStyle.Line(
        color: Defaults.secondaryScaleLineColor,
        length: Defaults.secondaryScaleLineLength
    )
    
    public static let primaryCentered = ScaleStyle.Line(
        length: nil,
        padding: .horizontal(4)
    )
    
    public static let secondaryCentered = ScaleStyle.Line(
        color: Defaults.secondaryScaleLineColor,
        length: nil,
        padding: .horizontal(8)
    )
    
    public static let circular = ScaleStyle.Line(color: Defaults.circularScaleLineColor)
}

// MARK: - Environment

struct ScaleStyleKey: EnvironmentKey {
    static var defaultValue: ScaleStyle? = .atSide()
}

extension EnvironmentValues {
    var scaleStyle: ScaleStyle? {
        get { self[ScaleStyleKey.self] }
        set { self[ScaleStyleKey.self] = newValue }
    }
}
