//
//  ProfileViewPresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import LinkPresentation

protocol ProfilePresenterProtocol {
    func handleTapNewTweet()
    func handleNewTweetAdded()
}

final class ProfileViewPresenter: Presenter {
    weak var view: ProfileView?
    private var timeLineProvider: UserService
    private var apperance = FactoryApperance()
    private var metadata: MetaDataStorage
    
    //TODO: Wrap this two into a single class and inject as dependancy
    private var inputFormatter = DateFormatter.inputFormatter
    private var relativeFormatter = RelativeDateTimeFormatter.relativeFormatter
    
    private var userInfo: User?
    
    private var timeLineInfo: [TimeLine] = []
    
    init(timeLineProvider: UserService = UserServiceImp(),
         metadata: MetaDataStorage = inject()) {
        self.timeLineProvider = timeLineProvider
        self.metadata = metadata
    }
}

extension ProfileViewPresenter: ProfilePresenterProtocol {
    func handleNewTweetAdded() {
        reloadView()
    }
    
    func handleTapNewTweet() {
        view?.goToNewTweet()
    }
    
    func sceneDidLoad() {
        reloadView()
    }
    
    func reloadView() {
        view?.showLoader()
        let group = DispatchGroup()
        group.enter()
        timeLineProvider.retrieveUserInfo { [weak self] profile in
            self?.userInfo = profile
            group.leave()
        }
        
        group.enter()
        timeLineProvider.retrieveUserTimeLine { [weak self] timeline in
            self?.timeLineInfo = timeline
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.loadView()
            self.view?.hideLoader()
        }
    }
}

private extension ProfileViewPresenter {
    struct Constants {
        static let followersApperance = FactoryApperance().makeApperance(weight: .bold, size: 20, color: .white)
        static let followersTitle = LabelViewModel(text: "Followers", appearance: followersApperance)
        static let followingTitle = LabelViewModel(text: "Following", appearance: followersApperance)
    }
    
    func loadView() {
        let model = createViewModel()
        view?.configure(with: model)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.metadata.loadMediaIfNeed(completion: self.updateView)
        }
    }
    
    func updateView() {
        let model = createViewModel()
        view?.update(model: model)
    }
    
    func createTimeLineViewModel() -> [ProfileTweetViewModel] {
        
        let regularApperance = apperance.makeApperance(weight: .regular, size: 17, color: .mainBlue)
        let timeApperance = apperance.makeApperance(weight: .light, size: 12, color: .gray)
        let blackApperance = apperance.makeApperance(weight: .light, size: 14, color: .darkGray)
        
        let timeline: [ProfileTweetViewModel] = timeLineInfo.compactMap {
            
            let name = LabelViewModel(text: "\($0.user.username) @\($0.user.displayName)", appearance: regularApperance)
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
                                            profilePic: URL(string: $0.user.profileImage))
            
        }
        
        return timeline
    }
    
    func createProfileViewModel() -> ProfileInfoViewModel? {
        let regularText = apperance.makeApperance(color: .white)
        let titleApperance = apperance.makeApperance(weight: .bold, size: 40, color: .white)
        let boldRegular = apperance.makeApperance(weight: .bold, size: 16, color: .white)
        
        guard let info = userInfo else { return nil }
        let aboutInfo = info.description.isEmpty ? "Nothing about me yet." : info.description
        
        let profileName = LabelViewModel(text: info.username, appearance: titleApperance)
        let about = LabelViewModel(text: aboutInfo, appearance: regularText)
        let profileUser = LabelViewModel(text: info.displayName, appearance: boldRegular)
        let followersCount = LabelViewModel(text: info.followers.description, appearance: boldRegular)
        let followingCount = LabelViewModel(text: info.following.description, appearance: boldRegular)
        
        return ProfileInfoViewModel(profileName: profileName,
                                    profileUser: profileUser,
                                    aboutMe: about,
                                    profilePic: URL(string: info.profileImage),
                                    followers: followersCount,
                                    following: followingCount,
                                    followersTitle: Constants.followersTitle,
                                    followingTitle: Constants.followingTitle)
    }
    
    func newTweetViewModel() -> ButtonViewModel {
        let style = StyleButton(fontTitle: .openSansBold(size: 20),
                                titleColor: [.normal(value: .white),],
                                             backgroundColor: .mainBlack,
                                             roundedBorder: 20)
        return .init(titles: [.normal(value: "+")],
                            style: style)
    }
    
    func createViewModel() -> ProfileViewModel {
        var viewModel = ProfileViewModel(navBarRightItem: newTweetViewModel(),
                                         element: [])
        
        //FIXME: Check for this validation seems redundant
        if let profile = createProfileViewModel() {
            viewModel.element.append(profile)
        }
        viewModel.element.append(contentsOf: createTimeLineViewModel())
        return viewModel
    }
}
