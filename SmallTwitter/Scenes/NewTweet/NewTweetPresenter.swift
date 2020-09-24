//
//  NewTweetPresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 09/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol NewTweetPresenterProtocol {
    var dismissAction: TriggerAction { get set }
    func handleNewTweet(tweet: String)
    func handleCancel()
}

final class NewTweetPresenter: BasePresenter {
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
        guard !tweet.isEmpty, tweet.count < 140 else { return }
        newTweet.sendTweet(tweet) { [weak self] in
            self?.view?.dismissView()
        }
    }
    
    func sceneDidLoad() {
        view?.configure(model: createViewModel())
    }
}

private extension NewTweetPresenter {
    func createViewModel() -> NewTweetViewModel {
        NewTweetViewModel(header: createHeaderViewModel(),
                          footerButton: createButtonViewModel())
    }
    
    func createHeaderViewModel() -> ModalHeaderViewModel {
        let apperanceHeader = LabelAppearance(font: .openSansBold(size: 18), textColor: .mainBlue)
        
        let headerTitle = LabelViewModel(text:"What are you thinking?", appearance: apperanceHeader)
        var buttonHeader: ButtonViewModel = .init(titles: [.normal(value: "X")],
                                                  style: .init(fontTitle: .openSansBold(size: 16),
                                                               titleColor: [.normal(value: .darkGray)],
                                                               backgroundColor: .white),
                                                  isEnabled: true)
        buttonHeader.style.fontTitle = .openSansBold(size: 20)
        return .init(headerTitle: headerTitle, closeButton: buttonHeader)
    }
    
    func createButtonViewModel() -> ButtonViewModel {
        .createRoundedBlueButton(title: "Send")
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
