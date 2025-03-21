//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
extension EnvironmentValues {
    /// An additional top inset for the stretchy header.
    ///
    /// This value adjusts the vertical layout offset of the stretchy header,
    /// allowing for fine-tuned alignment with external UI elements such as a top
    /// banner.
    ///
    /// Use this when other layout elements need to offset the stretchy header's
    /// position.
    @Entry public var stretchyHeaderTopInset: CGFloat = 0

    /// The vertical scroll offset of the stretchy header's scroll view.
    ///
    /// Used to drive stretch and collapse behavior of the header in response
    /// to user scrolling.
    @Entry var stretchyHeaderScrollContentOffset: CGFloat = 0

    /// The initial height of the stretchy header before scrolling begins.
    ///
    /// This value represents the base height from which stretching or collapsing
    /// will be calculated.
    @Entry var stretchyHeaderHeight: CGFloat = defaultHeaderHeight
}
