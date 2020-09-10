//
//  TweetPresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import LinkPresentation

protocol TweetPresenterProtocol {
    var identifier: String? { get set }
    func handleShare()
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
    var metadata: MetaDataStorage
    //TODO: Wrap this two into a single class and inyect as dependancy
    private var inputFormatter = DateFormatter.inputFormatter
    private var relativeFormatter = RelativeDateTimeFormatter.relativeFormatter
    
    init(userFacade: UserFacadeProtocol = inyect(),
         apperance: FactoryApperance = .init(),
         metadata: MetaDataStorage = inyect()) {
        self.metadata = metadata
        self.userFacade = userFacade
        self.apperance = apperance
    }
}

extension TweetPresenter: TweetPresenterProtocol {
    func sceneDidLoad() {
        view?.configure(model: loadTweetData())
    }
    
    func handleShare() {
        guard let id = identifier,
            let info = userFacade.retrieveTweet(id: id),
            let metadataInfo = metadata.retrieveMediaIfNeed(for: info.entities.urls?.first?.url ?? "") else { return }
        view?.showShareSheet(metadata: metadataInfo)
    }
}

private extension TweetPresenter {
    func loadTweetData() -> TweetViewModel {
        let regularApperance = apperance.makeApperance(size: 24)
        let timeApperance = apperance.makeApperance(weight: .light, size: 12, color: .gray)
        let usernameApperance = apperance.makeApperance(weight: .bold, size: 22, color: .mainBlue)
        let displayNameApperance = apperance.makeApperance(weight: .bold, size: 22, color: .mainBlack)
        
        guard let id = identifier,
            let info = userFacade.retrieveTweet(id: id)
            else {
                assertionFailure("Should not reach this point, something wrong came by")
                let error = LabelViewModel(text: "", appearance: regularApperance)
                return TweetViewModel(name: error, displayName: error,
                                      tweetText: error,
                                      tweetTime: error)
        }
        
        let metadataInfo = metadata.retrieveMediaIfNeed(for: info.entities.urls?.first?.url ?? "")
        
        let date = inputFormatter.date(from: info.created_at) ?? Date()
        let humanDate =  relativeFormatter.localizedString(for: date, relativeTo: Date())
        let tweetInfo = LabelViewModel(text: humanDate, appearance: timeApperance)
        
        let nameText = LabelViewModel(text: info.user.screen_name, appearance: displayNameApperance)
        let text = LabelViewModel(text: info.text, appearance: regularApperance)
        let userName = LabelViewModel(text: "@\(info.user.name)", appearance: usernameApperance)
        return TweetViewModel(name: userName,
                              displayName: nameText,
                              tweetText: text,
                              tweetTime: tweetInfo,
                              linkData: metadataInfo,
                              profileURL: URL(string: info.user.profile_image_url_https))
    }
}

struct TweetViewModel {
    var name: LabelViewModel
    var displayName: LabelViewModel
    var tweetText: LabelViewModel
    var tweetTime: LabelViewModel
    var linkData: LPLinkMetadata?
    var profileURL: URL?
}
