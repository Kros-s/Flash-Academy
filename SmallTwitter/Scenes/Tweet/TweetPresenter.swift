//
//  TweetPresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol TweetPresenterProtocol {
    var identifier: String? { get set }
}

extension MVPView where Self: TweetView {
    func inyect() -> TweetPresenterProtocol {
        let presenter = TweetPresenter()
        presenter.view = self
        return presenter
    }
}

final class TweetPresenter: MVPPresenter {
    weak var view: TweetView?
    var userFacade: UserFacadeProtocol
    var identifier: String?
    
    init(userFacade: UserFacadeProtocol = inyect()) {
        self.userFacade = userFacade
    }
}

extension TweetPresenter: TweetPresenterProtocol {
    
    func sceneDidLoad() {
        
        view?.configure(model: loadTweetData())
    }
}

private extension TweetPresenter {
    func loadTweetData() -> TweetViewModel {
        guard let id = identifier,
            let info = userFacade.retrieveTweet(id: id)
            else {
                //assertionFailure("Should not enter this")
                return TweetViewModel(name: .init(text: "ERROR", appearance: .init(fuente: .boldSystemFont(ofSize: 10), colorTexto: .red)), text: .init(text: "ERROR", appearance: .init(fuente: .systemFont(ofSize: 18), colorTexto: .black)))
        }
        let font: LabelAppearance = .init(fuente: .systemFont(ofSize: 14), colorTexto: .black)
        
        return TweetViewModel(name:
            .init(text: info.user.name, appearance: font),
                              text: .init(text: info.text, appearance: font), profileURL: URL(string: info.user.profile_image_url_https))
    }
}

struct TweetViewModel {
    var name: LabelViewModel
    var text: LabelViewModel
    var profileURL: URL? = nil
}
