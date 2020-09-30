//
//  UserInfo.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct User: Codable {
    var displayName: String
    var username: String
    var description: String
    var profileImage: String
    var followers: Int
    var following: Int
    
    enum CodingKeys: String, CodingKey {
        case displayName = "name"
        case username = "screen_name"
        case description
        case profileImage = "profile_image_url_https"
        case followers = "followers_count"
        case following = "friends_count"
    }
}
