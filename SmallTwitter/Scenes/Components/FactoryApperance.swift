//
//  FactoryApperance.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 05/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

enum Apperance {
    case profileBold
    case profile
    case title
}

final class FactoryApperance {
    func getApperance(for type: Apperance) -> LabelAppearance {
        switch type {
        case .profile:
            return getProfile()
        case .title:
            return getTitle()
        case .profileBold:
            return getProfileBold()
        }
    }
}

//FIXME: Find a way to have a method where you only pass what you need and it makes it
// Proper way of factory
private extension FactoryApperance {
    func getProfile() -> LabelAppearance {
        LabelAppearance(fuente: .openSansRegular(size: 14), colorTexto: .white)
    }
    
    func getProfileBold() -> LabelAppearance {
        LabelAppearance(fuente: .openSansBold(size: 16), colorTexto: .white)
    }
    
    func getTitle() -> LabelAppearance {
        LabelAppearance(fuente: .openSansBold(size: 40), colorTexto: .white)
    }
}
