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
    static let cTransparent = Color.white.opacity(0)
    
    static let cText = Color.cBase800
    static let cSubtext = Color.cBase500
    
    static let cOrange = Color.cOrange900
    static let cGreen = Color.cGreen600
    static let cRed = Color.cRed500
    static let cBlue = Color.cBlue300
    
    static let cBase900 = Color(hex: 0x2D2D2D)
    static let cBase800 = Color(hex: 0x4F4F4F)
    static let cBase700 = Color(hex: 0x6F6F6F)
    static let cBase600 = Color(hex: 0x848484)
    static let cBase500 = Color(hex: 0xAEAEAE)
    static let cBase400 = Color(hex: 0xCBCBCB)
    static let cBase300 = Color(hex: 0xEDEDED)
    static let cBase200 = Color(hex: 0xF2F2F2)
    static let cBase100 = Color(hex: 0xF7F7F7)
    static let cBase0 = Color.white
    
    static let cOrange900 = Color(hex: 0xF47932)
    static let cOrange400 = Color(hex: 0xFFCB4C)
    
    static let cGreen600 = Color(hex: 0x98B14B)
    
    static let cRed500 = Color(hex: 0xFF514B)
    
    static let cBlue200 = Color(hex: 0xAEB9CC)
    static let cBlue300 = Color(hex: 0x909DB4)
}
