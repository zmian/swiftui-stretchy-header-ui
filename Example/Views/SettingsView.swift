//
// StretchyHeaderUI
// Copyright © 2025 StretchyHeaderUI
// MIT license, see LICENSE file for details
//

import SwiftUI
import StretchyHeaderUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var customHeight: Double = 0
    @Binding var configuration: StretchyHeaderConfiguration

    var body: some View {
        NavigationStack {
            List {
                headerTypeRow
                collapseModeRow
            }
            .navigationTitle("Settings")
            .environment(\.defaultMinListRowHeight, 50)
            .presentationDetents([.large, .medium])
            .presentationCornerRadius(.cornerRadius)
            .presentationSizing(.form)
            #if !os(watchOS)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            #endif
        }
    }

    private var headerTypeRow: some View {
        Picker("Header Type", selection: $configuration.headerType) {
            ForEach(StretchyHeaderConfiguration.HeaderType.allCases, id: \.self) { item in
                Label {
                    Text(item.rawValue)
                } icon: {
                    Image(systemName: item.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .circularIcon(size: 30, shadowEnabled: false)
                        .tint(item.tint.mix(with: .tealGray, by: 0.5))
                }
                .tag(item)
                #if os(macOS)
                .labelStyle(.titleOnly)
                #endif
            }
        }
        .pickerStyle(.inline)
    }

    @ViewBuilder
    private var collapseModeRow: some View {
        Picker("Header Collapse Mode", selection: $configuration.collapseMode) {
            ForEach(StretchyHeaderConfiguration.CollapseMode.allCases, id: \.self) { item in
                Text(item.name)
                    .tag(String(describing: item))
            }
        }
        .pickerStyle(.inline)

        if case .height = configuration.collapseMode {
            Section("Collapse Mode Custom Height") {
                TextField("Collapse Mode Custom Height", value: $customHeight, format: .number)
            }
            .onChange(of: customHeight) { _, newValue in
                configuration.collapseMode = .height(newValue)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsView(configuration: .constant(.init()))
}
