//
//  ProfileElementVisitor.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

protocol ProfileElementVisitor {
    associatedtype Result
    func visit(viewModel: ProfileInfoViewModel) -> Result
    func visit(viewModel: ProfileTweetViewModel) -> Result
}

extension ProfileElementVisitor where Result == Void {
    func visit(viewModel: ProfileInfoViewModel) { }
    func visit(viewModel: ProfileTweetViewModel) { }
}
