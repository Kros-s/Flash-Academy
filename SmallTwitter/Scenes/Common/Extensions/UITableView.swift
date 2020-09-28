//
//  UITableView.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 27/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: Reusable>(_ cellType: T.Type) {
        register(cellType.self, forCellReuseIdentifier: T.reusableIdentifier)
    }
    
    func dequeueReusableCell<T: Reusable>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier) as? T else {
            fatalError("Should implement Reusable protocol on the Cell")
        }
        return cell
    }
}
