//
//  ModalNewTweet.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 17/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

final class ModalNewTweet: UIView {
    let header = ModalHeader()
    let textView = UITextView()
    let footerButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func configure(model: NewTweetViewModel) {
        footerButton.configure(model: model.footerButton)
        header.configure(label: model.header.headerTitle, button: model.header.closeButton)
    }
}

private extension ModalNewTweet {
    struct Metrics {
        static let cornerRadious: CGFloat = 10.0
        static let topMargin: CGFloat = 16.0
        static let halfTopMargin: CGFloat = 8.0
        static let lateralMargin: CGFloat = 20.0
        static let footerTopMargin: CGFloat = 8.0
        static let footerHeight: CGFloat = 48.0
    }
    
    func configureHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.topMargin),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.lateralMargin),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.lateralMargin)
        ])
    }
    
    func configureFooter() {
        footerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.lateralMargin),
            footerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.lateralMargin),
            footerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.topMargin),
            footerButton.heightAnchor.constraint(equalToConstant: Metrics.footerHeight)
        ])
    }
    
    func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.addDoneButtonOnKeyboard()
        textView.text = "What's Going on?"
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: Metrics.halfTopMargin),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.lateralMargin),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.lateralMargin),
            textView.bottomAnchor.constraint(equalTo: footerButton.topAnchor, constant: -Metrics.halfTopMargin),
        ])
    }
    
    func commonInit() {
        layer.cornerRadius = Metrics.cornerRadious
        
        addSubview(header)
        addSubview(textView)
        addSubview(footerButton)
        configureHeader()
        configureTextView()
        configureFooter()
    }
}
