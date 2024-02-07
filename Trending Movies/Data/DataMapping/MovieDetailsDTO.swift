//
//  MovieDetailsDTO.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData

struct MovieDetailsDTO {
    let id: Int
    let title: String
    let budget: Int?
    let genres: [GenreDTO]
    let homepage: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguageDTO]?
    let status: String?
    
    static func formatReleaseDate(_ releaseDate: String?) -> String? {
        guard let releaseDate = releaseDate else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: releaseDate) {
            formatter.dateFormat = "MMM yyyy"
            return formatter.string(from: date)
        }
        return nil
    }
    
    static func formatSpokenLanguages(_ spokenLanguages: [SpokenLanguage]?) -> String {
        guard let spokenLanguages = spokenLanguages else { return "" }
        return spokenLanguages.map { $0.name }.joined(separator: ", ")
    }
    
    static func formatGenres(_ genres: [Genre]) -> String {
        return genres.map { $0.name }.joined(separator: ", ")
    }
}
extension MovieDetailsDTO {
    func toEntity(context: NSManagedObjectContext) -> MovieEntity {
        let movieEntity = MovieEntity(context: context)
        movieEntity.id = Int32(self.id)
        movieEntity.title = self.title
        movieEntity.budget = Int64(self.budget ?? 0)
        movieEntity.homepage = self.homepage
        movieEntity.overview = self.overview
        movieEntity.posterPath = self.posterPath
        movieEntity.releaseDate = self.releaseDate
        movieEntity.revenue = Int64(self.revenue ?? 0)
        movieEntity.runtime = Int32(self.runtime ?? 0)
        movieEntity.status = self.status
        
        // Convert genres to GenreEntities and add to movieEntity
        for genreDTO in self.genres {
            let genreEntity = genreDTO.toEntity(context: context)
            movieEntity.addToGenres(genreEntity)
        }
        
        // Convert spoken languages to SpokenLanguageEntities and add to movieEntity
        if let spokenLanguages = self.spokenLanguages {
            for spokenLanguageDTO in spokenLanguages {
                let spokenLanguageEntity = SpokenLanguageEntity(context: context)
                spokenLanguageEntity.id = Int32(spokenLanguageDTO.id)
                spokenLanguageEntity.name = spokenLanguageDTO.name
                movieEntity.addToLanguages(spokenLanguageEntity)
            }
        }
        
        return movieEntity
    }
}
