//
//  MoviesListViewModel.swift
//  Trending Movies
//
//  Created by Mohamed on 08/02/2024.
//

import RxSwift
import RxCocoa

// MARK: - View Model Protocol: MoviesListViewModelProtocol

protocol MoviesListViewModelProtocol {
    var genres: BehaviorRelay<[GenreDTO]> { get }
    var movies: BehaviorRelay<[MoviePageDTO.MovieSummaryDTO]> { get }
    var currentPage: Int { get }
    
    func fetchMovies(page: Int)
    func fetchGenres()
    func searchMovies(query: String?, genreId: Int?)
    func didTapMovie(at id: Int)
}

// MARK: - View Model: MoviesListViewModel

class MoviesListViewModel: MoviesListViewModelProtocol {
    var genres: BehaviorRelay<[GenreDTO]> = BehaviorRelay(value: [])
    var movies: BehaviorRelay<[MoviePageDTO.MovieSummaryDTO]> = BehaviorRelay(value: [])
    
    var currentPage: Int = 1
    var coordinator: MoviesListCoordinator?
    
    private let movieService: MoviesRepositoryProtocol
    private let searchMovieService: SearchMovieRepositoryProtocol
    private let genreService: GenreRepositoryProtocol
    private var totalPages: Int = 1
    private let disposeBag = DisposeBag()
    
    init(movieService: MoviesRepositoryProtocol, genreService: GenreRepositoryProtocol, searchMovieService: SearchMovieRepositoryProtocol) {
        self.movieService = movieService
        self.genreService = genreService
        self.searchMovieService = searchMovieService
    }
    
    func fetchMovies(page: Int) {
        guard page <= totalPages else {
            // No more pages to fetch
            return
        }
        
        movieService.fetchMovies(page: page)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] moviePage in
                    guard let self = self else { return }
                    if page == 1 {
                        // Clear existing movies if fetching the first page
                        self.movies.accept(moviePage.results)
                    } else {
                        // Append new movies to the existing list
                        self.movies.accept(self.movies.value + moviePage.results)
                    }
                    self.currentPage = moviePage.page
                    self.totalPages = moviePage.totalPages
                },
                onError: { error in
                    // Handle error
                },
                onCompleted: {
                    // Handle completion if needed
                }
            )
            .disposed(by: disposeBag)
    }
    func fetchGenres() {
        genreService.fetchGenres()
            .subscribe(onNext: { [weak self] genreList in
                self?.genres.accept(genreList.genres)
            }, onError: { error in
                // Handle error
            })
            .disposed(by: disposeBag)
    }
    func searchMovies(query: String?, genreId: Int?) {
        searchMovieService.searchMovie(by: query, genreId: genreId).observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] movies in
                    guard let self = self else { return }
                    self.resetPages()
                    self.movies.accept( movies)
                    
                },
                onError: { error in
                    // Handle error
                },
                onCompleted: {
                    // Handle completion if needed
                }
            )
            .disposed(by: disposeBag)
    }
    
    func didTapMovie(at id: Int) {
           coordinator?.showMovieDetail(id: id)
       }
    private func resetPages() {
        currentPage = 0
        totalPages = 1
        movies.accept([])
    }
}
