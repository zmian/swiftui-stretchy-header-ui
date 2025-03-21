//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI
import StretchyHeaderUI

extension EnvironmentValues {
    @Entry var stretchyHeaderConfiguration = StretchyHeaderConfiguration()
}

// MARK: - Configuration

struct StretchyHeaderConfiguration {
    var headerType: HeaderType = .customScrollingView
    var collapseMode: CollapseMode = .revealStatusBarBackground

    enum HeaderType: String, CaseIterable {
        case plain = "Plain"
        case customScrollingView = "Custom Scrolling View"

        var icon: String {
            switch self {
                case .plain:
                    "rectangle"
                case .customScrollingView:
                    "inset.filled.center.rectangle.portrait"
            }
        }

        var tint: Color {
            switch self {
                case .plain: .indigo
                case .customScrollingView: .teal
            }
        }
    }

    enum CollapseMode: Hashable, CaseIterable {
        case revealStatusBarBackground
        case revealNavigationBarBackground
        case height(CGFloat)
        case scrolledOff
        case statusBarHeight
        case navigationBarHeight

        static let allCases: [Self] = [
            .revealStatusBarBackground,
            .revealNavigationBarBackground,
            .scrolledOff,
            .statusBarHeight,
            .navigationBarHeight,
            .height(0)
        ]

        var name: String {
            switch self {
                case .height: "Custom Height"
                default: String(describing: self)
            }
        }

        @MainActor
        var mode: StretchyHeaderCollapseMode {
            switch self {
                case .revealStatusBarBackground:
                    .revealStatusBarBackground
                case .revealNavigationBarBackground:
                    .revealNavigationBarBackground
                case .scrolledOff:
                    .scrolledOff
                case .statusBarHeight:
                    .statusBarHeight
                case .navigationBarHeight:
                    .navigationBarHeight
                case let .height(height):
                    .height(height)
            }
        }
    }
}
