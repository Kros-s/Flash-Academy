//
//  TweetViewController.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit
import LinkPresentation

protocol TweetView: class {
    func configure(model: TweetViewModel)
    func showShareSheet(metadata: LPLinkMetadata)
}

final class TweetViewController: BaseViewController, MVPView {
    lazy var presenter: TweetPresenterProtocol = inyect()
    lazy var router: Router = inyect()
    
    var metadata: LPLinkMetadata?
    
    //TODO: Compress into a view
    lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        stack.addArrangedSubview(profileItemsStack)
        stack.addArrangedSubview(tweet)
        return stack
    }()
    
    lazy var profileItemsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.addArrangedSubview(profileImage)
        stack.addArrangedSubview(profileDataStack)
        return stack
    }()
    
    lazy var profileDataStack: TitleSubtitleStack = {
        let stack = TitleSubtitleStack()
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var linkView: LPLinkView = {
        let viewer = LPLinkView()
        viewer.translatesAutoresizingMaskIntoConstraints = false
        return viewer
    }()
    
    lazy var profileImage: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Metrics.imageSize / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.mainBlue.cgColor
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var tweet: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var optionsHolder: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.addArrangedSubview(shareButton)
        return stack
    }()
    
    lazy var shareButton: UIButton = {
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let shareImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: iconConfig)
        let button = UIButton()
        button.setImage(shareImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        return button
    }()
}

extension TweetViewController: TweetView {
    func showShareSheet(metadata: LPLinkMetadata) {
        let controller = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        self.present(controller, animated: true)
    }
    
    struct Metrics {
        static let padding: CGFloat = 24
        static let imageSize: CGFloat = 70
    }
    
    func configure(model: TweetViewModel) {
        view.addSubview(mainStackView)
        setup(model: model)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.padding),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.padding),
            mainStackView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: 1.0),
            profileImage.widthAnchor.constraint(equalToConstant: Metrics.imageSize),
            
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor, multiplier: 1)
        ])
    }
}

private extension TweetViewController {
    func setup(model: TweetViewModel) {
        navigationBar.delegate = self
        navigationBar.configureNavBar(viewModel: .TweetView)
        tweet.configure(model: model.tweetText)
        profileDataStack.configure(title: model.displayName, subtitle: model.name)
        
        if let metadata = model.linkData {
            self.metadata = metadata
            linkView = LPLinkView(metadata: metadata)
            mainStackView.addArrangedSubview(linkView)
            mainStackView.addArrangedSubview(optionsHolder)
        }
        
        if let url = model.profileURL {
            profileImage.downloadImage(from: url)
        } else {
            profileImage.backgroundColor = .black
        }
        
        navigationBar.isVisible = true
        navigationBar.showLeftButton(true)
    }
    
    @objc func handleShare() {
        presenter.handleShare()
    }
}

extension TweetViewController: DelegateCustomNavigationBar {
    func leftButtonSelected() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TweetViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "metadata.url"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return metadata?.originalURL
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return metadata
    }
    
}
