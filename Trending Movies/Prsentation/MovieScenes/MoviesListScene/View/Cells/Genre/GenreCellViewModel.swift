//
//  GenreCellViewModel.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 08/02/2024.
//

import RxSwift
import RxCocoa

class GenreCellViewModel {
    let genreName: BehaviorRelay<String>
    let genreId: Int

    init(genre: GenreDTO) {
        self.genreName = BehaviorRelay(value: genre.name)
        self.genreId = genre.id
    }
}
