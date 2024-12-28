// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A handle visibility determines the rules for showing the handle.
public enum HandleVisibility {
    /// Shows the handle when hovering.
    case hovering
    /// Always shows the handle.
    case always
    /// Never shows the handle.
    case hidden
    
    /// Default value.
    public static var `default`: HandleVisibility {
        #if os(macOS)
        .hovering
        #else
        .always
        #endif
    }
}

public struct HandleConfiguration: Equatable {
    let width: CGFloat
    let visibility: HandleVisibility
    
    public init(width: CGFloat = 3, visibility: HandleVisibility = .default) {
        self.width = width
        self.visibility = visibility
    }
}
