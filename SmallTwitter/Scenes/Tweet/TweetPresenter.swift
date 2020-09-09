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
    var apperance: FactoryApperance
    
    init(userFacade: UserFacadeProtocol = inyect(),
         apperance: FactoryApperance = .init()) {
        self.userFacade = userFacade
        self.apperance = apperance
    }
}

extension TweetPresenter: TweetPresenterProtocol {
    
    func sceneDidLoad() {
        
        view?.configure(model: loadTweetData())
    }
}

private extension TweetPresenter {
    func loadTweetData() -> TweetViewModel {
        let regularApperance = apperance.makeApperance(size: 14)
        
        guard let id = identifier,
            let info = userFacade.retrieveTweet(id: id)
            else {
                assertionFailure("Should not reach this point, something wrong came by")
                
                return TweetViewModel(name: .init(text: "", appearance: regularApperance),
                                      text: .init(text: "", appearance: regularApperance))
        }
        
        let nameText = LabelViewModel(text: info.user.name, appearance: regularApperance)
        let text = LabelViewModel(text: info.text, appearance: regularApperance)
        
        return TweetViewModel(name: nameText,
                              text: text,
                              profileURL: URL(string: info.user.profile_image_url_https))
    }
}

struct TweetViewModel {
    var name: LabelViewModel
    var text: LabelViewModel
    var profileURL: URL? = nil
}
