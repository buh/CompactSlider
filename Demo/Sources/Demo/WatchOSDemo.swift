// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct WatchOSDemo: View {
    enum Style {
        case horizontal, vertical, grid, circularGrid
    }
    
    @State var value = 0.3
    @State var values: [Double] = [0.2, 0.5, 0.8]
    @State var point = CGPoint(x: 50, y: 50)
    @State var pointWithStep = CGPoint(x: 50, y: 50)
    @State var polarPoint: CompactSliderPolarPoint = .zero
    
    let style: Style
    
    var body: some View {
        switch style {
        case .horizontal:
            VStack(spacing: 16) {
                linearSliders()
                    .frame(height: 30)
            }
        case .vertical:
            HStack(spacing: 16) {
                linearSliders(isVertical: true)
                    .compactSliderStyle(default: .vertical())
                    .frame(width: 30)
            }
        case .grid:
            CompactSlider(
                point: $point,
                in: .zero ... CGPoint(x: 100, y: 100),
                step: .init(x: 10, y: 10)
            )
            .aspectRatio(1, contentMode: .fit)
        case .circularGrid:
            CompactSlider(polarPoint: $polarPoint)
        }
    }
    
    func linearSliders(isVertical: Bool = false) -> some View {
        Group {
            CompactSlider(value: $value)
            CompactSlider(values: $values)
            CompactSlider(value: $value)
                .compactSliderStyle(
                    default: isVertical ? .vertical(clipShapeStyle: .none) : .horizontal(clipShapeStyle: .none)
                )
                .compactSliderHandleStyle(.circle(progressAlignment: .inside, color: .gray, radius: 15, strokeStyle: .init(lineWidth: 2)))
                .compactSliderProgress { _ in
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.accentColor.opacity(0.2), .accentColor.opacity(0.8)],
                                startPoint: isVertical ? .bottom : .leading,
                                endPoint: isVertical ? .top : .trailing
                            )
                        )
                }
                .compactSliderBackground { configuration, padding in
                    Capsule()
                        .fill(Defaults.backgroundColor)
                }
        }
    }
}

#Preview("Watch Horizontal") {
    WatchOSDemo(style: .horizontal)
        .padding()
        .accentColor(.pink)
}

#Preview("Watch Vertical") {
    WatchOSDemo(style: .vertical)
        .padding()
        .accentColor(.pink)
}

#Preview("Watch Grid") {
    WatchOSDemo(style: .grid)
        .accentColor(.pink)
}

#Preview("Watch Circular Grid") {
    WatchOSDemo(style: .circularGrid)
        .accentColor(.pink)
}
