// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

/// A control for selecting a value from a bounded linear range of values.
///
/// A slider consists of a handle that the user moves between two extremes of a linear “track”.
/// The ends of the track represent the minimum and maximum possible values. As the user moves
/// the handle, the slider updates its bound value.
///
/// The following example shows a slider bound to the value speed. As the slider updates this value,
/// a bound Text view shows the value updating.
/// ```
/// @State private var speed = 50.0
///
/// var body: some View {
///     // (Speed    |      50)
///     CompactSlider(value: $speed, in: 0...100)
///         .overlay(
///             HStack {
///                 Text("Speed")
///                 Spacer()
///                 Text("\(Int(speed))")
///             }
///             .padding(.horizontal, 6)
///         )
/// }
/// ```
///
/// You can also use a step parameter to provide incremental steps along the path of the slider.
/// For example, if you have a slider with a range of 0 to 100, and you set the step value to 5,
/// the slider’s increments would be 0, 5, 10, and so on.
/// ```
/// @State private var speed = 50.0
///
/// var body: some View {
///     // 0 (      50      ) 100
///     HStack {
///         Text("0") // min value
///         CompactSlider(value: $speed, in: 0...100, step: 5)
///             .overlay(Text("\(Int(speed))"))
///         Text("100") // max value
///     }
/// }
/// ```
///
/// A slider can be created to represent a range of possible values.
/// ```
/// @State private var startTime = 8.0 // 08:00
/// @State private var endTime = 17.0 // 17:00
///
/// var body: some View {
///     // (Working hours  |-------|  8 - 17)
///     CompactSlider(
///         from: $startTime,
///         to: $endTime,
///         in: 0...24,
///         step: 1
///     )
///     .overlay(
///         HStack {
///             Text("Working hours")
///             Spacer()
///             Text("\(Int(startTime)) - \(Int(endTime))")
///         }
///         .padding(.horizontal, 6)
///     )
/// }
/// ```
public struct CompactSlider<Value: BinaryFloatingPoint, Point: CompactSliderPoint>: View {
    @Environment(\.isEnabled) var isEnabled
    @Environment(\.layoutDirection) var layoutDirection
    @Environment(\.compactSliderStyle) var compactSliderStyle
    @Environment(\.compactSliderGridStyle) var compactSliderGridStyle
    @Environment(\.compactSliderCircularGridStyle) var compactSliderCircularGridStyle
    @Environment(\.compactSliderDisabledHapticFeedback) var disabledHapticFeedback
    
    let bounds: ClosedRange<Value>
    let pointBounds: ClosedRange<Point>
    let step: CompactSliderStep?
    let options: Set<CompactSliderOption>
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
    
