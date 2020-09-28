//
//  ProfileTableViewCell.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

//TODO: almost sure this will be moved into a single view in order to add an efect about strechy header.

final class ProfileTableViewCell: UITableViewCell, Reusable {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickName)
        view.addSubview(stackView)
        view.addSubview(stackStats)
        view.addSubview(separatorLine)
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
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
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
    
    lazy var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.autoresizingMask = .flexibleWidth
        separatorLine.backgroundColor = .white
        return separatorLine
    }()
    lazy var stackStats: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(followers)
        stack.addArrangedSubview(following)
        return stack
    }()
    
    lazy var followers: TitleSubtitleStack = {
        let stack = TitleSubtitleStack()
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var following: TitleSubtitleStack = {
        let stack = TitleSubtitleStack()
        stack.alignment = .center
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
        
        followers.configure(title: viewModel.followersTitle, subtitle: viewModel.followers)
        following.configure(title: viewModel.followingTitle, subtitle: viewModel.following)
        if let url = viewModel.profilePic {
            profileImage.downloadImage(from: url)
        }
    }
    
}

private extension ProfileTableViewCell {
    struct Metrics {
        static let containerBotton: CGFloat = 8
        static let lateralPadding: CGFloat = 16
        static let topSeparatorPading: CGFloat = 8
        static let imageHeight: CGFloat = 70
    }
    
    func commonInit() {
        addSubview(containerView)
        backgroundColor = .clear
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        enableContainerConstraints()
    }
    
    func enableContainerConstraints() {
        
        NSLayoutConstraint.activate([
            nickName.topAnchor.constraint(equalTo: containerView.topAnchor),
            nickName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metrics.lateralPadding),
            nickName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metrics.lateralPadding),
            
            stackView.topAnchor.constraint(equalTo: nickName.bottomAnchor, constant: Metrics.lateralPadding),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metrics.lateralPadding),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Metrics.lateralPadding),
            
            stackStats.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Metrics.lateralPadding),
            stackStats.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metrics.lateralPadding),
            stackStats.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Metrics.lateralPadding),
            stackStats.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Metrics.lateralPadding),
            
            profileImage.heightAnchor.constraint(equalToConstant: Metrics.imageHeight),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 1),
            
            separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            separatorLine.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Metrics.topSeparatorPading)
        ])
    }
}
