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
    func update(model: ProfileViewModel)
    func showLoader()
    func hideLoader()
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
        table.backgroundColor = .softBlue
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
    func update(model: ProfileViewModel) {
        elements = model.element
    }
    
    func configure(with model: ProfileViewModel) {
        view.backgroundColor = .softBlue
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
        
        let factory = ProfileVisitor(tableView: tableView, indexPath: indexPath)
        let cell = factory.createCell(element: elements[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elements[indexPath.row].accept(visitor: self)
    }
}

extension ProfileViewController: ProfileElementVisitor {
    func visit(viewModel: ProfileTweetViewModel) {
        router.tapOnTweet(id: viewModel.id)
    }
}
