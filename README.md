<p align="center">
  <img width="640" alt="cover3" src="https://user-images.githubusercontent.com/284922/166153877-97536d02-1feb-4018-961a-c3646faffdc0.png">
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.6-orange" />
  <img src="https://img.shields.io/badge/SwiftUI-2-blue" />
  <img src="https://img.shields.io/badge/macOS-11-lightgrey" />
  <img src="https://img.shields.io/badge/iOS-14-blue" />
  <img src="https://img.shields.io/badge/watchOS-7-green" />
  <img src="https://img.shields.io/github/license/buh/CompactSlider" />
</p>

`CompactSlider` is a control for selecting a value from a bounded linear range of values.

The slider is a replacement for the build-in slider and is designed specifically for SwiftUI. For me, the main motivation for writing a component that already exists is the very slow performance under macOS (e.g. when you need to resize the screen with multiple sliders or when animating) and the severely outdated design. At the same time, I was inspired by the slider design that Apple's [Photos](https://www.apple.com/macos/photos/#edit-gallery) app developed, which makes heavy use of sliders.

- [Requirements](#requirements)
- [Installation](#installation)
- [Preview](#preview)
- Documentation
- [Usage](#usage)
- [License](#license)

# Requirements

- Swift 5.6
- Xcode 13
- SwiftUI 2
- macOS 11
- iOS 14
- watchOS 7

# Installation 

1. In Xcode go to `File` ⟩ `Add Packages...`
2. Search for https://github.com/buh/CompactSlider.git and click `Add Package`
3. Select to which target you want to add it and select `Add Package`

# Preview

**macOS**

https://user-images.githubusercontent.com/284922/166230021-223e1ffb-75e2-41ab-9995-618ccb414f8a.mov

**iPadOS**

https://user-images.githubusercontent.com/284922/166307680-8dfc706f-9e25-4739-94da-1d655b640e56.mov

**iOS**

https://user-images.githubusercontent.com/284922/166308017-fab77043-80c7-4567-b096-7fae8ba05967.mov

**watchOS**

https://user-images.githubusercontent.com/284922/166314399-857a0612-1a47-4bf8-9454-48eb3b63d1ba.mov

# Usage

A slider consists of a handle that the user moves between two extremes of a linear “track”. The ends of the track represent the minimum and maximum possible values. As the user moves the handle, the slider updates its bound value.

### Single value

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

Using the `direction:` parameter you can set the direction in which the slider will indicate the selected value:

![Direction](https://user-images.githubusercontent.com/284922/166335936-3e4cfdac-eafa-42c6-8da7-4010751973d8.gif)

```swift
@State private var value = 0.5

var body: some View {
    CompactSlider(value: $value, direction: .center) {
        Text("Center")
        Spacer()
        String(format: "%.2f", value)
    }
}
```

### Range values

# License

`CompactSlider` is available under the [MIT license](https://github.com/buh/CompactSlider/blob/main/LICENSE)


