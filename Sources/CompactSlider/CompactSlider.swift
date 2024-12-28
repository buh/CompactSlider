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
    let gestureOptions: Set<GestureOption>
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
    ///   - type: the slider type in which the slider will indicate the selected value.
    ///   - gestureOptions: a set of drag gesture options: minimum drag distance, delayed touch, and high priority.
    public init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        type: CompactSliderType = .horizontal(.leading),
        gestureOptions: Set<GestureOption> = .default
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
        alignment: Axis = .horizontal,
        gestureOptions: Set<GestureOption> = .default
    ) {
        _lowerValue = lowerValue
        _upperValue = upperValue
        _values = .constant([])
        self.bounds = bounds
        self.step = step
        self.type = alignment == .horizontal ? .horizontal(.leading) : .vertical(.top)
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
                #if os(macOS)
                .onChange(of: scrollWheelEvent) {
                    onScrollWheelChange($0, size: proxy.size, location: proxy.frame(in: .global).origin)
                }
                #endif
        }
        #if os(macOS) || os(iOS)
        .onHover {
            isHovering = isEnabled && $0
        }
        #endif
        #if os(macOS)
        .onScrollWheel(isEnabled: gestureOptions.contains(.scrollWheel)) { event in
            guard isHovering else { return }
            
            if type.isHorizontal, !event.isHorizontalDelta {
                return
            }
            
            if type.isVertical, event.isHorizontalDelta {
                return
            }
            
            Task {
                scrollWheelEvent = event
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
}

public extension CompactSlider {
    var isSingularValue: Bool { progresses.count == 1 }
    var isRangeValues: Bool { progresses.count == 2 }
    var isMultipleValues: Bool { progresses.count > 2 }

    var progress: Double { progresses.first ?? 0 }

    var lowerProgress: Double { progresses.first ?? 0 }
    
    func updateProgress(_ progress: Double, at index: Int) {
        guard index < progresses.count else { return }
        
        progresses[index] = progress
    }
    
    func updateLowerProgress(_ progress: Double) {
        updateProgress(progress, at: 0)
    }
    
    var upperProgress: Double { isRangeValues ? progresses[1] : 0 }
    
    func updateUpperProgress(_ progress: Double) {
        updateProgress(progress, at: 1)
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
    @State private var fromProgress: Double = 0.3
    @State private var toProgress: Double = 0.7
    
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
                    .compactSliderStyle(
                        .init(scaleConfiguration: .init(visibility: .always)) { configuration in
                            LinearGradient(
                                stops: [
                                    .init(color: .blue, location: configuration.progress),
                                    .init(color: .purple, location: 1),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .opacity(0.2)
                        }
                    )

                CompactSlider(value: $centerProgress, in: -10 ... 10, step: 1, type: .horizontal(.center))
                    .overlay(
                        Text("\(Int(centerProgress))")
                            .allowsHitTesting(false)
                    )
                
                CompactSlider(value: $progress, type: .horizontal(.trailing))
                
                CompactSlider(from: $fromProgress, to: $toProgress)
                    .overlay(
                        HStack {
                            Text("\(Int(fromProgress * 100))%")
                            Spacer()
                            Text("\(Int(toProgress * 100))%")
                        }
                        .padding(.horizontal, 6)
                        .allowsHitTesting(false)
                    )
            }
            .frame(maxHeight: 44)
            
            HStack {
                Group {
                    CompactSlider(value: $progress, type: .vertical(.bottom))
                        .compactSliderStyle(.init(
                            scaleConfiguration: .init(
                                visibility: .always,
                                line: .init(length: nil),
                                secondaryLine: .init(length: nil),
                                padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                            )
                        ))
                    CompactSlider(value: $centerProgress, in: -10 ... 10, step: 1, type: .vertical(.center))
                        .compactSliderStyle(.init(
                            scaleConfiguration: .init(
                                visibility: .always,
                                line: .init(length: nil),
                                padding: .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                            )
                        ))
                    CompactSlider(value: $progress, type: .vertical(.top))
                    CompactSlider(from: $fromProgress, to: $toProgress, alignment: .vertical)
                }
                .frame(maxWidth: 44)
            }
            .frame(height: 300)

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
