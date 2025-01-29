// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct CompactSliderSystemDemo: View {
    @State private var progress: Double = 0.1
    
    var body: some View {
        VStack(spacing: 20) {
            Text("System Slider")
            Slider(value:  $progress) {
                Text("Progress")
            }
            
            Text("\"System\" Sliders")
            SystemSlider(value: $progress)
            SystemSlider(value: $progress, step: 0.1)

            SystemSlider(value: $progress, step: 0.1)
                .systemSliderStyle(.scrollableHorizontal)
            
            Text("Vertical \"System\" Sliders")
            
            HStack(spacing: 20) {
                SystemSlider(value: $progress)
                    .systemSliderStyle(.vertical)
                
                SystemSlider(value: $progress)
                    .systemSliderStyle(.scrollableVertical)
                    .compactSliderOptionsByAdding(.loopValues)
            }
            .frame(maxHeight: 250)
        }
        .padding()
        .compactSliderOptionsByAdding(.scrollWheel)
    }
}

#Preview("System Slider") {
    CompactSliderSystemDemo()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
