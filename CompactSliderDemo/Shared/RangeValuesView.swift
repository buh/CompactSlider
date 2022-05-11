// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct RangeValuesView: View {
    
    @State private var lowerValue: Double = 0.4
    @State private var upperValue: Double = 0.6
    @State private var lowerValue2: Double = 8
    @State private var upperValue2: Double = 17

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Range Values").font(.headline)
                
                // A simple example for range values.
                CompactSlider(from: $lowerValue, to: $upperValue) {
                    Text("Range")
                    Spacer()
                    Text(String(format: "%.2f - %.2f", lowerValue, upperValue))
                        .monospacedDigitIfPossible()
                }
                
                Divider()
                Text("Stepped Range Values").font(.headline)
                
                // A range values with a step.
                #if os(watchOS)
                Text("Working hours:")
                CompactSlider(from: $lowerValue2, to: $upperValue2, in: 1...27, step: 1) {
                    Text("\(zeroLeadingHours(lowerValue2)) - \(zeroLeadingHours(upperValue2))")
                        .monospacedDigitIfPossible()
                }
                .padding(.top, -16)
                #else
                HStack {
                    CompactSlider(from: $lowerValue2, to: $upperValue2, in: 1...27, step: 1) {
                        Text("Working hours")
                        Spacer()
                        Text("from \(zeroLeadingHours(lowerValue2)) to \(zeroLeadingHours(upperValue2))")
                            .monospacedDigitIfPossible()
                    }
                }
                #endif
                
                Spacer()
            }
        }
        #if os(macOS) || os(iOS)
        .padding()
        #endif
    }
    
    private func zeroLeadingHours(_ value: Double) -> String {
        let hours = Int(value) % 24
        return "\(hours < 10 ? "0" : "")\(hours):00"
    }
}

struct RangeValuesView_Previews: PreviewProvider {
    static var previews: some View {
        RangeValuesView()
            #if os(macOS)
            .padding()
            .frame(width: 600, height: 500)
            #endif
    }
}
