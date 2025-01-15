// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension EdgeInsets {
    public static var zero: EdgeInsets { .init(top: 0, leading: 0, bottom: 0, trailing: 0) }
    
    public var horizontal: CGFloat { leading + trailing }
    public var vertical: CGFloat { top + bottom }
    
    public static func all(_ value: CGFloat) -> EdgeInsets {
        .init(top: value, leading: value, bottom: value, trailing: value)
    }
    
    public static func horizontal(_ value: CGFloat) -> EdgeInsets {
        .init(top: 0, leading: value, bottom: 0, trailing: value)
    }
    
    public static func vertical(_ value: CGFloat) -> EdgeInsets {
        .init(top: value, leading: 0, bottom: value, trailing: 0)
    }
}
