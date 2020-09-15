//
//  ProfileInfoViewModel.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct ProfileInfoViewModel: ProfileTableCellElement {
    var profileName: LabelViewModel
    var profileUser: LabelViewModel
    var aboutMe: LabelViewModel
    var profilePic: URL?
    var followers: LabelViewModel
    var following: LabelViewModel
    var followersTitle: LabelViewModel
    var followingTitle: LabelViewModel
    
    func accept<V>(visitor: V) -> V.Result where V : ProfileElementVisitor {
        visitor.visit(viewModel: self)
    }
}
