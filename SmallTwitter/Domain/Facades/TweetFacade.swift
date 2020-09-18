//
//  TweetFacade.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 17/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol SendTweetFacadeProtocol {
    func sendTweet(_ tweet: String, completion: @escaping () -> Void)
}

protocol TweetFacadeProtocol {
    func getTweetInfo(id: String, completion: @escaping (TimeLine) -> Void)
}

final class TweetFacade: DomainFacade {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = inject()) {
        self.httpClient = httpClient
    }
}

extension TweetFacade: SendTweetFacadeProtocol {
    func sendTweet(_ tweet: String, completion: @escaping () -> Void) {
        let request = Update(body: Tweet(status: tweet))
        let finishOnMainThread = self.finishOnMainThread(completion: completion)
        
        httpClient.execute(request: request) { response in
            switch response.result {
            case .success:
                finishOnMainThread(())
            case .failure:
                finishOnMainThread(())
            }
        }
    }
}

extension TweetFacade: TweetFacadeProtocol {
    func getTweetInfo(id: String, completion: @escaping (TimeLine) -> Void) {
        let request = Show(status: id)
        let finishOnMainThread = self.finishOnMainThread(completion: completion)
        httpClient.execute(request: request) { response in
            switch response.result {
            case .success(let tweetInfo):
                finishOnMainThread(tweetInfo)
            case .failure:
                break
            }
        }
    }
}
