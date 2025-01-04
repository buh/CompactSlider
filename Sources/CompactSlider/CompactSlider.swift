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
public struct CompactSlider<Value: BinaryFloatingPoint>: View {
    @Environment(\.isEnabled) var isEnabled
    @Environment(\.layoutDirection) var layoutDirection
    @Environment(\.compactSliderStyle) var compactSliderStyle
    @Environment(\.compactSliderDisabledHapticFeedback) var disabledHapticFeedback

    let options: Set<CompactSliderOption>
    let bounds: ClosedRange<Value>
    let step: Value
    var progressStep: Double = 0
    var steps: Int = 0
    
    @Binding var lowerValue: Value
    @Binding var upperValue: Value
    @Binding var values: [Value]
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
    ) {
        _lowerValue = value
        _upperValue = .constant(0)
        _values = .constant([])
        
        self.bounds = bounds
        self.step = step
        self.options = options
        let rangeDistance = Double(bounds.distance)
        
        guard rangeDistance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progress = Double(value.wrappedValue - bounds.lowerBound) / rangeDistance
        _progress = .init(initialValue: Progress([progress]))
        
        if step > 0 {
            progressStep = Double(step) / rangeDistance
            steps = Int((rangeDistance / Double(step)).rounded(.towardZero) - 1)
        }
    }
    
    public init(
        values: Binding<[Value]>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        gestureOptions: Set<CompactSliderOption> = .default
    ) {
        _lowerValue = .constant(0)
        _upperValue = .constant(0)
        _values = values
        
        self.bounds = bounds
        self.step = step
        self.options = gestureOptions
        let rangeDistance = Double(bounds.distance)
        
        guard rangeDistance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progresses = values.wrappedValue.map {
            Double($0 - bounds.lowerBound) / rangeDistance
        }
        
        _progress = .init(initialValue: Progress(progresses, isMultipleValues: true))
        
        if step > 0 {
            progressStep = Double(step) / rangeDistance
            steps = Int((rangeDistance / Double(step)).rounded(.towardZero) - 1)
        }
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
    ) {
        _lowerValue = lowerValue
        _upperValue = upperValue
        _values = .constant([])
        self.bounds = bounds
        self.step = step
        self.options = gestureOptions
        
        let rangeDistance = Double(bounds.distance)
        
        guard rangeDistance > 0 else {
            _progress = .init(initialValue: Progress())
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let lowerProgress = Double(lowerValue.wrappedValue - bounds.lowerBound) / rangeDistance
        let upperProgress = Double(upperValue.wrappedValue - bounds.lowerBound) / rangeDistance
        
        _progress = .init(initialValue: Progress([lowerProgress, upperProgress]))
        
        if step > 0 {
            progressStep = Double(step) / rangeDistance
            steps = Int((rangeDistance / Double(step)).rounded(.towardZero) - 1)
        }
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
        .animation(nil, value: lowerValue)
        .animation(nil, value: upperValue)
        .animation(nil, value: values)
        .opacity(isEnabled ? 1 : 0.5)
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    CompactSliderPreview()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}

struct CompactSliderPreview: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var layoutDirection: LayoutDirection = .leftToRight
    @State private var progress: Double = 0.3
    @State private var degree: Double = 0
    @State private var centerProgress: Double = 5
    @State private var fromProgress: Double = 0.3
    @State private var toProgress: Double = 0.7
    @State private var progresses: [Double] = [0.2, 0.5, 0.8]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                if #available(macOS 12.0, *) {
                    Group {
                        Text("\(progress, format: .percent.precision(.fractionLength(0)))")
                        Text("\(Int(centerProgress))")
                        Text("\(fromProgress, format: .percent.precision(.fractionLength(0)))-\(toProgress, format: .percent.precision(.fractionLength(0)))")
                    }
                    .monospacedDigit()
                }
                
                Spacer()
                Text("Multi:")
                ForEach(progresses, id: \.self) { p in
                    Text("\(Int(p * 100))%")
                }
                Spacer()
            }
            
            Picker(selection: $layoutDirection) {
                Text("Left-to-Right").tag(LayoutDirection.leftToRight)
                Text("Right-to-Left").tag(LayoutDirection.rightToLeft)
            } label: { EmptyView() }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
            
            Group {
                CompactSlider(
                    value: $degree,
                    in: 0 ... 355,
                    step: 5,
                    options: [.dragGestureMinimumDistance(0), .scrollWheel, .withoutBackground, .loopValues]
                )
                .compactSliderStyle(default: .scrollable(
                    cornerRadius: 0,
                    handleStyle: .init(width: 1, cornerRadius: 0),
                    scaleStyle: .init(
                        alignment: .bottom,
                        line: .init(length: 16, skipEdges: false),
                        secondaryLine: .init(color: Defaults.secondaryScaleLineColor, length: 8, skipEdges: false)
                    )
                ))
                .horizontalGradientMask()
                .overlay(
                    Text("\(Int(degree))º")
                        .offset(x: 2, y: -24)
                )
                .padding(.top, 12)
                .frame(height: 40)
                
                CompactSlider(value: $progress)
                
                CompactSlider(value: $centerProgress, in: -20 ... 20, step: 1, options: [.dragGestureMinimumDistance(0), .snapToSteps, .scrollWheel])
                    .compactSliderStyle(default: .horizontal(.center))
                
                CompactSlider(value: $progress)
                    .compactSliderStyle(default: .horizontal(.trailing))
                
                CompactSlider(from: $fromProgress, to: $toProgress)
                
                CompactSlider(from: $fromProgress, to: $toProgress)
                    .compactSliderStyle(default: .horizontal(
                        cornerRadius: 0,
                        handleStyle: .init(visibility: .always, width: 30),
                        scaleStyle: nil
                    ))
                    .compactSliderProgress { _ in
                        Capsule()
                            .fill(
                                LinearGradient(
                                    stops: [
                                        .init(color: .blue.opacity(0.5), location: 0),
                                        .init(color: .purple.opacity(0.5), location: 1),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .compactSliderHandle { _, _, _, index in
                        Circle()
                            .fill(index == 1 ? Color.purple : .blue)
                    }
                    .compactSliderBackground { _ in
                        Capsule()
                            .fill(Defaults.backgroundColor)
                            .frame(maxHeight: 10)
                    }
                
                CompactSlider(values: $progresses)
                    .compactSliderHandle { _, style, progress, _ in
                        HandleView(
                            style: .init(
                                visibility: .always,
                                color: Color(hue: progress, saturation: 0.8, brightness: 0.8),
                                width: style.width,
                                cornerRadius: 0
                            )
                        )
                        .shadow(color: Color(hue: progress, saturation: 0.8, brightness: 1), radius: 5)
                    }
                    .compactSliderBackground { _ in
                        RoundedRectangle(cornerRadius: Defaults.cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hue: 0, saturation: 0.8, brightness: 0.8),
                                        Color(hue: 0.2, saturation: 0.8, brightness: 0.8),
                                        Color(hue: 0.4, saturation: 0.8, brightness: 0.8),
                                        Color(hue: 0.6, saturation: 0.8, brightness: 0.8),
                                        Color(hue: 0.8, saturation: 0.8, brightness: 0.8),
                                        Color(hue: 1, saturation: 0.8, brightness: 0.8),
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .opacity(colorScheme == .dark ? 0.1 : 0.2)
                    }
            }
            .frame(maxHeight: 30)
            
            // MARK: - Vertical
            
            HStack(spacing: 16) {
                Group {
                    CompactSlider(
                        value: $progress,
                        options: [.dragGestureMinimumDistance(0), .scrollWheel, .loopValues]
                    )
                    .compactSliderStyle(default: .scrollable(
                        .vertical,
                        cornerRadius: 0,
                        handleStyle: .init(width: 2),
                        scaleStyle: .init(
                            line: .init(
                                length: nil,
                                skipEdges: false,
                                padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                            ),
                            secondaryLine: .init(
                                color: Defaults.secondaryScaleLineColor,
                                length: nil,
                                skipEdges: false,
                                padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                            )
                        )
                    ))
                    .verticalGradientMask()
                    
                    CompactSlider(value: $centerProgress, in: -20 ... 20, step: 1)
                        .compactSliderStyle(default: .scrollable(
                            .vertical,
                            handleStyle: .init(width: 2),
                            scaleStyle: .init(
                                line: .init(
                                    length: nil,
                                    padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                                ),
                                secondaryLine: .init(
                                    color: Defaults.secondaryScaleLineColor,
                                    length: nil,
                                    padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                                )
                            )
                        ))
                        .verticalGradientMask()
                    
                    CompactSlider(value: $progress)
                        .compactSliderStyle(default: .vertical(
                            .bottom,
                            scaleStyle: .init(
                                line: .init(
                                    length: nil,
                                    padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                                ),
                                secondaryLine: .init(
                                    color: Defaults.secondaryScaleLineColor,
                                    length: nil,
                                    padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                                )
                            )
                        ))
                    
                    CompactSlider(value: $centerProgress, in: -20 ... 20, step: 1)
                        .compactSliderStyle(default: .vertical(
                            .center,
                            scaleStyle: .init(
                                line: .init(length: nil, padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)),
                                secondaryLine: .init(
                                    color: Defaults.secondaryScaleLineColor,
                                    length: nil,
                                    padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                                )
                            )
                        ))
                    
                    CompactSlider(value: $progress)
                        .compactSliderStyle(default: .vertical(.top))
                        .compactSliderScale { _, _ in
                            Rectangle()
                                .fill(Color.accentColor)
                                .frame(maxWidth: 3)
                        }
                    
                    CompactSlider(from: $fromProgress, to: $toProgress)
                        .compactSliderStyle(default: .vertical())
                    
                    CompactSlider(from: $fromProgress, to: $toProgress)
                        .compactSliderStyle(default: .vertical(
                            cornerRadius: 0,
                            handleStyle: .init(visibility: .always, width: 30),
                            scaleStyle: nil
                        ))
                        .compactSliderProgress { _ in
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        stops: [
                                            .init(color: .blue.opacity(0.5), location: 0),
                                            .init(color: .purple.opacity(0.5), location: 1),
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                        .compactSliderHandle { _, _, _, index in
                            Circle()
                                .fill(index == 1 ? Color.purple : .blue)
                        }
                        .compactSliderBackground { _ in
                            Capsule()
                                .fill(Defaults.backgroundColor)
                                .frame(maxWidth: 10)
                        }
                    
                    CompactSlider(values: $progresses)
                        .compactSliderStyle(default: .vertical(
                            scaleStyle: .init(
                                line: .init(
                                    color: Defaults.label.opacity(0.2),
                                    length: nil,
                                    padding: .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                                ),
                                secondaryLine: nil
                            )
                        ))
                        .compactSliderHandle { _, style, progress, _ in
                            HandleView(
                                style: .init(
                                    visibility: .always,
                                    color: Color(hue: progress, saturation: 0.8, brightness: 0.8),
                                    width: style.width,
                                    cornerRadius: 0
                                )
                            )
                            .shadow(color: Color(hue: progress, saturation: 0.8, brightness: 1), radius: 5)
                        }
                        .compactSliderBackground { _ in
                            RoundedRectangle(cornerRadius: Defaults.cornerRadius)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hue: 0, saturation: 0.8, brightness: 0.8),
                                            Color(hue: 0.2, saturation: 0.8, brightness: 0.8),
                                            Color(hue: 0.4, saturation: 0.8, brightness: 0.8),
                                            Color(hue: 0.6, saturation: 0.8, brightness: 0.8),
                                            Color(hue: 0.8, saturation: 0.8, brightness: 0.8),
                                            Color(hue: 1, saturation: 0.8, brightness: 0.8),
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .opacity(colorScheme == .dark ? 0.1 : 0.2)
                        }
                }
                .frame(maxWidth: 30)
            }
        }
        .padding()
        .accentColor(.purple)
        .environment(\.layoutDirection, layoutDirection)
    }
}
#endif
