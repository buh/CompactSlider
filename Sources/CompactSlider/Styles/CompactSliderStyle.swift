// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A type that applies standard interaction behavior and a custom appearance to all sliders within a view hierarchy.
///
/// To configure the current slider style for a view hierarchy, use the `compactSliderStyle(_:)` modifier.
///
/// The following example sets the slider style for a view hierarchy to a custom slider style:
/// ```swift
/// CompactSlider(value: $value)
///    .compactSliderStyle(CustomCompactSliderStyle())
/// ```
///
/// - SeeAlso: `DefaultCompactSliderStyle`.
public protocol CompactSliderStyle {
    associatedtype Body: View
    typealias Configuration = CompactSliderStyleConfiguration
    
    /// The type of slider this style applies to.
    var type: CompactSliderType { get }
    /// The padding of the slider.
    var padding: EdgeInsets { get }
    
    /// Creates a view representing the body of a slider.
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
        } else if style.type.isCircularGrid {
            environment(\.compactSliderCircularGridStyle, AnyCompactSliderStyle(style))
        } else {
            environment(\.compactSliderStyle, AnyCompactSliderStyle(style))
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
