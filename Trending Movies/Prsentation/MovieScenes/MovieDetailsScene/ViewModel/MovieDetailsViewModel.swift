//
//  MovieDetailsViewModel.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 11/02/2024.
//


import RxSwift
import RxCocoa
import Foundation

// MARK: - View Model Protocol: MovieDetailsViewModelProtocol

protocol MovieDetailsViewModelProtocol {
    var movie: BehaviorRelay<MovieDetailsDTO?> { get }
    var imageData: BehaviorRelay<Data?> { get }
    func fetchMovieDetails()
}

// MARK: - View Model: MovieDetailsViewModel

class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    var movie: BehaviorRelay<MovieDetailsDTO?> = BehaviorRelay(value: nil)
    var imageData: BehaviorRelay<Data?> = BehaviorRelay(value: nil)
    
    private let movieId: Int
    private let movieDetailsRepository: MovieDetailsRepositoryProtocol
    private let imageRepository: ImageRepository
    private let disposeBag = DisposeBag()
    
    init(movieId: Int, movieDetailsRepository: MovieDetailsRepositoryProtocol, imageRepository: ImageRepository) {
        self.movieId = movieId
        self.movieDetailsRepository = movieDetailsRepository
        self.imageRepository = imageRepository
    }
    
    
    func fetchMovieDetails() {
        movieDetailsRepository.fetchMovieDetails(by: movieId)
            .subscribe(onNext: { [weak self] movie in
                self?.movie.accept(movie)
                // Fetch image data when movie details are fetched
                if let posterPath = movie.posterPath {
                   self?.fetchImage(from: posterPath)
                    }
            }, onError: { error in
                // Handle error
            })
            .disposed(by: disposeBag)
    }
    private func fetchImage(from posterPath: String) {
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") else {
            return
        }

        imageRepository.fetchImageData(from: imageURL)
                .observe(on: MainScheduler.instance) // Ensure UI updates are on the main thread
                .subscribe(onNext: { [weak self] data in
                    self?.imageData.accept(data)
                }, onError: { error in
                    // Handle error
                })
                .disposed(by: disposeBag)
    }
}

