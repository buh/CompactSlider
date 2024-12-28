// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A scale visibility determines the rules for showing the scale.
public enum ScaleVisibility {
    case hovering, always, hidden
}

public struct ScaleConfiguration: Equatable {
    let visibility: ScaleVisibility
    let scaleColor: Color
    let secondaryScaleColor: Color
    let scaleLength: CGFloat?
    let secondaryScaleLength: CGFloat?
    let lineWidth: CGFloat
    let secondaryLineWidth: CGFloat
    let padding: EdgeInsets
    
    public init(
        visibility: ScaleVisibility = .hovering,
        scaleColor: Color? = nil,
        secondaryScaleColor: Color? = nil,
        scaleLength: CGFloat? = 0,
        secondaryScaleLength: CGFloat? = 0,
        lineWidth: CGFloat = 0,
        secondaryLineWidth: CGFloat? = nil,
        padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    ) {
        self.visibility = visibility
        self.scaleColor = scaleColor ?? .label.opacity(CompactSliderDouble.scaleOpacity)
        self.secondaryScaleColor = secondaryScaleColor ?? .label.opacity(CompactSliderDouble.secondaryScaleOpacity)
        self.scaleLength = scaleLength == 0 ? .scaleLength : scaleLength
        self.secondaryScaleLength = secondaryScaleLength == 0 ? .secondaryScaleLength : secondaryScaleLength
        self.lineWidth = lineWidth == 0 ? .scaleLineWidth : lineWidth
        self.secondaryLineWidth = secondaryLineWidth ?? .scaleLineWidth
        self.padding = padding
    }
}