    /// Creates a slider to select a value from a given bounds.
    ///
    /// The value of the created instance is equal to the position of the given value
    /// within bounds, mapped into 0...1.
    ///
    /// - Parameters:
    ///   - value: the selected value within bounds.
    ///   - bounds: the range of the valid values. Defaults to 0...1.
    ///   - step: the distance between each valid value.
    ///   - gestureOptions: a set of drag gesture options: minimum drag distance, delayed touch, and high priority.
    public init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        options: Set<CompactSliderOption> = .default
    ) where Point == CompactSliderPointValue<Value> {
        _lowerValue = value
        _upperValue = .constant(0)
        _values = .constant([])
        _point = .constant(.zero)
        _polarPoint = .constant(.zero)
        
        self.bounds = bounds
        self.pointBounds = .zero ... .one
        self.step = CompactSliderStep(bounds: bounds, step: step)
        self.options = options
        let distance = Double(bounds.distance)
        
        guard distance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progress = Double(value.wrappedValue - bounds.lowerBound) / distance
        _progress = .init(initialValue: Progress([progress]))
    }
    
    public init(
        values: Binding<[Value]>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        gestureOptions: Set<CompactSliderOption> = .default
    ) where Point == CompactSliderPointValue<Value> {
        _lowerValue = .constant(0)
        _upperValue = .constant(0)
        _values = values
        _point = .constant(.zero)
        _polarPoint = .constant(.zero)
        
        self.bounds = bounds
        self.pointBounds = .zero ... .one
        self.step = CompactSliderStep(bounds: bounds, step: step)
        self.options = gestureOptions
        let distance = Double(bounds.distance)
        
        guard distance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progresses = values.wrappedValue.map {
            Double($0 - bounds.lowerBound) / distance
        }
        
        _progress = .init(initialValue: Progress(progresses, isMultipleValues: true))
    }
    
    /// Creates a slider to select a range of values from a given bounds.
    ///
    /// Values of the created instance is equal to the position of the given value
    /// within bounds, mapped into 0...1.
    ///
    /// - Parameters:
    ///   - lowerValue: the selected lower value within bounds.
    ///   - upperValue: the selected upper value within bounds.
    ///   - bounds: the range of the valid values. Defaults to 0...1.
    ///   - step: the distance between each valid value.
    ///   - gestureOptions: a set of drag gesture options: minimum drag distance, delayed touch, and high priority.
    public init(
        from lowerValue: Binding<Value>,
        to upperValue: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        gestureOptions: Set<CompactSliderOption> = .default
    ) where Point == CompactSliderPointValue<Value> {
        _lowerValue = lowerValue
        _upperValue = upperValue
        _values = .constant([])
        _point = .constant(.zero)
        _polarPoint = .constant(.zero)
        
        self.bounds = bounds
        self.pointBounds = .zero ... .one
        self.step = CompactSliderStep(bounds: bounds, step: step)
        self.options = gestureOptions
        
        let distance = Double(bounds.distance)
        
        guard distance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let lowerProgress = Double(lowerValue.wrappedValue - bounds.lowerBound) / distance
        let upperProgress = Double(upperValue.wrappedValue - bounds.lowerBound) / distance
        _progress = .init(initialValue: Progress([lowerProgress, upperProgress]))
    }
    
    public init(
        point: Binding<Point>,
        in bounds: ClosedRange<Point> = .zero ... .one,
        step: Point = .zero,
        gestureOptions: Set<CompactSliderOption> = .default
    ) where Value == Point.Value {
        _lowerValue = .constant(0)
        _upperValue = .constant(0)
        _values = .constant([])
        _point = point
        _polarPoint = .constant(.zero)
        
        self.bounds = 0 ... 1
        self.pointBounds = bounds
        self.step = CompactSliderStep(bounds: bounds, pointStep: step)
        self.options = gestureOptions
        
        let distanceX = Double(bounds.distanceX)
        let distanceY = Double(bounds.distanceY)

        guard distanceX > 0, distanceY > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progresses: [Double] = [
            Double(point.wrappedValue.x - bounds.lowerBound.x) / distanceX,
            Double(point.wrappedValue.y - bounds.lowerBound.y) / distanceY,
        ]
        
        _progress = .init(initialValue: Progress(progresses, isGridValues: true))
        defaultType = .grid
    }
    
    public init(
        polarPoint: Binding<CompactSliderPolarPoint>,
        step: CompactSliderPolarPoint = .zero,
        gestureOptions: Set<CompactSliderOption> = .default
    ) where Point == CompactSliderPointValue<Double>, Value == Point.Value {
        _lowerValue = .constant(0)
        _upperValue = .constant(0)
        _values = .constant([])
        _point = .constant(.zero)
        _polarPoint = polarPoint
        
        self.bounds = 0 ... 1
        self.pointBounds = .zero ... .one
        self.step = CompactSliderStep(polarPointStep: step)
        self.options = gestureOptions
        
        let progresses: [Double] = [polarPoint.wrappedValue.angle.radians, polarPoint.wrappedValue.normalizedRadius]
        _progress = .init(initialValue: Progress(progresses, isCircularGridValues: true))
        defaultType = .circularGrid
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let size = CGSize(
                width: proxy.size.width - style.padding.horizontal,
                height: proxy.size.height - style.padding.vertical
            )
            
            style
                .makeBody(
                    configuration: CompactSliderStyleConfiguration(
                        type: style.type,
                        size: size,
                        focusState: .init(isHovering: isHovering, isDragging: isDragging),
                        progress: progress,
                        step: step,
                        options: options
                    )
                )
                .dragGesture(
                    options: options,
                    onChanged: {
                        isDragging = true
                        
                        if startDragLocation == nil {
                            startDragLocation = nearestProgressLocation(
                                at: $0.startLocation,
                                size: size,
                                type: style.type,
                                isRightToLeft: layoutDirection == .rightToLeft
                            )
                        }
                        
                        onDragLocationChange(
                            translation: $0.translation,
                            size: size,
                            type: style.type,
                            isEnded: false,
                            isRightToLeft: layoutDirection == .rightToLeft
                        )
                    },
                    onEnded: {
                        if step != nil, !options.contains(.snapToSteps) {
                            onDragLocationChange(
                                translation: $0.translation,
                                size: proxy.size,
                                type: style.type,
                                isEnded: true,
                                isRightToLeft: layoutDirection == .rightToLeft
                            )
                        }
                        
                        startDragLocation = nil
                        isDragging = false
                    }
                )
                #if os(macOS)
                .onScrollWheel(isEnabled: options.contains(.scrollWheel)) { event in
                    guard isHovering else { return }
                    
                    if !event.isEnded {
                        if style.type.isHorizontal, !event.isHorizontalDelta {
                            return
                        }
                        
                        if style.type.isVertical, event.isHorizontalDelta {
                            return
                        }
                    }
                    
                    onScrollWheelChange(
                        event,
                        size: proxy.size,
                        location: proxy.frame(in: .global).origin,
                        type: style.type,
                        isRightToLeft: layoutDirection == .rightToLeft
                    )
                }
                #endif
        }
        #if os(macOS) || os(iOS)
        .onHover { isHovering = isEnabled && $0 }
        #endif
        .onChange(of: progress, perform: onProgressesChange)
        .onChange(of: lowerValue, perform: onLowerValueChange)
        .onChange(of: upperValue, perform: onUpperValueChange)
        .onChange(of: values, perform: onValuesChange)
        .onChange(of: point, perform: onValue2DChange)
        .animation(nil, value: lowerValue)
        .animation(nil, value: upperValue)
        .animation(nil, value: values)
        .opacity(isEnabled ? 1 : 0.5)
    }
}
