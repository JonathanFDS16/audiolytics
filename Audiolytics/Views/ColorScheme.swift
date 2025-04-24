//
//  ColorScheme.swift
//  Audiolytics
//
//  Created by Deborah Park on 4/24/25.
//
import SwiftUI

struct ColorTheme {
    static let backgroundPrimary = Color(hex: "#0D0D0D")
    static let backgroundSecondary = Color(hex: "#1A1A1A")
    static let textPrimary = Color(hex: "#F0F0F0")
    static let textSecondary = Color(hex: "#A0A0A0")
    static let accentGreen = Color(hex: "#10B981")
    static let accentGreenMuted = Color(hex: "#059669")
    static let errorRed = Color(hex: "#EF4444")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

