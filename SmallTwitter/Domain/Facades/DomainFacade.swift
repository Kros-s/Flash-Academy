//
//  DomainFacade.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol DomainFacade {
}

struct DomainFacadeDebugging {
    static var mockFacades: Bool {
        return ProcessInfo.processInfo.arguments.contains("")
    }
}

extension DomainFacade {
    func finishOnMainThread<Arg>(completion: @escaping (Arg) -> Void) -> ((Arg) -> Void) {
        return { arg in
            DispatchQueue.main.async {
                completion(arg)
            }
        }
    }
}
