//
//  MoviesAPIClient.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import RxSwift

class MoviesAPIClient {
    
    static func fetchMovies(page: Int) -> Observable<MoviePageDTO> {
        return NetworkManager().request(MoviesAPIRouter.fetchMovies(page: page), responseType: MoviePageDTO.self)
    }
 
    static func fetchGenres() -> Observable<[GenreDTO]> {
        return NetworkManager().request(MoviesAPIRouter.fetchGenres, responseType: [GenreDTO].self)
    }}


fileprivate enum MoviesAPIRouter : RouterRequestConvertible
    
{
    var environment: Environment {
        .development
    }
    
    
    case fetchMovies(page: Int)
    case fetchGenres
    
    var method: HTTPMethod {
        switch self {
        case .fetchMovies, .fetchGenres:
            return .get
        }
    }
    
    var endPoint: EndPoint {
        switch self {
        case .fetchMovies(let pageNo):
            return APIs.Movies.fetchMovies(pageNo: "\(pageNo)")
        case .fetchGenres:
            return APIs.Movies.fetchGenres
        }
    }
    
    var queryItems: QueryItems? {
        switch self {
        default:
            return nil

        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default :
            return nil
            
        }
    }
    
    struct Keys {
        //        static let articleId = "id"
    }
}
