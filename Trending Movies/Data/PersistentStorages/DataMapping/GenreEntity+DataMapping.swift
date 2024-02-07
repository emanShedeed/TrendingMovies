//
//  GenreEntity+DataMapping.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData

extension GenreEntity {
    func toDTO() -> GenreDTO {
        return GenreDTO(id: Int(self.id), name: self.name ?? "")
    }
}
