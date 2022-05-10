// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct SingleValueView: View {
    
    @State private var defaultValue: Double = 0.5
    @State private var defaultValue2: Double = 0.0
    @State private var defaultValue3: Double = 0.0
    @State private var stepValue: Double = 50
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Single Value").font(.headline)
                
                // 1. The default case.
                CompactSlider(value: $defaultValue) {
                    Text("Default")
                    Spacer()
                    Text(String(format: "%.2f", defaultValue))
                        .monospacedDigitIfPossible()
                }
                
                // 2. Handle in the centre for better representation of negative values.
                CompactSlider(value: $defaultValue2, in: -1.0...1.0, direction: .center) {
                    Text("Center")
                    Spacer()
                    Text(String(format: "%.2f", defaultValue2))
                        .monospacedDigitIfPossible()
                }
                
                // 3. The value is filled in on the right-hand side.
                CompactSlider(value: $defaultValue, direction: .trailing) {
                    Text("Trailing")
                    Spacer()
                    Text(String(format: "%.2f", defaultValue))
                        .monospacedDigitIfPossible()
                }
                
                Divider()
                Text("Snapped Value").font(.headline)
                
                // 4. Snapped value
                HStack {
                    #if os(watchOS)
                    CompactSlider(value: $stepValue, in: 0...160, step: 5) {
                        Text("Speed")
                        Spacer()
                        Text("\(Int(stepValue))")
                    }
                    #else
                    Text("Speed (with step 5):")
                    CompactSlider(value: $stepValue, in: 0...160, step: 5) {}
                    Text("\(Int(stepValue))")
                        .monospacedDigitIfPossible()
                    #endif
                }
                
                // 5. Handle in the centre for better representation of negative values.
                CompactSlider(value: $defaultValue3, in: -1.0...1.0, step: 0.1, direction: .center) {
                    #if os(watchOS)
                    Text("Center")
                    #else
                    Text("Center (step 10%)")
                    #endif
                    Spacer()
                    Text("\(Int(100 * defaultValue3))%")
                        .monospacedDigitIfPossible()
                }
                
                Spacer()
            }
            #if os(macOS) || os(iOS)
            .padding()
            #endif
        }
    }
}

struct SingleValueView_Previews: PreviewProvider {
    static var previews: some View {
        SingleValueView()
            #if os(macOS)
            .padding()
            .frame(width: 600, height: 500)
            #endif
    }
}
