//
//  User.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct GetUserRequest: HTTPRequest {
    typealias Response = User
    struct Body: Codable { }
    
    var urlPath: String = "/api/user"
    var method: HTTPMethod = .get
    var body: Body?
}
