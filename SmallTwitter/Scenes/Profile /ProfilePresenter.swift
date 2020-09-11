//
//  ProfilePresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import LinkPresentation

protocol ProfilePresenterProtocol {
    
}

final class ProfilePresenter: MVPPresenter {
    weak var view: ProfileView?
    var userFacade: UserFacadeProtocol
    var apperance = FactoryApperance()
    var metadata: MetaDataStorage
    
    private var metadataURL: [URL: LPLinkMetadata?] = [:]
    
    //TODO: Wrap this two into a single class and inyect as dependancy
    private var inputFormatter = DateFormatter.inputFormatter
    private var relativeFormatter = RelativeDateTimeFormatter.relativeFormatter
    
    private var userInfo: User?
    
    //TODO: Move into a DataStorage in order to retrieve data from it
    private var timeLineInfo: [TimeLine] = []
    
    init(userFacade: UserFacadeProtocol = inyect(),
         metadata: MetaDataStorage = inyect()) {
        self.userFacade = userFacade
        self.metadata = metadata
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func sceneDidLoad() {
        view?.showLoader()
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
            self.loadView()
            self.view?.hideLoader()
        }
    }
}

private extension ProfilePresenter {
    struct Constants {
        static let followersApperance = FactoryApperance().makeApperance(weight: .bold, size: 20, color: .white)
        static let followersTitle = LabelViewModel(text: "Followers", appearance: followersApperance)
        static let followingTitle = LabelViewModel(text: "Following", appearance: followersApperance)
    }
    
    func loadView() {
        let model = createViewModel()
        view?.configure(with: model)
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
            let metadataInfo: LPLinkMetadata? = metadata.retrieveMediaIfNeed(for: url)
            
            return ProfileTweetViewModel(id: $0.id_str,
                                            name: name,
                                            tweet: tweet,
                                            tweetInfo: tweetInfo,
                                            linkData: metadataInfo,
                                            profilePic: URL(string: $0.user.profile_image_url_https))
            
        }
        metadata.loadMediaIfNeed(completion: loadView)
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
