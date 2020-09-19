//
//  HTTPFactoryResponse.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 18/09/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

final class HTTPFactoryResponse<NetworkRequest: HTTPRequest> {
    var httpResponse: HTTPURLResponse?
    
    func createSuccessfulResponse(response: NetworkRequest.Response) -> HTTPResponse<NetworkRequest.Response> {
        return .init(httpResponse: httpResponse,
                     result: .success(response))
    }
    
    func createFailureResponse(error: HTTPResponse<NetworkRequest.Response>.Error) -> HTTPResponse<NetworkRequest.Response> {
        return .init(httpResponse: httpResponse,
                     result: .failure(error))
    }
}

