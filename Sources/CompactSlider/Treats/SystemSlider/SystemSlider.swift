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
            .compactSliderStyle(systemSliderStyle.slider)
            .compactSliderBackground { configuration, _ in
                SystemSliderBackgroundView(configuration: configuration)
            }
            .compactSliderProgress {
                SystemSliderProgressView(configuration: $0)
            }
            .compactSliderHandleStyle(
                systemSliderStyle.handle ?? .system(style: systemSliderStyle.slider, colorScheme: colorScheme)
            )
            .compactSliderHandle { configuration, handleStyle, progress, _ in
                SystemSliderHandleView(configuration: configuration, handleStyle: handleStyle, progress: progress)
            }
            .compactSliderSystemFrame(for: systemSliderStyle.slider.type)
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

#Preview {
    VStack(spacing: 20) {
        SystemSlider(value: .constant(0.2))
        SystemSlider(value: .constant(0.7), step: 0.1)

        SystemSlider(value: .constant(0.2), step: 0.1)
            .systemSliderStyle(.scrollableHorizontal)
        
        Divider()
        
        HStack(spacing: 20) {
            Group {
                SystemSlider(value: .constant(0.2))
                SystemSlider(value: .constant(0.7), step: 0.1)
            }
            .systemSliderStyle(.vertical)

            SystemSlider(value: .constant(0))
                .systemSliderStyle(.scrollableVertical)
                .compactSliderOptionsByAdding(.loopValues)
        }
    }
    .padding()
    #if os(macOS)
    .frame(width: 400, height: 400, alignment: .top)
    #endif
}
