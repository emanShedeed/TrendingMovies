//
//  MovieSummaryDTO.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData

struct MoviePageDTO:Decodable {
    let page: Int
    let totalPages: Int
    let results: [MovieSummaryDTO]

    struct MovieSummaryDTO:Decodable {
        let id: Int
        let title: String
        let posterPath: String?
        let releaseDate: String?
        let genreIds: [Int]

        init(id: Int, title: String, posterPath: String?, releaseDate: String?, genreIds: [Int]) {
            self.id = id
            self.title = title
            self.posterPath = posterPath
            self.releaseDate = releaseDate
            self.genreIds = genreIds
        }
        static func formatReleaseDate(_ releaseDate: String?) -> String? {
            guard let releaseDate = releaseDate else { return nil }

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"

            if let date = dateFormatter.date(from: releaseDate) {
                dateFormatter.dateFormat = "yyyy"
                return dateFormatter.string(from: date)
            }

            return nil
        }    }

    init(page: Int, totalPages: Int, movies: [MovieSummaryDTO]) {
        self.page = page
        self.totalPages = totalPages
        self.results = movies
    }
}

extension MoviePageDTO {
    func toEntity(context: NSManagedObjectContext) -> MoviesPageEntity {
        let moviesPageEntity = MoviesPageEntity(context: context)
        moviesPageEntity.page = Int32(self.page)
        moviesPageEntity.totalPages = Int32(self.totalPages)
        
        let movieSummaryEntities = self.results.map { movieSummaryDTO in
            return movieSummaryDTO.toEntity(context: context)
        }
        moviesPageEntity.movies = NSSet(array: movieSummaryEntities)
        
        return moviesPageEntity
    }
}

extension MoviePageDTO.MovieSummaryDTO {
    func toEntity(context: NSManagedObjectContext) -> MovieSummaryEntity {
        let movieSummaryEntity = MovieSummaryEntity(context: context)
        movieSummaryEntity.id = Int32(self.id)
        movieSummaryEntity.title = self.title
        movieSummaryEntity.posterPath = self.posterPath
        movieSummaryEntity.releaseDate = self.releaseDate
        
        // Convert genreIds array to NSSet
        let genreIdsNSSet: NSSet = NSSet(array: self.genreIds.map { NSNumber(value: $0) })
        movieSummaryEntity.genreIds = genreIdsNSSet
        
        return movieSummaryEntity
    }
}


extension MoviePageDTO {
    func toDomain() -> MoviesPage {
        let domainMovies = results.map { $0.toDomain() }
        return MoviesPage(page: page, totalPages: totalPages, movies: domainMovies)
    }
}

extension MoviePageDTO.MovieSummaryDTO {
    func toDomain() -> MovieSummary {
        return MovieSummary(id: id,
                     title: title,
                     posterPath: posterPath,
                     releaseDate: releaseDate,
                     genreIds: genreIds)
    }
}
