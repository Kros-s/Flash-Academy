//
//  HTTPClient.swift
//  SmallTwitter
//
//  Created by Marco Antonio Mayen Hernandez on 14/08/20.
//  Copyright © 2020 Wizeline. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

protocol HTTPRequest {
    associatedtype Body: Codable
    associatedtype Response: Codable
    
    var urlPath: String { get }
    var method: HTTPMethod { get }
    var body: Body? { get }
}

enum ServiceError: Swift.Error {
    case badResponseDecoding
    case urlMalformation
    case serverError
}

protocol Service: class {
    var baseURL: String { get set }
    func execute<Request: HTTPRequest>(request: Request,
                                       completion: @escaping (Result<Request.Response, ServiceError>) -> Void)
}

final class HTTPProvider {
    private let bodyEncoder: JSONEncoder
    private let responseDecoder: JSONDecoder
    private let urlSession: URLSession
    
    var baseURL: String
    
    init(baseURL: String = "https://twitter-proxy.wize.mx",
         urlSession: URLSession = .shared,
         bodyEncoder: JSONEncoder = .init(),
         responseDecoder: JSONDecoder = .init()) {
        self.baseURL = baseURL
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
        self.urlSession = urlSession
    }
}

extension HTTPProvider: Service {
    
    func execute<Request: HTTPRequest>(request: Request,
                                       completion: @escaping (Result<Request.Response, ServiceError>) -> Void) {
        
        guard let urlRequest = try? createRequest(request: request) else {
            completion(.failure(.urlMalformation))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
            let httpSuccesfulRange = 200...299
            
            guard let data = data,
                let response = urlResponse as? HTTPURLResponse,
                httpSuccesfulRange.contains(response.statusCode) else {
                    completion(.failure(.serverError))
                    return
            }
            
            let dataDecoded = try? self?.responseDecoder.decode(Request.Response.self, from: data)
            
            guard let responseDecoded = dataDecoded else {
                completion(.failure(.badResponseDecoding))
                return
            }
            completion(.success(responseDecoded))
        }.resume()
    }
}

private extension HTTPProvider {
    func createRequest<Request: HTTPRequest>(request: Request) throws -> URLRequest {
        guard let url = URL(string: baseURL + request.urlPath) else {
            throw ServiceError.urlMalformation
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //MARK: we can force since we are sure Encodable is present
        if let body = request.body {
            urlRequest.httpBody = try! bodyEncoder.encode(body)
        }
        return urlRequest
    }
}
