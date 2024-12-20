<p align="center">
  <img width="640" alt="cover3" src="https://user-images.githubusercontent.com/284922/166153877-97536d02-1feb-4018-961a-c3646faffdc0.png">
</p>

<p align="center">
  <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbuh%2FCompactSlider%2Fbadge%3Ftype%3Dswift-versions" />
  <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbuh%2FCompactSlider%2Fbadge%3Ftype%3Dplatforms" />
  <img src="https://img.shields.io/badge/SwiftUI-2-blue" />
  <a href="https://github.com/buh/CompactSlider/blob/main/LICENSE"><img src="https://img.shields.io/github/license/buh/CompactSlider" /></a>
</p>

`CompactSlider` is a control for selecting a value from a bounded linear range of values.

The slider is a replacement for the build-in slider and is designed specifically for SwiftUI. For me, the main motivation for writing a component that already exists is the very slow performance under macOS (e.g. when you need to resize the screen with multiple sliders or when animating) and the severely outdated design. At the same time, I was inspired by the slider design that Apple's [Photos](https://www.apple.com/macos/photos/#edit-gallery) app developed, which makes heavy use of sliders.

- [Requirements](#requirements)
- [Installation](#installation)
- [Documentation](https://swiftpackageindex.com/buh/CompactSlider/1.2.1/documentation/compactslider)
- [Preview](#preview)
- [Usage.md](Usage.md#usage)
  - [Single Value](Usage.md#single-value)
  - [Range Values](Usage.md#range-values)
  - [Styling](Usage.md#styling)
    - [Configuration](Usage.md#configuration)
    - [Secondary Appearance](Usage.md#secondary-appearance)
    - [Prominent Style](Usage.md#prominent-style)
  - [Advanced Layout](Usage.md#advanced-layout) and `CompactSliderState`
- [Support](#support)
- [License](#license)

# Requirements

- Swift 5.5+
- Xcode 13+
- SwiftUI 2+
- macOS 11+
- iOS 14+
- watchOS 7+

*Some of the requirements could be reduced if there is a demand for them.*

# Installation 

1. In Xcode go to `File` ⟩ `Add Packages...`
2. Search for the link below and click `Add Package`
```
https://github.com/buh/CompactSlider.git
```
3. Select to which target you want to add it and select `Add Package`

# Documentation

You can find the generated DocC documentation [here](https://swiftpackageindex.com/buh/CompactSlider/1.2.1/documentation/compactslider).

# Preview

**macOS**

https://user-images.githubusercontent.com/284922/166230021-223e1ffb-75e2-41ab-9995-618ccb414f8a.mov

**iPadOS**

https://user-images.githubusercontent.com/284922/166307680-8dfc706f-9e25-4739-94da-1d655b640e56.mov

**iOS**

https://user-images.githubusercontent.com/284922/166308017-fab77043-80c7-4567-b096-7fae8ba05967.mov

**watchOS**

https://user-images.githubusercontent.com/284922/166314399-857a0612-1a47-4bf8-9454-48eb3b63d1ba.mov

# [Usage](Usage.md)
- [Single Value](Usage.md#single-value)
- [Range Values](Usage.md#range-values)
- [Styling](Usage.md#styling)
  - [Configuration](Usage.md#configuration)
  - [Secondary Appearance](Usage.md#secondary-appearance)
  - [Prominent Style](Usage.md#prominent-style)
- [Advanced Layout](Usage.md#advanced-layout) and `CompactSliderState`

# Support

You can buy me a coffee [here](https://www.buymeacoffee.com/bukhtin) ☕️

# License

`CompactSlider` is available under the [MIT license](https://github.com/buh/CompactSlider/blob/main/LICENSE)


