//
//  MovieDetailsRepository.swift
//  Trending Movies
//
//  Created by Mohamed on 11/02/2024.
//

import CoreData
import RxSwift
// Protocol for Movie Details Repository
protocol MovieDetailsRepositoryProtocol {
    func fetchMovieDetails(by id: Int) -> Observable<MovieDetailsDTO>
}
// Online Movie Repository
class MovieDetailsRepository: MovieDetailsRepositoryProtocol {
    func fetchMovieDetails(by id: Int) -> RxSwift.Observable<MovieDetailsDTO> {
        MovieDetailsAPIClient.fetchMovieDetails(by: id)
    }
}
