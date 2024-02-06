//
//  MoviePage.swift
//  Trending Movies
//
//  Created by Mohamed on 06/02/2024.
//

struct MoviesPage: Decodable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}
