// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A handle style.
public struct HandleStyle: Equatable {
    let width: CGFloat
    let cornerRadius: CGFloat
    let visibility: Visibility
    
    public init(
        visibility: Visibility = .handleDefault,
        width: CGFloat = Defaults.handleWidth,
        cornerRadius: CGFloat = Defaults.handleCornerRadius
    ) {
        self.visibility = visibility
        self.width = width
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
