//
//  FactoryApperance.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 05/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

enum Apperance {
    case profileBold
    case profile
    case title
}

final class FactoryApperance {
    struct Constants {
        static let defaultFont: CGFloat = 14
    }
    
    let fontName = UIFont.SupportedFonts.openSans
    
    func makeApperance(weight: UIFont.FontWeight = .regular, size: CGFloat = Constants.defaultFont, color: UIColor = .black) -> LabelAppearance {
        createApperace(weight: weight, size: size, color: color)
    }
}

private extension FactoryApperance {
    func makeFont(weight: UIFont.FontWeight = .regular, size: CGFloat = Constants.defaultFont) -> UIFont {
        return UIFont.font(name: fontName, weight: weight, size: size)
    }
    
    func createApperace(weight: UIFont.FontWeight = .regular, size: CGFloat = Constants.defaultFont, color: UIColor = .mainBlue) -> LabelAppearance {
        let font = makeFont(weight: weight, size: size)
        return LabelAppearance(font: font, textColor: color)
    }
}
