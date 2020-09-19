//
//  HTTPClient.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

enum HTTPMethod: String, CaseIterable {
    case post = "POST"
    case get = "GET"
}

protocol HTTPRequest {
    associatedtype Body: Codable
    associatedtype Response: Codable
    
    var urlPath: String { get }
    var method: HTTPMethod { get }
    var body: Body? { get }
    var headers: [String: String] { get }
}

extension HTTPRequest {
    var headers: [String: String] {
        return [:]
    }
}

struct HTTPResponse<Model> {
    enum Error: Swift.Error {
        case unknown
        case noInternetConnection
        case urlBadFormed
        case badCodificationBody(error: Swift.Error)
        case badResponseDecoding(error: Swift.Error)
        case serverError
        case httpError(error: Swift.Error?)
    }
    let httpResponse: HTTPURLResponse?
    let result: Result<Model, Error>
}

protocol HTTPClient: class {
    var baseURL: String { get set }
    func execute<NetworkRequest: HTTPRequest>(request: NetworkRequest,
                                            completion: @escaping (HTTPResponse<NetworkRequest.Response>) -> Void)
}

final class URLSessionHTTPClient {
    private let bodyEncoder: JSONEncoder
    private let responseDecoder: JSONDecoder
    private let urlSession: URLSession
    
    var baseURL: String
    
    init(baseURL: String,
         urlSession: URLSession,
         bodyEncoder: JSONEncoder = .init(),
         responseDecoder: JSONDecoder = .init()) {
        self.baseURL = baseURL
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
        self.urlSession = urlSession
    }
}

extension URLSessionHTTPClient: HTTPClient {
    private struct Constants {
        static let httpSuccesfulRange = 200...299
    }
    
    func execute<NetworkRequest: HTTPRequest>(
        request: NetworkRequest,
        completion: @escaping (HTTPResponse<NetworkRequest.Response>) -> Void
    ) {
        let factoryResponse = HTTPFactoryResponse<NetworkRequest>()
        
        do {
            let urlRequest = try createURLRequest(for: request)
            let task = self.urlSession.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
                guard
                    let self = self,
                    let httpResponse = urlResponse as? HTTPURLResponse
                else {
                    let noInternetConnection = (error as NSError?)?.code == NSURLErrorNotConnectedToInternet
                    completion(factoryResponse.createFailureResponse(error: noInternetConnection ? .noInternetConnection : .unknown))
                    return
                }
                factoryResponse.httpResponse = httpResponse
                
                guard Constants.httpSuccesfulRange.contains(httpResponse.statusCode) else {
                    if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                         print("[DEBUG] Error Response: \(json)")
                    }
                   
                    completion(factoryResponse.createFailureResponse(error: .httpError(error: error)))
                    return
                }
                
                completion(self.decodeResponse(request: request,
                                                        urlRequest: urlRequest,
                                                        httpResponse: httpResponse,
                                                        data: data, error: error))
            }
            task.resume()
        } catch {
            guard let errorDetected = error as? HTTPResponse<NetworkRequest.Response>.Error else {
                completion(factoryResponse.createFailureResponse(error: .unknown))
                return
            }
            completion(factoryResponse.createFailureResponse(error: errorDetected))
        }
    }
}

private extension URLSessionHTTPClient {
    func createURLRequest<NetworkRequest: HTTPRequest>(for request: NetworkRequest) throws -> URLRequest {
        guard let url = URL(string: baseURL + request.urlPath) else {
            throw HTTPResponse<NetworkRequest.Response>.Error.urlBadFormed
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let headers = request.headers
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = request.body {
            do {
                urlRequest.httpBody = try bodyEncoder.encode(body)
            } catch let error {
                throw HTTPResponse<NetworkRequest.Response>.Error.badCodificationBody(error: error)
            }
        }
        
        return urlRequest
    }
    
    func decodeResponse<NetworkRequest: HTTPRequest>(
        request: NetworkRequest,
        urlRequest: URLRequest,
        httpResponse: HTTPURLResponse?,
        data: Data?,
        error: Error?) -> HTTPResponse<NetworkRequest.Response>
    {
        let factoryResponse = HTTPFactoryResponse<NetworkRequest>()
        factoryResponse.httpResponse = httpResponse
        
        switch (error: error, data: data) {
        case (error: .some(let requestError), data: _):
            return factoryResponse.createFailureResponse(error: .httpError(error: requestError))
        case (error: .none, data: .some(let responseData)):
            do {
                let decodedResponse = try responseDecoder.decode(NetworkRequest.Response.self, from: responseData)
                return factoryResponse.createSuccessfulResponse(response: decodedResponse)
            } catch let error {
                let json = (try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]) ?? [:]
                print("[DEBUG] ERROR RECEIVED: \n \(error) \n [DEBUG] WHILE PARSING: \n \(json)")
                return factoryResponse.createFailureResponse(error: .badResponseDecoding(error: error))
            }
        case (error: .none, data: .none):
            return factoryResponse.createFailureResponse(error: .serverError)
        }
    }
}

