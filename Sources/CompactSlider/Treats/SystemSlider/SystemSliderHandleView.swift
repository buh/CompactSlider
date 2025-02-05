// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A "system" slider handle view.
public struct SystemSliderHandleView: View {
    let configuration: CompactSliderStyleConfiguration
    let handleStyle: HandleStyle
    let progress: Double
    
    /// Create a "system" slider handle view.
    ///
    /// - Parameters:
    ///  - configuration: a configuration of the slider.
    ///  - handleStyle: a style of the handle.
    ///  - progress: a progress of the handle.
    public init(configuration: CompactSliderStyleConfiguration, handleStyle: HandleStyle, progress: Double) {
        self.configuration = configuration
        self.handleStyle = handleStyle
        self.progress = progress
    }
    
    public var body: some View {
        if configuration.type.isScrollable {
            HandleView(configuration: configuration, style: handleStyle)
        } else {
            #if os(visionOS)
            handleView(configuration, handleStyle)
                .scaleEffect(visionOSHandleScaleEffect)
                .contentShape(.hoverEffect, Rectangle())
                .hoverEffect()
                .onChange(of: configuration.focusState.isFocused) { _, newValue in
                    withAnimation(.bouncy(duration: 0.2, extraBounce: 0.25)) {
                        visionOSHandleScaleEffect = newValue ? 0.5 : 0.8
                    }
                }
            #else
            handleView(configuration, handleStyle)
            #endif
        }
    }
    
    private func handleView(
        _ configuration: CompactSliderStyleConfiguration,
        _ handleStyle: HandleStyle
    ) -> some View {
        #if os(macOS)
        HandleView(configuration: configuration, style: handleStyle)
            .shadow(radius: 1, y: 0.5)
        #else
        HandleView(configuration: configuration, style: handleStyle)
            .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
        #endif
    }
}
