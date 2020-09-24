//
//  ViewCoordinator.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import UIKit

typealias TriggerAction = (() -> Void)?

protocol ViewCordinatorProtocol: class {
    func showProfileView()
    func showDetailTweet(id: String)
    func showNewTweetView(action: TriggerAction)
}

protocol Router {
    func tapOnTweet(id: String)
    func tapOnNewTweet(action: TriggerAction)
}

final class ViewCoordinator: BaseView {
    typealias Presenter = PresenterCoordinatorProtocol
    
    static let shared: ViewCoordinator = {
        let presenter = PresenterCoordinator()
        let coordinator = ViewCoordinator(presenter: presenter)
        presenter.view = coordinator
        return coordinator
    }()
    
    let presenter: PresenterCoordinatorProtocol
    let rootNavigationController: UINavigationController = .init()
    
    init(presenter: PresenterCoordinatorProtocol) {
        self.presenter = presenter
    }
}

// MARK: Public Methods

extension ViewCoordinator {
    var rootViewController: UIViewController {
        if rootNavigationController.topViewController == nil {
            presenter.handleAppBegin()
        }
        rootNavigationController.isNavigationBarHidden = true
        return rootNavigationController
    }
}

extension ViewCoordinator: Router {
    func tapOnNewTweet(action: TriggerAction) {
        presenter.handleNewTweet(action: action)
    }
    
    func tapOnTweet(id: String) {
        presenter.handleTapOnTweet(id: id)
    }
}

extension ViewCoordinator: ViewCordinatorProtocol {
    func showNewTweetView(action: TriggerAction) {
        let viewController = NewTweetViewController()
        viewController.presenter.dismissAction = action
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        present(controller: viewController)
    }
    
    func showDetailTweet(id: String) {
        let view = TweetViewController()
        view.presenter.identifier = id
        goTo(controller: view)
    }
    
    func showProfileView() {
        goTo(controller: ProfileViewController())
    }
}

// MARK: Private Methods

private extension ViewCoordinator {
    func goTo(controller: UIViewController) {
        rootNavigationController.pushViewController(controller, animated: rootNavigationController.topViewController != nil)
    }
    
    func present(controller: UIViewController) {
        rootNavigationController.topViewController?.present(
            controller,
            animated: true,
            completion: nil)
    }
}

// MARK: inject for BaseView

extension BaseView {
    func inject() -> Router {
        return ViewCoordinator.shared
    }
}

