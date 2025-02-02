// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A "system" slider with a style inspired by the system slider.
///
/// The slider can have a single value, multiple values, or a range of values.
/// The slider is based on the `CompactSlider` and supports horizontal and vertical styles.
///
/// Example:
/// ```swift
/// SystemSlider(value: $value)
/// // or
/// SystemSlider(value: $value, in: 0...100, step: 5)
/// // or for multiple values
/// SystemSlider(values: $values)
/// // or for a range
/// SystemSlider(from: $lowerValue, to: $upperValue)
/// ```
/// Vertical slider:
/// ```swift
/// SystemSlider(value: $value)
///    .systemSliderStyle(.vertical())
/// ```
///
/// - Note: The "system" slider has predefined sizes for macOS and iOS.
///
/// - See also: `CompactSlider`, `DefaultCompactSliderStyle`.
/// - Note: The `.systemSliderStyle()` modifier is used to set the default style.
public struct SystemSlider<Value: BinaryFloatingPoint>: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.systemSliderStyle) var systemSliderStyle
    
    @Binding var lowerValue: Value
    @Binding var upperValue: Value
    @Binding var values: [Value]
    @State private var visionOSHandleScaleEffect: CGFloat = 0.8
    let bounds: ClosedRange<Value>
    let step: Value
    let type: `Type`
    
    public var body: some View {
        slider
            .compactSliderStyle(systemSliderStyle)
            .compactSliderBackground { configuration, _ in
                #if os(visionOS)
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.black.opacity(0.5), .black.opacity(0.1)],
                            startPoint: configuration.type.isHorizontal ? .top : .leading,
                            endPoint: configuration.type.isHorizontal ? .bottom : .trailing
                        )
                    )
                    .background {
                        Capsule()
                            .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                            .padding(.top, 1)
                    }
                #else
                Capsule().fill(
                    Defaults.labelColor.opacity(colorScheme == .dark ? 0.15 : 0.07)
                )
                #endif
            }
            .compactSliderProgress { _ in
                if #available(macOS 13.0, iOS 16.0, visionOS 1.0, watchOS 9.0, *) {
                    Capsule().fill(Color.accentColor.gradient.opacity(0.8))
                } else {
                    Capsule().fill(Color.accentColor.opacity(0.8))
                }
            }
            .compactSliderHandleStyle(handleStyle())
            .compactSliderHandle { configuration, handleStyle, _, _ in
                if systemSliderStyle.type.isScrollable {
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
            #if os(macOS)
            .frame(
                width: systemSliderStyle.type.isVertical ? 20 : nil,
                height: systemSliderStyle.type.isHorizontal ? 20 : nil
            )
            #elseif os(visionOS)
            .frame(
                width: systemSliderStyle.type.isVertical ? 32 : nil,
                height: systemSliderStyle.type.isHorizontal ? 32 : nil
            )
            #else
            .frame(
                width: systemSliderStyle.type.isVertical ? 27 : nil,
                height: systemSliderStyle.type.isHorizontal ? 27 : nil
            )
            #endif
    }
    
    private var slider: some View {
        switch type {
        case .singleValue: CompactSlider(value: $lowerValue, in: bounds, step: step)
        case .multipleValues: CompactSlider(values: $values, in: bounds, step: step)
        case .rangeValues: CompactSlider(from: $lowerValue, to: $upperValue, in: bounds, step: step)
        }
    }
    
    private func handleStyle() -> HandleStyle {
        guard !systemSliderStyle.type.isScrollable else {
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

// MARK: - Constructors

extension SystemSlider {
    enum `Type` {
        case singleValue, multipleValues, rangeValues
    }
    
    /// Creates a "system" slider with a single value. The value is bound to the given value.
    /// - Parameters:
    ///  - value: The value.
    ///  - bounds: The bounds of the value.
    ///  - step: The step to round the value. Default is `0`, which means no rounding.
    public init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0
    ) {
        _lowerValue = value
        _upperValue = .constant(0)
        _values = .constant([])
        self.bounds = bounds
        self.step = step
        type = .singleValue
    }
    
    /// Creates a "system" slider with multiple values. The values are bound to the given values.
    /// - Parameters:
    /// - values: The values.
    /// - bounds: The bounds of the value.
    /// - step: The step to round the value. Default is `0`, which means no rounding.
    public init(
        values: Binding<[Value]>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0
    ) {
        _lowerValue = .constant(0)
        _upperValue = .constant(0)
        _values = values
        self.bounds = bounds
        self.step = step
        type = .multipleValues
    }
    
    /// Creates a "system" slider with a range of values. The values are bound to the given values.
    /// - Parameters:
    /// - lowerValue: The lower value.
    /// - upperValue: The upper value.
    /// - bounds: The bounds of the value.
    /// - step: The step to round the value. Default is `0`, which means no rounding.
    public init(
        from lowerValue: Binding<Value>,
        to upperValue: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0
    ) {
        _lowerValue = lowerValue
        _upperValue = upperValue
        _values = .constant([])
        self.bounds = bounds
        self.step = step
        type = .rangeValues
    }
}

// MARK: - System Style

/// A type of the "system" slider.
public enum SystemSliderType {
    case horizontal(HorizontalAlignment)
    case vertical(VerticalAlignment)
    case scrollableHorizontal
    case scrollableVertical
    
    /// A horizontal slider with the leading alignment.
    public static var horizontal: SystemSliderType { .horizontal(.leading) }
    /// A vertical slider with the bottom alignment.
    public static var vertical: SystemSliderType { .vertical(.bottom) }
    
    var compactSliderType: CompactSliderType {
        switch self {
        case .horizontal(let alignment): .horizontal(alignment)
        case .vertical(let alignment): .vertical(alignment)
        case .scrollableHorizontal: .scrollableHorizontal
        case .scrollableVertical: .scrollableVertical
        }
    }
}

// MARK: - Environment

struct SystemSliderStyleKey: EnvironmentKey {
    static var defaultValue = DefaultCompactSliderStyle.horizontal(clipShapeStyle: .none)
}

extension EnvironmentValues {
    var systemSliderStyle: DefaultCompactSliderStyle {
        get { self[SystemSliderStyleKey.self] }
        set { self[SystemSliderStyleKey.self] = newValue }
    }
}

extension View {
    /// Sets a style for the "system" slider. The style supports horizontal and vertical sliders.
    /// - Parameters:
    /// - type: The type of the "system" slider.
    /// - padding: The padding of the slider. Default is `.zero`.
    public func systemSliderStyle(_ type: SystemSliderType, padding: EdgeInsets = .zero) -> some View {
        environment(
            \.systemSliderStyle,
             DefaultCompactSliderStyle(
                type: type.compactSliderType,
                clipShapeStyle: .init(shape: .capsule, options: [.background, .progress, .scale]),
                padding: padding
             )
        )
    }
}
