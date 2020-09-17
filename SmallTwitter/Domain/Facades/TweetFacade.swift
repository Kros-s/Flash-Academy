//
//  TweetFacade.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 17/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol TweetFacadeProtocol {
    func sendTweet(_ tweet: String, completion: @escaping () -> Void)
}

final class TweetFacade: DomainFacade {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = inyect()) {
        self.httpClient = httpClient
    }
}

extension TweetFacade: TweetFacadeProtocol {
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
