//
//  EndPoint.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 06/02/2024.
//

protocol EndPoint {
    var subdomain : String { get }
    var path: String { get }
}

struct APIs {
    
    enum Movies: EndPoint {
        
        case fetchMovies(pageNo:String)
        case fetchGenres
      
        var subdomain: String{
            switch self {
            case .fetchMovies:
                return "discover/movie"
            case .fetchGenres:
                return "genre/movie/list"
    
            }
        }
        var path: String {
            switch self {
            case .fetchMovies:
                 return ""
            case .fetchGenres:
                return ""
         
            }
        }

    }
    enum MovieDetails: EndPoint {
        
        case fetchMovieDetails(id: String)
      
        var subdomain: String{
            switch self {
            case .fetchMovieDetails(let id):
                return "movie/\(id)"
            }
        }
        var path: String {
            switch self {
            case .fetchMovieDetails:
                 return ""
           
         
            }
        }

    }  
    enum Images: EndPoint {
 
        case fetchImageData

           var subdomain: String {
               return ""
           }

           var path: String {
               return ""
           }

    }
}

