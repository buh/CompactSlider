// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol CompactSliderStyle {
    associatedtype Body: View
    typealias Configuration = CompactSliderStyleConfiguration
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

// MARK: - Default Styles

public struct DefaultCompactSliderStyle: CompactSliderStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.label.opacity(0.075))
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
}

public extension CompactSliderStyle where Self == DefaultCompactSliderStyle {
    static var `default`: DefaultCompactSliderStyle { DefaultCompactSliderStyle() }
}

public struct ProminentCompactSliderStyle: CompactSliderStyle {
    
    public let lowerColor: Color
    public let upperColor: Color
    public var useGradientBackground: Bool = false
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Color.label
                    .opacity(
                        useGradientBackground && (configuration.isDragging || configuration.isHovering) ? 0 : 0.075
                    )
            )
            .background(
                LinearGradient(
                    colors: [lowerColor, upperColor],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .opacity(useGradientBackground && (configuration.isDragging || configuration.isHovering) ? 0.2 : 0)
            )
            .accentColor(
                configuration.isRangeValue
                ? abs(configuration.progress2 - 0.5) > abs(configuration.progress - 0.5) ? upperColor : lowerColor
                : configuration.progress > 0.5 ? upperColor : lowerColor
            )
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
}

public extension CompactSliderStyle where Self == ProminentCompactSliderStyle {
    static func prominent(
        lowerColor: Color,
        upperColor: Color,
        useGradientBackground: Bool = false
    ) -> Self {
        ProminentCompactSliderStyle(
            lowerColor: lowerColor,
            upperColor: upperColor,
            useGradientBackground: useGradientBackground
        )
    }
}

// MARK: - Configuration

public struct CompactSliderStyleConfiguration {
    public struct Label: View {
        public var body: AnyView
        
        init<Content: View>(content: Content) {
            body = AnyView(content)
        }
    }
    
    public let direction: CompactSliderDirection
    public let isRangeValue: Bool
    public let isHovering: Bool
    public let isDragging: Bool
    public let progress: Double
    public let progress2: Double
    public let label: Label
}

// MARK: - Environment

public struct CompactSliderStyleKey: EnvironmentKey {
    public static var defaultValue = AnyCompactSliderStyle(DefaultCompactSliderStyle())
}

extension EnvironmentValues {
    var compactSliderStyle: AnyCompactSliderStyle {
        get { self[CompactSliderStyleKey.self] }
        set { self[CompactSliderStyleKey.self] = newValue }
    }
}

public struct AnyCompactSliderStyle: CompactSliderStyle {
    private let _makeBody: (Configuration) -> AnyView
    
    init<Style: CompactSliderStyle>(_ style: Style) {
        _makeBody = { AnyView(style.makeBody(configuration: $0)) }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - View Extension

public extension View {
    func compactSliderStyle<Style: CompactSliderStyle>(_ style: Style) -> some View {
        environment(\.compactSliderStyle, AnyCompactSliderStyle(style))
    }
}

// MARK: - Background Corner Radius

extension CGFloat {
    
    static let labelPadding: CGFloat = {
        #if os(macOS)
        6
        #else
        12
        #endif
    }()
    
    static let cornerRadius: CGFloat = {
        #if os(macOS)
        4
        #else
        8
        #endif
    }()
    
    static let scaleMin: CGFloat = {
        #if os(macOS)
        3
        #else
        6
        #endif
    }()
    
    static let scaleMax: CGFloat = {
        #if os(macOS)
        5
        #else
        10
        #endif
    }()
}

// MARK: - Color

extension Color {
    #if os(macOS)
    static let label = Color(NSColor.labelColor)
    #elseif os(watchOS)
    static let label = Color(UIColor.white)
    #else
    static let label = Color(UIColor.label)
    #endif
}
