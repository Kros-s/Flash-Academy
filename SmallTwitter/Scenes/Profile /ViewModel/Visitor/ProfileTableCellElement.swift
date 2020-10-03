//
//  ProfileTableCellElement.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

/// Visitor pattern
protocol ProfileTableCellElement {
    func accept<V: ProfileElementVisitor>(visitor: V) -> V.Result
}
