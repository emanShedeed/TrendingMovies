//
//  MoviesPageEntity+DataMapping.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData
extension MoviesPageEntity {
    func toDTO() -> [MovieSummaryDTO] {
        guard let movies = self.movies as? Set<MovieEntity> else { return [] }

        var movieDetailsDTOs: [MovieDetailsDTO] = []
        for movie in movies {
            let movieDetailsDTO = movie.toDTO()
            movieDetailsDTOs.append(movieDetailsDTO)
        }

        return [MovieSummaryDTO(page: Int(self.page), totalPages: Int(self.totalPages), movies: movieDetailsDTOs)]
    }
}
