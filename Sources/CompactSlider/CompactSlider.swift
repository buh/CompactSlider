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
public struct CompactSlider<Value: BinaryFloatingPoint, HandleView: View>: View {
    @Environment(\.isEnabled) var isEnabled
    @Environment(\.compactSliderStyle) var compactSliderStyle
    @Environment(\.compactSliderDisabledHapticFeedback) var disabledHapticFeedback

    @Binding var lowerValue: Value
    @Binding var upperValue: Value
    let bounds: ClosedRange<Value>
    let step: Value
    let isRangeValues: Bool
    let direction: CompactSliderDirection
    let scaleVisibility: ScaleVisibility
    let minHeight: CGFloat
    /// Slider height would at least be 10 pt if we do not set this explicitly since
    /// we are using Rectangle/Color in HandleView implementation.
    /// Explanation: When Color is used as a View, it would at least take 10 * 10
    /// if we do not set its frame(width / height) / frame(maxWidth / maxHeight) explicitly.
    let maxHeight: CGFloat?
    let gestureOptions: Set<GestureOption>
    @Binding var state: CompactSliderState
    private let handleView: (_ progress: Double, _ size: CGSize, _ isHovering: Bool, _ isDragging: Bool) -> HandleView
    
    var progressStep: Double = 0
    private var steps: Int = 0
    @State var isLowerValueChangingInternally = false
    @State var isUpperValueChangingInternally = false
    @State var isHovering = false
    @State var isDragging = false
    @State var lowerProgress: Double = 0
    @State var upperProgress: Double = 0
    @State private var dragLocationX: CGFloat = 0
    @State private var deltaLocationX: CGFloat = 0
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
    ///   - direction: the direction in which the slider will indicate the selected value.
    ///   - scaleVisibility: the scale visibility determines the rules for showing the scale.
    ///   - minHeight: the slider minimum height.
    ///   - maxHeight: the slider maximum height (optional).
    ///   - gestureOptions: a set of drag gesture options: minimum drag distance, delayed touch, and high priority.
    ///   - state: the state of the slider with tracking information.
    ///   - valueLabel: a `View` that describes the purpose of the instance.
    ///                 This view is contained in the `HStack` with central alignment.
    public init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        direction: CompactSliderDirection = .leading,
        scaleVisibility: ScaleVisibility = .hovering,
        minHeight: CGFloat = .compactSliderMinHeight,
        maxHeight: CGFloat? = nil,
        gestureOptions: Set<GestureOption> = .default,
        state: Binding<CompactSliderState> = .constant(.inactive),
        @ViewBuilder handle: @escaping (_ progress: Double, _ size: CGSize, _ isHovering: Bool, _ isDragging: Bool) -> HandleView
    ) {
        _lowerValue = value
        _upperValue = .constant(0)
        isRangeValues = false
        self.bounds = bounds
        self.step = step
        self.direction = direction
        self.scaleVisibility = scaleVisibility
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.gestureOptions = gestureOptions
        _state = state
        handleView = handle
        let rangeLength = Double(bounds.length)
        
        guard rangeLength > 0 else { return }
        
        _lowerProgress = State(wrappedValue: Double(value.wrappedValue - bounds.lowerBound) / rangeLength)
        
        if step > 0 {
            progressStep = Double(step) / rangeLength
            steps = Int((rangeLength / Double(step)).rounded(.towardZero) - 1)
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
    ///   - scaleVisibility: the scale visibility determines the rules for showing the scale.
    ///   - minHeight: the slider minimum height.
    ///   - maxHeight: the slider maximum height (optional).
    ///   - gestureOptions: a set of drag gesture options: minimum drag distance, delayed touch, and high priority.
    ///   - state: the state of the slider with tracking information.
    ///   - valueLabel: a `View` that describes the purpose of the instance.
    ///                 This view is contained in the `HStack` with central alignment.
    public init(
        from lowerValue: Binding<Value>,
        to upperValue: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        scaleVisibility: ScaleVisibility = .hovering,
        minHeight: CGFloat = .compactSliderMinHeight,
        maxHeight: CGFloat? = nil,
        gestureOptions: Set<GestureOption> = .default,
        state: Binding<CompactSliderState> = .constant(.inactive),
        @ViewBuilder handle: @escaping (_ progress: Double, _ size: CGSize, _ isHovering: Bool, _ isDragging: Bool) -> HandleView
    ) {
        _lowerValue = lowerValue
        _upperValue = upperValue
        isRangeValues = true
        self.bounds = bounds
        self.step = step
        direction = .leading
        self.scaleVisibility = scaleVisibility
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.gestureOptions = gestureOptions
        _state = state
        handleView = handle
        let rangeLength = Double(bounds.length)
        
        guard rangeLength > 0 else { return }
        
        _lowerProgress = State(wrappedValue: Double(lowerValue.wrappedValue - bounds.lowerBound) / rangeLength)
        _upperProgress = State(wrappedValue: Double(upperValue.wrappedValue - bounds.lowerBound) / rangeLength)
        
        if step > 0 {
            progressStep = Double(step) / rangeLength
            steps = Int((rangeLength / Double(step)).rounded(.towardZero) - 1)
        }
    }
    
    public var body: some View {
        compactSliderStyle
            .makeBody(
                configuration: CompactSliderStyleConfiguration(
                    direction: direction,
                    isRangeValues: isRangeValues,
                    isHovering: isHovering,
                    isDragging: isDragging,
                    lowerProgress: lowerProgress,
                    upperProgress: upperProgress,
                    label: .init(content: contentView)
                )
            )
            #if os(macOS) || os(iOS)
            .onHover {
                isHovering = isEnabled && $0
                updateState()
            }
            .onScrollWheel(isEnabled: gestureOptions.contains(.scrollWheel)) { delta in
                guard isHovering, abs(delta.x) > abs(delta.y) else { return }
                
                Task {
                    deltaLocationX = delta.x
                }
            }
            #endif
            .dragGesture(
                options: gestureOptions,
                onChanged: {
                    isDragging = true
                    updateState()
                    dragLocationX = $0.location.x
                }, onEnded: {
                    isDragging = false
                    updateState()
                    dragLocationX = $0.location.x
                }
            )
            .onChange(of: lowerProgress, perform: onLowerProgressChange)
            .onChange(of: upperProgress, perform: onUpperProgressChange)
            .onChange(of: lowerValue, perform: onLowerValueChange)
            .onChange(of: upperValue, perform: onUpperValueChange)
            .animation(nil, value: lowerValue)
            .animation(nil, value: upperValue)
    }
    
    private var contentView: some View {
        GeometryReader { proxy in
            ZStack {
                progressView(in: proxy.size)
                progressHandleView(lowerProgress, size: proxy.size)
                
                if isScaleVisible {
                    ScaleView(steps: steps)
                        .frame(height: proxy.size.height, alignment: .top)
                }
                
                if isRangeValues {
                    progressHandleView(upperProgress, size: proxy.size)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .onChange(of: dragLocationX) { onDragLocationXChange($0, size: proxy.size) }
            .onChange(of: deltaLocationX) { onDeltaLocationXChange($0, size: proxy.size) }
        }
        .opacity(isEnabled ? 1 : 0.5)
        .frame(minHeight: minHeight, maxHeight: maxHeight)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var isScaleVisible: Bool {
        if scaleVisibility == .hidden {
            return false
        }
        
        if scaleVisibility == .always {
            return true
        }
        
        return isHovering || isDragging
    }
    
    func progressHandleView(_ progress: Double, size: CGSize) -> some View {
        handleView(progress - 0.5, size, isHovering, isDragging)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        Text("CompactSlider")
            .font(.title.bold())
        
        Group {
            // 1. The default case.
            CompactSlider(value: .constant(0.5))
                .overlay(
                    HStack {
                        Text("Default (leading)")
                        Spacer()
                        Text("0.5")
                    }
                    .padding(.horizontal, 6)
                )
            
            // Handle in the centre for better representation of negative values.
            // 2.1. The value is 0, which should show the handle as there is no value to show.
            CompactSlider(value: .constant(0.0), in: -1.0...1.0, direction: .center)
                .overlay(
                    HStack {
                        Text("Center -1.0...1.0")
                        Spacer()
                        Text("0.0")
                    }
                    .padding(.horizontal, 6)
                )
            
            // 2.2. When the value is not 0, the value can be shown with a rectangle.
            CompactSlider(value: .constant(0.3), in: -1.0...1.0, direction: .center)
                .overlay(
                    HStack {
                        Text("Center -1.0...1.0")
                        Spacer()
                        Text("0.3")
                    }
                    .padding(.horizontal, 6)
                )
            
            // 3. The value is filled in on the right-hand side.
            CompactSlider(value: .constant(0.3), direction: .trailing)
                .overlay(
                    HStack {
                        Text("Trailing")
                        Spacer()
                        Text("0.3")
                    }
                )
            
            Divider()
            
            // 4. Set a range of values in specific step to change.
            CompactSlider(value: .constant(70), in: 0...200, step: 10)
                .overlay(
                    HStack {
                        Text("Snapped")
                        Spacer()
                        Text("70")
                    }
                    .padding(.horizontal, 6)
                )
            
            // 4. Set a range of values in specific step to change from the center.
            CompactSlider(value: .constant(0.0), in: -10...10, step: 1, direction: .center)
                .overlay(
                    HStack {
                        Text("Center")
                        Spacer()
                        Text("0.0")
                    }
                    .padding(.horizontal, 6)
                )
                .compactSliderDisabledHapticFeedback(true)
        }
        
        Divider()
        
        // Prominent style.
        Group {
            CompactSlider(value: .constant(0.5))
                .overlay(
                    HStack {
                        Text("Default")
                        Spacer()
                        Text("0.5")
                    }
                    .padding(.horizontal, 6)
                )
                .compactSliderStyle(
                    .prominent(
                        lowerColor: .purple,
                        upperColor: .pink,
                        useGradientBackground: true
                    )
                )
            
            // Get the range of values.
            VStack(spacing: 16) {
                CompactSlider(from: .constant(0.4), to: .constant(0.7))
                    .overlay(
                        HStack {
                            Text("Range")
                            Spacer()
                            Text("0.2 - 0.7")
                        }
                        .padding(.horizontal, 6)
                    )
                
                // Switch back to the `.default` style.
                CompactSlider(from: .constant(0.4), to: .constant(0.7))
                    .overlay(
                        HStack {
                            Text("Range")
                            Spacer()
                            Text("0.2 - 0.7")
                        }
                        .padding(.horizontal, 6)
                    )
                    .compactSliderStyle(.default)
            }
            .compactSliderStyle(
                .prominent(
                    lowerColor: .green,
                    upperColor: .yellow,
                    useGradientBackground: true
                )
            )
        }
    }
    .padding()
    #if os(macOS)
    .frame(width: 600, height: 500, alignment: .top)
    #endif
}
