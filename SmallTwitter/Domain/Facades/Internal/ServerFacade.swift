//
//  ServerFacade.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

final class ServerFacade: NSObject, DomainFacade {
    struct Environment {
        static let `default` = Environment.dev
        static let dev = Environment(baseURL: "https://twitter-proxy.wize.mx/")
        
        fileprivate var baseURL: String
        
        fileprivate init(baseURL: String) {
            self.baseURL = baseURL
        }
    }
    static let shared = ServerFacade()
    
    var environment: Environment {
        didSet {
            httpClient.baseURL = environment.baseURL
        }
    }
    fileprivate lazy var httpClient: HTTPClient = {
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
        let httpClient = URLSessionHTTPClient(baseURL: self.environment.baseURL, urlSession: urlSession)
        httpClient.headersProvider = self
        return httpClient
    }()
    
    private init(environment: Environment = .default) {
        self.environment = environment
    }
}

extension DomainFacade {
    static func inyect() -> HTTPClient {
        return ServerFacade.shared.httpClient
    }
}

extension ServerFacade: HeadersProvider {
    func getHeaders() -> [String : String] {
        let headers = [
            "X-App-Platform": "ios",
            "X-App-Version": Bundle.main.appVersion
        ]
        return headers
    }
}

extension ServerFacade: URLSessionDelegate {

}

extension Bundle {
    var appVersion: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
}
