//
//  MockProfileView.swift
//  SmallTwitterTests
//
//  Created by Marco Antonio Mayen Hernandez on 28/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

@testable import SmallTwitter

final class MockProfileView: ProfileView {
    
    var validate: ((ProfileViewModel) -> Void)!
    var isConfigureBeingCalled = false
    var isUpdateBeinCalled = false
    
    func configure(with model: ProfileViewModel) {
        validate(model)
        isConfigureBeingCalled = true
    }
    
    func update(model: ProfileViewModel) {
        isUpdateBeinCalled = true
    }
    
    func showLoader() { }
    func hideLoader() { }
    func goToNewTweet() { }
}
