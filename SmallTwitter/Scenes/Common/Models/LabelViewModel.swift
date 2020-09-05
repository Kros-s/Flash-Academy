//
//  LabelViewModel.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

struct LabelViewModel {
    var text: String
    var appearance: LabelAppearance
}

struct LabelAppearance {
    var font: UIFont
    var textColor: UIColor
    var underline: Bool
    var backgroundColor: UIColor?
    
    init(fuente: UIFont,
         colorTexto: UIColor,
         subrayado: Bool = false,
         colorFondo: UIColor? = nil) {
        self.font = fuente
        self.textColor = colorTexto
        self.underline = subrayado
        self.backgroundColor = colorFondo
    }
}


extension UILabel {
    func configure(model: LabelViewModel) {
        self.text = model.text
        self.configure(appearance: model.appearance)
    }
}

private extension UILabel {
    func configure(appearance: LabelAppearance) {
        self.font = appearance.font
        self.textColor = appearance.textColor
        
        if let background = appearance.backgroundColor {
            self.backgroundColor = background
        }
    }
}
