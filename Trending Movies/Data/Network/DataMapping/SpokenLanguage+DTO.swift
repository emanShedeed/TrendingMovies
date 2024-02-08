//
//  SpokenLanguage+DTO.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import Foundation

struct SpokenLanguageDTO: Decodable {
    
    let id: Int
    let name: String

}

extension SpokenLanguageDTO {
    func toDomain() -> SpokenLanguage {
        return SpokenLanguage(id: self.id, name: self.name)
    }
}
