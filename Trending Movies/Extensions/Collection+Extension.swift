//
//  Collection+Extension.swift
//  Trending Movies
//
//  Created by Mohamed on 10/02/2024.
//


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
