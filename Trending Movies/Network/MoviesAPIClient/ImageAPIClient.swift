//
//  ImageAPIClient.swift
//  Trending Movies
//
//  Created by Mohamed on 08/02/2024.
//

import RxSwift
import Foundation


class ImagesAPIClient {
    static func fetchImageData(from url: URL) -> Observable<Data>{
        return NetworkManager().request(ImagesAPIRouter.fetchImageData(url: url) , responseType: Data.self)
    }
}

fileprivate enum ImagesAPIRouter : RouterRequestConvertible
    
{
    var environment: Environment {
        .development
    }
    
    
    case fetchImageData(url: URL)
    
    var method: HTTPMethod {
        switch self {
        case .fetchImageData:
            return .get
        }
    }
    
    var endPoint: EndPoint {
        switch self {
        case .fetchImageData:
            return APIs.Images.fetchImageData
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
