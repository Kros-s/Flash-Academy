//
//  UIColor.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 05/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

extension UIColor {
    static var mainBlack = from(hex: 0x202126)
    static var mainBlue = from(hex: 0x278ee3)
}

private extension UIColor {
    static func from(hex value: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = (value >> 16) & 0xFF
        let green = (value >> 8) & 0xFF
        let blue = value & 0xFF
        
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
