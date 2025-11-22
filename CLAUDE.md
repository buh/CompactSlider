# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CompactSlider is a highly customizable multi-purpose slider control library for SwiftUI. It supports:
- Linear sliders (horizontal/vertical with various alignments)
- Scrollable sliders (where the handle is fixed and the scale moves)
- Grid sliders (for selecting 2D points)
- Circular grid sliders (for polar coordinates)
- Single values, ranges, or multiple values

The library targets macOS 12+, iOS 15+, watchOS 8+, and visionOS 1+, requiring Swift 5.9+ and SwiftUI 3+.

## Development Commands

### Building
```bash
# Build the package
swift build

# Build the Demo package
cd Demo && swift build
```

### Testing
This project does not currently have a test suite defined in Package.swift.

### Opening in Xcode
```bash
# Open the main package
open Package.swift

# Open the Demo package
cd Demo && open Package.swift
```

## Architecture

### Core Component Model

The slider follows a **configuration-driven architecture** where all component rendering is driven by `CompactSliderStyleConfiguration`. This configuration object is the single source of truth for:
- Slider type and dimensions
- Progress values (normalized to 0...1)
- Focus state (hovering, dragging, wheel-scrolling)
- Step values for snapping
- Color scheme

### Layered Style System

The slider uses a protocol-based style system with three layers:

1. **CompactSliderStyle Protocol** (`Styles/CompactSliderStyle.swift`)
   - Defines `type`, `padding`, and `makeBody(configuration:)`
   - Implemented by `DefaultCompactSliderStyle` and can be extended for custom styles
   - Different styles are stored in separate environment keys based on type (linear, grid, circular grid)

2. **Component Wrappers** (in `Styles/`)
   - `BackgroundViewWrapper`, `ProgressViewWrapper`, `ScaleViewWrapper`, `HandleViewWrapper`
   - These wrappers read component views from environment and pass configuration to them
   - Allow per-slider customization via environment-based dependency injection

3. **Concrete Components** (in `Components/`)
   - Background: `DefaultBackgroundView`, `GridBackgroundView`
   - Progress: `ProgressView`
   - Handle: `HandleView`
   - Scale: `DefaultScaleView`, `LinearScaleShape`, `CircularScaleShape`

### Value Binding Flow

The slider maintains separate `@Binding` properties for different use cases:
- `lowerValue`/`upperValue`: For range selection
- `values`: For multiple discrete values
- `point`: For grid (2D Cartesian) coordinates
- `polarPoint`: For circular grid (polar) coordinates

All these are internally converted to and from a unified `Progress` struct (defined in `Components/Progress/Progress.swift`) that normalizes values to 0...1 range. The `Progress` type has flags (`isSingularValue`, `isRangeValues`, `isMultipleValues`, `isGridValues`, `isCircularGridValues`) to track which mode is active.

### Gesture Handling

Drag gestures and scroll wheel events are processed in:
- `CompactSlider+Dragging.swift`: Converts drag locations to progress values
- `CompactSlider+ScrollWheel.swift`: Handles macOS scroll wheel input

The convertor logic (in `Treats/Convertor.swift`) translates between:
- Screen coordinates ↔ Progress (0...1)
- Progress ↔ Actual values (within specified bounds)
- Handles step snapping and haptic feedback

### Component Customization Pattern

Components can be customized using environment-based modifiers:
```swift
.compactSliderBackground { configuration, padding in /* custom view */ }
.compactSliderProgress { configuration in /* custom view */ }
.compactSliderHandle { configuration in /* custom view */ }
.compactSliderScale { configuration in /* custom view */ }
```

These modifiers set environment values that the wrapper components read.

### SystemSlider as a Preset

`SystemSlider` (in `Treats/SystemSlider/`) is a higher-level component that wraps `CompactSlider` with system-styled components:
- Pre-configured background, progress, and handle views
- Platform-specific sizing (different for macOS/iOS)
- Simpler API for common use cases

It demonstrates how to build opinionated presets on top of the flexible `CompactSlider` base.

## Code Organization

```
Sources/CompactSlider/
├── CompactSlider.swift           # Main view with @Binding properties
├── CompactSlider+Dragging.swift  # Drag gesture handlers
├── CompactSlider+ScrollWheel.swift # Scroll wheel support (macOS)
├── CompactSlider+OnChange.swift  # Value synchronization logic
├── CompactSliderType.swift       # Enum defining slider variants
├── CompactSliderStyleConfiguration.swift  # Configuration passed to all components
├── Styles/
│   ├── CompactSliderStyle.swift          # Protocol definition
│   ├── DefaultCompactSliderStyle.swift   # Default implementation
│   └── *ViewWrapper.swift                # Environment-reading wrappers
├── Components/
│   ├── Background/    # Background rendering
│   ├── Progress/      # Progress bar rendering
│   ├── Handle/        # Draggable handle rendering
│   ├── Scale/         # Scale/tick marks rendering
│   ├── Grid/          # Grid overlays for grid sliders
│   └── Gauge/         # Gauge views for circular grids
├── Treats/
│   ├── SystemSlider/  # System-styled preset slider
│   ├── Convertor.swift # Coordinate conversion utilities
│   └── ...            # Other utilities
└── Utils/             # General utilities (haptics, geometry, etc.)
```

## Key Patterns

### Environment-based Customization
All components read their configuration from `@Environment(\.compactSliderStyleConfiguration)`. This allows the main `CompactSlider` view to pass state to deeply nested components without prop drilling.

### Progress Normalization
All slider values are internally stored as normalized progress (0...1). The `CompactSliderStep` (in `CompactSliderStep.swift`) handles conversion back to actual values and implements snapping logic.

### Type-specific Rendering
The `CompactSliderType` enum drives rendering decisions throughout the codebase. Components use `switch type` to determine:
- Layout direction (horizontal vs vertical)
- Alignment calculations
- Visibility of certain elements

### Haptic Feedback
Haptic feedback is triggered when values snap to steps or reach boundaries. Implementation is in `Utils/HapticFeedback.swift` with platform-specific code for iOS, macOS, and watchOS.

## Important Notes

- **Xcode Version**: The main branch requires Xcode 16+. Use the `xcode15` branch for Xcode 15 support.
- **Frame Sizing**: Slider size is determined by setting `.frame()` on the slider view, not through parameters. For horizontal sliders, set `.frame(height:)`; for vertical sliders, set `.frame(width:)`; for grid sliders, set both dimensions (preferably square).
- **Default Bounds**: Value bounds default to `0...1` if not specified.
- **License**: MIT License (see LICENSE file).
