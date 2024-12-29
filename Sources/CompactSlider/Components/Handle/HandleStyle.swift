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
        width: CGFloat = Defaults.handleWidth,
        cornerRadius: CGFloat = Defaults.handleCornerRadius,
        visibility: Visibility = .default
    ) {
        self.width = width
        self.cornerRadius = cornerRadius
        self.visibility = visibility
    }
}

public extension HandleStyle {
    /// A handle visibility determines the rules for showing the handle.
    enum Visibility {
        /// Shows the handle when hovering.
        case hovering
        /// Always shows the handle.
        case always
        /// Never shows the handle.
        case hidden
        
        /// Default value.
        public static var `default`: Visibility {
            #if os(macOS)
            .hovering
            #else
            .always
            #endif
        }
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
