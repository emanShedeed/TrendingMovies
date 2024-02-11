//
//  MovieSetailsAPIClient.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 11/02/2024.
//


import RxSwift


class MovieDetailsAPIClient {
    
    static func fetchMovieDetails(by id: Int) -> Observable<MovieDetailsDTO> {
        return  NetworkManager().request(MovieDetailsAPIRouter.fetchMovieDetails(id: id), responseType: MovieDetailsDTO.self)
       
    }
 
}


fileprivate enum MovieDetailsAPIRouter: RouterRequestConvertible {
   
    var environment: Environment {
        .development
    }
    
    case fetchMovieDetails(id: Int)
    
    
    var method: HTTPMethod {
        switch self {
        case .fetchMovieDetails:
            return .get
        }
    }
    
    var endPoint: EndPoint {
        switch self {
        case .fetchMovieDetails(let id):
            return APIs.MovieDetails.fetchMovieDetails(id: "\(id)")
  
        }
    }
    
    var queryItems: QueryItems? {
        switch self {
        case .fetchMovieDetails:
            return nil
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
