//
//  MoviesListViewModel.swift
//  Trending Movies
//
//  Created by Mohamed on 08/02/2024.
//

import RxSwift
import RxCocoa

// MARK: - Protocol for ViewModel: MoviesListViewModelProtocol

protocol MoviesListViewModelProtocol {
    var movies: Driver<[MoviePageDTO.MovieSummaryDTO]> { get }
    var genres: Driver<[GenreDTO]> { get }
    func filterMovies(by genre: String)
    func loadMovies()
}

// MARK: - ViewModel Implementation: MoviesListViewModel

class MoviesListViewModel: MoviesListViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let repository: MovieRepositoryProtocol

    private let moviesRelay = BehaviorRelay<[MoviePageDTO.MovieSummaryDTO]>(value: [])
    private let genresRelay = BehaviorRelay<[GenreDTO]>(value: [])

    var movies: Driver<[MoviePageDTO.MovieSummaryDTO]> {
        return moviesRelay.asDriver()
    }

    var genres: Driver<[GenreDTO]> {
        return genresRelay.asDriver()
    }

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func filterMovies(by genre: String) {
        let filteredMovies = moviesRelay.value.filter { movie in
            movie.genreIds.contains(genre)
        }
        moviesRelay.accept(filteredMovies)
    }

    func loadMovies() {
        repository.fetchMovies()
            .observeOn(MainScheduler.instance)
            .bind(to: moviesRelay)
            .disposed(by: disposeBag)

        repository.fetchGenres()
            .observeOn(MainScheduler.instance)
            .bind(to: genresRelay)
            .disposed(by: disposeBag)
    }
}
