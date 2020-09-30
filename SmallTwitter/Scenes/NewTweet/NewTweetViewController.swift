//
//  NewTweetViewController.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 09/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

protocol NewTweetView: class {
    func configure(model: NewTweetViewModel)
    func dismissView()
}

final class NewTweetViewController: UIViewController, PresentationView {
    lazy var presenter: NewTweetPresenterProtocol = inject()
    lazy var router: Router = inject()
    var modalContainer = ModalNewTweet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observer?.sceneDidLoad()
    }
    
    deinit {
        removeKeyboardHandler()
    }
}

extension NewTweetViewController: NewTweetView {
    func dismissView() {
        dismiss(animated: true)
        presenter.dismissAction?()
    }
    
    func configure(model: NewTweetViewModel) {
        setKeyboardHandler()
        
        view.backgroundColor = .modalBackground
        view.addSubview(modalContainer)
        configureModalContainer(model: model)
    }
}

extension NewTweetViewController: KeyboardHandler { }

private extension NewTweetViewController {
    struct Metrics {
        static let heightMultiplier:CGFloat = 0.5
        static let widhtMultiplier: CGFloat = 0.9
    }
    
    struct Constants {
        static let keyboardHeight: CGFloat = 150
        static let originKeyboard: CGFloat = 0
    }
    
    func configureModalContainer(model: NewTweetViewModel) {
        modalContainer.translatesAutoresizingMaskIntoConstraints = false
        modalContainer.backgroundColor = .white
        modalContainer.configure(model: model)
        NSLayoutConstraint.activate([
            modalContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Metrics.heightMultiplier),
            modalContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Metrics.widhtMultiplier)
        ])
        modalContainer.header.setup(controlEvents: .touchUpInside, accion: presenter.handleCancel)
        modalContainer.footerButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
    }
    
    @objc func handleContinue() {
        presenter.handleNewTweet(tweet: modalContainer.textView.text)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        view.frame.origin.y = -Constants.keyboardHeight
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = Constants.originKeyboard
    }
}
