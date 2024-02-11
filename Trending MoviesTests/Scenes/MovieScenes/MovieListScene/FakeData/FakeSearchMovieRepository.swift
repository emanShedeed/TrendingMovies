//
//  FakeSearchMovieRepository.swift
//  Trending MoviesTests
//
//  Created by Eman Shedeed on 11/02/2024.
//

import RxSwift
@testable import Trending_Movies

// MARK: - Fake Search Movie Repository

class FakeSearchMovieRepository: SearchMovieRepositoryProtocol {
    func searchMovie(by query: String?, genreId: Int?) -> Observable<[MoviePageDTO.MovieSummaryDTO]> {
        return Observable.just(FakeMoviesListData.movies)
    }
}
