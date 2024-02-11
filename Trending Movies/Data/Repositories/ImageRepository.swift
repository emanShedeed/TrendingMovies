//
//  ImageRepository.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 08/02/2024.
//
import RxSwift
import Foundation

protocol ImageRepositoryProtocol {
    func fetchImageData(from url: URL) -> Observable<Data>
}

class ImageRepository: ImageRepositoryProtocol {
    func fetchImageData(from url: URL) -> Observable<Data> {
        return ImagesAPIClient.fetchImageData(from: url)
    }
}
