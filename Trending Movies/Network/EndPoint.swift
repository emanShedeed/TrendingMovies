//
//  EndPoint.swift
//  Trending Movies
//
//  Created by Mohamed on 06/02/2024.
//

protocol EndPoint {
    var subdomain : String { get }
    var path: String { get }
}

struct APIs {
    
    enum Movies: EndPoint {
        
        case fetchMovies(pageNo:String)
        //case fetc÷hProductById(id: String)
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

