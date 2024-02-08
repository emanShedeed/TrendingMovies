//
//  MovieCellViewModel.swift
//  Trending Movies
//
//  Created by Mohamed on 08/02/2024.
//


import Foundation
import RxSwift
import RxCocoa

// MARK: - MovieCellViewModel

class MovieCellViewModel {
    let title: BehaviorRelay<String>
    let releaseDate: BehaviorRelay<String>
    lazy var image: Observable<Data?> = {
        return self.fetchImage().catchAndReturn(nil)
    }()

    private let imageURL: URL?
    private let imageRepository: ImageRepository

    init(movie: MoviePageDTO.MovieSummaryDTO, imageRepository: ImageRepository) {
        self.title = BehaviorRelay(value: movie.title)
        self.releaseDate = BehaviorRelay(value: MoviePageDTO.MovieSummaryDTO.formatReleaseDate(movie.releaseDate) ?? "")
        self.imageRepository = imageRepository

        if let posterPath = movie.posterPath {
            self.imageURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
        } else {
            self.imageURL = nil
        }
    }

    private func fetchImage() -> Observable<Data?> {
        guard let imageURL = imageURL else {
            return Observable.just(nil)
        }

        // Use imageRepository to fetch image data and map to optional Data?
        return imageRepository.fetchImageData(from: imageURL)
            .map { data in
                return data
            }
            .asObservable()
    }
}
