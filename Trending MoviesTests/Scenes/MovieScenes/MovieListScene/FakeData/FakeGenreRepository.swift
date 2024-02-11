//
//  FakeGenreRepository.swift
//  Trending MoviesTests
//
//  Created by Eman Shedeed on 11/02/2024.
//

import RxSwift
@testable import Trending_Movies

// MARK: - Fake Genre Repository

class FakeGenreRepository: GenreRepositoryProtocol {
    func fetchGenres() -> Observable<GenreListDTO> {
        let genreListDTO = GenreListDTO(genres: FakeMoviesListData.genres)
        return Observable.just(genreListDTO)
    }
}
