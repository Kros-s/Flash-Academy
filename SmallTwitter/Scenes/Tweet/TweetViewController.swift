//
//  TweetViewController.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

protocol TweetView: class {
    func configure(model: TweetViewModel)
}

final class TweetViewController: BaseViewController, MVPView {
    lazy var presenter: TweetPresenterProtocol = inyect()
    
    lazy var router: Router = inyect()
    
    lazy var profileImage: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "??????????"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var tweet: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "??????????"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
}

extension TweetViewController: TweetView {
    func configure(model: TweetViewModel) {
        view.addSubview(profileImage)
        view.addSubview(name)
        view.addSubview(tweet)
        navigationBar.delegate = self
        navigationBar.configureNavBar()
        name.configure(model: model.name)
        tweet.configure(model: model.text)
        
        if let url = model.profileURL {
            profileImage.downloadImage(from: url)
        } else {
            profileImage.backgroundColor = .black
        }
        
        navigationBar.isVisible = true
        navigationBar.showLeftButton(true)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: 1.0),
            profileImage.widthAnchor.constraint(equalToConstant: 100.0),
            
            name.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16.0),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tweet.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 16.0),
            tweet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tweet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

extension TweetViewController: DelegateCustomNavigationBar {
    func leftButtonSelected() {
        self.navigationController?.popViewController(animated: true)
    }
}


