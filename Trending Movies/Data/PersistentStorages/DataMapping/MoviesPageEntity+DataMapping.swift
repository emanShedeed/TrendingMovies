//
//  MoviesPageEntity+DataMapping.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 07/02/2024.
//

import CoreData


extension MoviesPageEntity {
    func toDTO() -> MoviePageDTO? {
        guard let page = Int(exactly: self.page), let totalPages = Int(exactly: self.totalPages) else {
            return nil
        }

        let movieSummaryDTOs: [MoviePageDTO.MovieSummaryDTO] = (self.moviesSummary?.allObjects as? [MovieSummaryEntity] ?? []).compactMap { movieEntity in
            return movieEntity.toDTO()
        }

        return MoviePageDTO(page: page, totalPages: totalPages, movies: movieSummaryDTOs)
    }
}
