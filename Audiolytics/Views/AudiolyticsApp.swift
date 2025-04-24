//
//  AudiolyticsApp.swift
//  Audiolytics
//
//  Created by Jonathan Da Silva on 4/6/25.
//

import SwiftUI

@main
struct AudiolyticsApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}




