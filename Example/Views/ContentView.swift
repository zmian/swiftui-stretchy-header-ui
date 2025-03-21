//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI
import StretchyHeaderUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var configuration = StretchyHeaderConfiguration()
    @State private var showSettings = false

    var body: some View {
        Group {
            switch configuration.headerType {
                case .plain:
                    plainBody
                case .customScrollingView:
                    customScrollingViewBody
            }
        }
        .overlay(alignment: .topLeading) {
            settingsButton
        }
        .toolbarVisibility(.hidden, for: .topBar)
        .environment(\.stretchyHeaderConfiguration, configuration)
        .sheet(isPresented: $showSettings) {
            SettingsView(configuration: $configuration)
        }
    }

    private var plainBody: some View {
        ScrollView {
            VStack(spacing: .md) {
                HeaderView()
                cards
            }
        }
    }

    private var customScrollingViewBody: some View {
        StretchyHeaderScrollingView(spacing: .md) {
            cards
        } header: {
            HeaderView()
        }
    }

    @ViewBuilder
    private var cards: some View {
        Group {
            Rectangle()
                .foregroundStyle(.tealGray.opacity(0.8))

            Rectangle()
                .foregroundStyle(.tealGray.opacity(0.6))

            Rectangle()
                .foregroundStyle(.tealGray.opacity(0.4))

            Rectangle()
                .foregroundStyle(.tealGray.opacity(0.2))
        }
        .frame(height: .contentHeight)
        .clipShape(.rect(cornerRadius: .cornerRadius))
        .padding(.horizontal, .md)
    }

    private var settingsButton: some View {
        SettingsButton {
            showSettings = true
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
