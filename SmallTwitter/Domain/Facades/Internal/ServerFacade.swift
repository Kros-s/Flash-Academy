//
//  ServerFacade.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

final class ServerFacade: NSObject, DomainFacade {
    
    static let shared = ServerFacade()
    
    var baseURL: String {
        didSet {
            httpClient.baseURL = baseURL
        }
    }
    fileprivate lazy var httpClient: HTTPClient = {
        let urlSession = URLSession(configuration: .default,
                                    delegate: nil,
                                    delegateQueue: nil)
        let httpClient = URLSessionHTTPClient(baseURL: self.baseURL, urlSession: urlSession)
        return httpClient
    }()
    
    private init(baseURL: String = "https://twitter-proxy.wize.mx/") {
        self.baseURL = baseURL
    }
}

extension DomainFacade {
    static func inject() -> HTTPClient {
        return ServerFacade.shared.httpClient
    }
}
