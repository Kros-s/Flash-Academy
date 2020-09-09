//
//  ProfileFactoryCells.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

final class ProfileVisitor {
    let tableView: UITableView
    let indexPath: IndexPath
    
    init(tableView: UITableView, indexPath: IndexPath) {
        self.tableView = tableView
        self.indexPath = indexPath
    }
    
    func createCell(element: ProfileTableCellElement) -> UITableViewCell {
        element.accept(visitor: self)
    }
}

extension ProfileVisitor: ProfileElementVisitor {
    func visit(viewModel: ProfileTweetViewModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineTableViewCell") as? TimeLineTableViewCell else {
            return .init()
        }
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    func visit(viewModel: ProfileInfoViewModel) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as? ProfileTableViewCell else {
            return .init()
        }
        cell.configure(viewModel: viewModel)
        return cell
    }
}
