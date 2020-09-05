//
//  UserFacade.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

extension MVPPresenter {
    static func inyect() -> UserFacadeProtocol {
        return UserFacade.shared
    }
}

protocol UserFacadeProtocol {
    func retrieveUserInfo(completion: @escaping (User?) -> Void)
    func retrieveUserTimeLine(completion: @escaping ([TimeLine]) -> Void)
    
    func retrieveTweet(id: String) -> TimeLine?
}

private final class UserFacade: DomainFacade {
    static let shared = UserFacade()
    private let httpclient: HTTPClient
    
    private var lastTimeLine: [TimeLine] = []
    
    private init(httpclient: HTTPClient = inyect()) {
        self.httpclient = httpclient
    }
}

extension UserFacade: UserFacadeProtocol {
    
    func retrieveTweet(id: String) -> TimeLine? {
        return lastTimeLine.first { $0.id_str == id }
    }
    
    func retrieveUserTimeLine(completion: @escaping ([TimeLine]) -> Void) {
        let request = UserTimeline()
        let finishOnMainThread = self.finishOnMainThread(completion: completion)
        //Need to load other data
        
        httpclient.execute(solicitud: request) { [weak self] response in
            switch response.result {
            case .success(let timeline):
                self?.lastTimeLine = timeline
                finishOnMainThread(timeline)
            case .failure:
                finishOnMainThread([])
            }
        }
        
    }
    
    func retrieveUserInfo(completion: @escaping (User?) -> Void) {
        let request = GetUser()
        let finishOnMainThread = self.finishOnMainThread(completion: completion)
        
        //Need to load other data
        
        httpclient.execute(solicitud: request) { response in
            switch response.result {
            case .success(let user):
                finishOnMainThread(user)
            case .failure:
                finishOnMainThread(nil)
            }
        }
    
    }
}
