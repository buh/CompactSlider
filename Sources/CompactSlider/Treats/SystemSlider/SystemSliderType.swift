// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A type of the "system" slider.
public enum SystemSliderType {
    case horizontal(HorizontalAlignment)
    case vertical(VerticalAlignment)
    case scrollableHorizontal
    case scrollableVertical
    
    /// A horizontal slider with the leading alignment.
    public static var horizontal: SystemSliderType { .horizontal(.leading) }
    /// A vertical slider with the bottom alignment.
    public static var vertical: SystemSliderType { .vertical(.bottom) }
    
    var compactSliderType: CompactSliderType {
        switch self {
        case .horizontal(let alignment): .horizontal(alignment)
        case .vertical(let alignment): .vertical(alignment)
        case .scrollableHorizontal: .scrollableHorizontal
        case .scrollableVertical: .scrollableVertical
        }
    }
}
