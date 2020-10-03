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

final class TweetViewController: UIViewController, PresentationView {
    struct Constants {
        static let metadataIdentifier = "metadata.url"
        static let shareButtonImage = "square.and.arrow.up"
    }
    
    var presenter: TweetPresenterProtocol
    var router: Router
    
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
        let iconConfig = UIImage.SymbolConfiguration(pointSize: Metrics.shareButtonSize, weight: .bold, scale: .large)
        let shareImage = UIImage(systemName: Constants.shareButtonImage, withConfiguration: iconConfig)
        let button = UIButton()
        button.setImage(shareImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        return button
    }()
    
    init(presenter: TweetPresenterProtocol, router: Router) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        static let shareButtonSize: CGFloat = 20
        static let padding: CGFloat = 24
        static let imageSize: CGFloat = 70
        static let shareButtonHeight: CGFloat = 50
        static let aspectRatio: CGFloat = 1
        static let profileImageBorder: CGFloat = 2
        static let stackSpacing: CGFloat = 20
    }
    
    func configure(model: TweetViewModel) {
        
        setup(model: model)
        configureMainStack()
        configureProfileItems()
        configureProfileImage()
        configureTweetLabel()
        configureOptionsHolder()
        configureLinkView(model: model)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metrics.padding),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metrics.padding),
            mainStackView.topAnchor.constraint(equalTo: navigationBarBottomAnchor),
            
            shareButton.heightAnchor.constraint(equalToConstant: Metrics.shareButtonHeight),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor, multiplier: Metrics.aspectRatio)
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
        profileImage.layer.cornerRadius = Metrics.imageSize / Metrics.profileImageBorder
        profileImage.layer.borderWidth = Metrics.profileImageBorder
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
        profileItemsStack.spacing = Metrics.stackSpacing
        profileItemsStack.addArrangedSubview(profileImage)
        profileItemsStack.addArrangedSubview(profileDataStack)
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: Metrics.aspectRatio),
            profileImage.widthAnchor.constraint(equalToConstant: Metrics.imageSize),
        ])
    }
    
    func configureMainStack() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = Metrics.stackSpacing
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
        profileDataStack.configure(titleModel: model.displayName, subtitleModel: model.name)
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
        return Constants.metadataIdentifier
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return metadata?.originalURL
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return metadata
    }
}

extension TweetViewController: NavigationBarPresentable, LoaderViewPresentable { }
