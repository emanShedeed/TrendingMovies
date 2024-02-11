//
//  MovieEntity+DataMapping.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 07/02/2024.
//
import CoreData


extension MovieEntity {
    func toDTO() -> MovieDetailsDTO {
        var spokenLanguagesDTO: [SpokenLanguageDTO]? = nil
        if let spokenLanguagesSet = self.languages as? Set<SpokenLanguageEntity> {
            spokenLanguagesDTO = spokenLanguagesSet.map { SpokenLanguageDTO(name: $0.name ?? "") }
        }

        var genresDTO: [GenreDTO] = []
        if let genresSet = self.genres as? Set<GenreEntity> {
            genresDTO = genresSet.map { GenreDTO(id: Int($0.id), name: $0.name ?? "") }
        }

        return MovieDetailsDTO(
            id: Int(self.id),
            title: self.title ?? "",
            budget: Int(self.budget),
            genres: genresDTO,
            homepage: self.homepage,
            overview: self.overview,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            revenue: Int(self.revenue),
            runtime: Int(self.runtime),
            spokenLanguages: spokenLanguagesDTO,
            status: self.status
        )
    }
}
