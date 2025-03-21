//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Constants

@MainActor
enum Constants {
    static let statusBarHeight: CGFloat = {
        #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
        if #available(iOS 13.0, *) {
            return UIApplication
                .shared
                .firstSceneKeyWindow?
                .windowScene?
                .statusBarManager?
                .statusBarFrame.height ?? 44
        } else {
            return 0
        }
        #else
        return 0
        #endif
    }()

    static var statusBarPlusNavBarHeight: CGFloat {
        statusBarHeight + navBarHeight
    }

    private static var navBarHeight: CGFloat {
        #if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
        switch UIDevice.current.userInterfaceIdiom {
            case .pad: 50
            default: 44
        }
        #else
        return 0
        #endif
    }
}

// MARK: - ShapeStyle

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, visionOS 2.0, *)
extension ShapeStyle where Self == Material {
    static var systemBar: Self {
        #if os(watchOS) || os(tvOS)
        .regularMaterial
        #else
        .bar
        #endif
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
var defaultHeaderHeight: CGFloat {
    #if os(macOS) || targetEnvironment(macCatalyst)
    300
    #elseif os(iOS) || os(tvOS) || os(visionOS)
    MainActor.runImmediately {
        UIDevice.current.userInterfaceIdiom == .pad ? 400 : 300
    }
    #elseif os(watchOS)
    100
    #else
    300
    #endif
}
