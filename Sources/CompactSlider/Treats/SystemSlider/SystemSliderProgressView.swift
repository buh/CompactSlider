// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A "system" slider progress view.
public struct SystemSliderProgressView: View {
    let configuration: CompactSliderStyleConfiguration
    
    /// Create a "system" slider progress view.
    ///
    /// - Parameter configuration: a configuration of the slider.
    public init(configuration: CompactSliderStyleConfiguration) {
        self.configuration = configuration
    }
    
    public var body: some View {
        if #available(macOS 13.0, iOS 16.0, visionOS 1.0, watchOS 9.0, *) {
            Capsule().fill(Color.accentColor.gradient.opacity(0.8))
        } else {
            Capsule().fill(Color.accentColor.opacity(0.8))
        }
    }
}
