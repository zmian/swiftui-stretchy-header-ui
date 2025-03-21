//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

extension CGFloat {
    static let xs: Self = 8
    static let sm: Self = 12
    static let md: Self = 20
    static let lg: Self = 32

    static let cornerRadius: Self = 28

    @MainActor
    static var contentHeight: Self {
        #if os(macOS) || targetEnvironment(macCatalyst)
        300
        #elseif os(iOS) || os(tvOS) || os(visionOS)
        UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300
        #elseif os(watchOS)
        100
        #else
        0
        #endif
    }
}

extension ToolbarPlacement {
    static var topBar: ToolbarPlacement {
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || targetEnvironment(macCatalyst)
        .navigationBar
        #else
        .windowToolbar
        #endif
    }
}
