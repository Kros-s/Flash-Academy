//
//  SceneObserver.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

//MARK: This one works as a Decorator for SceneObserver
protocol SceneController {
    var observer: SceneObserver? { get }
}

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
