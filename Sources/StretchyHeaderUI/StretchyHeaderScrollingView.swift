//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A `ScrollView` wrapper that supports a **stretchy header** effect.
///
/// This view allows for a **collapsible, scroll-aware header** that expands
/// when scrolling down and shrinks when scrolling up. The header stays
/// positioned at the top, while content scrolls underneath it.
///
/// - Supports dynamic header height adjustments.
/// - Supports configurable spacing between the header and content.
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
@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public struct StretchyHeaderScrollingView<Header: View, Content: View>: View {
    @State private var scrollGeometry = ScrollGeometry()
    private let header: Header
    private let content: Content
    private let headerHeight: CGFloat
    private let spacing: CGFloat

    /// Creates a **Stretchy Header Scrolling View** with a sticky, collapsible
    /// header.
    ///
    /// - Parameters:
    ///   - headerHeight: The initial height of the header.
    ///   - spacing: The spacing between the header and the content.
    ///   - content: The main scrollable content.
    ///   - header: The stretchy header header view.
    public init(
        headerHeight: CGFloat? = nil,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header
    ) {
        self.header = header()
        self.content = content()
        self.headerHeight = headerHeight ?? defaultHeaderHeight
        self.spacing = spacing ?? 0
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                // Creates an empty space where the header will be overlaid
                Spacer()
                    .frame(height: headerHeight)
                content
            }
        }
        // Adjusts the top margin for scroll indicators dynamically based on header
        // height
        .contentMargins(.top, scrollIndicatorsTopMargin, for: .scrollIndicators)
        // Tracks scrolling changes and updates `scrollGeometry`
        .onScrollGeometryChange(for: ScrollGeometry.self) { geometry in
            ScrollGeometry(
                contentOffsetY: -geometry.contentOffset.y,
                contentInsetsTop: geometry.contentInsets.top
            )
        } action: { _, newValue in
            $scrollGeometry.wrappedValue = newValue
        }
        // Overlays the header at the top of the view
        .overlay(alignment: .top) {
            header
                .environment(\.stretchyHeaderScrollContentOffset, scrollGeometry.contentOffsetY)
                .environment(\.stretchyHeaderHeight, headerHeight)
        }
    }

    /// The top margin for scroll indicators.
    ///
    /// Ensures the scroll indicators start **below** the header and are adjusted
    /// dynamically based on scrolling position.
    private var scrollIndicatorsTopMargin: CGFloat {
        headerHeight + spacing + (scrollGeometry.contentOffsetY - scrollGeometry.contentInsetsTop)
    }

    /// Tracks the scroll position and content insets to determine header behavior.
    private struct ScrollGeometry: Hashable {
        /// The vertical offset of the content.
        var contentOffsetY: CGFloat = 0
        /// The top inset of the content.
        var contentInsetsTop: CGFloat = 0
    }
}
