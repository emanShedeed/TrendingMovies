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
        return NetworkManager().fetchImageData(url: url)
    }
}

