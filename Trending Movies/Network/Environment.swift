//
//  Environment.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 06/02/2024.
//

// MARK: - Environment Enum

enum Environment {
    case development
    case production

    var baseURL: String {
        switch self {
        case .development:
            return "https://api.themoviedb.org/3/"
        case .production:
            return "https://api.themoviedb.org/3/"
        }
    }
}
