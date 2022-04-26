// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct CompactSlider<Value: BinaryFloatingPoint, ValueLabel: View>: View {
    
    @Environment(\.compactSliderStyle) var compactSliderStyle
    @Environment(\.isEnabled) var isEnabled
    
    @Binding private var fromValue: Value
    @Binding private var toValue: Value
    private let scaleRange: ClosedRange<Value>
    private let scaleStep: Value
    private let isRangeValue: Bool
    private let direction: CompactSliderDirection
    @ViewBuilder private var valueLabel: () -> ValueLabel
    
    private var progressStep: Double = 0
    private var steps: Int = 0
    @State private var isValueChangingInternally = false
    @State private var isValue2ChangingInternally = false
    @State private var isHovering = false
    @State private var isDragging = false
    @State private var progress: Double = 0
    @State private var progress2: Double = 0
    @State private var dragLocationX: CGFloat = 0
    
    public init(
        value: Binding<Value>,
        in range: ClosedRange<Value> = 0...1,
        step: Value = 0,
        direction: CompactSliderDirection = .leading,
        @ViewBuilder valueLabel: @escaping () -> ValueLabel
    ) {
        _fromValue = value
        _toValue = .constant(0)
        isRangeValue = false
        scaleRange = range
        scaleStep = step
        self.direction = direction
        self.valueLabel = valueLabel
        let rangeLength = Double(range.length)
        
        guard rangeLength > 0 else { return }
        
        _progress = State(wrappedValue: Double(value.wrappedValue - range.lowerBound) / rangeLength)
        
        if step > 0 {
            progressStep = Double(step) / rangeLength
            steps = Int((rangeLength / Double(step)).rounded(.towardZero) - 1)
        }
    }
    
    public init(
        from value: Binding<Value>,
        to value2: Binding<Value>,
        in range: ClosedRange<Value> = 0...1,
        step: Value = 0,
        @ViewBuilder valueLabel: @escaping () -> ValueLabel
    ) {
        _fromValue = value
        _toValue = value2
        isRangeValue = true
        scaleRange = range
        scaleStep = step
        direction = .leading
        self.valueLabel = valueLabel
        let rangeLength = Double(range.length)
        
        guard rangeLength > 0 else { return }
        
        _progress = State(wrappedValue: Double(value.wrappedValue - range.lowerBound) / rangeLength)
        _progress2 = State(wrappedValue: Double(value2.wrappedValue - range.lowerBound) / rangeLength)
        
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
                    progress: progress,
                    progress2: progress2,
                    label: .init(content: contentView)
                )
            )
            #if os(macOS) || os(iOS)
            .onHover { isHovering = isEnabled && $0 }
            #endif
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged {
                        isDragging = true
                        dragLocationX = $0.location.x
                    }
                    .onEnded {
                        isDragging = false
                        dragLocationX = $0.location.x
                    }
            )
            .onChange(of: progress, perform: onProgressChange)
            .onChange(of: progress2, perform: onProgress2Change)
            .onChange(of: fromValue, perform: onValueChange)
            .onChange(of: toValue, perform: onValue2Change)
            .animation(nil, value: fromValue)
            .animation(nil, value: toValue)
    }
    
    private var contentView: some View {
        ZStack {
            GeometryReader { proxy in
                ZStack(alignment: .center) {
                    progressView(in: proxy.size)
                    
                    if isHovering || isDragging {
                        progressHandlerView(progress, size: proxy.size)
                        
                        if isRangeValue {
                            progressHandlerView(progress2, size: proxy.size)
                        }
                        
                        scaleView(in: proxy.size)
                    } else if direction == .center && abs(progress - 0.5) < 0.02 {
                        progressHandlerView(progress, size: proxy.size)
                    } else if isRangeValue, abs(progress2 - progress) < 0.01 {
                        progressHandlerView(progress, size: proxy.size)
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onChange(of: dragLocationX) { onDragLocationXChange($0, size: proxy.size) }
            }
            
            HStack(content: valueLabel)
                .padding(.horizontal, .labelPadding)
                .foregroundColor(Color.label.opacity(isHovering || isDragging ? 1 : 0.7))
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
                : Color.label.opacity(0.075)
            )
            .frame(width: progressWidth(size))
            .offset(x: progressOffsetX(size))
    }
    
    func progressWidth(_ size: CGSize) -> CGFloat {
        if isRangeValue {
            return size.width * abs(progress2 - progress)
        }
        
        if direction == .trailing {
            return size.width * (1 - progress)
        }
        
        if direction == .center {
            return size.width * abs(0.5 - progress)
        }
        
        return size.width * progress
    }
    
    func progressOffsetX(_ size: CGSize) -> CGFloat {
        if isRangeValue {
            return size.width * ((1 - (progress2 - progress)) / -2 + progress)
        }
        
        if direction == .trailing {
            return size.width * progress / 2
        }
        
        if direction == .center {
            return size.width * (progress - 0.5) / 2
        }
        
        return size.width * (1 - progress) / -2
    }
}

// MARK: - Progress Handler View

private extension CompactSlider {
    func progressHandlerView(_ progress: Double, size: CGSize) -> some View {
        Rectangle()
            .fill(isHovering || isDragging ? Color.accentColor : Color.label.opacity(0.2))
            .frame(width: 3)
            .offset(x: (size.width - 3) * (progress - 0.5))
    }
}

// MARK: - Scale View

private extension CompactSlider {
    @ViewBuilder
    func scaleView(in size: CGSize) -> some View {
        Scale(count: steps > 0 ? steps : 49)
            .stroke(Color.label.opacity(steps > 0 ? 0.8 : 0.3), lineWidth: 0.5)
            .frame(height: .scaleMin)
            .offset(y: (size.height - 3) / -2)
        
        if steps == 0 {
            Scale(count: 9)
                .stroke(Color.label.opacity(0.8), lineWidth: 0.5)
                .frame(height: .scaleMax)
                .offset(y: (size.height - 5) / -2)
        }
    }
}

// MARK: - On Change

private extension CompactSlider {
    
    func onDragLocationXChange(_ newValue: CGFloat, size: CGSize) {
        guard !scaleRange.isEmpty else { return }
        
        let newProgress = max(0, min(1, newValue / size.width))
        let isProgress2Nearest: Bool
        
        // Check which progress is closest and should be in focus.
        if abs(progress2 - progress) < 0.01 {
            isProgress2Nearest = newProgress > progress2
        } else {
            isProgress2Nearest = isRangeValue && abs(progress - newProgress) > abs(progress2 - newProgress)
        }
        
        guard progressStep > 0 else {
            if isProgress2Nearest {
                progress2 = newProgress
            } else {
                progress = newProgress
            }
            
            return
        }
        
        let rounded = (newProgress / progressStep).rounded() * progressStep
        
        if isProgress2Nearest {
            if rounded != progress2 {
                progress2 = rounded
            }
        } else if rounded != progress {
            progress = rounded
        }
    }
    
    func onProgressChange(_ newValue: Double) {
        isValueChangingInternally = true
        fromValue = convertProgressToValue(newValue)
        DispatchQueue.main.async { isValueChangingInternally = false }
    }
    
    func onProgress2Change(_ newValue: Double) {
        isValue2ChangingInternally = true
        toValue = convertProgressToValue(newValue)
        DispatchQueue.main.async { isValue2ChangingInternally = false }
    }
    
    func convertProgressToValue(_ newValue: Double) -> Value {
        let value = scaleRange.lowerBound + Value(newValue) * scaleRange.length
        return scaleStep > 0 ? (value / scaleStep).rounded() * scaleStep : value
    }
    
    func onValueChange(_ newValue: Value) {
        if isValueChangingInternally { return }
        progress = convertValueToProgress(newValue)
    }
    
    func onValue2Change(_ newValue: Value) {
        if isValue2ChangingInternally { return }
        progress2 = convertValueToProgress(newValue)
    }
    
    func convertValueToProgress(_ newValue: Value) -> Double {
        let length = Double(scaleRange.length)
        return length != 0 ? Double(newValue - scaleRange.lowerBound) / length : 0
    }
}

// MARK: - Direction

public enum CompactSliderDirection {
    case leading
    case center
    case trailing
}

// MARK: - Scale

private extension CompactSlider {
    
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
            contentView
                .preferredColorScheme(.light)
                .padding()
            
            contentView
                .preferredColorScheme(.dark)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
    
    private static var contentView: some View {
        VStack(spacing: 16) {
            // 1. The default case.
            CompactSlider(value: .constant(0.5)) {
                Text("Default (leading)")
                Spacer()
                Text("0.5")
            }
            
            // Handler in the centre for better representation of negative values.
            // 2.1. The value is 0, which should show the handler as there is no value to show.
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
            
            // 5. Get the range of values.
            VStack {
                // Colourful version with `.prominent` style.
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
            // Apply a prominent style.
            .compactSliderStyle(
                .prominent(
                    lowerColor: .green,
                    upperColor: .yellow,
                    useGradientBackground: true
                )
            )
        }
    }
}
