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
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case trace = "TRACE"
}

protocol HTTPRequest {
    associatedtype Body: Codable
    associatedtype Response: Codable
    
    var urlPath: String { get }
    var metodo: HTTPMethod { get }
    var cuerpo: Body? { get }
    var headers: [String: String] { get }
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
    let urlRequest: URLRequest?
    let httpResponse: HTTPURLResponse?
    let result: Result<Model, Error>
}

extension HTTPRequest {
    var headers: [String: String] {
        return [:]
    }
}

protocol HTTPClient: class {
    var baseURL: String { get set }
    var headersProvider: HeadersProvider? { get set }
    
    func execute<Solicitud: HTTPRequest>(solicitud: Solicitud,
                                            completion: @escaping (HTTPResponse<Solicitud.Response>) -> Void)
}

protocol HeadersProvider: class {
    func getHeaders() -> [String: String]
}

final class URLSessionHTTPClient {
    private let bodyEncoder: JSONEncoder
    private let responseDecoder: JSONDecoder
    private let urlSession: URLSession
    
    var baseURL: String
    weak var headersProvider: HeadersProvider?
    
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
    
    func execute<Solicitud: HTTPRequest>(
        solicitud: Solicitud,
        completion: @escaping (HTTPResponse<Solicitud.Response>) -> Void
    ) {
        let factoryResponse = HTTPFactoryResponse<Solicitud>()
        
        do {
            let urlRequest = try createURLRequest(for: solicitud)
            let task = self.urlSession.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
                factoryResponse.urlRequest = urlRequest
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
                
                completion(self.decodeResponse(solicitud: solicitud,
                                                        urlRequest: urlRequest,
                                                        httpResponse: httpResponse,
                                                        data: data, error: error))
            }
            task.resume()
        } catch {
            guard let errorDetected = error as? HTTPResponse<Solicitud.Response>.Error else {
                completion(factoryResponse.createFailureResponse(error: .unknown))
                return
            }
            completion(factoryResponse.createFailureResponse(error: errorDetected))
        }
    }
}

private extension URLSessionHTTPClient {
    func createURLRequest<Solicitud: HTTPRequest>(for solicitud: Solicitud) throws -> URLRequest {
        guard let url = URL(string: baseURL + solicitud.urlPath) else {
            throw HTTPResponse<Solicitud.Response>.Error.urlBadFormed
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = solicitud.metodo.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let headers = (self.headersProvider?.getHeaders() ?? [:]).merging(solicitud.headers) { $1 }
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = solicitud.cuerpo {
            do {
                urlRequest.httpBody = try bodyEncoder.encode(body)
            } catch let error {
                throw HTTPResponse<Solicitud.Response>.Error.badCodificationBody(error: error)
            }
        }
        
        return urlRequest
    }
    
    func decodeResponse<Solicitud: HTTPRequest>(
        solicitud: Solicitud,
        urlRequest: URLRequest,
        httpResponse: HTTPURLResponse?,
        data: Data?,
        error: Error?) -> HTTPResponse<Solicitud.Response>
    {
        let factoryResponse = HTTPFactoryResponse<Solicitud>()
        factoryResponse.urlRequest = urlRequest
        factoryResponse.httpResponse = httpResponse
        
        switch (error: error, data: data) {
        case (error: .some(let requestError), data: _):
            return factoryResponse.createFailureResponse(error: .httpError(error: requestError))
        case (error: .none, data: .some(let responseData)):
            do {
                let decodedResponse = try responseDecoder.decode(Solicitud.Response.self, from: responseData)
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

private final class HTTPFactoryResponse<Solicitud: HTTPRequest> {
    var urlRequest: URLRequest?
    var httpResponse: HTTPURLResponse?
    
    init() {
    }
    
    func createSuccessfulResponse(response: Solicitud.Response) -> HTTPResponse<Solicitud.Response> {
        return .init(urlRequest: urlRequest,
                     httpResponse: httpResponse,
                     result: .success(response))
    }
    
    func createFailureResponse(error: HTTPResponse<Solicitud.Response>.Error) -> HTTPResponse<Solicitud.Response> {
        return .init(urlRequest: urlRequest,
                     httpResponse: httpResponse,
                     result: .failure(error))
    }
}

