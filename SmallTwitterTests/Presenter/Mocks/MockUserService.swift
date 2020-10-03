//
//  MockUserService.swift
//  SmallTwitterTests
//
//  Created by Marco Antonio Mayen Hernandez on 28/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

@testable import SmallTwitter

final class MockUserService: UserService {
    typealias RetrieveClosure = (User?) -> Void
    typealias TimeLineClosure = ([TimeLine]) -> Void
    
    var mock_getUserInfo: ((RetrieveClosure) -> Void)!
    var mock_getTimeLine: ((TimeLineClosure) -> Void)!
    var mock_getTweet: TimeLine!
    
    func retrieveUserInfo(completion: @escaping (User?) -> Void) {
        mock_getUserInfo(completion)
    }
    
    func retrieveUserTimeLine(completion: @escaping ([TimeLine]) -> Void) {
        mock_getTimeLine(completion)
    }
    
    func retrieveTweet(id: String) -> TimeLine? {
        return mock_getTweet
    }
    
    
}
