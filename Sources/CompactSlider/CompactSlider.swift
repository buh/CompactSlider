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
    @Environment(\.compactSliderStyle) var compactSliderStyle
    @Environment(\.compactSliderDisabledHapticFeedback) var disabledHapticFeedback

    let type: CompactSliderType
    let gestureOptions: Set<CompactSliderGestureOption>
    let bounds: ClosedRange<Value>
    let step: Value
    var progressStep: Double = 0
    var steps: Int = 0
    
    @Binding var lowerValue: Value
    @Binding var upperValue: Value
    @Binding var values: [Value]
    @State var isValueChangingInternally = false
    @State var progresses: [Double]
    
    @State var isHovering = false
    @State var isDragging = false
    @State var location: CGPoint = .zero
    @State var dragLocation: CGPoint = .zero
    @State var deltaLocation: CGPoint = .zero
    @State var adjustedDragLocationX: (lower: CGFloat, upper: CGFloat) = (0, 0)
    
    /// Creates a slider to select a value from a given bounds.
    ///
    /// The value of the created instance is equal to the position of the given value
    /// within bounds, mapped into 0...1.
    ///
    /// - Parameters:
    ///   - value: the selected value within bounds.
    ///   - bounds: the range of the valid values. Defaults to 0...1.
    ///   - step: the distance between each valid value.
    ///   - type: the slider type in which the slider will indicate the selected value.
    ///   - gestureOptions: a set of drag gesture options: minimum drag distance, delayed touch, and high priority.
    public init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        type: CompactSliderType = .horizontal(.leading),
        gestureOptions: Set<CompactSliderGestureOption> = .default
    ) {
        _lowerValue = value
        _upperValue = .constant(0)
        _values = .constant([])
        
        self.bounds = bounds
        self.step = step
        self.type = type
        self.gestureOptions = gestureOptions
        let rangeDistance = Double(bounds.distance)
        
        guard rangeDistance > 0 else {
            _progresses = .init(initialValue: [])
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let progress = Double(value.wrappedValue - bounds.lowerBound) / rangeDistance
        _progresses = .init(initialValue: [progress])
        
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
        type: CompactSliderType = .horizontal(.leading),
        gestureOptions: Set<CompactSliderGestureOption> = .default
    ) {
        _lowerValue = lowerValue
        _upperValue = upperValue
        _values = .constant([])
        self.bounds = bounds
        self.step = step
        self.type = type
        self.gestureOptions = gestureOptions
        
        let rangeDistance = Double(bounds.distance)
        
        guard rangeDistance > 0 else {
            _progresses = .init(initialValue: [])
            assertionFailure("Bounds distance must be greater than zero")
            return
        }
        
        let lowerProgress = Double(lowerValue.wrappedValue - bounds.lowerBound) / rangeDistance
        let upperProgress = Double(upperValue.wrappedValue - bounds.lowerBound) / rangeDistance
        
        _progresses = .init(initialValue: [lowerProgress, upperProgress])
        
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
                        type: type,
                        size: proxy.size,
                        isHovering: isHovering,
                        isDragging: isDragging,
                        progresses: progresses,
                        steps: steps
                    )
                )
                .dragGesture(
                    options: gestureOptions,
                    onChanged: {
                        isDragging = true
                        dragLocation = $0.location
                    }, onEnded: {
                        isDragging = false
                        dragLocation = $0.location
                    }
                )
                .onChange(of: dragLocation) { onDragLocationChange($0, size: proxy.size) }
                .onChange(of: deltaLocation) { onDeltaLocationChange($0, size: proxy.size) }
        }
        #if os(macOS) || os(iOS)
        .onHover {
            isHovering = isEnabled && $0
        }
        .onScrollWheel(isEnabled: gestureOptions.contains(.scrollWheel)) { delta in
            guard isHovering else { return }
            
            if type.isHorizontal, abs(delta.x) < abs(delta.y) {
                return
            }
            
            if type.isVertical, abs(delta.x) > abs(delta.y) {
                return
            }
            
            Task {
                deltaLocation = delta
            }
        }
        #endif
        .onChange(of: progresses, perform: onProgressesChange)
        .onChange(of: lowerValue, perform: onLowerValueChange)
        .onChange(of: upperValue, perform: onUpperValueChange)
        .onChange(of: values, perform: onValuesChange)
        .animation(nil, value: lowerValue)
        .animation(nil, value: upperValue)
        .animation(nil, value: values)
        .opacity(isEnabled ? 1 : 0.5)
    }
    
//    private var contentView: some View {
//        GeometryReader { proxy in
//            ZStack {
//                progressView(in: proxy.size)
//                progressHandleView(lowerProgress, size: proxy.size)
//                
//                if isScaleVisible {
//                    ScaleView(steps: steps)
//                        .frame(height: proxy.size.height, alignment: .top)
//                }
//                
//                if isRangeValues {
//                    progressHandleView(upperProgress, size: proxy.size)
//                }
//            }
//            .frame(width: proxy.size.width, height: proxy.size.height)
//            .onChange(of: dragLocationX) { onDragLocationXChange($0, size: proxy.size) }
//            .onChange(of: deltaLocationX) { onDeltaLocationXChange($0, size: proxy.size) }
//        }
//        .opacity(isEnabled ? 1 : 0.5)
//        .frame(minHeight: minHeight, maxHeight: maxHeight)
//        .fixedSize(horizontal: false, vertical: true)
//    }
//    
//    private var isScaleVisible: Bool {
//        if scaleVisibility == .hidden {
//            return false
//        }
//        
//        if scaleVisibility == .always {
//            return true
//        }
//        
//        return isHovering || isDragging
//    }
//    
//    func progressHandleView(_ progress: Double, size: CGSize) -> some View {
//        handleView(progress - 0.5, size, isHovering, isDragging)
//    }
}

