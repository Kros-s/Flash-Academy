//
//  ProfileTweetViewModel.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import LinkPresentation

struct ProfileTweetViewModel: ProfileTableCellElement {
    var id: String
    var name: LabelViewModel
    var tweet: LabelViewModel
    var tweetInfo: LabelViewModel
    var linkData: LPLinkMetadata?
    var profilePic: URL?
    
    func accept<V>(visitor: V) -> V.Result where V : ProfileElementVisitor {
        visitor.visit(viewModel: self)
    }
}
