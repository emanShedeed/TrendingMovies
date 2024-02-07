//
//  Environment.swift
//  Trending Movies
//
//  Created by Mohamed on 06/02/2024.
//

// MARK: - Environment Enum

enum Environment {
    case development
    case production

    var baseURL: String {
        switch self {
        case .development:
            return "https://developer.themoviedb.org/reference/"
        case .production:
            return "https://prod.themoviedb.org/reference/"
        }
    }
}
