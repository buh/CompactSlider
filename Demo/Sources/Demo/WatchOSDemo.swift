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
            VStack {
                Group {
                    CompactSlider(value: $value)
                    CompactSlider(values: $values)
                }
                .frame(height: 40)
            }
        case .vertical:
            HStack {
                Group {
                    CompactSlider(value: $value)
                    CompactSlider(values: $values)
                }
                .compactSliderStyle(default: .vertical())
                .frame(width: 40)
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
}

#Preview("Horizontal") {
    WatchOSDemo(style: .horizontal)
        .accentColor(.pink)
}

#Preview("Vertical") {
    WatchOSDemo(style: .vertical)
        .accentColor(.pink)
}

#Preview("Grid") {
    WatchOSDemo(style: .grid)
        .accentColor(.pink)
}

#Preview("Circular Grid") {
    WatchOSDemo(style: .circularGrid)
        .accentColor(.pink)
}
