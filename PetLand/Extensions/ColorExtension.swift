//
//  ColorExtension.swift
//  PetLand
//
//  Created by Никита Сигал on 15.01.2023.
//

import SwiftUI

public extension Color {
    init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0)
    }

    init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

// MARK: Custom Colors

public extension Color {
    static let cText = Color(hex: 0x4F4F4F)
    static let cSubtext = Color(hex: 0xAEB9CC)
    static let cOrange = Color(hex: 0xF47932)
    static let cGreen = Color(hex: 0x98B14B)
    static let cGray = Color(hex: 0xCBCBCB)
    static let cRed = Color(hex: 0xFF6164)
    static let cBackground = Color(hex: 0xF5F1EE)
    static let cTransparent = Color.white.opacity(0)
}
