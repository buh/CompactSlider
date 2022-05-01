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
///     CompactSlider(value: $speed, in: 0...100) {
///         Text("Speed")
///         Spacer()
///         Text("\(Int(speed))")
///     }
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
///         CompactSlider(value: $speed, in: 0...100, step: 5) {
///             Text("\(Int(speed))") // selected value in the center
///         }
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
///     ) {
///         Text("Working hours")
///         Spacer()
///         Text("\(Int(startTime)) - \(Int(endTime))")
///     }
/// }
/// ```
public struct CompactSlider<Value: BinaryFloatingPoint, ValueLabel: View>: View {
    
    @Environment(\.compactSliderStyle) var compactSliderStyle
    @Environment(\.compactSliderSecondaryAppearance) var secondaryAppearance
    @Environment(\.isEnabled) var isEnabled
    
    @Binding private var lowerValue: Value
    @Binding private var upperValue: Value
    private let bounds: ClosedRange<Value>
    private let step: Value
    private let isRangeValue: Bool
    private let direction: CompactSliderDirection
    private let handleVisibility: HandleVisibility
    @Binding private var state: CompactSliderState
    @ViewBuilder private var valueLabel: () -> ValueLabel
    
    private var progressStep: Double = 0
    private var steps: Int = 0
    @State private var isLowerValueChangingInternally = false
    @State private var isUpperValueChangingInternally = false
    @State private var isHovering = false
    @State private var isDragging = false
    @State private var lowerProgress: Double = 0
    @State private var upperProgress: Double = 0
    @State private var dragLocationX: CGFloat = 0
    @State private var adjustedDragLocationX: (lower: CGFloat, upper: CGFloat) = (0, 0)
    
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
    ///   - handleVisibility: the handle visibility determines the rules for showing the handle.
    ///   - state: the state of the slider with tracking information.
    ///   - valueLabel: a `View` that describes the purpose of the instance.
    ///                 This view is contained in the `HStack` with central alignment.
    public init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        direction: CompactSliderDirection = .leading,
        handleVisibility: HandleVisibility = .standard,
        state: Binding<CompactSliderState> = .constant(.inactive),
        @ViewBuilder valueLabel: @escaping () -> ValueLabel
    ) {
        _lowerValue = value
        _upperValue = .constant(0)
        isRangeValue = false
        self.bounds = bounds
        self.step = step
        self.direction = direction
        self.handleVisibility = handleVisibility
        _state = state
        self.valueLabel = valueLabel
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
    ///   - handleVisibility: the handle visibility determines the rules for showing the handle.
    ///   - state: the state of the slider with tracking information.
    ///   - valueLabel: a `View` that describes the purpose of the instance.
    ///                 This view is contained in the `HStack` with central alignment.
    public init(
        from lowerValue: Binding<Value>,
        to upperValue: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        handleVisibility: HandleVisibility = .standard,
        state: Binding<CompactSliderState> = .constant(.inactive),
        @ViewBuilder valueLabel: @escaping () -> ValueLabel
    ) {
        _lowerValue = lowerValue
        _upperValue = upperValue
        isRangeValue = true
        self.bounds = bounds
        self.step = step
        direction = .leading
        self.handleVisibility = handleVisibility
        _state = state
        self.valueLabel = valueLabel
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
                    isRangeValue: isRangeValue,
                    isHovering: isHovering,
                    isDragging: isDragging,
                    progress: lowerProgress,
                    progress2: upperProgress,
                    label: .init(content: contentView)
                )
            )
            #if os(macOS) || os(iOS)
            .onHover {
                isHovering = isEnabled && $0
                updateState()
            }
            #endif
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged {
                        isDragging = true
                        updateState()
                        dragLocationX = $0.location.x
                    }
                    .onEnded {
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
        ZStack {
            GeometryReader { proxy in
                ZStack {
                    progressView(in: proxy.size)
                    
                    if !handleVisibility.isHidden,
                       handleVisibility.isAlways || isHovering || isDragging {
                        progressHandleView(lowerProgress, size: proxy.size)
                        
                        if !handleVisibility.isHidden, isRangeValue {
                            progressHandleView(upperProgress, size: proxy.size)
                        }
                        
                        if isHovering || isDragging {
                            scaleView(in: proxy.size)
                        }
                    } else if isRangeValue, abs(upperProgress - lowerProgress) < 0.01 {
                        progressHandleView(lowerProgress, size: proxy.size)
                    } else if direction == .center && abs(lowerProgress - 0.5) < 0.02 {
                        progressHandleView(lowerProgress, size: proxy.size)
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onChange(of: dragLocationX) { onDragLocationXChange($0, size: proxy.size) }
            }
            
            HStack(content: valueLabel)
                .padding(.horizontal, .labelPadding)
        }
        .opacity(isEnabled ? 1 : 0.5)
        #if os(macOS)
        .frame(minHeight: 24)
        #else
        .frame(minHeight: 44)
        #endif
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Progress View

private extension CompactSlider {
    
    func progressView(in size: CGSize) -> some View {
        Rectangle()
            .fill(
                isHovering || isDragging
                ? Color.accentColor.opacity(0.3)
                : secondaryAppearance.color.opacity(secondaryAppearance.progressOpacity)
            )
            .frame(width: progressWidth(size))
            .offset(x: progressOffsetX(size))
    }
    
    func progressWidth(_ size: CGSize) -> CGFloat {
        if isRangeValue {
            return size.width * abs(upperProgress - lowerProgress)
        }
        
        if direction == .trailing {
            return size.width * (1 - lowerProgress)
        }
        
        if direction == .center {
            return size.width * abs(0.5 - lowerProgress)
        }
        
        return size.width * lowerProgress
    }
    
    func progressOffsetX(_ size: CGSize) -> CGFloat {
        let width = progressWidth(size)
        
        if isRangeValue {
            let offset = size.width * ((1 - (upperProgress - lowerProgress)) / -2 + lowerProgress)
            
            DispatchQueue.main.async {
                adjustedDragLocationX = (offset - width / 2, offset + width / 2)
                updateState()
            }
            
            return offset
        }
        
        let offset: CGFloat
        
        if direction == .trailing {
            offset = size.width * lowerProgress / 2
        } else if direction == .center {
            offset = size.width * (lowerProgress - 0.5) / 2
        } else {
            offset = size.width * (1 - lowerProgress) / -2
        }
        
        DispatchQueue.main.async {
            adjustedDragLocationX = (offset + width / 2, 0)
            updateState()
        }
        
        return offset
    }
}

// MARK: - Progress Handle View

private extension CompactSlider {
    func progressHandleView(_ progress: Double, size: CGSize) -> some View {
        Group {
            if handleVisibility.width > 0 {
                Rectangle()
                    .fill(
                        isHovering || isDragging
                        ? Color.accentColor
                        : secondaryAppearance.color.opacity(secondaryAppearance.handleOpacity)
                    )
                    .frame(width: handleVisibility.width)
                    .offset(x: (size.width - handleVisibility.width) * (progress - 0.5))
            }
        }
    }
}

// MARK: - Scale View

private extension CompactSlider {
    @ViewBuilder
    func scaleView(in size: CGSize) -> some View {
        Scale(count: steps > 0 ? steps : 49)
            .stroke(
                secondaryAppearance.color.opacity(
                    steps > 0 ? secondaryAppearance.scaleOpacity : secondaryAppearance.smallScaleOpacity
                ),
                lineWidth: 0.5
            )
            .frame(height: .scaleMin)
            .offset(y: (size.height - 3) / -2)
        
        if steps == 0 {
            Scale(count: 9)
                .stroke(secondaryAppearance.color.opacity(secondaryAppearance.scaleOpacity), lineWidth: 0.5)
                .frame(height: .scaleMax)
                .offset(y: (size.height - 5) / -2)
        }
    }
}

// MARK: - On Change

private extension CompactSlider {
    
    func onDragLocationXChange(_ newValue: CGFloat, size: CGSize) {
        guard !bounds.isEmpty else { return }
        
        let newProgress = max(0, min(1, newValue / size.width))
        let isProgress2Nearest: Bool
        
        // Check which progress is closest and should be in focus.
        if abs(upperProgress - lowerProgress) < 0.01 {
            isProgress2Nearest = newProgress > upperProgress
        } else {
            isProgress2Nearest = isRangeValue && abs(lowerProgress - newProgress) > abs(upperProgress - newProgress)
        }
        
        guard progressStep > 0 else {
            if isProgress2Nearest {
                upperProgress = newProgress
            } else {
                lowerProgress = newProgress
            }
            
            return
        }
        
        let rounded = (newProgress / progressStep).rounded() * progressStep
        
        if isProgress2Nearest {
            if rounded != upperProgress {
                upperProgress = rounded
            }
        } else if rounded != lowerProgress {
            lowerProgress = rounded
        }
    }
    
    func onLowerProgressChange(_ newValue: Double) {
        isLowerValueChangingInternally = true
        lowerValue = convertProgressToValue(newValue)
        DispatchQueue.main.async { isLowerValueChangingInternally = false }
    }
    
    func onUpperProgressChange(_ newValue: Double) {
        isUpperValueChangingInternally = true
        upperValue = convertProgressToValue(newValue)
        DispatchQueue.main.async { isUpperValueChangingInternally = false }
    }
    
    func convertProgressToValue(_ newValue: Double) -> Value {
        let value = bounds.lowerBound + Value(newValue) * bounds.length
        return step > 0 ? (value / step).rounded() * step : value
    }
    
    func onLowerValueChange(_ newValue: Value) {
        if isLowerValueChangingInternally { return }
        lowerProgress = convertValueToProgress(newValue)
    }
    
    func onUpperValueChange(_ newValue: Value) {
        if isUpperValueChangingInternally { return }
        upperProgress = convertValueToProgress(newValue)
    }
    
    func convertValueToProgress(_ newValue: Value) -> Double {
        let length = Double(bounds.length)
        return length != 0 ? Double(newValue - bounds.lowerBound) / length : 0
    }
    
    func updateState() {
        guard state.isActive else { return }
        
        state = .init(
            isHovering: isHovering,
            isDragging: isDragging,
            lowerProgress: lowerProgress,
            upperProgress: upperProgress,
            dragLocationX: adjustedDragLocationX
        )
    }
}

// MARK: - Direction

/// A direction in which the slider will indicate the selected value.
public enum CompactSliderDirection {
    /// The selected value will be indicated from the lower left-hand area of the boundary.
    case leading
    /// The selected value will be indicated from the centre.
    case center
    /// The selected value will be indicated from the upper right-hand area of the boundary.
    case trailing
}

// MARK: - Handle Visibility

extension CompactSlider {
    /// A handle visibility determines the rules for showing the handle.
    public enum HandleVisibility {
        /// Shows the handle when hovering.
        case hovering(width: CGFloat)
        /// Always shows the handle.
        case always(width: CGFloat)
        /// Never shows the handle.
        case hidden
        
        /// Default value.
        public static var standard: HandleVisibility {
            #if os(macOS)
            .hovering(width: 3)
            #else
            .always(width: 3)
            #endif
        }
        
        var isHovering: Bool {
            if case .hovering = self {
                return true
            }
            
            return false
        }
        
        var isAlways: Bool {
            if case .always = self {
                return true
            }
            
            return false
        }
        
        var isHidden: Bool {
            if case .hidden = self {
                return true
            }
            
            return false
        }
        
        var width: CGFloat {
            switch self {
            case .hovering(width: let width),
                 .always(width: let width):
                return width
            case .hidden:
                return 0
            }
        }
    }
}

// MARK: - State

/// Represents the current slider state
public struct CompactSliderState {
    /// Returns true when the cursor is over the slider (macOS, iPadOS).
    public let isHovering: Bool
    /// Returns true when dragging the handle.
    public let isDragging: Bool
    /// The progress type represents the position of the given value within bounds, mapped into 0...1.
    /// This progress should be used to track a single value or a lower value for a range of values.
    public let lowerProgress: Double
    /// The progress type represents the position of the given value within bounds, mapped into 0...1.
    /// This progress should only be used to track the upper value for the range of values.
    public let upperProgress: Double
    /// Position of the handle while dragging it.
    public let dragLocationX: (lower: CGFloat, upper: CGFloat)
    
    /// A flag for internal usage.
    var isActive = true
    
    /// Initial state for the state.
    public static let zero = CompactSliderState(
        isHovering: false,
        isDragging: false,
        lowerProgress: 0,
        upperProgress: 0,
        dragLocationX: (0, 0)
    )
    
    /// Inactive state, which will be ignored for updates.
    public static let inactive: CompactSliderState = {
        var state = CompactSliderState(
            isHovering: false,
            isDragging: false,
            lowerProgress: 0,
            upperProgress: 0,
            dragLocationX: (0, 0)
        )
        
        state.isActive = false
        return state
    }()
}

// MARK: - Scale

private extension CompactSlider {
    /// A shape that draws a scale of possible values.
    struct Scale: Shape {
        let count: Int
        var minSpacing: CGFloat = 3
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                guard count > 0, minSpacing > 1 else { return }
                
                let spacing = max(minSpacing, rect.width / CGFloat(count + 1))
                var x = spacing
                
                for _ in 0..<count {
                    path.move(to: .init(x: x, y: 0))
                    path.addLine(to: .init(x: x, y: rect.maxY))
                    x += spacing
                    
                    if x > rect.maxX {
                        break
                    }
                }
            }
        }
    }
}

// MARK: - Range

private extension ClosedRange where Bound: BinaryFloatingPoint {
    var length: Bound { upperBound - lowerBound }
}

// MARK: - Preview

struct CompactSlider_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            contentView.preferredColorScheme(.light)
            contentView.preferredColorScheme(.dark)
        }
        .padding()
    }
    
    private static var contentView: some View {
        VStack(spacing: 16) {
            Text("CompactSlider")
                .font(.title.bold())
            
            Group {
                // 1. The default case.
                CompactSlider(value: .constant(0.5)) {
                    Text("Default (leading)")
                    Spacer()
                    Text("0.5")
                }
                
                // Handle in the centre for better representation of negative values.
                // 2.1. The value is 0, which should show the handle as there is no value to show.
                CompactSlider(value: .constant(0.0), in: -1.0...1.0, direction: .center) {
                    Text("Center -1.0...1.0")
                    Spacer()
                    Text("0.0")
                }
                
                // 2.2. When the value is not 0, the value can be shown with a rectangle.
                CompactSlider(value: .constant(0.3), in: -1.0...1.0, direction: .center) {
                    Text("Center -1.0...1.0")
                    Spacer()
                    Text("0.3")
                }
                
                // 3. The value is filled in on the right-hand side.
                CompactSlider(value: .constant(0.3), direction: .trailing) {
                    Text("Trailing")
                    Spacer()
                    Text("0.3")
                }
                
                // 4. Set a range of values in specific step to change.
                CompactSlider(value: .constant(70), in: 0...200, step: 10) {
                    Text("Snapped")
                    Spacer()
                    Text("70")
                }
                
                // 4. Set a range of values in specific step to change from the center.
                CompactSlider(value: .constant(0.0), in: -10...10, step: 1, direction: .center) {
                    Text("Center")
                    Spacer()
                    Text("0.0")
                }
            }
            
            Divider()
            
            // Prominent style.
            Group {
                CompactSlider(value: .constant(0.5)) {
                    Text("Default")
                    Spacer()
                    Text("0.5")
                }
                .compactSliderStyle(
                    .prominent(
                        lowerColor: .purple,
                        upperColor: .pink,
                        useGradientBackground: true
                    )
                )
                
                // Get the range of values.
                VStack(spacing: 16) {
                    CompactSlider(from: .constant(0.4), to: .constant(0.7)) {
                        Text("Range")
                        Spacer()
                        Text("0.2 - 0.7")
                    }
                    
                    // Switch back to the `.default` style.
                    CompactSlider(from: .constant(0.4), to: .constant(0.7)) {
                        Text("Range")
                        Spacer()
                        Text("0.2 - 0.7")
                    }
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
            
            Spacer()
        }
    }
}
