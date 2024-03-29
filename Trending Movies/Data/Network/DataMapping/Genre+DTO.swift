//
//  Genre+DTO.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 07/02/2024.
//

import CoreData

struct GenreListDTO: Decodable {
    let genres: [GenreDTO]
}
struct GenreDTO: Decodable {
    let id: Int
    let name: String
}
extension GenreDTO {
    func toEntity(context: NSManagedObjectContext) -> GenreEntity {
        let entity = GenreEntity(context: context)
        entity.id = Int32(id)
        entity.name = name
        return entity
    }
}

extension GenreDTO {
    func toDomain() -> Genre {
        return Genre(id: self.id, name: self.name)
    }
}
