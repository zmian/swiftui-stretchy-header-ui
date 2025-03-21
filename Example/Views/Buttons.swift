//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI
import StretchyHeaderUI

struct SettingsButton: View {
    @Environment(\.displayScale) private var displayScale
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: "gear")
                .resizable()
                .offset(x: 1 / displayScale, y: 1 / displayScale)
                .circularIcon(scale: 0.6)
                .tint(.tealGray)
                .padding(.top, .xs)
                .padding(.leading, .md)
        }
        .buttonStyle(.plain)
    }
}

struct ProfileButton: View {
    @Environment(\.deviceSafeAreaInsets) private var safeAreaInsets

    var body: some View {
        #if os(watchOS)
        EmptyView()
        #else
        Button {
            print("Profile button tapped")
        } label: {
            Image(systemName: "person.fill")
                .resizable()
                .circularIcon()
                .tint(.tealGray)
                .padding(.top, .xs)
                .padding(.trailing, .md)
                .padding(.top, safeAreaInsets.top)
        }
        .buttonStyle(.plain)
        #endif
    }
}
