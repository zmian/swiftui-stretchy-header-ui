//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//
// Helpers borrowed from https://github.com/zmian/Xcore

import SwiftUI

/// A view that takes over all the available space.
///
/// It's useful when you want to set background to take a over all the available
/// space.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, visionOS 2.0, *)
struct FillView<Content: View>: View {
    private let alignment: Alignment
    private let content: Content

    init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.content = content()
    }

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: alignment) {
                content
            }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
extension MainActor {
    /// Executes an operation synchronously on the main actor’s serial executor.
    ///
    /// - Warning: This API is not recommended for general use. Use this function
    ///   only in exceptional cases. In most situations, prefer using the
    ///   `@MainActor` attribute.
    ///
    /// This function checks if the current task is executing on the main actor’s
    /// serial executor. If so, it executes the operation immediately using
    /// `MainActor.assumeIsolated()`. Otherwise, it dispatches the operation
    /// synchronously to the main actor’s serial executor and returns its result.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// // Before
    /// struct Model {
    ///     /// Return true `1` pixel relative to the screen scale.
    ///     @MainActor // 👈 ← Requires @MainActor attribute
    ///     var onePixel: CGFloat {
    ///         1 / UIScreen.main.scale
    ///     }
    /// }
    ///
    /// // After
    /// struct Model {
    ///     /// Return true `1` pixel relative to the screen scale.
    ///     var onePixel: CGFloat {
    ///         // ✅ No longer requires @MainActor attribute as the body has been isolated to MainActor directly.
    ///         MainActor.runImmediately {
    ///             1 / UIScreen.main.scale
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - operation: The operation that will be executed on the main actor that
    ///     returns a value of type `T`.
    ///   - file: The file name to print if the assertion fails.
    ///   - line: The line number to print if the assertion fails.
    /// - Returns: The return value of the `operation`.
    /// - Throws: Rethrows the `Error` thrown by the operation.
    static func runImmediately<T: Sendable>(
        _ operation: @MainActor () throws -> T,
        file: StaticString = #file,
        line: UInt = #line
    ) rethrows -> T {
        if Thread.isMainThread {
            // Execute immediately if already on the main thread.
            return try MainActor.assumeIsolated(
                { try operation() },
                file: file,
                line: line
            )
        }

        // Otherwise, dispatch synchronously to the main queue.
        return try DispatchQueue.main.sync {
            try operation()
        }
    }
}

// MARK: - Clamped

extension Comparable {
    /// Returns a copy of `self` clamped to the given limiting range.
    ///
    /// ```swift
    /// 30.clamped(to: 0...10) // returns 10
    /// 3.0.clamped(to: 0.0...10.0) // returns 3.0
    /// "z".clamped(to: "a"..."x") // returns "x"
    /// ```
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

#if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
@available(iOS 13.0, *)
extension UIApplication {
    /// Returns the app's first currently active scene's first key window.
    var firstSceneKeyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .sorted { $0.activationState.sortOrder < $1.activationState.sortOrder }
            .first?
            .windows
            .reversed()
            .first(where: \.isKeyWindow)
    }
}

@available(iOS 13.0, *)
extension UIScene.ActivationState {
    fileprivate var sortOrder: Int {
        switch self {
            case .foregroundActive: 0
            case .foregroundInactive: 1
            case .background: 2
            case .unattached: 3
            @unknown default: 4
        }
    }
}
#endif
