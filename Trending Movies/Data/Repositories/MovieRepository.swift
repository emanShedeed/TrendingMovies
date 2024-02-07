//
//  MovieRepository.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData
import RxSwift

// Protocol for Movie Repository
protocol MovieRepositoryProtocol {
    func fetchMovies(page: Int) -> Observable<[MoviePageDTO]>
}

// Offline Movie Repository
class OfflineMovieRepository: MovieRepositoryProtocol {
    let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func fetchMovies(page: Int) -> Observable<[MoviePageDTO]> {
        return Observable.create { observer in
            let context = self.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<MoviesPageEntity> = MoviesPageEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "page == %d", page)

            do {
                let results = try context.fetch(fetchRequest)
                if let moviesPageEntity = results.first {
                    let moviePageDTO = moviesPageEntity.toDTO()
                    observer.onNext(moviePageDTO)
                    observer.onCompleted()
                } else {
                    // Page does not exist locally, fetch from online
                    let onlineRepository = OnlineMovieRepository()
                    onlineRepository.fetchMovies(page: page)
                        .subscribe(onNext: { moviePageDTOs in
                            self.saveMoviesPageToCoreData(moviePageDTOs, context: context)
                            observer.onNext(moviePageDTOs)
                            observer.onCompleted()
                        }, onError: { error in
                            observer.onError(error)
                        })
                        .disposed(by: DisposeBag())
                }
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    private func saveMoviesPageToCoreData(_ moviePageDTOs: [MoviePageDTO], context: NSManagedObjectContext) {
        for moviePageDTO in moviePageDTOs {
            let moviesPageEntity = moviePageDTO.toEntity(context: context)
            do {
                try context.save()
            } catch {
                print("Failed to save data to CoreData: \(error)")
            }
        }
    }
}

// Online Movie Repository
class OnlineMovieRepository: MovieRepositoryProtocol {
    func fetchMovies(page: Int) -> Observable<[MoviePageDTO]> {
        // Code to make API call and fetch movies data
        // Example:
        let moviePageDTO = MoviePageDTO(page: page, totalPages: 1, movies: [])
        return Observable.just([moviePageDTO])
    }
}

