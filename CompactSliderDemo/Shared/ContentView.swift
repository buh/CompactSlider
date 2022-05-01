// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct ContentView: View {
    
    @State private var defaultValue: Double = 0.5
    @State private var defaultValue2: Double = 0.0
    @State private var stepValue: Double = 50
    @State private var lowerValue: Double = 0.4
    @State private var upperValue: Double = 0.6
    @State private var sliderState: CompactSliderState = .zero
    @State private var sliderState2: CompactSliderState = .zero

    var body: some View {
        VStack(spacing: 32) {
//            Text("CompactSlider")
//                .font(.title.bold())
            
            // 1. The default case.
//            CompactSlider(value: $defaultValue) {
//                Text("Default (leading)")
//                Spacer()
//                Text(String(format: "%.2f", defaultValue))
//            }
            
//            // 2. Handle in the centre for better representation of negative values.
            CompactSlider(value: $defaultValue2, in: -1.0...1.0, direction: .center) {
                Text("Center -1.0...1.0")
                Spacer()
                Text(String(format: "%.2f", defaultValue2))
            }
//
//            // 3. The value is filled in on the right-hand side.
            CompactSlider(value: $defaultValue, direction: .trailing) {
                Text("Trailing")
                Spacer()
                Text(String(format: "%.2f", defaultValue))
            }
//
//            // 4. Set a range of values in specific step to change.
//            CompactSlider(value: $stepValue, in: 0...100, step: 5) {
//                Text("Snapped")
//                Spacer()
//                Text("\(Int(stepValue))")
//            }
//
//            // 5. Get the range of values.
//            // Colourful version with `.prominent` style.
//            VStack {
//                CompactSlider(from: $lowerValue, to: $upperValue) {
//                    Text("Range")
//                    Spacer()
//                    Text(String(format: "%.2f - %.2f", lowerValue, upperValue))
//                }
//
//                CompactSlider(value: $lowerValue) {
//                    Text("Default")
//                    Spacer()
//                    Text(String(format: "%.2f", lowerValue))
//                }
//
//                // Switch back to the `.default` style.
//                CompactSlider(from: $lowerValue, to: $upperValue) {
//                    Text("Range")
//                    Spacer()
//                    Text(String(format: "%.2f - %.2f", lowerValue, upperValue))
//                }
//                .compactSliderStyle(.default)
//            }
//            // Apply a prominent style.
//            .compactSliderStyle(
//                .prominent(
//                    lowerColor: .green,
//                    upperColor: .yellow,
//                    useGradientBackground: true
//                )
//            )
//
//            // 6. Custom height.
//            CompactSlider(value: $defaultValue) {
//                Text("Bigger height")
//                    .padding()
//                Spacer()
//                Text(String(format: "%.2f", defaultValue))
//            }
//
//            // 7. Show the handle at a progress position.
            ZStack {
                CompactSlider(
                    value: $defaultValue,
                    step: 0.05,
                    handleVisibility: .hovering(width: 3),
                    state: $sliderState.animation(.easeOut(duration: 0.2))
                ) {}
                
                Text("\(Int(100 * sliderState.lowerProgress))%")
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(Capsule().fill(Color.accentColor))
                    .offset(
                        x: sliderState.dragLocationX.lower
                        + (sliderState.lowerProgress < 0.1
                           ? 30
                           : (sliderState.lowerProgress > 0.9 ? -40 : 1)),
                        y: sliderState.isDragging ? jumpOffsetY : 0
                    )
                    .allowsHitTesting(false)
            }
            
            ZStack {
                CompactSlider(
                    from: $lowerValue,
                    to: $upperValue,
//                    step: 0.05,
                    handleVisibility: .hovering(width: 3),
                    state: $sliderState2.animation(.easeOut(duration: 0.2))
                ) {}
                .compactSliderStyle(
                    .prominent(
                        lowerColor: .green,
                        upperColor: .yellow,
                        useGradientBackground: true
                    )
                )
                
                if abs(sliderState2.upperProgress - sliderState2.lowerProgress) < 0.15 {
                    HStack {
                        Text("\(Int(100 * sliderState2.lowerProgress))%")
                        Text(" - ")
                        Text("\(Int(100 * sliderState2.upperProgress))%").foregroundColor(.black)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(
                        Capsule().fill(
                            LinearGradient(colors: [.green, .green, .yellow, .yellow], startPoint: .leading, endPoint: .trailing)
                        )
                    )
                    .offset(
                        x: sliderState2.dragLocationX.lower + (sliderState2.dragLocationX.upper - sliderState2.dragLocationX.lower) / 2
                        + (sliderState2.lowerProgress < 0.1
                           ? 30
                           : (sliderState2.lowerProgress > 0.9 ? -40 : 1)),
                        y: sliderState2.isDragging ? jumpOffsetY : 0
                    )
                    .allowsHitTesting(false)
                } else {
                    Text("\(Int(100 * sliderState2.lowerProgress))%")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .foregroundColor(.white)
                        .background(Capsule().fill(Color.green))
                        .offset(
                            x: sliderState2.dragLocationX.lower
                                + (sliderState2.lowerProgress < 0.1 ? 30 : (sliderState2.lowerProgress > 0.9 ? -40 : 1)),
                            y: sliderState2.isDragging ? jumpOffsetY : 0
                        )
                        .allowsHitTesting(false)
                    
                    Text("\(Int(100 * sliderState2.upperProgress))%")
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .foregroundColor(.black)
                        .background(Capsule().fill(Color.yellow))
                        .offset(
                            x: sliderState2.dragLocationX.upper
                            + (sliderState2.upperProgress < 0.1
                               ? 30
                               : (sliderState2.upperProgress > 0.9 ? -40 : 1)),
                            y: sliderState2.isDragging ? jumpOffsetY : 0
                        )
                        .allowsHitTesting(false)
                }
            }

//            Spacer()
        }
        .padding()
        #if os(macOS)
        .frame(width: 500, height: 600)
        #endif
    }
    
    private var jumpOffsetY: CGFloat {
        #if os(macOS)
        -30
        #else
        -40
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
