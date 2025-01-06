// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
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
    @Environment(\.compactSliderDisabledHapticFeedback) var disabledHapticFeedback

    let options: Set<CompactSliderOption>
    let bounds: ClosedRange<Value>
    let step: Value
    var progressStep: Double = 0
    var steps: Int = 0
    var pointProgressStep: (x: Double, y: Double) = (0, 0)
    var pointSteps: (x: Int, y: Int) = (0, 0)
    
    let pointBounds: ClosedRange<Point>
    let pointStep: Point
    
    @Binding var lowerValue: Value
    @Binding var upperValue: Value
    @Binding var values: [Value]
    @Binding var point: Point
    @State var isValueChangingInternally = false
    @State var progress: Progress
    
    @State var isHovering = false
    @State var isDragging = false
    @State var startDragLocation: CGPoint?
    @State var scrollWheelEvent = ScrollWheelEvent.zero
    
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
        
        self.bounds = bounds
        self.step = step
        self.pointBounds = .zero ... .one
        self.pointStep = .zero
        self.options = options
        let distance = Double(bounds.distance)
        
        guard distance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progress = Double(value.wrappedValue - bounds.lowerBound) / distance
        _progress = .init(initialValue: Progress([progress]))
        setupSteps()
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
        
        self.bounds = bounds
        self.step = step
        self.pointBounds = .zero ... .one
        self.pointStep = .zero
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
        setupSteps()
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
        
        self.bounds = bounds
        self.step = step
        self.pointBounds = .zero ... .one
        self.pointStep = .zero
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
        setupSteps()
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
        
        self.bounds = 0 ... 1
        self.step = 0
        self.pointBounds = bounds
        self.pointStep = step
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
        
        _progress = .init(initialValue: Progress(progresses, is2DValue: true))
        setupSteps(is2DValue: true)
    }
    
    private mutating func setupSteps(is2DValue: Bool = false) {
        guard is2DValue else {
            guard step > 0 else { return }
            
            progressStep = bounds.progressStep(step: step)
            steps = bounds.steps(step: step)
            return
        }
        
        guard pointStep.x > 0, pointStep.y > 0 else { return }
        
        pointProgressStep = (
            x: pointBounds.rangeX.progressStep(step: pointStep.x),
            y: pointBounds.rangeY.progressStep(step: pointStep.y)
        )
        
        pointSteps = (x: pointBounds.rangeX.steps(step: pointStep.x), y: pointBounds.rangeY.steps(step: pointStep.y))
    }
    
    public var body: some View {
        GeometryReader { proxy in
            compactSliderStyle
                .makeBody(
                    configuration: CompactSliderStyleConfiguration(
                        type: compactSliderStyle.type,
                        size: proxy.size,
                        focusState: .init(isHovering: isHovering, isDragging: isDragging),
                        progress: progress,
                        steps: steps,
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
                                size: proxy.size,
                                type: compactSliderStyle.type,
                                isRightToLeft: layoutDirection == .rightToLeft
                            )
                        }
                        
                        onDragLocationChange(
                            translation: $0.translation,
                            size: proxy.size,
                            type: compactSliderStyle.type,
                            isEnded: false,
                            isRightToLeft: layoutDirection == .rightToLeft
                        )
                    }, onEnded: {
                        if steps > 0, !options.contains(.snapToSteps) {
                            onDragLocationChange(
                                translation: $0.translation,
                                size: proxy.size,
                                type: compactSliderStyle.type,
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
                        if compactSliderStyle.type.isHorizontal, !event.isHorizontalDelta {
                            return
                        }
                        
                        if compactSliderStyle.type.isVertical, event.isHorizontalDelta {
                            return
                        }
                    }
                    
                    onScrollWheelChange(
                        event,
                        size: proxy.size,
                        location: proxy.frame(in: .global).origin,
                        type: compactSliderStyle.type,
                        isRightToLeft: layoutDirection == .rightToLeft
                    )
                }
                #endif
        }
        #if os(macOS) || os(iOS)
        .onHover {
            isHovering = isEnabled && $0
        }
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
