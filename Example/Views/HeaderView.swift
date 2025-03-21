//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI
import StretchyHeaderUI

struct HeaderView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.stretchyHeaderConfiguration) private var configuration

    var body: some View {
        switch configuration.headerType {
            case .plain:
                plainBody
            case .customScrollingView:
                customScrollingViewBody
        }
    }

    private var plainBody: some View {
        StretchyHeader(collapseMode: configuration.collapseMode.mode) {
            contentView
        } background: {
            backgroundView
        }
    }

    private var customScrollingViewBody: some View {
        StretchyHeaderContainer(collapseMode: configuration.collapseMode.mode) {
            contentView
        } background: {
            backgroundView
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch horizontalSizeClass {
            case .compact:
                Image("headerBackground")
                    .resizable()
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            default:
                Color.indigo
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
        }
    }

    private var contentView: some View {
        VStack {
            Spacer()
            VStack(spacing: .sm) {
                Text("What you seek is seeking you")
                    .foregroundStyle(.white)
                    .font(.title3)
                    .fontDesign(.serif)
                    .italic()
                    .lineLimit(3)
                    .minimumScaleFactor(0.5)

                Text("— Rumi")
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.subheadline)
                    .fontDesign(.serif)
            }
            .shadow(color: .black.opacity(0.6), radius: 12)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(.horizontal, .md)
            .padding(.bottom, .lg)
            .accessibilityElement(children: .combine)
        }
        .frame(maxWidth: .infinity)
        .allowsHitTesting(false)
        .overlay(alignment: .topTrailing) {
            ProfileButton()
        }
    }
}

// MARK: - Preview

#Preview {
    HeaderView()
}
