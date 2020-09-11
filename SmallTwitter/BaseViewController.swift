//
//  BaseViewController.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

protocol SceneObserver {
    func sceneDidLoad()
    func sceneWillAppear()
    func sceneDidAppear()
    func sceneWillDisappear()
    func sceneDidDisappear()
}

extension SceneObserver {
    func sceneDidLoad() {}
    func sceneWillAppear() {}
    func sceneDidAppear() {}
    func sceneWillDisappear() {}
    func sceneDidDisappear() {}
}

protocol LoaderView {
    func showLoader()
    func hideLoader()
}

protocol SceneController {
    var observer: SceneObserver? { get }
}

class BaseViewController: UIViewController {
    var navigationBar: CustomNavigationBarProtocol = CustomNavigationBar()
    var loaderView: ScreenLoaderProtocol = ScreenLoader()

    private var sceneObserver: SceneObserver? {
        return (self as? SceneController)?.observer
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.configureCustomBar()
        self.sceneObserver?.sceneDidLoad()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sceneObserver?.sceneWillAppear()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.sceneObserver?.sceneDidAppear()
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.sceneObserver?.sceneWillDisappear()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.sceneObserver?.sceneDidDisappear()
        super.viewDidDisappear(animated)
    }
    
    deinit {
        navigationBar.delegate = nil
    }
}


private extension BaseViewController {
    func configureCustomBar() {
        navigationBar.addCustomNavBar(container: self.view, height: 55.0)
    }
}

extension BaseViewController: LoaderView {
    func showLoader() {
        loaderView.addLoader(view: self.view)
    }
    
    func hideLoader() {
        loaderView.removeLoader()
    }
}

