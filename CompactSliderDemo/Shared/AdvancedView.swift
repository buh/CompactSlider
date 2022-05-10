// The MIT License (MIT)
//
// Copyright (c) 2022 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct AdvancedView: View {
    
    @State private var defaultValue: Double = 0.5
    @State private var defaultValue2: Double = 25
    @State private var defaultValue3: Double = 0.5
    @State private var lowerValue: Double = 0.3
    @State private var upperValue: Double = 0.7
    
    @State private var displayDuration: TimeInterval = 2.0
    @State private var displayDurationSliderState: CompactSliderState = .zero
    @State private var opacity: CGFloat = 0.75
    @State private var opacitySliderState: CompactSliderState = .zero
    
    @State private var sliderState: CompactSliderState = .zero
    @State private var sliderState2: CompactSliderState = .zero
    
    @State private var gradient = Gradient(colors: [.green, .yellow, .red])
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Prominent Style")
                    .font(.headline)
                
                CompactSlider(value: $defaultValue, direction: .center) {
                    Text("Green or Red")
                    Spacer()
                    Text(String(format: "%.2f", defaultValue))
                        .monospacedDigitIfPossible()
                }
                .compactSliderStyle(
                    .prominent(
                        lowerColor: .green,
                        upperColor: .red
                    )
                )
                
                #if os(watchOS)
                Text("Speed:")
                CompactSlider(value: $defaultValue2, in: 0...180, step: 5) {
                    Text("\(Int(defaultValue2))")
                        .monospacedDigitIfPossible()
                }
                .compactSliderStyle(
                    .prominent(
                        lowerColor: .green,
                        upperColor: .red,
                        useGradientBackground: true
                    )
                )
                .padding(.top, -16)
                #else
                HStack {
                    Text("Speed (with background):")
                    CompactSlider(value: $defaultValue2, in: 0...180, step: 5) {}
                        .compactSliderStyle(
                            .prominent(
                                lowerColor: .green,
                                upperColor: .red,
                                useGradientBackground: true
                            )
                        )
                    Text("\(Int(defaultValue2))")
                        .monospacedDigitIfPossible()
                }
                #endif
                
                Divider()
                Text("Custom Layout").font(.headline)
                customStyleWithJumpingValue
                
                #if os(macOS)
                Divider()
                displayOptionAndOpacity
                #endif
                
                Spacer()
            }
        }
        #if os(macOS) || os(iOS)
        .padding()
        #endif
    }
    
    @ViewBuilder
    private var customStyleWithJumpingValue: some View {
        ZStack {
            CompactSlider(
                value: $defaultValue3,
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
                        LinearGradient(
                            colors: [.green, .green, .yellow, .yellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                )
                .offset(
                    x: sliderState2.dragLocationX.lower
                    + (sliderState2.dragLocationX.upper - sliderState2.dragLocationX.lower) / 2
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
    }
    
    private var jumpOffsetY: CGFloat {
        #if os(macOS)
        -30
        #else
        -40
        #endif
    }
    
    private var displayOptionAndOpacity: some View {
        HStack(spacing: 16) {
            Spacer()
            
            VStack(alignment: .trailing, spacing: 24) {
                Text("Display Duration")
                
                HStack {
                    Text("Opacity")
                    Circle()
                        .fill(.orange.opacity(opacity))
                        .frame(width: 25, height: 25)
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 4)
                        )
                }
            }
            .padding(.top, 6)
            
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    if #available(watchOSApplicationExtension 8.0, *) {
                        Button {
                            displayDuration = max(0.5, displayDuration - 0.1)
                        } label: {
                            Image(systemName: "tortoise.fill")
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    ZStack {
                        CompactSlider(value: $displayDuration, in: 0.5...3.5, step: 0.1, state: $displayDurationSliderState) {}
                            .frame(width: 250)
                            .compactSliderSecondaryColor(.blue, progressOpacity: 0.2, focusedProgressOpacity: 0.4)
                        
                        Text("\(String(format: "%0.1f", 4 - displayDuration))s")
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 4).fill(.white)
                                    .shadow(radius: 3, y: 2)
                            )
                            .offset(
                                x: displayDurationSliderState.dragLocationX.lower * 0.9
                            )
                            .allowsHitTesting(false)
                    }
                    
                    if #available(watchOSApplicationExtension 8.0, *) {
                        Button {
                            displayDuration = min(3.5, displayDuration + 0.1)
                        } label: {
                            Image(systemName: "hare.fill")
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
                ZStack {
                    CompactSlider(value: $opacity, state: $opacitySliderState) {}
                        .frame(width: 250)
                        .compactSliderSecondaryColor(
                            .orange,
                            progressOpacity: 0.35,
                            focusedProgressOpacity: opacity
                        )
                    
                    Text("\(Int(opacity * 100))%")
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 4).fill(.white)
                                .shadow(radius: 3, y: 2)
                        )
                        .offset(
                            x: opacitySliderState.dragLocationX.lower * 0.9
                        )
                        .allowsHitTesting(false)
                }
            }
            
            Spacer()
        }
    }
}

struct AdvancedView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedView()
            #if os(macOS)
            .padding()
            .frame(width: 600, height: 500)
            #endif
    }
}
