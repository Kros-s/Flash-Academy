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
}

final class TweetViewController: BaseViewController, MVPView {
    lazy var presenter: TweetPresenterProtocol = inyect()
    
    lazy var router: Router = inyect()
    
    lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.addArrangedSubview(profileItemsStack)
        stack.addArrangedSubview(tweet)
        return stack
    }()
    
    lazy var profileItemsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        
        stack.addArrangedSubview(profileImage)
        stack.addArrangedSubview(profileDataStack)
        return stack
    }()
    
    lazy var profileDataStack: TitleSubtitleStack = {
        let stack = TitleSubtitleStack()
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
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var tweet: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
}

extension TweetViewController: TweetView {
    func configure(model: TweetViewModel) {
        view.addSubview(mainStackView)
        navigationBar.delegate = self
        navigationBar.configureNavBar(viewModel: .TweetView)
        tweet.configure(model: model.text)
        
        if let url = model.profileURL {
            profileImage.downloadImage(from: url)
        } else {
            profileImage.backgroundColor = .black
        }
        
        navigationBar.isVisible = true
        navigationBar.showLeftButton(true)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
}

extension TweetViewController: DelegateCustomNavigationBar {
    func leftButtonSelected() {
        self.navigationController?.popViewController(animated: true)
    }
}


