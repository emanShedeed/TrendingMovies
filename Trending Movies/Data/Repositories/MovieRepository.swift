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
    func fetchMovies(page: Int) -> Observable<MoviePageDTO>
}

// Offline Movie Repository
import Foundation
import CoreData
import RxSwift

class OfflineMovieRepository: MovieRepositoryProtocol {
    let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    func fetchMovies(page: Int) -> Observable<MoviePageDTO> {
        let onlineRepository = OnlineMovieRepository() // Create an instance of OnlineMovieRepository
        
        return Observable.create { observer in
            self.coreDataStorage.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<MoviesPageEntity> = MoviesPageEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "page == %d", page)

                do {
                    let results = try context.fetch(fetchRequest)
                    if let moviesPageEntity = results.first, let moviePageDTO = moviesPageEntity.toDTO() {
                        observer.onNext(moviePageDTO)
                        observer.onCompleted()
                    } else {
                        print("No data found locally for page \(page)")
                        observer.onError(CoreDataStorageError.readError) // Signal error if no data found locally
                    }
                } catch {
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
        .catch { error in // Handle the error here
            guard let coreDataError = error as? CoreDataStorageError, coreDataError == .readError else {
                return Observable.error(error) // Pass through other errors
            }
            
            // Fetch movies from the online repository
            return onlineRepository.fetchMovies(page: page)
                .do(onNext: { [weak self] moviePageDTO in
                    guard let self = self else { return }
                    self.coreDataStorage.performBackgroundTask { context in
                        self.saveMoviesPageToCoreData(moviePageDTO, context: context)
                    }
                })
        }
    }




    private func saveMoviesPageToCoreData(_ moviePageDTO: MoviePageDTO, context: NSManagedObjectContext) {
        context.perform {
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
    func fetchMovies(page: Int) -> Observable<MoviePageDTO> {

       return MoviesAPIClient.fetchMovies(page: page)
    }
}
