// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI

public struct RectangleHandleView: View {
    let progress: CGFloat
    let size: CGSize
    let isHovering: Bool
    let isDragging: Bool
    
    var isFocused: Bool { isHovering || isDragging }
    
    var offsetX: CGFloat {
        (size.width - 3) * progress
    }
    
    public var body: some View {
        Rectangle()
            .fill(isFocused ? Color.accentColor : Color.gray)
            .frame(width: 3)
            .offset(x: offsetX)
    }
}

public extension CompactSlider where HandleView == RectangleHandleView {
    init(
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        direction: CompactSliderDirection = .leading,
        scaleVisibility: ScaleVisibility = .hovering,
        minHeight: CGFloat = .compactSliderMinHeight,
        maxHeight: CGFloat? = nil,
        gestureOptions: Set<GestureOption> = .default,
        state: Binding<CompactSliderState> = .constant(.inactive)
    ) {
        self.init(
            value: value,
            in: bounds,
            step: step,
            direction: direction,
            scaleVisibility: scaleVisibility,
            minHeight: minHeight,
            maxHeight: maxHeight,
            gestureOptions: gestureOptions,
            state: state,
            handle: { progress, size, isHovering, isDragging in
                RectangleHandleView(progress: progress, size: size, isHovering: isHovering, isDragging: isDragging)
            }
        )
    }
    
    init(
        from lowerValue: Binding<Value>,
        to upperValue: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value = 0,
        scaleVisibility: ScaleVisibility = .hovering,
        minHeight: CGFloat = .compactSliderMinHeight,
        maxHeight: CGFloat? = nil,
        gestureOptions: Set<GestureOption> = .default,
        state: Binding<CompactSliderState> = .constant(.inactive)
    ) {
        self.init(
            from: lowerValue,
            to: upperValue,
            in: bounds,
            step: step,
            scaleVisibility: scaleVisibility,
            minHeight: minHeight,
            maxHeight: maxHeight,
            gestureOptions: gestureOptions,
            state: state,
            handle: { progress, size, isHovering, isDragging in
                RectangleHandleView(progress: progress, size: size, isHovering: isHovering, isDragging: isDragging)
            }
        )
    }
}
