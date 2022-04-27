//
//  ContentView.swift
//  Shared
//
//  Created by bukhtin on 25/04/2022.
//

import SwiftUI
import CompactSlider

struct ContentView: View {
    
    @State private var defaultValue: Double = 0.5
    @State private var defaultValue2: Double = 0.0
    @State private var stepValue: Double = 50
    @State private var lowerValue: Double = 0.4
    @State private var upperValue: Double = 0.6
    
    var body: some View {
        VStack(spacing: 16) {
            Text("CompactSlider")
                .font(.title.bold())
            
            // 1. The default case.
            CompactSlider(value: $defaultValue) { _ in
                Text("Default (leading)")
                Spacer()
                Text(String(format: "%.2f", defaultValue))
            }
            
            // 2. Handle in the centre for better representation of negative values.
            CompactSlider(value: $defaultValue2, in: -1.0...1.0, direction: .center) { _ in
                Text("Center -1.0...1.0")
                Spacer()
                Text(String(format: "%.2f", defaultValue2))
            }
            
            // 3. The value is filled in on the right-hand side.
            CompactSlider(value: $defaultValue, direction: .trailing) { _ in
                Text("Trailing")
                Spacer()
                Text(String(format: "%.2f", defaultValue))
            }
            
            // 4. Set a range of values in specific step to change.
            CompactSlider(value: $stepValue, in: 0...100, step: 5) { _ in
                Text("Snapped")
                Spacer()
                Text("\(Int(stepValue))")
            }
            
            // 5. Get the range of values.
            // Colourful version with `.prominent` style.
            VStack {
                CompactSlider(from: $lowerValue, to: $upperValue) { _ in
                    Text("Range")
                    Spacer()
                    Text(String(format: "%.2f - %.2f", lowerValue, upperValue))
                }
                
                CompactSlider(value: $lowerValue) { _ in
                    Text("Default")
                    Spacer()
                    Text(String(format: "%.2f", lowerValue))
                }
                
                // Switch back to the `.default` style.
                CompactSlider(from: $lowerValue, to: $upperValue) { _ in
                    Text("Range")
                    Spacer()
                    Text(String(format: "%.2f - %.2f", lowerValue, upperValue))
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
            
            // 6. Custom height.
            CompactSlider(value: $defaultValue) { _ in
                Text("Bigger height")
                    .padding()
                Spacer()
                Text(String(format: "%.2f", defaultValue))
            }
            
            // 7. Show the handle at a progress position.
            GeometryReader { proxy in
                CompactSlider(
                    value: .constant(0.5),
                    handleVisibility: .hovering(width: 3)
                ) { progress in
                    Text("\(Int(100 * progress.from))%")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.accentColor))
                        .offset(
                            x: max(
                                proxy.size.width / -2 + 30,
                                min(
                                    proxy.size.width / 2 - 36,
                                    proxy.size.width * (progress.from - 0.5)
                                )
                            )
                        )
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
        .padding()
        #if os(macOS)
        .frame(width: 500, height: 600)
        #endif
    }
}

private extension Double {
    var formatted: String { String(format: "%.2f", self) }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
