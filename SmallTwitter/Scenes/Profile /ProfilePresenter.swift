//
//  ProfilePresenter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

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
    var apperanceFactory = FactoryApperance()
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
    //TODO: - Move to a factory
    func createTimeLineViewModel() -> [ProfileTimeLineViewModel] {
        return timeLineInfo.compactMap {
            ProfileTimeLineViewModel(id: $0.id_str, name:
                .init(text: "@" + $0.user.name, appearance: .init(fuente: .boldSystemFont(ofSize: 13.0), colorTexto: .gray)),
                                     tweet: .init(text: $0.text, appearance: .init(fuente: .boldSystemFont(ofSize: 13.0), colorTexto: .black)), profilePic: URL(string: $0.user.profile_image_url_https)
            )
        }
    }
    
    func createProfileViewModel() -> ProfileInfoViewModel? {
        guard let info = userInfo else { return nil }
        let titleApperance = apperanceFactory.getApperance(for: .title)
        let regularText = apperanceFactory.getApperance(for: .profile)
        let boldRegular = apperanceFactory.getApperance(for: .profileBold)
        
        let profileName = LabelViewModel(text: info.screen_name, appearance: titleApperance)
        
        let aboutInfo = info.description.isEmpty ? "Nothing about me yet." : info.description
        let about = LabelViewModel(text: aboutInfo, appearance: regularText)
        
        let profileUser = LabelViewModel(text: info.name, appearance: boldRegular)
        
        return ProfileInfoViewModel(profileName: profileName,
                                    profileUser: profileUser,
                                    aboutMe: about,
                                    profilePic: URL(string: info.profile_image_url_https),
                                                    followers: profileUser,
                                        following: profileUser)
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
