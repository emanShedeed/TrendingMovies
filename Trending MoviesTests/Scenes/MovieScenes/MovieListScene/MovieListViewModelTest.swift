//
//  MovieListViewModelTest.swift
//  Trending MoviesTests
//
//  Created by Eman Shedeed on 11/02/2024.
//

import XCTest
@testable import Trending_Movies

class MoviesListViewModelTests: XCTestCase {

    var viewModel: MoviesListViewModel!
    
    override func setUp() {
        super.setUp()
        let fakeMoviesRepository = FakeMoviesRepository()
        let fakeGenreRepository = FakeGenreRepository()
        let fakeSearchMovieRepository = FakeSearchMovieRepository()
        viewModel = MoviesListViewModel(movieService: fakeMoviesRepository, genreService: fakeGenreRepository, searchMovieService: fakeSearchMovieRepository)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchGenres() {
        viewModel.fetchGenres()
        XCTAssertEqual(viewModel.genres.value.count, FakeMoviesListData.genres.count)
    }

    func testFetchMovies() {
        viewModel.fetchMovies(page: 1)
        XCTAssertEqual(viewModel.movies.value.count, FakeMoviesListData.movies.count)
    }

    // Add more tests as needed
}
