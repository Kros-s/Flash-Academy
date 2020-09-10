//
//  DateFormatter.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 09/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()
}

extension RelativeDateTimeFormatter {
    static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
}
