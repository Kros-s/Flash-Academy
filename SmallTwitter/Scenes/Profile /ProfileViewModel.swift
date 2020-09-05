//
//  ProfileViewModel.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

struct ProfileViewModel {
    var element: [ProfileTableCellElement]
}

struct ProfileInfoViewModel: ProfileTableCellElement {
    var profileName: LabelViewModel
    var profileUser: LabelViewModel
    var aboutMe: LabelViewModel
    var profilePic: URL?
    var followers: LabelViewModel
    var following: LabelViewModel
    
    func accept<V>(visitor: V) -> V.Result where V : ProfileElementVisitor {
        visitor.visit(viewModel: self)
    }
}

struct ProfileTimeLineViewModel: ProfileTableCellElement {
    var id: String
    var name: LabelViewModel
    var tweet: LabelViewModel
    var profilePic: URL?
    
    func accept<V>(visitor: V) -> V.Result where V : ProfileElementVisitor {
        visitor.visit(viewModel: self)
    }
}

/// Visitor pattern
protocol ProfileTableCellElement {
    func accept<V: ProfileElementVisitor>(visitor: V) -> V.Result
}

protocol ProfileElementVisitor {
    associatedtype Result
    func visit(viewModel: ProfileInfoViewModel) -> Result
    func visit(viewModel: ProfileTimeLineViewModel) -> Result
}

extension ProfileElementVisitor where Result == Void {
    func visit(viewModel: ProfileInfoViewModel) { }
    func visit(viewModel: ProfileTimeLineViewModel) { }
}
