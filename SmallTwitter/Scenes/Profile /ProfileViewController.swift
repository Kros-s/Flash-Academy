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
    func goToNewTweet()
}

final class ProfileViewController: UIViewController, BaseView {
    
    lazy var presenter: ProfilePresenterProtocol = inject()
    lazy var router: Router = inject()
    private lazy var dismissAction: () -> Void = { [weak self] in
        self?.presenter.handleNewTweetAdded()
    }
    
    private var profileTable = UITableView()
    private lazy var visitorCellConfigurator = ProfileCellConfiguratorVisitor(tableView: self.profileTable)
    private var elements: [ProfileTableCellElement] = [] {
        didSet {
            profileTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observer?.sceneDidLoad()
    }
}
 
private extension ProfileViewController {
    
    func configureProfileTable() {
        profileTable.backgroundColor = .softBlue
        profileTable.translatesAutoresizingMaskIntoConstraints = false
        profileTable.layoutMargins = .zero
        profileTable.separatorInset = .zero
        profileTable.separatorStyle = .none
        profileTable.rowHeight = UITableView.automaticDimension
        profileTable.indicatorStyle = .white
        profileTable.register(ProfileTableViewCell.self)
        profileTable.register(TimeLineTableViewCell.self)
        profileTable.delegate = self
        profileTable.dataSource = self
        view.addSubview(profileTable)
        NSLayoutConstraint.activate([
            profileTable.topAnchor.constraint(equalTo: navigationBarBottomAnchor, constant: 8.0),
            profileTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            profileTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            profileTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configureNavigationBar(button: ButtonViewModel) {
        setupNavigationBar()
        setNavBar(delegate: self)
        configureNavBar(viewModel: .GeneralView)
        configureRightItem(model: button)
        isNavBarVisible(true)
    }
}

extension ProfileViewController: ProfileView {
    func goToNewTweet() {
        router.tapOnNewTweet(action: dismissAction)
    }
    
    func update(model: ProfileViewModel) {
        elements = model.element
    }
    
    func configure(with model: ProfileViewModel) {
        view.backgroundColor = .softBlue
        configureProfileTable()
        configureNavigationBar(button: model.navBarRightItem)
        elements = model.element
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = visitorCellConfigurator.configureCell(element: elements[indexPath.row])
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

extension ProfileViewController: DelegateCustomNavigationBar {
    func rightButtonSelected() {
        presenter.handleTapNewTweet()
    }
}

extension ProfileViewController: NavigationBarPresentable, LoaderViewPresentable { }
