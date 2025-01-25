// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension EdgeInsets {
    /// The zero edge insets.
    public static var zero: EdgeInsets { .init(top: 0, leading: 0, bottom: 0, trailing: 0) }
    
    /// Sum of leading and trailing edge insets.
    public var horizontal: CGFloat { leading + trailing }
    /// Sum of top and bottom edge insets.
    public var vertical: CGFloat { top + bottom }
    
    /// Creates an edge insets with the given value on all edges.
    public static func all(_ value: CGFloat) -> EdgeInsets {
        .init(top: value, leading: value, bottom: value, trailing: value)
    }
    
    /// Creates an edge insets with the given value on leading and trailing edges.
    public static func horizontal(_ value: CGFloat) -> EdgeInsets {
        .init(top: 0, leading: value, bottom: 0, trailing: value)
    }
    
    /// Creates an edge insets with the given value on tom and bottom edges.
    public static func vertical(_ value: CGFloat) -> EdgeInsets {
        .init(top: value, leading: 0, bottom: value, trailing: 0)
    }
}
