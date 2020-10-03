//
//  TweetFacade.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 17/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol SendService {
    func sendTweet(_ tweet: String, completion: @escaping () -> Void)
}

protocol GetInfoService {
    func getTweetInfo(id: String, completion: @escaping (TimeLine) -> Void)
}

final class TweetService: Domain {
    private let httpClient: Service
    
    init(httpClient: Service = HTTPProvider(responseDecoder: .DecoderWithStringFormat)) {
        self.httpClient = httpClient
    }
}

extension TweetService: SendService {
    func sendTweet(_ tweet: String, completion: @escaping () -> Void) {
        let request = NewTweetRequest(body: Tweet(status: tweet))
        let finishOnMainThread = self.finishOnMainThread(completion: completion)
        
        httpClient.execute(request: request) { response in
            
            switch response {
            case .success:
                finishOnMainThread(())
            case .failure:
                finishOnMainThread(())
            }
        }
    }
}

extension TweetService: GetInfoService {
    func getTweetInfo(id: String, completion: @escaping (TimeLine) -> Void) {
        let request = DetailTweetRequest(status: id)
        let finishOnMainThread = self.finishOnMainThread(completion: completion)
        httpClient.execute(request: request) { response in
            switch response {
            case .success(let tweetInfo):
                finishOnMainThread(tweetInfo)
            case .failure:
                break
            }
        }
    }
}
