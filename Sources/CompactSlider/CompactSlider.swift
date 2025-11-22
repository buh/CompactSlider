// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// ``CompactSlider`` is a highly customizable multi-purpose slider control for SwiftUI. It can be used
/// to select a single value, or a range of values, or multiple values, or a point in a grid,
/// or a polar point in a circular grid. The slider can be displayed horizontally, vertically,
/// or in a (circular) grid. The slider can be customized with a variety of styles and options,
/// including the possibility to design your own style.
///
/// The slider basically defines two variants: a linear slider and a grid slider.
///
/// The linear slider can be horizontal or vertical, and also scrollable, where
/// the handle is still and the scale is moving.
///
/// The grid slider can be used to select a point in a grid or a polar point in a circular grid.
/// The point in the grid represents a value of the x and y axis. The polar point represents
/// a value of the angle and radius.
///
/// - Note: The size of the slider is determined by setting the frame of the slider, depending on the type.
///         For example, a horizontal slider which should be 44 points needs to set the frame height to 44.
///         The width of the slider is determined by the size of the content. The same applies to the vertical slider.
///         The grid slider usually should have a square frame.
///
/// - Note: Values by default are mapped to the range 0...1. The slider type by default is horizontal.
///
/// Possible slider types defined by the ``CompactSliderType``:
///  - a horizontal slider with alignments: leading, center, trailing.
///  - a vertical slider with alignments: top, center, bottom.
///  - a scrollable horizontal slider.
///  - a scrollable vertical slider.
///  - a grid slider.
///  - a circular grid slider.
///
///  The slider can be customized with a variety of styles and options, including the possibility
///  to design your own style. Use the modifiers to set the style or customize components separately.
///  Take a look at the ``CompactSliderStyle`` protocol and the default style ``DefaultCompactSliderStyle``.
///  Possible components to customize are the background, progress, handle, and scale.
///
///  The slider can be customized with a variety of options, including the possibility to enable haptic feedback,
///  snap to steps, and scroll wheel support. Use ``.compactSliderOptions()`` and ``.compactSliderOptionsByAdding()``
///  modifiers to change options.
///
/// ## Examples
///
/// An example with a single value:
/// ```swift
/// @State private var value = 0.5
///
/// var body: some View {
///     // A horizontal slider with a height of 44 points.
///     // The range is 0...1 by default.
///     // (0 |----•----| 1)
///     CompactSlider(value: $value)
///         .frame(height: 44)
/// }
/// ```
/// An example with a custom range and step:
/// ```swift
/// @State private var value = 50.0
///
/// var body: some View {
///     // (0 |----•----| 100)
///     // The step is 5.
///     CompactSlider(value: $value, in: 0...100, step: 5)
///         .frame(height: 44)
/// }
/// ```
/// An example for a vertical slider:
/// ```swift
/// @State private var value = 0.5
///
/// var body: some View {
///     // A vertical slider with a width of 44 points.
///     CompactSlider(value: $value)
///         .compactSliderStyle(default: .vertical())
///         .frame(width: 44)
/// }
/// ```
///
/// An example with multiple values:
/// ```swift
/// @State private var values = [0.2, 0.5, 0.8]
///
/// var body: some View {
///     // (0 |----•----•----•----| 1)
///     CompactSlider(values: $values)
///         .frame(height: 44)
/// }
/// ```
///
/// An example with a range:
/// ```swift
/// @State private var lowerValue = 0.2
/// @State private var upperValue = 0.8
///
/// var body: some View {
///     // (0 |----•----|----•----| 1)
///     CompactSlider(from: $lowerValue, to: $upperValue)
///         .frame(height: 44)
/// }
/// ```
///
/// An example with a grid:
/// ```swift
/// @State private var point = CGPoint(x: 50, y: 50)
///
/// var body: some View {
///     // A grid from (0, 0) to (100, 100) with a step of (5, 5).
///     CompactSlider(point: $point, in: .zero ... CGPoint(x: 100, y: 100), step: CGPoint(x: 5, y: 5))
///         .frame(width: 100, height: 100)
/// }
/// ```
///
/// An example with a circular grid:
/// ```swift
/// @State private var polarPoint = CompactSliderPolarPoint(angle: .zero, normalizedRadius: 0.5)
///
/// var body: some View {
///     CompactSlider(polarPoint: $polarPoint)
///         .frame(width: 100, height: 100)
/// }
/// ```
public struct CompactSlider<Value: BinaryFloatingPoint, Point: CompactSliderPoint>: View {
    @Environment(\.isEnabled) var isEnabled
    @Environment(\.layoutDirection) var layoutDirection
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.compactSliderOptions) var options
    @Environment(\.compactSliderStyle) var compactSliderStyle
    @Environment(\.compactSliderGridStyle) var compactSliderGridStyle
    @Environment(\.compactSliderCircularGridStyle) var compactSliderCircularGridStyle
    @Environment(\.compactSliderAnimations) var animations
    @Environment(\.compactSliderOnChangeAction) var onChangeAction
    #if os(macOS)
    @Environment(\.appearsActive) var appearsActive
    #endif
    
    let bounds: ClosedRange<Value>
    let pointBounds: ClosedRange<Point>
    let step: CompactSliderStep?
    private var defaultType: CompactSliderType = .scrollableHorizontal
    
    @Binding var lowerValue: Value
    @Binding var upperValue: Value
    @Binding var values: [Value]
    @Binding var point: Point
    @Binding var polarPoint: CompactSliderPolarPoint
    
    @State var isValueChangingInternally = false
    @State var progress: Progress
    
    @State var isHovering = false
    @State var isDragging = false
    @State var isWheelScrolling = false
    @State var startDragTime: CFAbsoluteTime?
    @State var startDragLocation: CGPoint?
    @State var scrollWheelEvent = ScrollWheelEvent.zero
    
    var style: AnyCompactSliderStyle {
        if defaultType.isLinear {
            return compactSliderStyle
        }
        
        if defaultType.isGrid {
            return compactSliderGridStyle
        }
        
        if defaultType.isCircularGrid {
            return compactSliderCircularGridStyle
        }
        
        return compactSliderStyle
    }
    
    var isHapticFeedbackEnabled: Bool { options.contains(.enabledHapticFeedback) }
    
    public var body: some View {
        GeometryReader { proxy in
            let size = CGSize(
                width: proxy.size.width - style.padding.horizontal,
                height: proxy.size.height - style.padding.vertical
            )
            
            style.makeBody(configuration: {
                let configuration = CompactSliderStyleConfiguration(
                    type: style.type,
                    size: size,
                    focusState: .init(
                        isHovering: isHovering,
                        isDragging: isDragging,
                        isWheelScrolling: isWheelScrolling
                    ),
                    progress: progress,
                    step: step,
                    colorScheme: colorScheme
                )
                
                onChangeAction?(configuration)
                return configuration
            }())
            #if os(macOS)
            .saturation(appearsActive ? 1 : 0)
            #endif
            .dragGesture(
                options: options,
                onChanged: { dragGestureOnChange($0, size: size) },
                onEnded: { dragGestureOnEnded($0, size: size) }
            )
            #if os(macOS)
            .onScrollWheel(isEnabled: options.contains(.scrollWheel)) {
                scrollWheelOnChange($0, size: size, location: proxy.frame(in: .global).origin)
            }
            #endif
        }
        .opacity(isEnabled ? 1 : 0.5)
        #if os(macOS) || os(iOS)
        .onHover { isHovering in
            if let animation = animations[.hovering] {
                withAnimation(animation) {
                    self.isHovering = isEnabled && isHovering
                }
            } else {
                self.isHovering = isEnabled && isHovering
            }
        }
        #endif
        .onChange(of: progress, perform: onProgressesChange)
        .onChange(of: lowerValue, perform: onLowerValueChange)
        .onChange(of: upperValue, perform: onUpperValueChange)
        .onChange(of: values, perform: onValuesChange)
        .onChange(of: point, perform: onPointChange)
        .onChange(of: polarPoint, perform: onPolarPointChange)
        .animation(nil, value: lowerValue)
        .animation(nil, value: upperValue)
        .animation(nil, value: values)
        .animation(nil, value: point)
        .animation(nil, value: polarPoint)
    }
}

