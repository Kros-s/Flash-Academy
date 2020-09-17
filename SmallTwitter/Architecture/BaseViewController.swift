//
//  BaseViewController.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private var sceneObserver: SceneObserver? {
        return (self as? SceneController)?.observer
    }
    
    final override func viewDidLoad() {
        self.view.backgroundColor = .white
        setupNavigationBar()
        self.sceneObserver?.sceneDidLoad()
        super.viewDidLoad()
    }
    
    final override func viewWillAppear(_ animated: Bool) {
        self.sceneObserver?.sceneWillAppear()
        super.viewWillAppear(animated)
    }
    
    final override func viewDidAppear(_ animated: Bool) {
        self.sceneObserver?.sceneDidAppear()
        super.viewDidAppear(animated)
    }
    
    final override func viewWillDisappear(_ animated: Bool) {
        self.sceneObserver?.sceneWillDisappear()
        super.viewWillDisappear(animated)
    }
    
    final override func viewDidDisappear(_ animated: Bool) {
        self.sceneObserver?.sceneDidDisappear()
        super.viewDidDisappear(animated)
    }
    
}

extension BaseViewController: NavigationBarPresentable, LoaderViewPresentable { }
