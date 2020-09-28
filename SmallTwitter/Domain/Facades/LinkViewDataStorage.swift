//
//  LinkViewDataStorage.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 09/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation
import LinkPresentation

extension Presenter {
    static func inject() -> MetaDataStorage {
        return LinkViewDataStorage.shared
    }
}

protocol MetaDataStorage {
    func loadMediaIfNeed(completion: @escaping (() -> Void))
    func retrieveMediaIfNeed(for url: String) -> LPLinkMetadata?
}

private final class LinkViewDataStorage: DomainFacade {
    
    //This will work as a data storage (singleton for now), should be changed to core data instead
    static let shared  = LinkViewDataStorage()
    private var metadataStorage: [URL: LPLinkMetadata?]
    
    private init() {
        metadataStorage = [:]
    }
}

extension LinkViewDataStorage: MetaDataStorage {
    func loadMediaIfNeed(completion: @escaping (() -> Void)) {
        guard metadataStorage.contains(where: { $0.value == nil }) else { return }
        let group = DispatchGroup()
        for tweet in metadataStorage {
            guard tweet.value == nil else { continue }
            let provider = LPMetadataProvider()
            group.enter()
            provider.startFetchingMetadata(for: tweet.key) { [weak self] (data, error) in
                guard let self = self,
                    let data = data,
                    error == nil else { return }
                
                self.metadataStorage[tweet.key] = data
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func retrieveMediaIfNeed(for url: String) -> LPLinkMetadata? {
        guard let url = URL(string: url) else { return nil }
        guard let data = metadataStorage[url] as? LPLinkMetadata else {
            // FIXME: tricky way to define a element that needs to be pulled
            metadataStorage[url] = nil as LPLinkMetadata?
            return nil
        }
        return data
    }
}