// MARK: - Constructors

extension CompactSlider {
    /// Creates a slider to select a single value from a given bounds.
    ///
    /// Use `.compactSliderStyle()` to change the style, e.g. `.vertical()`.
    ///
    /// - Parameters:
    ///   - value: the selected value within bounds.
    ///   - bounds: the range of the valid values. Defaults to 0...1.
    ///   - step: the distance between each valid value. Defaults to 0, which means no rounding.
    public init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0
    ) where Point == CompactSliderPointValue<Value> {
        _lowerValue = value
        _upperValue = .constant(0)
        _values = .constant([])
        _point = .constant(.zero)
        _polarPoint = .constant(.zero)
        
        self.bounds = bounds
        self.pointBounds = .zero ... .one
        self.step = CompactSliderStep(bounds: bounds, step: step)
        let distance = Double(bounds.distance)
        
        guard distance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progress = (Double(value.wrappedValue - bounds.lowerBound) / distance).clamped()
        _progress = .init(initialValue: Progress([progress]))
    }
    
    /// Creates a slider to select multiple values from a given bounds.
    ///
    /// Use `.compactSliderStyle()` to change the style, e.g. `.vertical()`.
    ///
    /// - Parameters:
    ///   - values: the selected values within bounds.
    ///   - bounds: the range of the valid values. Defaults to 0...1.
    ///   - step: the distance between each valid value. Defaults to 0, which means no rounding.
    public init(
        values: Binding<[Value]>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0
    ) where Point == CompactSliderPointValue<Value> {
        _lowerValue = .constant(0)
        _upperValue = .constant(0)
        _values = values
        _point = .constant(.zero)
        _polarPoint = .constant(.zero)
        
        self.bounds = bounds
        self.pointBounds = .zero ... .one
        self.step = CompactSliderStep(bounds: bounds, step: step)
        let distance = Double(bounds.distance)
        
        guard distance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progresses = values.wrappedValue.map {
            (Double($0 - bounds.lowerBound) / distance).clamped()
        }
        
        _progress = .init(initialValue: Progress(progresses, isMultipleValues: true))
    }
    
    /// Creates a slider to select a range of values from a given bounds.
    ///
    /// Use `.compactSliderStyle()` to change the style, e.g. `.vertical()`.
    ///
    /// - Parameters:
    ///   - lowerValue: the lower selected value within bounds.
    ///   - upperValue: the upper selected value within bounds.
    ///   - bounds: the range of the valid values. Defaults to 0...1.
    ///   - step: the distance between each valid value. Defaults to 0, which means no rounding.
    public init(
        from lowerValue: Binding<Value>,
        to upperValue: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0
    ) where Point == CompactSliderPointValue<Value> {
        _lowerValue = lowerValue
        _upperValue = upperValue
        _values = .constant([])
        _point = .constant(.zero)
        _polarPoint = .constant(.zero)
        
        self.bounds = bounds
        self.pointBounds = .zero ... .one
        self.step = CompactSliderStep(bounds: bounds, step: step)
        
        let distance = Double(bounds.distance)
        
        guard distance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let lowerProgress = (Double(lowerValue.wrappedValue - bounds.lowerBound) / distance).clamped()
        let upperProgress = (Double(upperValue.wrappedValue - bounds.lowerBound) / distance).clamped()
        _progress = .init(initialValue: Progress([lowerProgress, upperProgress]))
    }
    
    /// Creates a grid slider to select a point from a given bounds.
    /// - Parameters:
    ///   - point: the selected point within bounds.
    ///   - bounds: the range of the valid points. Defaults to .zero ... .one.
    ///   - step: the distance between each valid point. Defaults to .zero, which means no rounding.
    public init(
        point: Binding<Point>,
        in bounds: ClosedRange<Point> = .zero ... .one,
        step: Point = .zero
    ) where Value == Point.Value {
        _lowerValue = .constant(0)
        _upperValue = .constant(0)
        _values = .constant([])
        _point = point
        _polarPoint = .constant(.zero)
        
        self.bounds = 0 ... 1
        self.pointBounds = bounds
        self.step = CompactSliderStep(bounds: bounds, pointStep: step)
        
        let distanceX = Double(bounds.distanceX)
        let distanceY = Double(bounds.distanceY)

        guard distanceX > 0, distanceY > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progresses: [Double] = [
            (Double(point.wrappedValue.x - bounds.lowerBound.x) / distanceX).clamped(),
            (Double(point.wrappedValue.y - bounds.lowerBound.y) / distanceY).clamped(),
        ]
        
        _progress = .init(initialValue: Progress(progresses, isGridValues: true))
        defaultType = .grid
    }
    
    /// Creates a circular grid slider to select a polar point.
    /// - Parameters:
    ///   - polarPoint: the selected polar point.
    ///   - step: the distance between each valid polar point. Defaults to .zero, which means no rounding.
    public init(
        polarPoint: Binding<CompactSliderPolarPoint>,
        step: CompactSliderPolarPoint = .zero
    ) where Point == CompactSliderPointValue<Double>, Value == Point.Value {
        _lowerValue = .constant(0)
        _upperValue = .constant(0)
        _values = .constant([])
        _point = .constant(.zero)
        _polarPoint = polarPoint
        
        self.bounds = 0...1
        self.pointBounds = .zero ... .one
        self.step = CompactSliderStep(polarPointStep: step)
        
        _progress = .init(initialValue: Progress(polarPoint.wrappedValue))
        defaultType = .circularGrid
    }
}
