//
//  Movie.swift
//  Trending Movies
//
//  Created by Mohamed on 06/02/2024.
//
import Foundation

// MARK: - Movie
struct Movie: Decodable {
    
    let id: Int  
    let title: String
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let name: String

}
