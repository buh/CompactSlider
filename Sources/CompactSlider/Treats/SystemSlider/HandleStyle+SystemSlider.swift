// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

extension HandleStyle {
    /// Create a default "system" handle style.
    ///
    /// - Parameters:
    ///  - style: a default slider style.
    ///  - colorScheme: a color scheme.
    public static func system(style: DefaultCompactSliderStyle, colorScheme: ColorScheme) -> HandleStyle {
        guard !style.type.isScrollable else {
            return .rectangle(visibility: .always, color: .accentColor, width: 3)
        }
        
        #if os(macOS)
        return .circle(
            visibility: .always,
            progressAlignment: .inside,
            color: colorScheme == .light ? .white : Color(white: 0.8),
            radius: 10
        )
        #elseif os(visionOS)
        return .circle(visibility: .always, progressAlignment: .inside, color: .white.opacity(0.9), radius: 16)
        #else
        return .circle(visibility: .always, progressAlignment: .inside, color: .white, radius: 13.5)
        #endif
    }
}
