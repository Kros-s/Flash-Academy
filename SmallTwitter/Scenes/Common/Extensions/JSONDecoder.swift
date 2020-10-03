//
//  JSONDecoder.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 30/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static let DecoderWithStringFormat: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            return DateFormatter.inputFormatter.date(from: dateString) ?? Date()
        })
        return decoder
    }()
}
