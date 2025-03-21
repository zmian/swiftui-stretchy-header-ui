<div>
  <img src="/Resources/icon.svg" width="128px" height="128px" alt="StretchyHeaderUI icon"/>
  <h1>StretchyHeaderUI</h1>
</div>

A SwiftUI component that provides a stretchy, collapsible header with dynamic scrolling behavior. The header expands when scrolling down and contracts when scrolling up, allowing the main content to scroll beneath it seamlessly.

<img src="/Resources/hero.gif" width="200px" alt="Hero image"/>

## Features

- Stretchy Header: The header expands when scrolling down and collapses when scrolling up.
- Smooth Scroll Tracking: The header height automatically adjusts based on the current scroll position.
- Customizable Header and Content: This component is compatible with any SwiftUI View, allowing for flexible header and content options.
- Dynamic Spacing: Configurable spacing is available between the header and the content.
- Lightweight and SwiftUI Native: Built entirely with SwiftUI, this component has no dependencies on UIKit.

## Documentation

The latest documentation for the StretchyHeaderUI package is available [here][docs].

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 10.0+
- visionOS 2.0+
- Xcode 16.2+
- Swift 6.0+

**Additional Requirements**

- [SwiftLint][swiftlint-link]
- [SwiftFormat][swiftformat-link]

## Installation

StretchyHeaderUI is available through the Swift Package Manager. To integrate it into your project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/zmian/swiftui-stretchy-header-ui", from: "1.0.0")
    ],
    ...
)
```

## Author

- [Zeeshan Mian](https://github.com/zmian) ([@zmian](https://twitter.com/zmian))

## License

StretchyHeaderUI is released under the MIT license. For more details, please refer to the [LICENSE](https://github.com/zmian/swiftui-stretchy-header-ui/blob/main/LICENSE).

[swiftlint-link]: https://github.com/realm/SwiftLint
[swiftformat-link]: https://github.com/nicklockwood/SwiftFormat
[docs]: https://zmian.github.io/swiftui-stretchy-header-ui/main/documentation/stretchyheaderui/
