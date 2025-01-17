// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import CoreGraphics

extension CGSize {
    var minValue: CGFloat { Swift.min(width, height) }
    var min: CGSize { CGSize(width: minValue, height: minValue) }
}
