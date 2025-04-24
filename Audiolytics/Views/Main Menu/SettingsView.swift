//
//  SettingsView.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/23/25.
//
import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
            }

            Section {
                Button(role: .destructive) {
                    logOut()
                } label: {
                    Text("Log Out of Spotify")
                }
            }
        }
        .navigationTitle("Settings")
    }

    private func logOut() {
        // Clear the stored access token or session info here
        UserDefaults.standard.removeObject(forKey: "spotifyAccessToken")
        print("User logged out.")
        dismiss()
    }
}

#Preview {
    SettingsView()
}
