//
//  MVP.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

// MARK: Base Presenter definition for MVP
protocol Presenter: class, SceneObserver {
    associatedtype View
    var view: View? { get }
}

//MARK: Base View definition for MVP
protocol PresentationView {
    associatedtype Presenter
    var presenter: Presenter { get }
}

extension PresentationView  {
    var observer: SceneObserver? {
        return presenter as? SceneObserver
    }
}
