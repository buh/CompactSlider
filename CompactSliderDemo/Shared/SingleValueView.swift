// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct SingleValueView: View {
    
    @State private var defaultValue: Double = 0.5
    @State private var defaultValue2: Double = 0.0
    @State private var defaultValue3: Double = 0.0
    @State private var stepValue: Double = 50
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Single Value").font(.headline)
                    singleValueSliders

                    Divider()

                    Text("Snapped Value").font(.headline)
                    snappedValueSliders

                    Spacer()
                }
            }
            #if os(macOS) || os(iOS)
            .padding()
            #endif
        }
    }

    @ViewBuilder
    private var singleValueSliders: some View {
        // 1. The default case.
        CompactSlider(value: $defaultValue)
            .overlay(
                HStack {
                    Text("Default")
                    Spacer()
                    Text(String(format: "%.2f", defaultValue))
                        .monospacedDigitIfPossible()
                }
            )

        // 2. Handle in the centre for better representation of negative values.
        CompactSlider(value: $defaultValue2, in: -1.0...1.0, direction: .center)
            .overlay(
                HStack {
                    Text("Center")
                    Spacer()
                    Text(String(format: "%.2f", defaultValue2))
                        .monospacedDigitIfPossible()
                }
            )

        // 3. The value is filled in on the right-hand side.
        CompactSlider(value: $defaultValue, direction: .trailing)
            .overlay(
                HStack {
                    Text("Trailing")
                    Spacer()
                    Text(String(format: "%.2f", defaultValue))
                        .monospacedDigitIfPossible()
                }
            )
    }

    @ViewBuilder
    private var snappedValueSliders: some View {
        // 4. Snapped value
        HStack {
            #if os(watchOS)
            CompactSlider(value: $stepValue, in: 0...160, step: 5)
                .overlay(
                    HStack {
                        Text("Speed")
                        Spacer()
                        Text("\(Int(stepValue))")
                    }
                    .padding(.horizontal, 6)
                )
            #else
            Text("Speed:")
            CompactSlider(value: $stepValue, in: 0...160, step: 5)
            Text("\(Int(stepValue))")
                .monospacedDigitIfPossible()
            #endif
        }

        // 5. Handle in the centre for better representation of negative values.
        CompactSlider(value: $defaultValue3, in: -1.0...1.0, step: 0.1, direction: .center)
            .overlay(
                HStack {
                    #if os(watchOS)
                    Text("Center")
                    #else
                    Text("Center (step 10%)")
                    #endif
                    Spacer()
                    Text("\(Int(100 * defaultValue3))%")
                        .monospacedDigitIfPossible()
                }
            )
    }
}

#Preview {
    SingleValueView()
    #if os(macOS)
        .padding()
        .frame(width: 600, height: 500)
    #endif
}
