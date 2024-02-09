//
//  NetworkConfig.swift
//  Trending Movies
//
//  Created by Mohamed on 06/02/2024.
//
import Foundation

// MARK: - Protocol for Router: URLRequestConvertible

typealias QueryItems = [String: String]

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}
protocol RouterRequestConvertible: URLRequestConvertible {
    var method: HTTPMethod { get }
    var endPoint: EndPoint { get }
    var queryItems: QueryItems? { get }
    var headers: [String: String]? { get }
    var parameters: Parameters? { get }
    var environment: Environment { get }
}


