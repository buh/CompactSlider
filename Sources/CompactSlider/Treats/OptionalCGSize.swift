// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A structure that contains optional width and height values.
///
/// It's useful for creating a size with nil width and height by default for the `frame(width:height:)` modifier.
public struct OptionalCGSize {
    /// A width value.
    public let width: CGFloat?
    /// A height value.
    public let height: CGFloat?
    
    /// Create an optional size with the given width and height values.
    public init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width
        self.height = height
    }
}
