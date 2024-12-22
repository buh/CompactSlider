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

// MARK: - View Extension

public extension View {
    /// Sets the style for sliders within this view to a slider style with a custom appearance
    /// and custom interaction behaviour.
    func compactSliderStyle<Style: CompactSliderStyle>(_ style: Style) -> some View {
        environment(\.compactSliderStyle, AnyCompactSliderStyle(style))
    }
}
