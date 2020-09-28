//
//  ProfileFactoryCells.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

final class ProfileCellConfiguratorVisitor {
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func configureCell(element: ProfileTableCellElement) -> UITableViewCell {
        element.accept(visitor: self)
    }
}

extension ProfileCellConfiguratorVisitor: ProfileElementVisitor {
    func visit(viewModel: ProfileTweetViewModel) -> UITableViewCell {
        let cell: TimeLineTableViewCell = tableView.dequeueReusableCell()
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    func visit(viewModel: ProfileInfoViewModel) -> UITableViewCell {
        let cell: ProfileTableViewCell = tableView.dequeueReusableCell()
        cell.configure(viewModel: viewModel)
        return cell
    }
}
