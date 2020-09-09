//
//  ProfilePresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import LinkPresentation

extension MVPView where Self: ProfileView {
    func inyect() -> ProfilePresenterProtocol {
        let presenter = ProfilePresenter()
        presenter.view = self
        return presenter
    }
    
}

protocol ProfilePresenterProtocol {
    
}

final class ProfilePresenter: MVPPresenter {
    weak var view: ProfileView?
    var userFacade: UserFacadeProtocol
    var apperance = FactoryApperance()
    
    private var metadataURL: [URL: LPLinkMetadata?] = [:]
    
    private lazy var inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()
    
    private lazy var relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    private var userInfo: User?
    private var timeLineInfo: [TimeLine] = []
    
    init(userFacade: UserFacadeProtocol = inyect()) {
        self.userFacade = userFacade
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func sceneDidLoad() {
        //FIXME: Add a loader before screen shows up
        let group = DispatchGroup()
        group.enter()
        userFacade.retrieveUserInfo { [weak self] profile in
            self?.userInfo = profile
            group.leave()
        }
        
        group.enter()
        userFacade.retrieveUserTimeLine { [weak self] timeline in
            self?.timeLineInfo = timeline
            print(timeline)
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let model = self.createViewModel()
            self.view?.configure(with: model)
        }
    }
}

private extension ProfilePresenter {
    struct Constants {
        static let followersApperance = FactoryApperance().makeApperance(weight: .bold, size: 20, color: .white)
        static let followersTitle = LabelViewModel(text: "Followers", appearance: followersApperance)
        static let followingTitle = LabelViewModel(text: "Following", appearance: followersApperance)
    }
    
    func loadMediaIfNeed() {
        guard metadataURL.contains(where: { $0.value == nil }) else { return }
        let group = DispatchGroup()
        for tweet in metadataURL {
            guard tweet.value == nil else { continue }
            let provider = LPMetadataProvider()
            group.enter()
            provider.startFetchingMetadata(for: tweet.key) { [weak self] (data, error) in
                guard let self = self,
                    let data = data,
                    error == nil else { return }
                
                self.metadataURL[tweet.key] = data
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let model = self.createViewModel()
            self.view?.update(model: model)
        }
    }
    
    func validateIfMediaNeed(for url: String) -> LPLinkMetadata? {
        guard let url = URL(string: url) else { return nil }
        guard let data = metadataURL[url] as? LPLinkMetadata else {
            // FIXME: tricky way to define a element that needs to be pulled
            metadataURL[url] = nil as LPLinkMetadata?
            return nil
        }
        return data
    }
    
    func createTimeLineViewModel() -> [ProfileTweetViewModel] {
        
        let regularApperance = apperance.makeApperance(weight: .regular, size: 17, color: .mainBlue)
        let timeApperance = apperance.makeApperance(weight: .light, size: 12, color: .gray)
        let blackApperance = apperance.makeApperance(weight: .light, size: 14, color: .darkGray)
        
        let timeline: [ProfileTweetViewModel] = timeLineInfo.compactMap {
            
            let name = LabelViewModel(text: "\($0.user.screen_name) @\($0.user.name)", appearance: regularApperance)
            let tweet = LabelViewModel(text: $0.text, appearance: blackApperance)
            let date = inputFormatter.date(from: $0.created_at) ?? Date()
            let humanDate =  relativeFormatter.localizedString(for: date, relativeTo: Date())
            let tweetInfo = LabelViewModel(text: humanDate, appearance: timeApperance)
            
            let url = $0.entities.urls?.first?.url ?? ""
            let metadata: LPLinkMetadata? = validateIfMediaNeed(for: url)
            
            return ProfileTweetViewModel(id: $0.id_str,
                                            name: name,
                                            tweet: tweet,
                                            tweetInfo: tweetInfo,
                                            linkData: metadata,
                                            profilePic: URL(string: $0.user.profile_image_url_https))
            
        }
        loadMediaIfNeed()
        return timeline
    }
    
    func createProfileViewModel() -> ProfileInfoViewModel? {
        let regularText = apperance.makeApperance(color: .white)
        let titleApperance = apperance.makeApperance(weight: .bold, size: 40, color: .white)
        let boldRegular = apperance.makeApperance(weight: .bold, size: 16, color: .white)
        
        guard let info = userInfo else { return nil }
        let aboutInfo = info.description.isEmpty ? "Nothing about me yet." : info.description
        
        let profileName = LabelViewModel(text: info.screen_name, appearance: titleApperance)
        let about = LabelViewModel(text: aboutInfo, appearance: regularText)
        let profileUser = LabelViewModel(text: info.name, appearance: boldRegular)
        let followersCount = LabelViewModel(text: info.followers_count.description, appearance: boldRegular)
        let followingCount = LabelViewModel(text: info.friends_count.description, appearance: boldRegular)
        
        return ProfileInfoViewModel(profileName: profileName,
                                    profileUser: profileUser,
                                    aboutMe: about,
                                    profilePic: URL(string: info.profile_image_url_https),
                                    followers: followersCount,
                                    following: followingCount,
                                    followersTitle: Constants.followersTitle,
                                    followingTitle: Constants.followingTitle)
    }
    
    func createViewModel() -> ProfileViewModel {
        var viewModel = ProfileViewModel(element: [])
        if let profile = createProfileViewModel() {
            viewModel.element.append(profile)
        }
        viewModel.element.append(contentsOf: createTimeLineViewModel())
        return viewModel
    }
}
