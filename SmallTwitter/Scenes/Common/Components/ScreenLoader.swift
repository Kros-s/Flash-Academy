//
//  ScreenLoader.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 11/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import UIKit

protocol LoaderViewPresentable {
    func showLoader()
    func hideLoader()
}

extension LoaderViewPresentable where Self: UIViewController {
    func findLoader() -> ScreenLoaderProtocol? {
        return view.subviews.compactMap { $0 as? ScreenLoaderProtocol }.first
    }
    
    func hideLoader() {
        findLoader()?.removeLoader()
    }
    
    func showLoader() {
        let loaderView: ScreenLoaderProtocol = ScreenLoader()
        loaderView.addLoader(view: self.view)
    }
}

protocol ScreenLoaderProtocol {
    func addLoader(view: UIView)
    func removeLoader()
}

final class ScreenLoader: UIView {
    
    struct Constants {
        static let backgroundColor: UIColor = .softBlue
        static let squareBackground: UIColor = .white
        static let mainSize: CGFloat = 40
        static let squareSize: CGFloat = 80
        static let cornerRadious: CGFloat = 10
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: Constants.mainSize, height: Constants.mainSize))
        indicator.style = .large
        indicator.layer.cornerRadius = 0
        indicator.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    lazy var container: UIView = {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: Constants.squareSize,
                                        height: Constants.squareSize))
        view.backgroundColor = Constants.squareBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadious
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
}

private extension ScreenLoader {
    func configure() {
        backgroundColor = Constants.backgroundColor
        container.addSubview(activityIndicator)
        addSubview(container)
    }
}

extension ScreenLoader: ScreenLoaderProtocol {
    func addLoader(view: UIView) {
        frame = view.frame
        center = view.center
        container.center = center
        view.addSubview(self)
    }
    
    func removeLoader() {
        self.removeFromSuperview()
    }
}
