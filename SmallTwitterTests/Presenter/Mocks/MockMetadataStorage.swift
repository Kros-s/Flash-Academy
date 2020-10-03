//
//  MockMetadataStorage.swift
//  SmallTwitterTests
//
//  Created by Marco Antonio Mayen Hernandez on 28/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import LinkPresentation

@testable import SmallTwitter

final class MockMetadataStorage: MetaDataStorage {
    var mock_load: ((() -> Void) -> Void)!
    var mock_metadata: LPLinkMetadata!
    
    func retrieveMediaIfNeed(for url: String) -> LPLinkMetadata? {
        return mock_metadata
    }
    
    func loadMediaIfNeed(completion: @escaping (() -> Void)) {
        mock_load(completion)
    }
}
