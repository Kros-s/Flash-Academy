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
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setupNavigationBar()
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
    
}

extension BaseViewController: NavigationBarPresentable, LoaderViewPresentable { }
