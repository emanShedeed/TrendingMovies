//
//  MoviePage.swift
//  Trending Movies
//
//  Created by Mohamed on 06/02/2024.
//

struct MoviesPage {
    let page: Int
    let totalPages: Int
    let movies: [MovieSummary]
}
struct MovieSummary {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?
    let genreIds: [Int]
}
