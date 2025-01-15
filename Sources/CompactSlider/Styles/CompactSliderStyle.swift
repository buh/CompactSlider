// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A type that applies standard interaction behavior and a custom appearance to all sliders within a view hierarchy.
///
/// To configure the current slider style for a view hierarchy, use the `compactSliderStyle(_:)` modifier.
public protocol CompactSliderStyle {
    associatedtype Body: View
    typealias Configuration = CompactSliderStyleConfiguration
    
    /// A slider type in which the slider will indicate the selected value.
    var type: CompactSliderType { get }
    var padding: EdgeInsets { get }
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

// MARK: - View Extension

extension View {
    /// Sets the default style for compact sliders.
    public func compactSliderStyle(default style: DefaultCompactSliderStyle) -> some View {
        compactSliderStyle(style)
    }
    
    /// Sets a custom style for compact sliders.
    public func compactSliderStyle<Style: CompactSliderStyle>(_ style: Style) -> some View {
        if style.type.isLinear {
            environment(\.compactSliderStyle, AnyCompactSliderStyle(style))
        } else if style.type.isGrid {
            environment(\.compactSliderGridStyle, AnyCompactSliderStyle(style))
        } else {
            environment(\.compactSliderCircularGridStyle, AnyCompactSliderStyle(style))
        }
    }
}

// MARK: - Environment

struct CompactSliderStyleKey: EnvironmentKey {
    static var defaultValue = AnyCompactSliderStyle(DefaultCompactSliderStyle())
}

struct CompactSliderGridStyleKey: EnvironmentKey {
    static var defaultValue = AnyCompactSliderStyle(DefaultCompactSliderStyle.grid())
}

struct CompactSliderCircularGridStyleKey: EnvironmentKey {
    static var defaultValue = AnyCompactSliderStyle(DefaultCompactSliderStyle.circularGrid())
}

extension EnvironmentValues {
    var compactSliderStyle: AnyCompactSliderStyle {
        get { self[CompactSliderStyleKey.self] }
        set { self[CompactSliderStyleKey.self] = newValue }
    }
    
    var compactSliderGridStyle: AnyCompactSliderStyle {
        get { self[CompactSliderGridStyleKey.self] }
        set { self[CompactSliderGridStyleKey.self] = newValue }
    }
    
    var compactSliderCircularGridStyle: AnyCompactSliderStyle {
        get { self[CompactSliderCircularGridStyleKey.self] }
        set { self[CompactSliderCircularGridStyleKey.self] = newValue }
    }
}

struct AnyCompactSliderStyle: CompactSliderStyle {
    let type: CompactSliderType
    let padding: EdgeInsets
    
    private let _makeBody: (Configuration) -> AnyView
    
    init<Style: CompactSliderStyle>(_ style: Style) {
        type = style.type
        padding = style.padding
        _makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}
