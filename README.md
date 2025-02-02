<p align="center">
  <img width="640" alt="cover3" src="https://user-images.githubusercontent.com/284922/166153877-97536d02-1feb-4018-961a-c3646faffdc0.png">
</p>

<p align="center">
  <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbuh%2FCompactSlider%2Fbadge%3Ftype%3Dswift-versions" />
  <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbuh%2FCompactSlider%2Fbadge%3Ftype%3Dplatforms" />
  <img src="https://img.shields.io/badge/SwiftUI-2-blue" />
  <a href="https://github.com/buh/CompactSlider/blob/main/LICENSE"><img src="https://img.shields.io/github/license/buh/CompactSlider" /></a>
</p>

`CompactSlider` is a highly customizable multi-purpose slider control for SwiftUI. It can be used to select a single value, or a range of values, or multiple values, or a point in a grid, or a polar point in a circular grid. The slider can be displayed horizontally, vertically, or in a (circular) grid. The slider can be customized with a variety of styles and options, including the possibility to design your own style.

The slider is a replacement for the build-in slider and is designed specifically for SwiftUI. For me, the main motivation for writing a component that already exists is the very slow performance under macOS 12 and below (e.g. when you need to resize the screen with multiple sliders or when animating) and the severely outdated design at that time. 

I was inspired by the slider design that Apple's [Photos](https://support.apple.com/guide/photos/adjust-white-balance-pht9b1d4a744/10.0/mac/15.0) app developed, which makes heavy use of sliders. Also new sliders in the [Camera](https://www.apple.com/v/iphone-16-pro/d/images/overview/photographic-styles/megapixels__dhiskrxv388y_large_2x.jpg) app on iPhone 16 Pro.

## Slider Types

The slider basically defines two variants: a linear slider and a grid slider. The linear slider can be horizontal or vertical, and also scrollable, where the handle is still and the scale is moving.

The grid slider can be used to select a point in a grid or a polar point in a circular grid. The point in the grid represents a value of the x and y axis. The polar point represents a value of the angle and radius.

Possible slider types defined by the `CompactSliderType`:
 - a horizontal slider with alignments: leading, center, trailing.
 - a vertical slider with alignments: top, center, bottom.
 - a scrollable horizontal slider.
 - a scrollable vertical slider.
 - a grid slider.
 - a circular grid slider.

# Requirements

- Swift 5.9+
- Xcode 15+
- SwiftUI 3+
- macOS 12+
- iOS 15+
- watchOS 8+
- visionOS 1+

# Installation 

1. In Xcode go to `File` ⟩ `Add Packages...`.
2. Search for the link below and click `Add Package`:
```
https://github.com/buh/CompactSlider.git
```
3. Select to which target you want to add it and select `Add Package`.

## Version 1.0

Version 1.0 is deprecated and no longer supported. You can find the documentation for version 1.0 in the file: [README v1](https://github.com/buh/CompactSlider/blob/main/README_v1.md).

# Support

You can buy me a coffee [here](https://www.buymeacoffee.com/bukhtin) ☕️

# License

`CompactSlider` is available under the [MIT license](https://github.com/buh/CompactSlider/blob/main/LICENSE)


