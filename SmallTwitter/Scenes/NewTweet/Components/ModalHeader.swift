//
//  ModalHeader.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 17/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

final class ModalHeader: UIView {
    private var button = UIButton()
    private var label = UILabel()
    private var stack = UIStackView()
    private var action: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func configure(labelModel: LabelViewModel, buttonModel: ButtonViewModel) {
        label.configure(model: labelModel)
        button.configure(model: buttonModel)
    }
    
    func setup(controlEvents control: UIControl.Event, accion: @escaping () -> Void) {
        self.action = accion
        button.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
    
}

private extension ModalHeader {
    @objc func triggerActionHandler() {
        self.action?()
    }
    
    func configureButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureStack() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(button)
    }
    
    func commonInit() {
        configureLabel()
        configureButton()
        configureStack()
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

