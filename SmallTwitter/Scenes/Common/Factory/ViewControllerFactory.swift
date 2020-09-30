//
//  DependencyInjectionManager.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 11/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

struct ViewControllerFactory {
    static func makeProfileViewController() -> UIViewController {
        let presenter = ProfileViewPresenter()
        let router = ViewCoordinator.shared
        let viewController = ProfileViewController(presenter: presenter, router: router)
        presenter.view = viewController
        return viewController
    }
    
    static func makeNewTweetViewController(action: TriggerAction) -> UIViewController {
        let presenter = NewTweetViewPresenter()
        let router = ViewCoordinator.shared
        let viewController = NewTweetViewController(presenter: presenter, router: router)
        presenter.view = viewController
        
        viewController.presenter.dismissAction = action
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        return viewController
    }
    
    static func makeTweetViewController(tweet id: String) -> UIViewController {
        let presenter = TweetViewPresenter(identifier: id)
        let router = ViewCoordinator.shared
        let viewController = TweetViewController(presenter: presenter, router: router)
        presenter.view = viewController
        return viewController
    }
}
