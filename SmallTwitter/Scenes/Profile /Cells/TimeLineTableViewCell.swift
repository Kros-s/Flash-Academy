//
//  TimeLineTableViewCell.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit
import LinkPresentation


final class TimeLineTableViewCell: UITableViewCell {
    var cornerRadius: CGFloat = 6
    var shadowOffsetWidth = 0
    var shadowOffsetHeight = 3
    var shadowColor: UIColor = .gray
    var shadowOpacity: Float = 0.3
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(stackViewContainer)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowPath = shadowPath.cgPath
        return view
    }()
    
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
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tweetInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tweetText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var linkView: LPLinkView = {
        let viewer = LPLinkView()
        viewer.translatesAutoresizingMaskIntoConstraints = false
        return viewer
    }()
    
    lazy var stackViewDataHolder: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.addArrangedSubview(userName)
        stack.addArrangedSubview(tweetInfo)
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
    
    override func prepareForReuse() {
        linkView.removeFromSuperview()
    }
    
    func configure(viewModel: ProfileTweetViewModel) {
        tweetInfo.configure(model: viewModel.tweetInfo)
        userName.configure(model: viewModel.name)
        tweetText.configure(model: viewModel.tweet)
        if let metadata = viewModel.linkData {
            linkView = LPLinkView(metadata: metadata)
            stackViewDataHolder.addArrangedSubview(linkView)
            //Tried almost all layoyt options but seems a previous view can't be updated since frame is wrong
        }
        
        if let url = viewModel.profilePic {
            profileImage.downloadImage(from: url)
        }
    }
}

private extension TimeLineTableViewCell {
    struct Metrics {
        static let lateralPadding: CGFloat = 8
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metrics.lateralPadding),
            stackViewContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Metrics.lateralPadding),
            stackViewContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metrics.lateralPadding),
            stackViewContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Metrics.lateralPadding),
            
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: 1.0),
            profileImage.widthAnchor.constraint(equalToConstant: 50.0),
        ])
    }
    
    func commonInit() {
        addSubview(containerView)
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
        
        constraints()
    }
}
