//
//  Reusable.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 27/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol Reusable: class {
    static var reusableIdentifier: String { get }
}

extension Reusable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
