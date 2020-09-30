//
//  ProfilePresenterTests.swift
//  SmallTwitterTests
//
//  Created by Marco Antonio Mayen Hernandez on 28/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import XCTest
@testable import SmallTwitter

final class ProfilePresenterTests: XCTestCase {
    var presenter: ProfileViewPresenter!
    var mockUserService: MockUserService!
    var mockMetadata: MockMetadataStorage!
    var mockView: MockProfileView!
    
    override func setUp() {
        super.setUp()
        mockUserService = MockUserService()
        mockMetadata = MockMetadataStorage()
        mockView = MockProfileView()
        
        presenter = ProfileViewPresenter(timeLineProvider: mockUserService,
                                     metadata: mockMetadata)
        presenter.view = mockView
    }
    
    override func tearDown() {
        super.tearDown()
        presenter = nil
        mockUserService = nil
        mockMetadata = nil
    }
    
    func test_load_view_scene_did_load() {
        let profileExpectation = expectation(description: "Expectation for ProfileView")
        
        mockUserService.mock_getUserInfo = { handler in
            handler(self.getMockUser())
        }
        
        mockUserService.mock_getTimeLine = { handler in
            handler([])
        }
        
        mockMetadata.mock_load = { handler in
            profileExpectation.fulfill()
            handler()
        }
        
        mockView.validate = { model in
            let profileModel = model.element.compactMap{
                $0 as? ProfileInfoViewModel
            }.first
            let user = self.getMockUser()
            XCTAssertEqual(profileModel?.followers.text, user.followers.description)
            XCTAssertEqual(profileModel?.following.text, user.following.description)
            XCTAssertEqual(profileModel?.profileName.text, user.username)
            XCTAssertEqual(profileModel?.profileUser.text, user.displayName)
            XCTAssertNil(profileModel?.profilePic)
            
        }
        presenter.sceneDidLoad()
        
        waitForExpectations(timeout: 1.0)
        XCTAssert(mockView.isConfigureBeingCalled)
    }
    
    private func getMockUser() -> User {
        User(name: "Kross",
             screen_name: "@Kross",
             description: "iOS Dev",
             profile_image_url_https: "",
             followers_count: 10,
             friends_count: 0)
    }
}

