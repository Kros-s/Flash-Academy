//
//  UIFont.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 05/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

extension UIFont {
    static func openSansMedium(size: CGFloat) -> UIFont {
        return UIFont.font(name: .openSans, weight: .medium, size: size)
    }
    
    static func openSansBold(size: CGFloat) -> UIFont {
        return UIFont.font(name: .openSans, weight: .bold, size: size)
    }
    
    static func openSansRegular(size: CGFloat) -> UIFont {
        return UIFont.font(name: .openSans, weight: .regular, size: size)
    }
}

private extension UIFont {
    enum FontWeight: String {
        case light = "-Light"
        case bold = "-Bold"
        case medium = "-Medium"
        case regular = "-Regular"
        case semibold = "-SemiBold"
        case black = "-Black"
    }
    
    enum SupportedFonts: String {
        case openSans = "OpenSans"
    }
    
    enum FontExtensions: String {
        case ttf = "ttf"
    }
    
    static func font(name: SupportedFonts, weight: FontWeight, size: CGFloat) -> UIFont {
        let fontName = name.rawValue + weight.rawValue
        var font = UIFont(name: fontName, size: size)
    
        
        if let fontExist = font {
            return fontExist
        }

        if registerFont(fileName: fontName, type: FontExtensions.ttf.rawValue, bundle: Bundle(for: self)) {
            font = UIFont(name: fontName, size: size)
        }
        
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func registerFont(fileName: String, type: String, bundle: Bundle?) -> Bool {
        guard
            let bundle = bundle,
            let ruta = bundle.path(forResource: fileName, ofType: type),
            let dataFont = NSData(contentsOfFile: ruta),
            let dataProvider = CGDataProvider(data: dataFont),
            let fontReference = CGFont(dataProvider)
        else {
            return false
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        
        return !(CTFontManagerRegisterGraphicsFont(fontReference, &errorRef) == false)
    }
}
