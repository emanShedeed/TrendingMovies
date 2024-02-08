//
//  MoviesPageEntity+DataMapping.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData

extension MoviesPageEntity {
    func toDTO() -> [MoviePageDTO] {
        var moviePageDTOs: [MoviePageDTO] = []

        // Extracting data from MoviesPageEntity
        let page = Int(self.page)
        let totalPages = Int(self.totalPages)

        // Extracting movie summaries from the set
        guard let movieSummaries = self.movies as? Set<MovieSummaryEntity> else {
            return moviePageDTOs
        }

        // Iterating over each movie summary to construct MoviePageDTO
        for movieSummary in movieSummaries {
            var movieSummariesDTO: [MoviePageDTO.MovieSummaryDTO] = []

            // Extracting data from each MovieSummaryEntity
            let movieId = Int(movieSummary.id)
            let title = movieSummary.title ?? ""
            let posterPath = movieSummary.posterPath
            let releaseDate = movieSummary.releaseDate
            // Extracting genre IDs from the NSSet and converting them to [Int]
            let genreIDs = movieSummary.genreIds?.compactMap { ($0 as? NSNumber)?.intValue } ?? []



            // Constructing MovieSummary DTO
            let movieSummaryDTO = MoviePageDTO.MovieSummaryDTO(id: movieId,
                                                             title: title,
                                                             posterPath: posterPath,
                                                             releaseDate: releaseDate,
                                                             genreIds: genreIDs)
            // Appending to movieSummariesDTO array
            movieSummariesDTO.append(movieSummaryDTO)

            // Constructing MoviePageDTO with the extracted data
            let moviePageDTO = MoviePageDTO(page: page, totalPages: totalPages, movies: movieSummariesDTO)
            // Appending to moviePageDTOs array
            moviePageDTOs.append(moviePageDTO)
        }

        return moviePageDTOs
    }
}
