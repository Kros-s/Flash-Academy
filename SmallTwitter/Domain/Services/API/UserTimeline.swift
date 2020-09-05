//
//  UserTimeline.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct UserTimeline: HTTPRequest {
    typealias Response = [TimeLine]
    struct Body: Codable { }
    
    var urlPath: String = "/api/statuses/user_timeline"
    var metodo: HTTPMethod = .get
    var cuerpo: Body?
}
