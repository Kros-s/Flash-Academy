//
//  ProfileViewController.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

protocol ProfileView: class {
    func configure(with model: ProfileViewModel)
}

final class ProfileViewController: BaseViewController, MVPView {
    
    lazy var presenter: ProfilePresenterProtocol = inyect()
    
    lazy var router: Router = inyect()
    
    var elements: [ProfileTableCellElement] = [] {
        didSet {
            profileTable.reloadData()
        }
    }
    
    lazy var profileTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layoutMargins = .zero
        table.separatorInset = .zero
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.indicatorStyle = .white
        table.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        table.register(TimeLineTableViewCell.self, forCellReuseIdentifier: "TimeLineTableViewCell")
        return table
    }()
}

extension ProfileViewController: ProfileView {
    func configure(with model: ProfileViewModel) {

        profileTable.delegate = self
        profileTable.dataSource = self
        elements = model.element
        
        view.addSubview(profileTable)
        
        NSLayoutConstraint.activate([
            profileTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            profileTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            profileTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            profileTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let factory = ProfileFactoryCells(tableView: tableView, indexPath: indexPath)
        let cell = factory.createCell(element: elements[indexPath.row])
        cell.selectionStyle = .none
        UIView.performWithoutAnimation {
            // This explicit call to layout the cell without animation is to prevent the cell's content to be updated with animation, for cells that are being dequeued as a result of animating the content offset (as we do when reacting to keyboard changes).
            cell.layoutIfNeeded()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements[indexPath.row].accept(visitor: self)
    }
}

extension ProfileViewController: ProfileElementVisitor {
    func visit(viewModel: ProfileTimeLineViewModel) {
        router.tapOnTweet(id: viewModel.id)
    }
}
