//
//  ViewCoordinator.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import UIKit

protocol ViewCordinatorProtocol: class {
    func goToProfile()
    func goToSingleTweet(id: String)
    func goToNewTweet()
}

protocol Router {
    func tapOnTweet(id: String)
    func tapOnNewTweet()
}

final class ViewCoordinator: BaseView {
    typealias Presenter = PresenterCoordinatorProtocol
    static let shared: ViewCoordinator = {
        let presenter = PresenterCoordinator()
        let coordinador = ViewCoordinator(presenter: presenter)
        
        presenter.view = coordinador
        return coordinador
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
    func tapOnNewTweet() {
        presenter.handleNewTweet()
    }
    
    func tapOnTweet(id: String) {
        presenter.handleTapOnTweet(id: id)
    }
}

extension ViewCoordinator: ViewCordinatorProtocol {
    func goToNewTweet() {
        let viewController = NewTweetViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        present(controller: viewController)
    }
    
    func goToSingleTweet(id: String) {
        let view = TweetViewController()
        view.presenter.identifier = id
        goTo(controller: view)
    }
    
    func goToProfile() {
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

// MARK: Inyect for BaseView

extension BaseView {
    func inyect() -> Router {
        return ViewCoordinator.shared
    }
}

