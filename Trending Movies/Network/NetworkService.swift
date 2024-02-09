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
    case noData
}


// MARK: - Protocol for Network Service

protocol NetworkService {
    func request<T: Decodable>(_ router: RouterRequestConvertible, responseType: T.Type) -> Observable<T>
}

// MARK: - Network Manager

class NetworkManager: NetworkService {
    private let baseHeaders: [String: String] = [
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NmMyYmIxMGEzNGFjNmNlNzgyYTNhODExN2Y4MGIxNSIsInN1YiI6IjY1YzA4YzM0MWRiYzg4MDE3YzIwNjQyMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qhnz7B8wCI-2bjngLy7kbxshmhrcKxpW2D5LNO9239I",
        "Accept": "application/json"
    ]
    
    func request<T: Decodable>(_ router: RouterRequestConvertible, responseType: T.Type) -> Observable<T> {
        guard let url = try? router.asURLRequest().url else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        
        // Add base headers
        for (key, value) in baseHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Add custom headers from the router
        for (key, value) in router.headers ?? [:] {
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
        print(request)
        
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle the response, data, and error here
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(NetworkError.invalidResponse)
                    return
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    observer.onError(NetworkError.invalidResponse)
                    return
                }
                
                guard let responseData = data else {
                    observer.onError(NetworkError.noData)
                    return
                }
                if let jsonString = String(data: responseData, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                } else {
                    print("Failed to convert response data to JSON string")
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedResponse = try decoder.decode(T.self, from: responseData)
                    observer.onNext(decodedResponse)
                    observer.onCompleted()
                } catch {
                    print("Error decoding JSON: \(error)")
                    observer.onError(NetworkError.serializationError)
                }
            }
            
            task.resume()
            
            return Disposables.create()
        }
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
        guard let url = URL(string: environment.baseURL + endPoint.subdomain + endPoint.path) else {
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
        DefaultNetworkErrorLogger().log(request: request)
        return request
    }
}


protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}
final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }

    func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {
        printIfDebug("\(error)")
    }
}
func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
