//
//  ButtonViewModel.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 17/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

// MARK: State definitions for buttons
struct ValueState<Value> {
    var state: UIControl.State
    var value: Value
    
    static func normal(value: Value) -> ValueState<Value> {
        return ValueState<Value>(state: .normal, value: value)
    }
    
    static func selected(value: Value) -> ValueState<Value> {
        return ValueState<Value>(state: .selected, value: value)
    }
    
    static func disabled(value: Value) -> ValueState<Value> {
        return ValueState<Value>(state: .disabled, value: value)
    }
    
    init(state: UIControl.State, value: Value) {
        self.state = state
        self.value = value
    }
}

// MARK: General Button View Model
struct ButtonViewModel {
    var titles: [ValueState<String>]
    var style: StyleButton
    var isEnabled: Bool
    var isSelected: Bool
    var isHidden: Bool
    init(titles: [ValueState<String>],
         style: StyleButton,
         isEnabled: Bool = true,
         isSelected: Bool = false,
         isHidden: Bool = false) {
        self.titles = titles
        self.style = style
        self.isEnabled = isEnabled
        self.isSelected = isSelected
        self.isHidden = isHidden
    }
}

//MARK: Definition for style
struct StyleButton {
    var fontTitle: UIFont
    var titleColor: [ValueState<UIColor>]
    var backgroundColor: UIColor?
    var borderColor: UIColor?
    var borderWidth: CGFloat?
    var roundedBorder: CGFloat?
    var underline: Bool
    
    init(fontTitle: UIFont,
         titleColor: [ValueState<UIColor>],
         backgroundColor: UIColor? = nil,
         borderColor: UIColor? = nil,
         borderWidth: CGFloat? = nil,
         roundedBorder: CGFloat? = nil,
         underline: Bool = false) {
        self.fontTitle = fontTitle
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.roundedBorder = roundedBorder
        self.underline = underline
    }
}

//MARK: Default configuration method
extension UIButton {
    func configure(model: ButtonViewModel) {
        model.titles.forEach { self.setTitle($0.value, for: $0.state) }
        isEnabled = model.isEnabled
        isSelected = model.isSelected
        isHidden = model.isHidden
        configure(style: model.style)
    }
    
    func configure(style: StyleButton) {
        titleLabel?.font = style.fontTitle
        style.titleColor.forEach { self.setTitleColor($0.value, for: $0.state) }
        backgroundColor = style.backgroundColor
        layer.borderColor = style.borderColor?.cgColor
        
        if let borderWidth = style.borderWidth {
            layer.borderWidth = borderWidth
        }
        
        if let cornerRadious = style.roundedBorder {
            layer.cornerRadius = cornerRadious
        }
    }
}

extension ButtonViewModel {
    static func createRoundedBlueButton(title: String,
                                        isEnabled: Bool = true) -> ButtonViewModel {
        
        let titles:[ValueState<String>] = [.normal(value: title),
                                           .disabled(value: title)]
        let colorStates: [ValueState<UIColor>] =  [.normal(value: .softBlue),
                                                   .disabled(value: .gray)]
        
        let style = StyleButton(fontTitle: .systemFont(ofSize: 17),
                                      titleColor: colorStates,
                                      backgroundColor: .mainBlue,
                                      borderColor: .white,
                                      roundedBorder: 25)
        return .init(titles: titles,
                     style: style,
                     isEnabled: isEnabled)
    }
}
