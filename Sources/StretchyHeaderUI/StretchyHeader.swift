//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A flexible, native-feeling stretchy header that expands and collapses with
/// scroll behavior.
///
/// This component is designed to integrate seamlessly with `ScrollView`,
/// providing a dynamic header that:
/// - **Expands when scrolling down** (stretch effect)
/// - **Collapses when scrolling up** (shrinking effect)
/// - **Can reveal system UI elements** like the **status bar** or **navigation
///   bar** backgrounds.
///
/// ## Features
/// - Supports configurable **height** and **collapse behavior**.
/// - Works with both **foreground content** and **background images**.
/// - Adjusts dynamically based on scrolling position.
///
/// ## Usage
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         ScrollView {
///             StretchyHeader {
///                 Text("Stretchy Header Content")
///                     .font(.largeTitle)
///             } background: {
///                 Image("header-image")
///                     .resizable()
///             }
///
///             VStack {
///                 Text("Hello, SwiftUI!")
///             }
///         }
///     }
/// }
/// ```
///
/// ## Advanced Usage
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         ScrollView {
///             HeaderView()
///             Text("Hello, SwiftUI!")
///         }
///         .toolbarVisibility(.hidden, for: .navigationBar)
///     }
/// }
///
/// struct HeaderView: View {
///     var body: some View {
///         StretchyHeader {
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
public struct StretchyHeader<Content: View, Background: View>: View {
    private let headerHeight: CGFloat
    private let collapseMode: StretchyHeaderCollapseMode
    private let content: () -> Content
    private let background: () -> Background

    /// Creates a stretchy header with a background and content.
    ///
    /// - Parameters:
    ///   - height: The initial height of the header.
    ///   - collapseMode: Defines how the header collapses when scrolling.
    ///   - content: The primary content displayed in the header.
    ///   - background: A view that serves as the header's background.
    public init(
        height: CGFloat? = nil,
        collapseMode: StretchyHeaderCollapseMode = .revealStatusBarBackground,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder background: @escaping () -> Background
    ) {
        self.headerHeight = height ?? defaultHeaderHeight
        self.collapseMode = collapseMode
        self.content = content
        self.background = background
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                if Background.self != Never.self {
                    FillView(alignment: .bottom) {
                        background()
                            .aspectRatio(contentMode: .fill)
                    }
                }

                if Content.self != Never.self {
                    FillView {
                        content()
                            .opacity(opacity(offset: geometry.offsetY))
                    }
                }
            }
            .frame(height: max(headerHeight, geometry.currentHeight))
            .clipped()
            .offset(y: barBackgroundRevealOffsetY(geometry.offsetY))
            .background(alignment: .bottom) {
                barBackgroundView
            }
            .offset(y: offsetY(geometry.offsetY))
        }
        .frame(height: headerHeight)
        .zIndex(100)
    }

    /// Returns the background view for the navigation or status bar when collapsing.
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
    private func barBackgroundRevealOffsetY(_ offset: CGFloat) -> CGFloat {
        collapseMode
            .barBackgroundRevealOffsetY(offset, headerHeight: headerHeight)
    }

    /// The opacity of the header content as it collapses.
    private func opacity(offset: CGFloat) -> CGFloat {
        collapseMode
            .opacity(offset: offset, headerHeight: headerHeight)
    }

    /// Calculates the offset required to smoothly collapse the header.
    private func offsetY(_ offset: CGFloat) -> CGFloat {
        let collapsedHeight = collapseMode.collapsedHeight.clamped(to: 0...headerHeight)
        let sizeOffScreen = headerHeight - collapsedHeight

        if offset > 0 {
            return -offset
        }

        if offset < -sizeOffScreen {
            let imageOffset = abs(min(-sizeOffScreen, offset))
            return imageOffset - sizeOffScreen
        }

        return 0
    }
}

// MARK: - Convenience Inits

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, visionOS 2.0, *)
extension StretchyHeader where Background == Never {
    /// Creates a **Stretchy Header** without a background.
    ///
    /// - Parameters:
    ///   - height: The initial height of the header.
    ///   - collapseMode: Defines how the header collapses when scrolling.
    ///   - content: The primary content displayed in the header.
    public init(
        height: CGFloat? = nil,
        collapseMode: StretchyHeaderCollapseMode = .revealStatusBarBackground,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(
            height: height,
            collapseMode: collapseMode,
            content: content,
            background: { fatalError("Background should not be accessed when not provided.") }
        )
    }
}

// MARK: - GeometryProxy Extensions

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
extension GeometryProxy {
    /// Returns the vertical offset of the header relative to the global coordinate
    /// space.
    fileprivate var offsetY: CGFloat {
        frame(in: .global).minY
    }

    /// The current height of the header based on scroll position.
    ///
    /// - If the user **scrolls down**, the header **stretches** beyond its original
    ///   height.
    /// - If the user **scrolls up**, the header collapses **but never goes below
    ///   the collapsed height**.
    fileprivate var currentHeight: CGFloat {
        let offset = offsetY
        let height = size.height

        if offset > 0 {
            return height + offset
        }

        return height
    }
}
