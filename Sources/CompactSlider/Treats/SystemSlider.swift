// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A "system" slider with a style based on the system slider. The slider can have a single value,
/// multiple values, or a range of values. The slider is based on the `CompactSlider` and
/// supports horizontal and vertical styles. The slider uses the default accent color.
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
/// - See also: `CompactSlider`, `DefaultCompactSliderStyle`.
/// - Note: The `.systemSliderStyle()` modifier is used to set the default style.
public struct SystemSlider<Value: BinaryFloatingPoint>: View {
    @Environment(\.systemSliderStyle) var systemSliderStyle
    
    @Binding var lowerValue: Value
    @Binding var upperValue: Value
    @Binding var values: [Value]
    let bounds: ClosedRange<Value>
    let step: Value
    let type: `Type`
    
    public var body: some View {
        slider
            .compactSliderStyle(systemSliderStyle)
            .compactSliderBackground { _, _ in
                Capsule().fill(Color.gray.opacity(0.15))
            }
            .compactSliderProgress { _ in
                Capsule().fill(Color.accentColor.opacity(0.8))
            }
            #if os(macOS)
            .compactSliderHandleStyle(.circle(visibility: .always, progressAlignment: .inside, radius: 10))
            #else
            .compactSliderHandleStyle(.circle(visibility: .always, progressAlignment: .inside, radius: 13.5))
            #endif
            .compactSliderHandle { configuration, _, _, _ in
                #if os(macOS)
                HandleView(
                    configuration: configuration,
                    style: .circle(color: configuration.colorScheme == .light ? .white : Color(white: 0.8))
                )
                .shadow(radius: 1, y: 0.5)
                #else
                HandleView(
                    configuration: configuration,
                    style: .circle(color: .white)
                )
                .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
                #endif
            }
            #if os(macOS)
            .frame(
                width: systemSliderStyle.type.isVertical ? 20 : nil,
                height: systemSliderStyle.type.isHorizontal ? 20 : nil
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

// MARK: - Environment Style

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
    /// Sets the default style for the system slider. The style supports horizontal and vertical sliders.
    public func systemSliderStyle(_ style: DefaultCompactSliderStyle) -> some View {
        environment(\.systemSliderStyle, style.withClipShapeStyle(.none))
    }
}
