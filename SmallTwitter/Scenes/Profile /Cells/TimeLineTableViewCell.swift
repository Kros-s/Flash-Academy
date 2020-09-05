//
//  TimeLineTableViewCell.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

final class TimeLineTableViewCell: UITableViewCell {
    lazy var stackViewContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.spacing = 10.0
        stack.addArrangedSubview(profileImage)
        stack.addArrangedSubview(stackViewDataHolder)
        return stack
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "??????????"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tweetText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "??????????"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var stackViewDataHolder: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(tweetText)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
}

private extension TimeLineTableViewCell {
    func commonInit() {
        addSubview(stackViewContainer)
        
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: topAnchor),
            stackViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: 1.0),
            profileImage.widthAnchor.constraint(equalToConstant: 50.0),
        ])
    }
}
