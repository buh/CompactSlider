# Usage

A slider consists of a handle that the user moves between two extremes of a linear “track”. 
The ends of the track represent the minimum and maximum possible values. As the user moves the handle, the slider updates its bound value.

- [Single Value](#single-value)
- [Range Values](#range-values)
- [Styling](#styling)
  - [Configuration](#configuration)
  - [Secondary Appearance](#secondary-appearance)
  - [Prominent Style](#prominent-style)
- [Advanced Layout](#advanced-layout) and `CompactSliderState`

## Single value

The following example shows a slider bound to the speed value in increments of 5. As the slider updates this value, a bound Text view shows the value updating.

![Speed](https://user-images.githubusercontent.com/284922/166335247-2351777f-7ef5-440d-af8e-410fd94ce3a2.gif)

```swift
@State private var speed = 50.0

var body: some View {
    CompactSlider(value: $speed, in: 0...100, step: 5) {
        Text("Speed")
        Spacer()
        Text("\(Int(speed))")
    }
}
```

When used by default, the range of possible values is 0.0...1.0:

```swift
@State private var value = 0.5

var body: some View {
    CompactSlider(value: $value) {
        Text("Value")
        Spacer()
        String(format: "%.2f", value)
    }
}
```

Using the `alignment:` parameter you can set the alignment in which the slider will indicate the selected value:

![Alignment](https://user-images.githubusercontent.com/284922/166335936-3e4cfdac-eafa-42c6-8da7-4010751973d8.gif)

```swift
@State private var value = 0.5

var body: some View {
    CompactSlider(value: $value, alignment: .center) {
        Text("Center")
        Spacer()
        String(format: "%.2f", value)
    }
}
```

## Range values

The slider allows you to retrieve a range of values. This is possible by initialising the slider with the parameters `from:` and `to:`. 

The following example asks for a range of working hours:

![Range Values](https://user-images.githubusercontent.com/284922/166336963-7ba1ebd8-80f1-401a-b13d-b365c30748c2.gif)

```swift
@State private var lowerValue: Double = 8
@State private var upperValue: Double = 17

var body: some View {
    HStack {
        Text("Working hours:")
        CompactSlider(from: $lowerValue, to: $upperValue, in: 6...20, step: 1) {
            Text("\(zeroLeadingHours(lowerValue)) — \(zeroLeadingHours(upperValue))")
            Spacer()
        }
    }
}

private func zeroLeadingHours(_ value: Double) -> String {
    let hours = Int(value) % 24
    return "\(hours < 10 ? "0" : "")\(hours):00"
}
```

# Styling

The slider supports changing appearance and behaviour. In addition to the standard style, the [Prominent style](#prominent-style) is also available.

To implement your own style, you need to implement the `CompactSliderStyle` protocol, which contains many parameters that allow you to define the view according to user events. The styles are implemented in the same pattern as [ButtonStyle](https://developer.apple.com/documentation/swiftui/buttonstyle).

## Configuration

`CompactSliderStyleConfiguration` properties:

<img width="640" alt="Configuration" src="https://user-images.githubusercontent.com/284922/166454886-b80d7a9e-928d-46f0-b1ec-a58af7f37ff4.png">

The following example shows how to create your own style and use the configuration:

```swift
public struct CustomCompactSliderStyle: CompactSliderStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                configuration.isHovering || configuration.isDragging ? .orange : .black
            )
            .background(
                Color.orange.opacity(0.1)
            )
            .accentColor(.orange)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension CompactSliderStyle where Self == CustomCompactSliderStyle {
    public static var `custom`: CustomCompactSliderStyle { CustomCompactSliderStyle() }
}
```

And now we can apply it:

```swift
@State private var value: Double = 0.5

var body: some View {
    CompactSlider(value: $value) {
        Text("Custom Style")
        Spacer()
        Text(String(format: "%.2f", value))
    }
    .compactSliderStyle(.custom)
}
```

<img width="640" alt="custom1@2x" src="https://user-images.githubusercontent.com/284922/167266441-473bdd18-e571-4dda-8128-09122a7117f4.png">

## Secondary Appearance

The slider consists of several secondary elements, which can also be defined within their own style or directly for the slider.

1. The `.compactSliderSecondaryColor` modifier allows you to set the color and opacity for the secondary slider elements. You can simply change the base color for secondary elements: `.compactSliderSecondaryColor(.orange)`.

2. Using the other signature of the modifier: `.compactSliderSecondaryColor', the color can be set individually for each secondary element.

3. Another modifier `.compactSliderSecondaryAppearance` gives you the ability to change the `ShapeStyle` for the progress view.

Let's take the previous example and change the secondary elements:

```swift
public struct CustomCompactSliderStyle: CompactSliderStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                configuration.isHovering || configuration.isDragging ? .orange : .black
            )
            .background(
                Color.orange.opacity(0.1)
            )
            .accentColor(.orange)
            .compactSliderSecondaryColor(
                .orange,
                progressOpacity: 0.2,
                handleOpacity: 0.5,
                scaleOpacity: 1,
                secondaryScaleOpacity: 1
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
```

<img width="640" alt="Custom Style 1" src="https://user-images.githubusercontent.com/284922/167267510-a7e312d3-e955-4cd7-a5bf-dfa9a77d93bc.png">

Now change the solid color of the progress view to a gradient using the `compactSliderSecondaryAppearance' modifier:

```swift
public struct CustomCompactSliderStyle: CompactSliderStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                configuration.isHovering || configuration.isDragging ? .orange : .black
            )
            .background(
                Color.orange.opacity(0.1)
            )
            .accentColor(.orange)
            .compactSliderSecondaryAppearance(
                progressShapeStyle: LinearGradient(
                    colors: [.orange.opacity(0), .orange.opacity(0.5)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                focusedProgressShapeStyle: LinearGradient(
                    colors: [.yellow.opacity(0.2), .orange.opacity(0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                handleColor: .orange,
                scaleColor: .orange,
                secondaryScaleColor: .orange
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
```

<img width="640" alt="Custom Style 2" src="https://user-images.githubusercontent.com/284922/167268168-af0867fe-240f-41ee-a8bc-6afac7526c97.png">

One of the slider parameters allows you to control the visibility of the handle. For this gradient example, it can be disabled:

```swift
CompactSlider(value: $value, handleVisibility: .hidden) {
    Text("Custom Style")
    Spacer()
    Text(String(format: "%.2f", value))
}
.compactSliderStyle(.custom)
```

![Custom Style](https://user-images.githubusercontent.com/284922/167268544-f559fb2a-5350-4bf5-b8cc-133f962c06e8.gif)

## Prominent Style

Prominent style allows for a more dramatic response for the selected value. 
It requires two colors, which determine the accent color depending on the progress of the selected value. 
You can also optionally apply a background gradient based on these colors.

![Prominent Style](https://user-images.githubusercontent.com/284922/167272787-58fa2ccc-037f-4a4f-8fc8-c9a778adafb8.gif)

```swift

@State private var chooseSide: Double = 0.5
@State private var temperature: Double = 20

var body: some View {
    VStack(alignment: .leading, spacing: 24) {
        // 1.
        CompactSlider(value: $chooseSide, alignment: .center) {
            Text("Red")
            Spacer()
            Text("Blue")
        }
        .compactSliderStyle(
            .prominent(
                lowerColor: .red,
                upperColor: .blue
            )
        )
        
        // 2.
        HStack {
            Text("Temperature:")
            CompactSlider(value: $temperature, in: -10...30, step: 2) {}
                .compactSliderStyle(
                    .prominent(
                        lowerColor: .blue,
                        upperColor: .orange,
                        useGradientBackground: true
                    )
                )
            Text("\(Int(temperature))℃")
                .frame(width: 50, alignment: .trailing)
        }
    }
}
```

# Advanced Layout

The slider provides a state that can be used for more advanced layouts. To do this, you must subscribe for state changes via bindings.

### CompactSliderState

<img width="640" alt="CompactSliderState" src="https://user-images.githubusercontent.com/284922/167273735-4e818e10-714c-4916-87c8-d6b053cca89c.png">

In the following example, we will show the value in the progress position:

```swift
@State private var value: Double = 0.5
@State private var sliderState: CompactSliderState = .zero

var body: some View {
    ZStack {
        CompactSlider(value: $value, state: $sliderState) {}
        
        Text("\(Int(100 * value))%")
            .foregroundColor(.white)
            .padding(6)
            .background(
                Capsule().fill(Color.blue)
            )
            .offset(x: sliderState.dragLocationX.lower)
            .allowsHitTesting(false)
    }
}
```

![Advanced Layout](https://user-images.githubusercontent.com/284922/167297236-e8d341a1-b09b-49b7-83c4-cd5c710d978a.gif)
