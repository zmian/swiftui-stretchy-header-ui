//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    @ViewBuilder
    func circularIcon(scale: CGFloat = 0.45, size overrideSize: CGFloat? = nil, shadowEnabled: Bool = true) -> some View {
        var size: CGFloat {
            var value = overrideSize ?? 44
            #if os(watchOS)
            value = overrideSize ?? 30
            #endif
            return value
        }

        let contentSize = size - (size * (1 - scale))

        self
            .frame(width: contentSize, height: contentSize)
            .frame(width: size, height: size)
            .foregroundStyle(.white)
            .background(.tint)
            .clipShape(.circle)
            .overlay(
                Circle()
                    .strokeBorder(LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white.opacity(0.2), location: 0),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
            )
            .shadow(color: .black.opacity(shadowEnabled ? 0.3 : 0), radius: 12, x: 0, y: 14)
    }
}
