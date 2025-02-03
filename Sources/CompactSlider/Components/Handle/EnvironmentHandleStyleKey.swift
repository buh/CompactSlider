// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

struct HandleStyleKey: EnvironmentKey {
    static var defaultValue = HandleStyle.default()
}

extension EnvironmentValues {
    var handleStyle: HandleStyle {
        get { self[HandleStyleKey.self] }
        set { self[HandleStyleKey.self] = newValue }
    }
}

extension View {
    /// Set a handle style for a compact slider.
    ///
    /// - Parameter style: a handle style.
    public func compactSliderHandleStyle(_ style: HandleStyle) -> some View {
        environment(\.handleStyle, style)
    }
}

// MARK: - Default Style

extension HandleStyle {
    func byType(_ type: CompactSliderType) -> HandleStyle {
        guard case .default = self.type else { return self }
        
        if type == .grid || type == .circularGrid {
            return .circle()
        }
        
        #if os(watchOS)
        return .capsule(width: 2 * Defaults.cornerRadius)
        #endif
        
        return .rectangle()
    }
}
