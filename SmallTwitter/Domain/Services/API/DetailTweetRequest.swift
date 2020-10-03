//
//  Show.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 18/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct DetailTweetRequest: HTTPRequest {
    typealias Body = Request
    typealias Response = TimeLine

    var urlPath: String
    var method: HTTPMethod = .get
    var body: Request?
    struct Request: Codable { }
    
    init(status: String) {
        urlPath = "/api/statuses/show/\(status)"
    }
}
