//
//  UserInfo.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String
    var screen_name: String
    var description: String
    var profile_image_url_https: String
}
