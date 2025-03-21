//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

/// An enumeration defining the behavior of the `StretchyHeader` as it collapses
/// while scrolling.
///
/// It provides different strategies for handling the header collapse, such as
/// dynamically adjusting the height or revealing system UI elements.
///
/// - `height(CGFloat)`: Collapses to a specified height.
/// - `revealStatusBarBackground`: Shrinks the header until the system status
///   bar background is fully revealed.
/// - `revealNavigationBarBackground`: Shrinks the header until the system
///   navigation bar background is fully visible.
public enum StretchyHeaderCollapseMode: Sendable, Hashable {
    /// The header collapses to a fixed height.
    case height(CGFloat)

    /// The header collapses until the system status bar background is revealed.
    case revealStatusBarBackground

    /// The header collapses until the system navigation bar background is revealed.
    case revealNavigationBarBackground

    /// A static mode where the header completely scrolls off the screen.
    public static var scrolledOff: Self {
        .height(0)
    }
}

// MARK: - Helpers

@MainActor
extension StretchyHeaderCollapseMode {
    /// A static mode where the header collapses to the height of the status bar
    /// with background set to the header background.
    public static var statusBarHeight: Self {
        .height(Constants.statusBarHeight)
    }

    /// A static mode where the header collapses to the combined height of the
    /// status and navigation bar with background set to the header background.
    public static var navigationBarHeight: Self {
        .height(Constants.statusBarPlusNavBarHeight)
    }

    /// Returns the collapsed height for the current mode.
    ///
    /// - Returns: The target height of the header when fully collapsed.
    var collapsedHeight: CGFloat {
        switch self {
            case let .height(value):
                value
            case .revealStatusBarBackground:
                Constants.statusBarHeight
            case .revealNavigationBarBackground:
                Constants.statusBarPlusNavBarHeight
        }
    }

    /// Determines the opacity of the header as it collapses.
    ///
    /// - Parameters:
    ///   - offset: The current vertical scroll offset.
    ///   - headerHeight: The full height of the header.
    /// - Returns: A value between `0.0` and `1.0` representing the header's
    ///   visibility.
    func opacity(offset: CGFloat, headerHeight: CGFloat) -> CGFloat {
        let safeArea = Constants.statusBarHeight
        let offset = offset - safeArea

        if offset >= 0 {
            return 1
        }

        let maxHeight = headerHeight - Constants.statusBarPlusNavBarHeight
        let maxOffset = min(maxHeight, abs(offset))
        return abs((maxOffset - maxHeight) / maxHeight)
    }

    /// Returns the Y-offset for revealing the bar background as the header
    /// collapses.
    ///
    /// - Parameters:
    ///   - offset: The current vertical scroll offset.
    ///   - headerHeight: The full height of the header.
    /// - Returns: The Y-axis translation needed to align the background correctly.
    func barBackgroundRevealOffsetY(_ offset: CGFloat, headerHeight: CGFloat) -> CGFloat {
        switch self {
            case .revealStatusBarBackground, .revealNavigationBarBackground:
                let barOffset = -(headerHeight - collapsedHeight)

                if offset < 0, barOffset > offset {
                    return offset - barOffset
                }

                return 0
            case .height:
                return 0
        }
    }
}
