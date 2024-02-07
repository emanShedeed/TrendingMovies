//
//  MovieSummaryDTO.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData


struct MovieSummaryDTO {
    let page: Int
    let totalPages: Int
    let movies: [MovieDetailsDTO]

    init(page: Int, totalPages: Int, movies: [MovieDetailsDTO]) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }

    static func formatReleaseYear(_ releaseDate: String?) -> String? {
        guard let releaseDate = releaseDate else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Assuming releaseDate follows this format

        if let date = formatter.date(from: releaseDate) {
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
        }
        return nil
    }
}

extension MovieSummaryDTO {
    func toEntity(context: NSManagedObjectContext) -> MoviesPageEntity {
        let moviesPageEntity = MoviesPageEntity(context: context)
        moviesPageEntity.page = Int32(self.page)
        moviesPageEntity.totalPages = Int32(self.totalPages)
        moviesPageEntity.movies = NSSet(array: self.movies.map { $0.toEntity(context: context) })
        return moviesPageEntity
    }
}
