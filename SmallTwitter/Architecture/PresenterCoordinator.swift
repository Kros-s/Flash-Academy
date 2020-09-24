//
//  PresenterCoordinator.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol PresenterCoordinatorProtocol {
    func handleAppBegin()
    func handleTapOnTweet(id: String)
    func handleNewTweet(action: TriggerAction)
}

final class PresenterCoordinator: BasePresenter {
    weak var view: ViewCordinatorProtocol?
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard)
    {
        self.userDefaults = userDefaults
    }
}

extension PresenterCoordinator: PresenterCoordinatorProtocol {
    func handleTapOnTweet(id: String) {
        view?.showDetailTweet(id: id)
    }
    
    func handleAppBegin() {
        view?.showProfileView()
    }
    
    func handleNewTweet(action: TriggerAction) {
        view?.showNewTweetView(action: action)
    }
}
