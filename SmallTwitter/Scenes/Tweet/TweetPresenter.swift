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

final class TweetPresenter: Presenter {
    weak var view: TweetView?
    var tweetInfo: GetInfoService
    var identifier: String?
    var apperance: FactoryApperance
    var metadata: MetaDataStorage
    var shareURL: String?
    
    //TODO: Wrap this two into a single class and inject as dependancy
    private var inputFormatter = DateFormatter.inputFormatter
    private var relativeFormatter = RelativeDateTimeFormatter.relativeFormatter
    
    init(tweetInfo: GetInfoService = TweetService(),
         apperance: FactoryApperance = .init(),
         metadata: MetaDataStorage = inject()) {
        
        self.tweetInfo = tweetInfo
        self.metadata = metadata
        self.apperance = apperance
    }
}

extension TweetPresenter: TweetPresenterProtocol {
    func sceneDidLoad() {
        view?.showLoader()
        tweetInfo.getTweetInfo(id: identifier ?? "") { [weak self] info in
            guard let self = self else { return }
            self.shareURL = info.entities.urls?.first?.url
            let model = self.loadTweetData(info: info)
            self.view?.configure(model: model)
            self.view?.hideLoader()
        }
    }
    
    func handleShare() {
        guard let url = shareURL,
            let metadataInfo = metadata.retrieveMediaIfNeed(for: url) else { return }
        view?.showShareSheet(metadata: metadataInfo)
    }
}

private extension TweetPresenter {
    func loadTweetData(info: TimeLine) -> TweetViewModel {
        let regularApperance = apperance.makeApperance(size: 24)
        let timeApperance = apperance.makeApperance(weight: .light, size: 12, color: .gray)
        let usernameApperance = apperance.makeApperance(weight: .bold, size: 22, color: .mainBlue)
        let displayNameApperance = apperance.makeApperance(weight: .bold, size: 22, color: .mainBlack)
        
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
