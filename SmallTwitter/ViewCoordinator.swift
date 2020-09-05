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
}

protocol Router {
    func tapOnTweet(id: String)
}

final class ViewCoordinator: MVPView {
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

// MARK: Metodos Publicos

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
    func tapOnTweet(id: String) {
        presenter.handleTapOnTweet(id: id)
    }
}

// MARK: Conformacia de CoordinadorDeVistaProtocolo

extension ViewCoordinator: ViewCordinatorProtocol {
    func goToSingleTweet(id: String) {
        let view = TweetViewController()
        view.presenter.identifier = id
        irA(controlador: view)
    }
    
    func goToProfile() {
        irA(controlador: ProfileViewController())
    }
}

// MARK: Metods Privados

private extension ViewCoordinator {
    func irA(controlador: UIViewController) {
        rootNavigationController.pushViewController(controlador, animated: rootNavigationController.topViewController != nil)
    }
    
    func presentar(controlador: UIViewController) {
        rootNavigationController.topViewController?.present(
            controlador,
            animated: true,
            completion: nil)
    }
}

// MARK: MVPVista

extension MVPView {
    func inyect() -> Router {
        return ViewCoordinator.shared
    }
}

