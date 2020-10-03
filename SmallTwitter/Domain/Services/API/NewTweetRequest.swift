//
//  Update.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 17/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct NewTweetRequest: HTTPRequest {
    typealias Response = ResponseNull
    
    var urlPath: String = "/api/statuses/update"
    var method: HTTPMethod = .post
    var body: Tweet?
    
    typealias Body = Tweet
    
    struct ResponseNull: Codable { }
}

struct Tweet: Codable {
    var status: String
}
