// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public extension EdgeInsets {
    static var zero: EdgeInsets { .init(top: 0, leading: 0, bottom: 0, trailing: 0) }
    
    static func all(_ value: CGFloat) -> EdgeInsets {
        .init(top: value, leading: value, bottom: value, trailing: value)
    }
    
    static func horizontal(_ value: CGFloat) -> EdgeInsets {
        .init(top: 0, leading: value, bottom: 0, trailing: value)
    }
    
    static func vertical(_ value: CGFloat) -> EdgeInsets {
        .init(top: value, leading: 0, bottom: value, trailing: 0)
    }
    
    var horizontal: CGFloat {
        leading + trailing
    }
    
    var vertical: CGFloat {
        top + bottom
    }
}
