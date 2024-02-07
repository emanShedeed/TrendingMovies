//
//  MovieSummaryDTO.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData

struct MoviePageDTO {
    let page: Int
    let totalPages: Int
    let movies: [MovieSummary]

    struct MovieSummary {
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
    }

    init(page: Int, totalPages: Int, movies: [MovieSummary]) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }
}

extension MoviePageDTO {
    func toEntity(context: NSManagedObjectContext) -> MoviesPageEntity {
        let moviesPageEntity = MoviesPageEntity(context: context)
        moviesPageEntity.page = Int32(self.page)
        moviesPageEntity.totalPages = Int32(self.totalPages)
        
        let movieSummaryEntities = self.movies.map { movieSummary in
            return movieSummary.toEntity(context: context)
        }
        moviesPageEntity.movies = NSSet(array: movieSummaryEntities)
        
        return moviesPageEntity
    }
}

extension MoviePageDTO.MovieSummary {
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

