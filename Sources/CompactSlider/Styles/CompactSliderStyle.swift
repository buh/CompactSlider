// The MIT License (MIT)
//
// Copyright (c) 2024 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A type that applies standard interaction behavior and a custom appearance to all sliders within a view hierarchy.
///
/// To configure the current slider style for a view hierarchy, use the `compactSliderStyle(_:)` modifier.
public protocol CompactSliderStyle {
    associatedtype Body: View
    typealias Configuration = CompactSliderStyleConfiguration
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

// MARK: - View Extension

public extension View {
    /// Sets a custom style for compact sliders.
    func compactSliderStyle<Style: CompactSliderStyle>(_ style: Style) -> some View {
        environment(\.compactSliderStyle, AnyCompactSliderStyle(style))
    }
    
    /// Sets the default style for compact sliders.
    func compactSliderStyle<Background: View>(_ style: DefaultCompactSliderStyle<Background>) -> some View {
        environment(\.compactSliderStyle, AnyCompactSliderStyle(style))
    }
    
    /// Sets the default style with a solid background color for compact sliders.
    func compactSliderStyle(_ style: DefaultCompactSliderStyle<Color>) -> some View {
        environment(\.compactSliderStyle, AnyCompactSliderStyle(style))
    }
}

// MARK: - Environment

struct CompactSliderStyleKey: EnvironmentKey {
    static var defaultValue = AnyCompactSliderStyle(DefaultCompactSliderStyle())
}

extension EnvironmentValues {
    var compactSliderStyle: AnyCompactSliderStyle {
        get { self[CompactSliderStyleKey.self] }
        set { self[CompactSliderStyleKey.self] = newValue }
    }
}

struct AnyCompactSliderStyle: CompactSliderStyle {
    private let _makeBody: (Configuration) -> AnyView
    
    init<Style: CompactSliderStyle>(_ style: Style) {
        _makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}
