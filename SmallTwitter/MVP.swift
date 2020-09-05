//
//  MVP.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//


protocol MVPPresenter: class, SceneObserver {
    associatedtype View
    
    var view: View? { get }
}

protocol MVPView: SceneController {
    associatedtype Presenter
    
    var presenter: Presenter { get }
}

extension MVPView  {
    var observer: SceneObserver? {
        return presenter as? SceneObserver
    }
}

