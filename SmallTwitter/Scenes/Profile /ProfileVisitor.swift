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
    private let indexPath: IndexPath
    
    init(tableView: UITableView, indexPath: IndexPath) {
        self.tableView = tableView
        self.indexPath = indexPath
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
