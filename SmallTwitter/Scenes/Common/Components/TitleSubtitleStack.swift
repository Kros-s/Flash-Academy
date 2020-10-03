//
//  TitleSubtitleStack.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 05/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

final class TitleSubtitleStack: UIStackView {
    lazy var titleLabel: UILabel = {
        let labelMode = UILabel()
        labelMode.translatesAutoresizingMaskIntoConstraints = false
        labelMode.textColor = .black
        return labelMode
    }()
    
    lazy var subtitleLabel: UILabel = {
        let commentMode = UILabel()
        commentMode.translatesAutoresizingMaskIntoConstraints = false
        commentMode.textColor = .black
        return commentMode
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure(titleModel: LabelViewModel, subtitleModel: LabelViewModel, axis: NSLayoutConstraint.Axis = .vertical) {
        titleLabel.configure(model: titleModel)
        subtitleLabel.configure(model: subtitleModel)
        self.axis = axis
    }
    
}

private extension TitleSubtitleStack {
    func configure() {
        distribution = .fill
        axis = .vertical
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
    }
}
