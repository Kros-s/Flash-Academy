//
//  NewTweetPresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 09/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

extension MVPView where Self == NewTweetViewController {
    func inyect() -> NewTweetPresenterProtocol {
        let presenter = NewTweetPresenter()
        presenter.view = self
        return presenter
    }
}

protocol NewTweetPresenterProtocol {
    
}

final class NewTweetPresenter: MVPPresenter {
    weak var view: NewTweetView?
}

extension NewTweetPresenter: NewTweetPresenterProtocol {
    
}
