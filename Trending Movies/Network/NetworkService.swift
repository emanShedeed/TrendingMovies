//
//  Network.swift
//  Trending Movies
//
//  Created by Mohamed on 06/02/2024.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Network Error

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serializationError
}


// MARK: - Protocol for Network Service

protocol NetworkService {
    func request<T: Decodable>(_ router: RouterRequestConvertible, responseType: T.Type) -> Observable<T>
}

// MARK: - Network Manager

class NetworkManager: NetworkService {
    func request<T: Decodable>(_ router: RouterRequestConvertible, responseType: T.Type) -> Observable<T> {
        guard let url = try? router.asURLRequest().url else {
            return Observable.error(NetworkError.invalidURL)
        }
        print(url.absoluteString)

        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        router.headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        // Add query items if any
        if let queryItems = router.queryItems {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = components.url
        }

        // Add parameters if any
        if let parameters = router.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        return URLSession.shared.rx.response(request: request)
            .map { response, data in
                guard 200..<300 ~= response.statusCode else {
                    throw NetworkError.invalidResponse
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    return decodedResponse
                } catch {
                    throw NetworkError.serializationError
                }
            }
            .asObservable()
    }
}

// MARK: - Sample Enums and Protocols for Demonstration

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Add more methods if needed
}




typealias Parameters = [String: Any]

extension URLRequestConvertible where Self: RouterRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: environment.baseURL + endPoint.path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        // Add query items if any
        if let queryItems = queryItems {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = components.url
        }

        // Add parameters if any
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        return request
    }
}

