//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Color {
    static let tealGray = Color(TealGrayShapeStyle())

    private struct TealGrayShapeStyle: ShapeStyle, Hashable {
        func resolve(in environment: EnvironmentValues) -> Color.Resolved {
            Color.gray.mix(with: .teal, by: 0.1)
                .opacity(environment.colorScheme == .dark ? 0.3 : 0.8)
                .resolve(in: environment)
        }
    }
}

extension ShapeStyle where Self == Color {
    static var tealGray: Self { .tealGray }
}
