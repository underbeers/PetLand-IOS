//
//  ColorExtension.swift
//  PetLand
//
//  Created by Никита Сигал on 15.01.2023.
//

import UIKit

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

// MARK: Custom Colors

public extension UIColor {
    static let cText = UIColor(hex: 0x4F4F4F)
    static let cSubtext = UIColor(hex: 0xAEB9CC)
    static let cAccent1 = UIColor(hex: 0xF47932)
    static let cAccent2 = UIColor(hex: 0x97B14B)
    static let cRed = UIColor(hex: 0xFF5454)
    static let cGreen = UIColor(hex: 0x7CC350)
    static let cFavoriteRed = UIColor(hex: 0xF71B47)
    static let cRatingStar = UIColor(hex: 0xFFA046)
    static var cBackground: UIColor = {
        if let backdrop = UIImage(named: "backdrop") {
            return UIColor(patternImage: backdrop)
        } else {
            return UIColor(hex: 0xF5F1EE)
        }
    }()
}
