//
//  MovieDetailsRepository.swift
//  Trending Movies
//
//  Created by Mohamed on 11/02/2024.
//

import CoreData
import RxSwift
// Protocol for Movie Details Repository
protocol MovieDetailsRepositoryProtocol {
    func fetchMovieDetails(by id: Int) -> Observable<MovieDetailsDTO>
}
// Offline Movie Details Repository
class OfflineMovieDetailsRepository: MovieDetailsRepositoryProtocol {
    let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func fetchMovieDetails(by id: Int) -> Observable<MovieDetailsDTO> {
        let onlineRepository = OnlineMovieDetailsRepository()
        
        return Observable.create { observer in
            self.coreDataStorage.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", id)
                
                do {
                    let results = try context.fetch(fetchRequest)
                    if let movie = results.first {
                        observer.onNext(movie.toDTO())
                        observer.onCompleted()
                    } else {
                        print("No data found locally for id \(id)")
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
            return onlineRepository.fetchMovieDetails(by: id)
                .do(onNext: { [weak self] movieDTO in
                    guard let self = self else { return }
                    self.coreDataStorage.performBackgroundTask { context in
                        self.saveMovieToCoreData(movieDTO, context: context)
                    }
                })
        }
    }
    
    
    
    
    private func saveMovieToCoreData(_ movieDTO: MovieDetailsDTO, context: NSManagedObjectContext) {
        context.perform {
            let movieEntity = movieDTO.toEntity(context: context)
            do {
                try context.save()
            } catch {
                print("Failed to save data to CoreData: \(error)")
            }
        }
    }
}


// Online Movie etails Repository
class OnlineMovieDetailsRepository: MovieDetailsRepositoryProtocol {
    func fetchMovieDetails(by id: Int) -> RxSwift.Observable<MovieDetailsDTO> {
        MovieDetailsAPIClient.fetchMovieDetails(by: id)
    }

}
