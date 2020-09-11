//
//  TitleSubtitleStack.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 05/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

final class TitleSubtitleStack: UIStackView {
    
    var title: LabelViewModel? {
        didSet {
            if let title = title {
                titleLabel.configure(model: title)
            }
        }
    }
    var subtitle: LabelViewModel? {
        didSet {
            if let subtitle = subtitle {
                subtitleLabel.configure(model: subtitle)
            }
        }
    }
    
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
    
    func configure(title: LabelViewModel, subtitle: LabelViewModel, axis: NSLayoutConstraint.Axis = .vertical) {
        self.title = title
        self.subtitle = subtitle
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
