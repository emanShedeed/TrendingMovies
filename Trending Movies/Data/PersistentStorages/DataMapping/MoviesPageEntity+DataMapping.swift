//
//  MoviesPageEntity+DataMapping.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData

extension MoviesPageEntity {
    func toDTO() -> MoviePageDTO? {
        // Extracting data from MoviesPageEntity
        let page = Int(self.page)
        let totalPages = Int(self.totalPages)

        // Extracting movie summaries from the set
        guard let movieSummaries = self.movies as? Set<MovieSummaryEntity>,
              let firstMovieSummary = movieSummaries.first else {
            return nil
        }

        // Extracting data from the first MovieSummaryEntity
        let movieId = Int(firstMovieSummary.id)
        let title = firstMovieSummary.title ?? ""
        let posterPath = firstMovieSummary.posterPath
        let releaseDate = firstMovieSummary.releaseDate
        // Extracting genre IDs from the NSSet and converting them to [Int]
        let genreIDs = firstMovieSummary.genreIds?.compactMap { ($0 as? NSNumber)?.intValue } ?? []

        // Constructing MovieSummary DTO
        let movieSummaryDTO = MoviePageDTO.MovieSummaryDTO(id: movieId,
                                                           title: title,
                                                           posterPath: posterPath,
                                                           releaseDate: releaseDate,
                                                           genreIds: genreIDs)

        // Constructing MoviePageDTO with the extracted data
        let moviePageDTO = MoviePageDTO(page: page, totalPages: totalPages, movies: [movieSummaryDTO])
        
        return moviePageDTO
    }
}
