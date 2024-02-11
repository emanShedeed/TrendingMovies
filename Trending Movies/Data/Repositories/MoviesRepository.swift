//
//  MoviesRepository.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import CoreData
import RxSwift
// Protocol for Movie Repository
protocol MoviesRepositoryProtocol {
    func fetchMovies(page: Int) -> Observable<MoviePageDTO>
}

// Offline Movie Repository
class OfflineMoviesRepository: MoviesRepositoryProtocol {
    let coreDataStorage: CoreDataStorageProtocol
    let onlineRepository: MoviesRepositoryProtocol
    
    init(coreDataStorage: CoreDataStorageProtocol = CoreDataStorage.shared, onlineRepository: MoviesRepositoryProtocol = OnlineMoviesRepository()) {
        self.coreDataStorage = coreDataStorage
        self.onlineRepository = onlineRepository
    }

    func fetchMovies(page: Int) -> Observable<MoviePageDTO> {
      
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
        .catch { [weak self ]error in // Handle the error here
            guard let self else { return Observable.error(error) }
            guard let coreDataError = error as? CoreDataStorageError, coreDataError == .readError else {
                return Observable.error(error) // Pass through other errors
            }
            
            // Fetch movies from the online repository
            return self.onlineRepository.fetchMovies(page: page)
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
            _ = moviePageDTO.toEntity(context: context)
            do {
                try context.save()
            } catch {
                print("Failed to save data to CoreData: \(error)")
            }
        }
    }
}

// Online Movie Repository
class OnlineMoviesRepository: MoviesRepositoryProtocol {
    func fetchMovies(page: Int) -> Observable<MoviePageDTO> {

       return MoviesAPIClient.fetchMovies(page: page)
    }
}
