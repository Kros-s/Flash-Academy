//
//  NewTweetPresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 09/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import UIKit

protocol NewTweetPresenterProtocol {
    var dismissAction: TriggerAction { get set }
    func handleNewTweet(tweet: String)
    func handleCancel()
}

final class NewTweetPresenter: Presenter {
    weak var view: NewTweetView?
    private var newTweet: SendService
    var dismissAction: TriggerAction = nil
    
    deinit {
        dismissAction = nil
    }
    
    init(newTweet: SendService = TweetService()) {
        self.newTweet = newTweet
    }
}

extension NewTweetPresenter: NewTweetPresenterProtocol {
    func handleCancel() {
        view?.dismissView()
    }
    
    func handleNewTweet(tweet: String) {
        guard !tweet.isEmpty, tweet.count < Constants.maxCharactersOnTweet else { return }
        newTweet.sendTweet(tweet) { [weak self] in
            self?.view?.dismissView()
        }
    }
    
    func sceneDidLoad() {
        view?.configure(model: createViewModel())
    }
}

private extension NewTweetPresenter {
    struct Constants {
        static let modalTitle = "What are you thinking?"
        static let closeButton = "X"
        static let headerFontSize: CGFloat = 18
        static let buttonFontSize: CGFloat = 16
        static let buttonHeaderSize: CGFloat = 20
        static let buttonSendText = "Send"
        static let maxCharactersOnTweet = 140
    }
    
    func createViewModel() -> NewTweetViewModel {
        NewTweetViewModel(header: createHeaderViewModel(),
                          footerButton: createButtonViewModel())
    }
    
    func createHeaderViewModel() -> ModalHeaderViewModel {
        let apperanceHeader = LabelAppearance(font: .openSansBold(size: Constants.headerFontSize), textColor: .mainBlue)
        
        let headerTitle = LabelViewModel(text: Constants.modalTitle,
                                         appearance: apperanceHeader)
        
        var buttonHeader: ButtonViewModel = .init(titles: [.normal(value: Constants.closeButton)],
                                                  style: .init(fontTitle: .openSansBold(size: Constants.buttonFontSize),
                                                               titleColor: [.normal(value: .darkGray)],
                                                               backgroundColor: .white),
                                                  isEnabled: true)
        buttonHeader.style.fontTitle = .openSansBold(size: Constants.buttonHeaderSize)
        return .init(headerTitle: headerTitle, closeButton: buttonHeader)
    }
    
    func createButtonViewModel() -> ButtonViewModel {
        .createRoundedBlueButton(title: Constants.buttonSendText)
    }
}

struct NewTweetViewModel {
    let header: ModalHeaderViewModel
    let footerButton: ButtonViewModel
}

struct ModalHeaderViewModel {
    let headerTitle: LabelViewModel
    let closeButton: ButtonViewModel
}
