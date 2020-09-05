//
//  User.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct GetUser: HTTPRequest {
    typealias Response = UserInfo
    struct Body: Codable { }
    
    var urlPath: String = "/api/user"
    var metodo: HTTPMethod = .get
    var cuerpo: Body?
}
