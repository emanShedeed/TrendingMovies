//
//  FakeFilterRepository.swift
//  Trending MoviesTests
//
//  Created by Eman Shedeed on 11/02/2024.
//


@testable import Trending_Movies
import RxSwift
// MARK: - Fake Movies Repository

class FakeMoviesRepository: MoviesRepositoryProtocol {
    func fetchMovies(page: Int) -> Observable<MoviePageDTO> {
        let moviePageDTO =
        MoviePageDTO(page: 1, totalPages: 2, movies: FakeMoviesListData.movies)
        return Observable.just(moviePageDTO)
    }
}
class MockOnlineMoviesRepository: MoviesRepositoryProtocol {
    var fetchMoviesResult: Observable<MoviePageDTO>?

    func fetchMovies(page: Int) -> Observable<MoviePageDTO> {
        guard let result = fetchMoviesResult else {
            fatalError("fetchMoviesResult is not set. Make sure to set it for testing.")
        }
        return result
    }
}

