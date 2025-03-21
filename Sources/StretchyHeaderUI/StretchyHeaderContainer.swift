//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A container view that provides a **stretchy header** effect inside a
/// `ScrollView`.
///
/// This component allows for a **collapsible header** that expands when
/// scrolling down and shrinks when scrolling up. It also supports **different
/// collapse behaviors**, such as revealing the **status bar or navigation
/// bar backgrounds**.
///
/// **Usage**
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         StretchyHeaderScrollingView(spacing: 20) {
///             Text("Hello, SwiftUI!")
///         } header: {
///             HeaderView()
///         }
///         .toolbarVisibility(.hidden, for: .navigationBar)
///     }
/// }
///
/// struct HeaderView: View {
///     var body: some View {
///         StretchyHeaderContainer {
///             contentView
///         } background: {
///             Image(.headerBackground)
///                 .resizable()
///                 .allowsHitTesting(false)
///                 .accessibilityHidden(true)
///         }
///     }
///
///     private var contentView: some View {
///         VStack {
///             Spacer()
///             Text("Hello, SwiftUI!")
///                 .padding(.bottom, 20)
///         }
///         .frame(maxWidth: .infinity)
///         .allowsHitTesting(false)
///         .overlay(alignment: .topTrailing) {
///             Button("Profile", systemImage: "person.fill") {
///                 print("Profile button tapped")
///             }
///             .labelStyle(.iconOnly)
///         }
///     }
/// }
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, visionOS 2.0, *)
public struct StretchyHeaderContainer<Content: View, Background: View>: View {
    @Environment(\.stretchyHeaderScrollContentOffset) private var contentOffset
    @Environment(\.stretchyHeaderHeight) private var _headerHeight
    @Environment(\.stretchyHeaderTopInset) private var stretchyHeaderTopInset
    private let _collapseMode: StretchyHeaderCollapseMode
    private let content: () -> Content
    private let background: () -> Background

    /// Creates a **Stretchy Header Container** with a background and content.
    ///
    /// - Parameters:
    ///   - collapseMode: Defines how the header collapses when scrolling.
    ///   - content: The primary content displayed in the header.
    ///   - background: A view that serves as the header's background.
    public init(
        collapseMode: StretchyHeaderCollapseMode = .revealStatusBarBackground,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping () -> Background
    ) {
        self._collapseMode = collapseMode
        self.content = content
        self.background = background
    }

    public var body: some View {
        ZStack {
            if Background.self != Never.self {
                FillView(alignment: .bottom) {
                    background()
                        .aspectRatio(contentMode: .fill)
                }
            }

            FillView {
                content()
                    .opacity(opacity)
            }
        }
        // Expands or shrinks based on scroll
        .frame(height: contentHeight)
        .clipped()
        // Adjusts background reveal animation
        .offset(y: barBackgroundRevealOffsetY)
        .background(alignment: .bottom) {
            barBackgroundView
        }
        .ignoresSafeArea(edges: .top)
    }

    private var contentHeight: CGFloat {
        max(
            collapseMode.collapsedHeight.clamped(to: 0...headerHeight),
            headerHeight + contentOffset
        )
    }

    /// Returns the background view for the navigation or status bar when
    /// collapsing.
    @ViewBuilder
    private var barBackgroundView: some View {
        switch collapseMode {
            case .revealStatusBarBackground, .revealNavigationBarBackground:
                Rectangle()
                    .fill(.systemBar)
                    .frame(height: collapseMode.collapsedHeight)
            case .height:
                EmptyView()
        }
    }

    /// The Y-offset to reveal the bar background smoothly as the header collapses.
    private var barBackgroundRevealOffsetY: CGFloat {
        collapseMode
            .barBackgroundRevealOffsetY(contentOffset, headerHeight: headerHeight)
    }

    /// The opacity of the header content as it collapses.
    private var opacity: CGFloat {
        collapseMode
            .opacity(offset: contentOffset, headerHeight: headerHeight)
    }

    /// Returns the adjusted **collapse mode**, accounting for any top inset.
    private var collapseMode: StretchyHeaderCollapseMode {
        switch _collapseMode {
            case .height, .revealNavigationBarBackground:
                _collapseMode
            case .revealStatusBarBackground:
                stretchyHeaderTopInset > 0 ? .height(0) : .revealStatusBarBackground
        }
    }

    /// Returns the adjusted **header height**, accounting for any top inset.
    private var headerHeight: CGFloat {
        _headerHeight - stretchyHeaderTopInset
    }
}

// MARK: - Convenience Inits

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, visionOS 2.0, *)
extension StretchyHeaderContainer where Background == Never {
    /// Creates a **Stretchy Header Container** without a background.
    ///
    /// - Parameters:
    ///   - collapseMode: Defines how the header collapses when scrolling.
    ///   - content: The primary content displayed in the header.
    public init(
        collapseMode: StretchyHeaderCollapseMode = .revealStatusBarBackground,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            collapseMode: collapseMode,
            content: content,
            background: {
                fatalError("Background should not be accessed when not provided.")
            }
        )
    }
}
