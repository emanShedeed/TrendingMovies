//
//  MovieSummary+DataMapping.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 09/02/2024.
//

import Foundation

extension MovieSummaryEntity {
    func toDTO() -> MoviePageDTO.MovieSummaryDTO {
        // Extract id and title directly since they are not optional
        let id = Int(self.id)
        let title = self.title!

        // Convert genreIds
        let genreIds: [Int] = (self.genreIds?.allObjects as? [GenreEntity] ?? []).compactMap { genreEntity in
            return Int(genreEntity.id)
        }

        return MoviePageDTO.MovieSummaryDTO(id: id,
                                            title: title,
                                            posterPath: self.posterPath,
                                            releaseDate: self.releaseDate,
                                            genreIds: genreIds)
    }
}

