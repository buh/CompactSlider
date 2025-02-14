// The MIT License (MIT)
//
// Copyright (c) 2025 Alexey Bukhtin (github.com/buh).
//

import SwiftUI
import CompactSlider

struct CompactSliderSystemDemo: View {
    @State private var progress: Double = 0.1
    
    @State private var playerTime: TimeInterval = 10
    @State private var isPlaying = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(progress, format: .percent.precision(.fractionLength(1)))")
                .monospacedDigit()
                .font(.title)
            Divider()
            Text("System slider")
            Slider(value:  $progress) {
                Text("Progress")
            }
            
            Text("\"System\" sliders")
            SystemSlider(value: $progress)
            SystemSlider(value: $progress, step: 0.1)
            
            Text("\"System\" expandable slider")
            playerView()
            
            Text("\"System\" scrollable slider")
            
            SystemSlider(value: $progress, step: 0.1)
                .systemSliderStyle(.scrollableHorizontal)
            
            Text("Vertical \"System\" sliders")
            
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
        .compactSliderOptionsByAdding(.scrollWheel, .tapToSlide)
        .compactSliderAnimation(.bouncy(duration: 0.2, extraBounce: 0.05), when: .tapping)
    }
    
    private func playerView() -> some View {
        GroupBox {
            SystemSlider(value: $playerTime, in: 0...60)
                .systemSliderStyle(handleStyle: .hidden())
                .compactSliderOptionsByAdding(.expandOnFocus(minScale: 0.5))
                .compactSliderAnimation(.bouncy, when: .dragging, .hovering)
            
            if #available(macOS 13.0, iOS 16.0, *) {
                HStack(alignment: .top) {
                    Text("\(Duration(secondsComponent: Int64(playerTime), attosecondsComponent: 0), format: .time(pattern: .minuteSecond(padMinuteToLength: 2)))")
                        .contentTransition(.numericText())
                        .foregroundStyle(.secondary)
                    Spacer()
                    
                    Button(action: { isPlaying.toggle() }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .font(.title)
                    .padding(4)
                    
                    Spacer()
                    Text("\(Duration(secondsComponent: Int64(60 - playerTime), attosecondsComponent: 0), format: .time(pattern: .minuteSecond(padMinuteToLength: 2)))")
                        .contentTransition(.numericText(countsDown: true))
                        .foregroundStyle(.secondary)
                }
                .font(.footnote)
                .monospacedDigit()
                .padding(.horizontal, 6)
            }
        }
        .onReceive(timer) { _ in
            guard isPlaying else { return }
            
            withAnimation {
                if playerTime >= 59 {
                    isPlaying = false
                    playerTime = 60
                    return
                }
                
                playerTime += 1
            }
        }
    }
}

#Preview("System Slider") {
    CompactSliderSystemDemo()
        #if os(macOS)
        .frame(width: 400, height: 800, alignment: .top)
        #endif
}
