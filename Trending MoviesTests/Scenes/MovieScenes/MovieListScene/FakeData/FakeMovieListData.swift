//
//  FakeMovieListData.swift
//  Trending MoviesTests
//
//  Created by Eman Shedeed on 11/02/2024.
//

@testable import Trending_Movies
// MARK: - Fake Data Enum

enum FakeMoviesListData {
    static let genres: [GenreDTO] = [
        GenreDTO(id: 1, name: "Action"),
        GenreDTO(id: 2, name: "Comedy"),
        // Add more genres as needed for testing
    ]

    static let movies: [MoviePageDTO.MovieSummaryDTO] = [
        MoviePageDTO.MovieSummaryDTO(id: 1, title: "Movie 1", posterPath: "https://www.google.com", releaseDate: "08-09-2024", genreIds: [28, 29]),
        MoviePageDTO.MovieSummaryDTO(id: 2, title: "Movie 2", posterPath: "https://www.google.com", releaseDate: "08-09-2024", genreIds: [28, 29])
    ]
    

        static let moviePageDtO = MoviePageDTO(page: 1, totalPages: 2, movies: movies)
    
}
