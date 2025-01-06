// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A handle style.
public struct HandleStyle: Equatable {
    let visibility: Visibility
    let color: Color
    let width: CGFloat
    let lineWidth: CGFloat
    let cornerRadius: CGFloat
    
    public init(
        visibility: Visibility = .handleDefault,
        color: Color = .accentColor,
        width: CGFloat = Defaults.handleWidth,
        lineWidth: CGFloat = Defaults.handleLineWidth,
        cornerRadius: CGFloat = Defaults.handleCornerRadius
    ) {
        self.visibility = visibility
        self.color = color
        self.width = width
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
    }
}

// MARK: - Environment

struct HandleStyleKey: EnvironmentKey {
    static var defaultValue: HandleStyle = HandleStyle()
}

extension EnvironmentValues {
    var handleStyle: HandleStyle {
        get { self[HandleStyleKey.self] }
        set { self[HandleStyleKey.self] = newValue }
    }
}
