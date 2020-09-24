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
    func showLoader()
    func hideLoader()
    func configure(model: TweetViewModel)
    func showShareSheet(metadata: LPLinkMetadata)
}

final class TweetViewController: UIViewController, BaseView {
    lazy var presenter: TweetPresenterProtocol = inject()
    lazy var router: Router = inject()
    
    private var metadata: LPLinkMetadata?
    
    private var mainStackView = UIStackView()
    private var profileItemsStack = UIStackView()
    private var profileDataStack =  TitleSubtitleStack()
    private var tweet = UILabel()
    private var profileImage = UIImageView()
    private var optionsHolder = UIStackView()
    
    lazy var linkView: LPLinkView = {
        let viewer = LPLinkView()
        viewer.translatesAutoresizingMaskIntoConstraints = false
        return viewer
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observer?.sceneDidLoad()
    }
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
        
        setup(model: model)
        configureMainStack()
        configureProfileItems()
        configureProfileImage()
        configureOptionsHolder()
        configureLinkView(model: model)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.padding),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.padding),
            mainStackView.topAnchor.constraint(equalTo: navigationBarBottomAnchor),
            
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor, multiplier: 1)
        ])
    }
}

private extension TweetViewController {
    func configureLinkView(model: TweetViewModel) {
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
    }
    
    func configureOptionsHolder() {
        optionsHolder.translatesAutoresizingMaskIntoConstraints = false
        optionsHolder.axis = .vertical
        optionsHolder.alignment = .trailing
        optionsHolder.addArrangedSubview(shareButton)
    }
    
    func configureTweetLabel(){
        tweet.translatesAutoresizingMaskIntoConstraints = false
        tweet.numberOfLines = 0
    }
    
    func configureProfileImage() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.cornerRadius = Metrics.imageSize / 2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.mainBlue.cgColor
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFit
    }
    
    func configureProfileData() {
        profileDataStack.distribution = .fillEqually
        profileDataStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureProfileItems() {
        profileItemsStack.translatesAutoresizingMaskIntoConstraints = false
        profileItemsStack.axis = .horizontal
        profileItemsStack.spacing = 20
        profileItemsStack.addArrangedSubview(profileImage)
        profileItemsStack.addArrangedSubview(profileDataStack)
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: 1.0),
            profileImage.widthAnchor.constraint(equalToConstant: Metrics.imageSize),
        ])
    }
    
    func configureMainStack() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.addArrangedSubview(profileItemsStack)
        mainStackView.addArrangedSubview(tweet)
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.padding),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.padding),
            mainStackView.topAnchor.constraint(equalTo: navigationBarBottomAnchor),
        ])
    }
    
    func setup(model: TweetViewModel) {
        view.backgroundColor = .white
        setupNavigationBar()
        setNavBar(delegate: self)
        configureNavBar(viewModel: .TweetView)
        tweet.configure(model: model.tweetText)
        profileDataStack.configure(title: model.displayName, subtitle: model.name)
        isNavBarVisible(true)
        showLeftButton(true)
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

extension TweetViewController: NavigationBarPresentable, LoaderViewPresentable { }