public extension CompactSlider {
    var isSingularValue: Bool { progresses.count == 1 }
    var isRangeValues: Bool { progresses.count == 2 }
    var isMultipleValues: Bool { progresses.count > 2 }

    var progress: Double { progresses.first ?? 0 }

    var lowerProgress: Double { progresses.first ?? 0 }
    
    func updateLowerProgress(_ progress: Double) {
        guard !progresses.isEmpty else { return }
        
        progresses[0] = progress
    }
    
    var upperProgress: Double { isRangeValues ? progresses[1] : 0 }
    
    func updateUpperProgress(_ progress: Double) {
        if isRangeValues {
            progresses[1] = progress
        }
    }
}

// MARK: - Preview

#if DEBUG
#Preview {
    CompactSliderPreview()
        #if os(macOS)
        .frame(width: 400, height: 600, alignment: .top)
        #endif
}

struct CompactSliderPreview: View {
    @State private var progress: Double = 0.3
    @State private var centerProgress: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("0%") { progress = 0 }
                Button("25%") { progress = 0.25 }
                
                Text("CompactSlider")
                    .font(.title.bold())
                
                Button("50%") { progress = 0.5 }
                Button("100%") { progress = 1 }
            }
            
            Group {
                // 1. The default case.
                CompactSlider(value: $progress)
                    .overlay(
                        HStack {
                            Text("Default (leading)")
                            Spacer()
                            Text("\(Int(progress * 100))%")
                        }
                            .padding(.horizontal, 6)
                            .allowsHitTesting(false)
                    )
                
                CompactSlider(value: $centerProgress, in: -10 ... 10, step: 1, type: .horizontal(.center))
                    .overlay(
                        Text("\(centerProgress)")
                    )
                CompactSlider(value: $progress, type: .horizontal(.trailing))
            }
            
            Group {
                HStack {
                    CompactSlider(value: $progress, type: .vertical(.bottom))
                    CompactSlider(value: $centerProgress, in: -10 ... 10, step: 1, type: .vertical(.center))
                    CompactSlider(value: $progress, type: .vertical(.top))
                }
                .frame(height: 300)
            }
                
                // Handle in the centre for better representation of negative values.
                // 2.1. The value is 0, which should show the handle as there is no value to show.
                //
                //            // 2.2. When the value is not 0, the value can be shown with a rectangle.
                //            CompactSlider(value: .constant(0.3), in: -1.0...1.0, type: .horizontal(.center))
                //                .overlay(
                //                    HStack {
                //                        Text("Center -1.0...1.0")
                //                        Spacer()
                //                        Text("0.3")
                //                    }
                //                    .padding(.horizontal, 6)
                //                )
                //
                //            // 3. The value is filled in on the right-hand side.
                //            CompactSlider(value: .constant(0.3), type: .horizontal(.trailing))
                //                .overlay(
                //                    HStack {
                //                        Text("Trailing")
                //                        Spacer()
                //                        Text("0.3")
                //                    }
                //                )
                //
                //            Divider()
                //
                //            // 4. Set a range of values in specific step to change.
                //            CompactSlider(value: .constant(70), in: 0...200, step: 10)
                //                .overlay(
                //                    HStack {
                //                        Text("Snapped")
                //                        Spacer()
                //                        Text("70")
                //                    }
                //                    .padding(.horizontal, 6)
                //                )
                //
                //            // 4. Set a range of values in specific step to change from the center.
                //            CompactSlider(value: .constant(0.0), in: -10...10, step: 1, type: .horizontal(.center))
                //                .overlay(
                //                    HStack {
                //                        Text("Center")
                //                        Spacer()
                //                        Text("0.0")
                //                    }
                //                    .padding(.horizontal, 6)
                //                )
                //                .compactSliderDisabledHapticFeedback(true)
            
            // Prominent style.
            //        Group {
            //            CompactSlider(value: .constant(0.5))
            //                .overlay(
            //                    HStack {
            //                        Text("Default")
            //                        Spacer()
            //                        Text("0.5")
            //                    }
            //                    .padding(.horizontal, 6)
            //                )
            //                .compactSliderStyle(
            //                    .prominent(
            //                        lowerColor: .purple,
            //                        upperColor: .pink,
            //                        useGradientBackground: true
            //                    )
            //                )
            //
            //            // Get the range of values.
            //            VStack(spacing: 16) {
            //                CompactSlider(from: .constant(0.4), to: .constant(0.7))
            //                    .overlay(
            //                        HStack {
            //                            Text("Range")
            //                            Spacer()
            //                            Text("0.2 - 0.7")
            //                        }
            //                        .padding(.horizontal, 6)
            //                    )
            //
            //                // Switch back to the `.default` style.
            //                CompactSlider(from: .constant(0.4), to: .constant(0.7))
            //                    .overlay(
            //                        HStack {
            //                            Text("Range")
            //                            Spacer()
            //                            Text("0.2 - 0.7")
            //                        }
            //                        .padding(.horizontal, 6)
            //                    )
            //                    .compactSliderStyle(.default)
            //            }
            //            .compactSliderStyle(
            //                .prominent(
            //                    lowerColor: .green,
            //                    upperColor: .yellow,
            //                    useGradientBackground: true
            //                )
            //            )
            //        }
        }
        .padding()
    }
}
#endif
