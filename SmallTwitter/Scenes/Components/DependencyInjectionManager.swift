//
//  DependencyInjectionManager.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 11/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

//Using this way of dependency since there are a couple of reasons why i didn't choose to use a Locator, Interactor or Factory over this one

// It allow us to limit the use of the inyectio to the layer where is attached

// It follows a single patter by using a same signature instead of a interactor since interactor could become a dependency itself

// Locator hides the implementation and start becoming a GOD object since it handles more than one dependency.

extension BaseView where Self == NewTweetViewController {
    func inyect() -> NewTweetPresenterProtocol {
        let presenter = NewTweetPresenter()
        presenter.view = self
        return presenter
    }
}

extension BaseView where Self: TweetView {
    func inyect() -> TweetPresenterProtocol {
        let presenter = TweetPresenter()
        presenter.view = self
        return presenter
    }
}

extension BaseView where Self: ProfileView {
    func inyect() -> ProfilePresenterProtocol {
        let presenter = ProfilePresenter()
        presenter.view = self
        return presenter
    }
}
