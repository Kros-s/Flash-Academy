//
//  UserFacade.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol UserService {
    func retrieveUserInfo(completion: @escaping (User?) -> Void)
    func retrieveUserTimeLine(completion: @escaping ([TimeLine]) -> Void)
    func retrieveTweet(id: String) -> TimeLine?
}

final class UserFacade: DomainFacade {
    private let httpclient: Service
    
    private var lastTimeLine: [TimeLine] = []
    
    init(httpclient: Service = HTTPProvider()) {
        self.httpclient = httpclient
    }
}

extension UserFacade: UserService {
    
    func retrieveTweet(id: String) -> TimeLine? {
        return lastTimeLine.first { $0.id_str == id }
    }
    
    func retrieveUserTimeLine(completion: @escaping ([TimeLine]) -> Void) {
        let request = UserTimelineRequest()
        let finishOnMainThread = self.finishOnMainThread(completion: completion)
        //Need to load other data
        
        httpclient.execute(request: request) { [weak self] response in
            switch response {
            case .success(let timeline):
                self?.lastTimeLine = timeline
                finishOnMainThread(timeline)
            case .failure:
                finishOnMainThread([])
            }
        }
        
    }
    
    func retrieveUserInfo(completion: @escaping (User?) -> Void) {
        let request = GetUserRequest()
        let finishOnMainThread = self.finishOnMainThread(completion: completion)
        
        //Need to load other data
        
        httpclient.execute(request: request) { response in
            switch response {
            case .success(let user):
                finishOnMainThread(user)
            case .failure:
                finishOnMainThread(nil)
            }
        }
    
    }
}
