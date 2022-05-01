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

/// A type that applies standard interaction behaviour and a custom appearance to all sliders within a view hierarchy.
///
/// To configure the current slider style for a view hierarchy, use the `compactSliderStyle(_:)` modifier.
public protocol CompactSliderStyle {
    associatedtype Body: View
    typealias Configuration = CompactSliderStyleConfiguration
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

// MARK: - Default Styles

/// The default slider style.
public struct DefaultCompactSliderStyle: CompactSliderStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                Color.label.opacity(configuration.isHovering || configuration.isDragging ? 1 : 0.7)
            )
            .background(Color.label.opacity(0.075))
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
}

public extension CompactSliderStyle where Self == DefaultCompactSliderStyle {
    static var `default`: DefaultCompactSliderStyle { DefaultCompactSliderStyle() }
}

/// A slider style that applies prominent artwork based on the slider’s context.
public struct ProminentCompactSliderStyle: CompactSliderStyle {
    
    /// The color of the lower value within bounds.
    public let lowerColor: Color
    /// The color of the upper value within bounds.
    public let upperColor: Color
    /// Flag which allows the specified colours (`lowerColor`, `upperColor`) to be used for the gradient background.
    public var useGradientBackground: Bool = false
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                Color.label.opacity(configuration.isHovering || configuration.isDragging ? 1 : 0.7)
            )
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
                ? abs(configuration.upperProgress - 0.5) > abs(configuration.lowerProgress - 0.5) ? upperColor : lowerColor
                : configuration.lowerProgress > 0.5 ? upperColor : lowerColor
            )
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
}

public extension CompactSliderStyle where Self == ProminentCompactSliderStyle {
    /// A slider style that applies prominent artwork based on the slider’s context.
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

/// Configuration for creating a style for the slider.
public struct CompactSliderStyleConfiguration {
    public struct Label: View {
        public var body: AnyView
        
        init<Content: View>(content: Content) {
            body = AnyView(content)
        }
    }
    
    /// A direction in which the slider will indicate the selected value.
    public let direction: CompactSliderDirection
    /// True if the slider uses a range of values.
    public let isRangeValue: Bool
    /// True, when hovering the slider.
    public let isHovering: Bool
    /// True, when dragging the slider.
    public let isDragging: Bool
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    /// This progress should be used to track a single value or a lower value for a range of values.
    public let lowerProgress: Double
    /// The progress represents the position of the selected value within bounds, mapped into 0...1.
    /// This progress should only be used to track the upper value for the range of values.
    public let upperProgress: Double
    /// A view that describes the effect of calling the slider’s action.
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

struct SecondaryAppearance {
    public let color: Color
    public var progressOpacity: Double = 0.075
    public var handleOpacity: Double = 0.2
    public var scaleOpacity: Double = 0.8
    public var smallScaleOpacity: Double = 0.3
}

struct CompactSliderSecondaryColorKey: EnvironmentKey {
    static var defaultValue = SecondaryAppearance(color: .label)
}

extension EnvironmentValues {
    var compactSliderSecondaryAppearance: SecondaryAppearance {
        get { self[CompactSliderSecondaryColorKey.self] }
        set { self[CompactSliderSecondaryColorKey.self] = newValue }
    }
}

// MARK: - View Extension

public extension View {
    
    /// Sets the style for sliders within this view to a slider style with a custom appearance
    /// and custom interaction behaviour.
    func compactSliderStyle<Style: CompactSliderStyle>(_ style: Style) -> some View {
        environment(\.compactSliderStyle, AnyCompactSliderStyle(style))
    }
    
    /// Sets secondary colors for sliders within this view to a slider style.
    /// - Parameters:
    ///   - color: the secondary color.
    ///   - progressOpacity: the opacity for the progress view based on the secondary color.
    ///   - handleOpacity: the opacity for the handle view based on the secondary color.
    ///   - scaleOpacity: the opacity for the scale view based on the secondary color.
    ///   - smallScaleOpacity: the opacity for the small scale view based on the secondary color.
    func compactSliderSecondaryColor(
        _ color: Color,
        progressOpacity: Double = 0.075,
        handleOpacity: Double = 0.2,
        scaleOpacity: Double = 0.8,
        smallScaleOpacity: Double = 0.3
    ) -> some View {
        environment(
            \.compactSliderSecondaryAppearance,
             SecondaryAppearance(
                color: color,
                progressOpacity: progressOpacity,
                handleOpacity: handleOpacity,
                scaleOpacity: scaleOpacity,
                smallScaleOpacity: smallScaleOpacity
             )
        )
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
