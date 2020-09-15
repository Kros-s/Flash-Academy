//
//  CustomNavigationBar.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import UIKit

protocol NavigationBarPresentable {
    var navigationBarBottomAnchor: NSLayoutYAxisAnchor { get }
    func setupNavigationBar()
    func configureNavBar(viewModel: NavigationBarViewModel)
    func setNavBar(delegate: DelegateCustomNavigationBar?)
    func isNavBarVisible(_ show: Bool)
}

extension NavigationBarPresentable where Self: UIViewController {
    var navigationBarBottomAnchor: NSLayoutYAxisAnchor {
        return findNavigation()?.bottomAnchor ?? view.bottomAnchor
    }
    
    func setupNavigationBar() {
        guard findNavigation() == nil else {
            return
        }
        let navigationBar = CustomNavigationBar()
        navigationBar.addCustomNavBar(container: self.view, height: 55.0)
    }
    
    func findNavigation() -> CustomNavigationBarProtocol? {
        return view.subviews.compactMap { $0 as? CustomNavigationBarProtocol }.first
    }
    
    func configureNavBar(viewModel: NavigationBarViewModel) {
        findNavigation()?.configureNavBar(viewModel: viewModel)
    }
    
    func setNavBar(delegate: DelegateCustomNavigationBar?) {
        var navigationBar = findNavigation()
        navigationBar?.delegate = delegate
    }
    
    func isNavBarVisible(_ show: Bool) {
        var navigationBar = findNavigation()
        navigationBar?.isVisible = show
    }
    
    func showLeftButton(_ show: Bool) {
        let navigationBar = findNavigation()
        navigationBar?.showLeftButton(show)
    }
}

struct NavigationBarViewModel {
    var isVisible: Bool = true
    var headerText: LabelViewModel
    var showBackButton: Bool
}

extension NavigationBarViewModel {
    static let TweetView = NavigationBarViewModel(headerText: .init(text: "Tweet", appearance: FactoryApperance().makeApperance()), showBackButton: true)
    static let GeneralView = NavigationBarViewModel(headerText: .init(text: "", appearance: FactoryApperance().makeApperance()), showBackButton: false)
}

protocol DelegateCustomNavigationBar: class {
    func leftButtonSelected()
}

protocol CustomNavigationBarProtocol {
    var delegate: DelegateCustomNavigationBar? { get set }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var isVisible: Bool { get set }
    func addCustomNavBar(container: UIView, height: CGFloat)
    func showLeftButton(_ show: Bool)
    func configureNavBar(viewModel: NavigationBarViewModel)
}

final class CustomNavigationBar: UIView {
    private var leftButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "chevron.left"), for: .normal)
        button.isHidden = true
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(leftButtonActivated), for: .touchUpInside)
        return button
    }()
    
    private var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "NO TITLE"
        return title
    }()

    weak var delegate: DelegateCustomNavigationBar?
    
    var isVisible: Bool = false {
        didSet {
            isHidden = !isVisible
        }
    }
    
    var showLeftButton: Bool = true {
        didSet {
            leftButton.isHidden = !showLeftButton
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

extension CustomNavigationBar: CustomNavigationBarProtocol {
    
    func setupView() {
        addSubview(leftButton)
        addSubview(title)
        
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            leftButton.topAnchor.constraint(equalTo: topAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 40),
            leftButton.widthAnchor.constraint(equalToConstant: 40),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5),
            title.heightAnchor.constraint(equalToConstant: bounds.height * 0.8),
            title.widthAnchor.constraint(equalToConstant: 150.0)
        ])
    }
    
    @objc func leftButtonActivated() {
        delegate?.leftButtonSelected()
    }
    
    func addCustomNavBar(container: UIView, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            trailingAnchor.constraint(equalTo: container.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func showLeftButton(_ show: Bool) {
        showLeftButton = show
    }
    
    func configureNavBar(viewModel: NavigationBarViewModel) {
           showLeftButton(viewModel.showBackButton)
           title.configure(model: viewModel.headerText)
       }
    
}
