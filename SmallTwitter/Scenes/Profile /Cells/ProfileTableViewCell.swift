//
//  ProfileTableViewCell.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

//TODO: almost sure this will be moved into a single view in order

final class ProfileTableViewCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickName)
        view.addSubview(stackView)
        view.addSubview(stackStats)
        view.layer.cornerRadius = 15
        view.backgroundColor = .mainBlue
        return view
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nickName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USER DE PRUEBA"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var aboutMe: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.addArrangedSubview(profileImage)
        stack.addArrangedSubview(stackHolder)
        return stack
    }()
    
    lazy var stackHolder: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.addArrangedSubview(userName)
        stack.addArrangedSubview(aboutMe)
        return stack
    }()
    
    lazy var stackStats: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(followers)
        stack.addArrangedSubview(following)
        return stack
    }()
    
    lazy var followers: TitleSubtitleStack = {
        let stack = TitleSubtitleStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var following: TitleSubtitleStack = {
        let stack = TitleSubtitleStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configure(viewModel: ProfileInfoViewModel) {
        nickName.configure(model: viewModel.profileName)
        userName.configure(model: viewModel.profileUser)
        aboutMe.configure(model: viewModel.aboutMe)
        
        if let url = viewModel.profilePic {
            profileImage.downloadImage(from: url)
        }
        
    }
    
}

private extension ProfileTableViewCell {
    func commonInit() {
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
        enableViewConstraints()
    }
    
    func enableViewConstraints() {
        
        NSLayoutConstraint.activate([
            nickName.topAnchor.constraint(equalTo: containerView.topAnchor),
            nickName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nickName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 16),
            
            stackView.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            stackStats.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            stackStats.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackStats.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 1)
        ])
    }
}
