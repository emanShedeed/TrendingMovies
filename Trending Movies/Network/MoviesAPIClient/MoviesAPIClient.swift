//
//  MoviesAPIClient.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import RxSwift

class MoviesAPIClient {
    
    static func fetchMovies(page: Int) -> Observable<MoviePageDTO> {
        return  NetworkManager().request(MoviesAPIRouter.fetchMovies(page: page), responseType: MoviePageDTO.self)
       
    }
    
    static func fetchGenres() -> Observable<GenreListDTO> {
        return NetworkManager().request(MoviesAPIRouter.fetchGenres, responseType: GenreListDTO.self)
    }
}


fileprivate enum MoviesAPIRouter: RouterRequestConvertible {
   
    var environment: Environment {
        .development
    }
    
    case fetchMovies(page: Int, sortBy: String = "popularity.desc", includeAdult: Bool = false)
    case fetchGenres
    
    var method: HTTPMethod {
        switch self {
        case .fetchMovies, .fetchGenres:
            return .get
        }
    }
    
    var endPoint: EndPoint {
        switch self {
        case .fetchMovies(let page, _, _):
            return APIs.Movies.fetchMovies(pageNo: "\(page)")
            
        case .fetchGenres:
            return APIs.Movies.fetchGenres
        }
    }
    
    var queryItems: QueryItems? {
        switch self {
        case .fetchMovies(let page, let sortBy, let includeAdult):
            return [
                "page": "\(page)",
                "sort_by": sortBy,
                "include_adult": "\(includeAdult)"
            ]
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    struct Keys {
        // Keys if any
    }
}
