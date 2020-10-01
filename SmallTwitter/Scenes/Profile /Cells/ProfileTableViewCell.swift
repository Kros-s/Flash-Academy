//
//  ProfileTableViewCell.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    
    private var containerView = UIView()
    private var profileImage = UIImageView()
    private var nickName = UILabel()
    private var userName = UILabel()
    private var aboutMe = UILabel()
    private var stackView = UIStackView()
    private var stackHolder = UIStackView()
    private var separatorLine = UIView()
    private var stackStats = UIStackView()
    private var followers = TitleSubtitleStack()
    private var following = TitleSubtitleStack()
    
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
        
        followers.configure(titleModel: viewModel.followersTitle, subtitleModel: viewModel.followers)
        following.configure(titleModel: viewModel.followingTitle, subtitleModel: viewModel.following)
        if let url = viewModel.profilePic {
            profileImage.downloadImage(from: url)
        }
    }
    
}

extension ProfileTableViewCell: Reusable { }

private extension ProfileTableViewCell {
    struct Metrics {
        static let containerBotton: CGFloat = 8
        static let lateralPadding: CGFloat = 16
        static let topSeparatorPading: CGFloat = 8
        static let imageHeight: CGFloat = 70
        static let imageBorder: CGFloat = 2
        static let imageCornerRadious: CGFloat = 35
        static let mainCornerRadious: CGFloat = 15
        static let aspectRatio: CGFloat = 1
        static let separatorHeight: CGFloat = 1
        static let separatorAspectWidth: CGFloat = 0.7
    }
    
    struct Constants {
        static let numberOfLines = 0
    }
    
    func commonInit() {
        setupContainerView()
        setupNickName()
        setupProfileImage()
        setupAboutMe()
        setupUserName()
        setupStackHolder()
        setupStackView()
        configureSeparatorLine()
        configureFollowers()
        configureFollowing()
        configureStackStats()
        enableContainerConstraints()
    }
    
    func configureStackStats() {
        stackStats.axis = .horizontal
        stackStats.alignment = .center
        stackStats.distribution = .fillEqually
        stackStats.translatesAutoresizingMaskIntoConstraints = false
        stackStats.addArrangedSubview(followers)
        stackStats.addArrangedSubview(following)
    }
    
    func configureFollowers() {
        followers.alignment = .center
        followers.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureFollowing() {
        following.alignment = .center
        following.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureSeparatorLine() {
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.autoresizingMask = .flexibleWidth
        separatorLine.backgroundColor = .white
    }
    
    func setupUserName() {
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.numberOfLines = Constants.numberOfLines
    }
    
    func setupAboutMe() {
        aboutMe.translatesAutoresizingMaskIntoConstraints = false
        aboutMe.numberOfLines = Constants.numberOfLines
    }
    
    func setupStackHolder() {
        stackHolder.axis = .vertical
        stackHolder.alignment = .center
        stackHolder.translatesAutoresizingMaskIntoConstraints = false
        stackHolder.distribution = .fill
        stackHolder.addArrangedSubview(userName)
        stackHolder.addArrangedSubview(aboutMe)
    }
    
    func setupStackView() {
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.addArrangedSubview(profileImage)
        stackView.addArrangedSubview(stackHolder)
    }
    
    func setupNickName() {
        containerView.addSubview(nickName)
        nickName.translatesAutoresizingMaskIntoConstraints = false
        nickName.numberOfLines = Constants.numberOfLines
    }
    
    func setupProfileImage() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = Metrics.imageCornerRadious
        profileImage.layer.borderWidth = Metrics.imageBorder
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true
    }
    
    func setupContainerView() {
        addSubview(containerView)
        backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackStats)
        containerView.addSubview(separatorLine)
        containerView.layer.cornerRadius = Metrics.mainCornerRadious
        containerView.backgroundColor = .mainBlue
    }
    
    func enableContainerConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
                       containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.topSeparatorPading),
                       containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                       containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
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
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: Metrics.aspectRatio),
            
            separatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: Metrics.separatorAspectWidth),
            separatorLine.heightAnchor.constraint(equalToConstant: Metrics.separatorHeight),
            separatorLine.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            separatorLine.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Metrics.topSeparatorPading)
        ])
    }
}
