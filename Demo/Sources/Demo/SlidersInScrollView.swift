import SwiftUI
import CompactSlider

@available(iOS 16.0, macOS 13.0, *)
struct SlidersInScrollView: View {
    @State private var showEditSheet = false
    
    var body: some View {
        Button {
            showEditSheet = true
        } label: {
            Text("Sliders in Sheet in ScrollView")
                .font(.title2.bold())
        }
        .sheet(isPresented: $showEditSheet) {
            Sheet()
                .ignoresSafeArea()
                .presentationDetents([.fraction(0.3)])
        }
    }
}

// MARK: - Sheet

@available(iOS 16.0, macOS 13.0, *)
struct Sheet: View {
    @State private var value = 0.5
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<20) { index in
                    HStack {
                        Text("\(index < 10 ? "0": "")\(index)")
                        CustomSlider(value: $value, range: 0...1)
                        CompactSlider(value: $value)
                    }
                }
            }
            .padding()
            .padding(.bottom)
        }
        .monospacedDigit()
        .compactSliderOptionsByAdding(.simultaneousGesture)
    }
}

@available(iOS 16.0, macOS 13.0, *)
struct CustomSlider<Value: BinaryFloatingPoint>: View {
    @Binding var value: Value
    let range: ClosedRange<Value>
    
    var body: some View {
        CompactSlider(value: $value, in: range)
            .compactSliderStyle(default: .horizontal(.center, clipShapeStyle: .none))
            .compactSliderHandleStyle(.circle(radius: 9))
            .compactSliderHandle { config, _, _, _ in
                Circle()
                    .foregroundStyle(Color.accentColor)
                    .shadow(radius: 2, y: 1)
                    .animation(.linear.speed(1.5), value: config.progress)
            }
            .compactSliderBackground { config, _ in
                Capsule()
                    .fill(Color.primary.opacity(0.15))
                    .frame(height: config.focusState.isFocused ? 18 : 9)
                    .animation(.smooth.speed(2), value: config.focusState.isFocused)
            }
            .compactSliderProgress { config in
                Rectangle()
                    .fill(Color.primary.opacity(0.25))
                    .frame(height: config.focusState.isFocused ? 18 : 9)
                    .animation(.smooth.speed(2), value: config.focusState.isFocused)
                    .animation(.linear.speed(1.5), value: config.progress)
            }
    }
}

#Preview {
    if #available(iOS 16.0, macOS 13.0, *) {
        SlidersInScrollView()
    }
}
