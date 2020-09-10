//
//  NewTweetViewController.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 09/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

protocol NewTweetView: class {
    func configure()
}

final class NewTweetViewController: BaseViewController, MVPView {
    lazy var presenter: NewTweetPresenterProtocol = inyect()
    lazy var router: Router = inyect()
}

extension NewTweetViewController: NewTweetView {
    func configure() {
        <#code#>
    }
}
