// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import Foundation

extension ClosedRange where Bound: BinaryFloatingPoint {
    var length: Bound { upperBound - lowerBound }
}
