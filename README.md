<p align="center">
  <img width="640" alt="CompactSlider" src="https://github.com/user-attachments/assets/1b4fb8d0-45ab-4c6c-923f-4a4c6813aaf8">
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

# Documentation

### Getting started
- `CompactSlider` [v.2.0.3](https://swiftpackageindex.com/buh/compactslider/2.0.3/documentation/compactslider/compactslider) ([v.2.0.2](https://swiftpackageindex.com/buh/compactslider/2.0.2/documentation/compactslider/compactslider))
- `DefaultCompactSliderStyle` [v.2.0.3](https://swiftpackageindex.com/buh/compactslider/2.0.3/documentation/compactslider/defaultcompactsliderstyle) ([v.2.0.2](https://swiftpackageindex.com/buh/compactslider/2.0.2/documentation/compactslider/defaultcompactsliderstyle))
- `SystemSlider` [v.2.0.3](https://swiftpackageindex.com/buh/compactslider/2.0.3/documentation/compactslider/systemslider) ([v.2.0.2](https://swiftpackageindex.com/buh/compactslider/2.0.2/documentation/compactslider/systemslider))

## Demo

The demo package contains different usage cases.

`Demo`
| macOS  | iOS |
| ------------- | ------------- |
| <img width="387" alt="image" src="https://github.com/user-attachments/assets/44d1751c-2e99-4e62-ab8b-1ee011cebd11" /> | <img width="391" alt="image" src="https://github.com/user-attachments/assets/a2fa2bbf-f9e1-4fbd-a754-9e08dfc45a16" /> |
| <img width="390" alt="image" src="https://github.com/user-attachments/assets/d5dfacca-26c1-4a0f-909a-309df4b60abf" /> | <img width="392" alt="image" src="https://github.com/user-attachments/assets/c619bed8-5634-4554-88f6-cac6bfa70587" /> |
| <img width="420" alt="image" src="https://github.com/user-attachments/assets/16fb1ad5-0173-4f1b-8ec0-73070ae066f4" /> | <img width="391" alt="image" src="https://github.com/user-attachments/assets/167dc5ea-49b0-4b8c-b7e3-00337bce050c" /> |

`GridDemo`
| macOS  | iOS |
| ------------- | ------------- |
| <img width="371" alt="image" src="https://github.com/user-attachments/assets/34cd8742-a98b-4616-9388-bd6afac550e9" /> | <img width="354" alt="image" src="https://github.com/user-attachments/assets/ceac4cb0-b9ab-4fe8-823c-45729859155c" /> |

`CircularGridDemo`
| macOS  | iOS |
| ------------- | ------------- |
| <img width="371" alt="image" src="https://github.com/user-attachments/assets/8def037d-6d7b-4343-9d96-be4867249fdc" /> | <img width="379" alt="image" src="https://github.com/user-attachments/assets/9940d142-0c68-4282-ab75-f054c26e99fa" /> |

`SystemDemo`
| macOS  | iOS |
| ------------- | ------------- |
| <img width="394" alt="image" src="https://github.com/user-attachments/assets/ae6cc1fb-ae52-4ba9-b238-3d5e88345b38" /> | <img width="387" alt="image" src="https://github.com/user-attachments/assets/7bea24f0-c043-4c20-8714-6500b1862e0c" /> |

**visionOS**
<img width="950" alt="image" src="https://github.com/user-attachments/assets/7a42e4f8-b739-4b98-ba8c-1266884e1131" />

`WatchOSDemo`
| Horizontal  | Vertical | Grid | Circular Grid |
| ------------- | ------------- | ------------- | ------------- |
| <img width="274" alt="image" src="https://github.com/user-attachments/assets/9c85510c-47ac-401b-8fc6-d1c6508c2693" /> | <img width="272" alt="image" src="https://github.com/user-attachments/assets/370afdce-6944-4db3-b681-e28f811719e0" /> | <img width="270" alt="image" src="https://github.com/user-attachments/assets/eb0bbe15-a99a-4e9c-951e-7caa39ebd1b1" /> | <img width="269" alt="image" src="https://github.com/user-attachments/assets/ec29ecbb-159c-43b5-96dd-3b115b73fd61" /> |

## Version 1.0 (deprecated)

Version 1.0 is deprecated and no longer supported. You can find the documentation for version 1.0 in the file: [README v1](https://github.com/buh/CompactSlider/blob/main/README_v1.md).

# Support

You can buy me a coffee [here](https://www.buymeacoffee.com/bukhtin) ☕️

# License

`CompactSlider` is available under the [MIT license](https://github.com/buh/CompactSlider/blob/main/LICENSE)


