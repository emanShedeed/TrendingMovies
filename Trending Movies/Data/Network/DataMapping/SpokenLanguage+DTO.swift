//
//  SpokenLanguage+DTO.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 07/02/2024.
//

import Foundation

struct SpokenLanguageDTO: Decodable {
 
    let name: String

}

extension SpokenLanguageDTO {
    func toDomain() -> SpokenLanguage {
        return SpokenLanguage(name: self.name)
    }
}
