//
//  TimeLine.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct TimeLine: Codable {
    var id_str: String
    var text: String
    var user: User
    var created_at: String
    var entities: Entities
}

struct Entities: Codable {
    var urls: [SharedURL]?
}

struct SharedURL: Codable {
    var url: String
    var display_url: String
}
