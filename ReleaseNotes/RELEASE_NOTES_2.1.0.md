# CompactSlider 2.1.0 Release Notes

## New Features

### Precision Control Option (#33)
Added a new `.precisionControl` option that enables fine-grained slider adjustments by reducing sensitivity when dragging perpendicular to the slider axis. This is especially useful for precise value adjustments in scenarios like audio mixing, color selection, or parameter tuning.

**Usage:**
```swift
// Basic usage with default sensitivity
CompactSlider(value: $value)
    .compactSliderOptionsByAdding(.precisionControl())

// Custom sensitivity (50-200 typical range)
CompactSlider(value: $colorValue, in: 0...255, step: 1)
    .compactSliderOptionsByAdding(.precisionControl(sensitivity: 80))
```

**How it works:**
- For horizontal sliders: drag up/down while dragging to engage precision mode
- For vertical sliders: drag left/right while dragging to engage precision mode
- The further you drag perpendicular to the slider, the more precise the control becomes
- Sensitivity parameter controls the curve (default: 100.0)

A comprehensive demo showcasing precision control is included in the Demo package.

### Enhanced Scale Customization API (#32)
Significantly improved the scale customization API to provide more flexibility and control over the default scale appearance.

**New `.compactSliderScale()` method** - Customize the default scale:
```swift
CompactSlider(value: $value)
    .compactSliderScale(
        visibility: .always,
        alignment: .top,
        lineLength: 8,
        strokeStyle: .init(lineWidth: 2),
        color: .blue,
        secondaryColor: .blue.opacity(0.3)
    )
```

**Renamed methods for clarity:**
- `.compactSliderScaleStyles(...)` - For custom scale shape styles (previously `compactSliderScale` with variadic parameters)
- `.compactSliderScaleView(...)` - For completely custom scale views (previously generic `compactSliderScale`)

This separation makes the API more intuitive and discoverable, allowing users to easily customize the default scale without having to rebuild it from scratch.

## Bug Fixes

### Fixed Progress Range Clamping
Fixed a rendering issue where sliders would draw beyond their bounds when initialized with values outside the specified range. All progress values are now properly clamped to the 0...1 range during initialization:
- Single value sliders
- Multiple value sliders
- Range sliders
- Grid sliders

**Example of fixed behavior:**
```swift
// Previously: slider would render off-screen
// Now: value is clamped to maximum (255)
CompactSlider(value: .constant(300), in: 0...255)
```

### Fixed Scale Visibility Issue
Fixed a bug where calling `.compactSliderScale(visibility: .always)` without providing custom scale styles would incorrectly hide the scale entirely. The scale now correctly respects visibility settings while maintaining the default scale appearance.

## Documentation

Added `CLAUDE.md` - comprehensive development guide for future contributors and AI assistants working with the codebase, including:
- Build and development commands
- Architecture overview
- Key design patterns
- Component organization

## Related Issues
- Implements improvements for #33 (Precision control request)
- Addresses #32 (Scale customization flexibility)

---

## Migration Notes

### Scale API Changes
If you were using the generic `compactSliderScale` method for custom views, update to the new method name:

```swift
// Before:
.compactSliderScale(visibility: .always) { config in
    MyCustomScaleView(config: config)
}

// After:
.compactSliderScaleView(visibility: .always) { config in
    MyCustomScaleView(config: config)
}
```

If you were using variadic scale shape styles, update to:
```swift
// Before:
.compactSliderScale(visibility: .always, .linear(...), .linear(...))

// After:
.compactSliderScaleStyles(visibility: .always, .linear(...), .linear(...))
```

The new `.compactSliderScale()` method (without variadic parameters) is for customizing the default scale appearance.
