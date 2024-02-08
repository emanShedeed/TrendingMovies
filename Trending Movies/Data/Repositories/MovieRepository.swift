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
class OfflineMovieRepository: MovieRepositoryProtocol {
    let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func fetchMovies(page: Int) -> Observable<MoviePageDTO> {
        return Observable.create { observer in
            let context = self.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<MoviesPageEntity> = MoviesPageEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "page == %d", page)

            do {
                let results = try context.fetch(fetchRequest)
                if let moviesPageEntity = results.first {
                    if let moviePageDTO = moviesPageEntity.toDTO() {
                        observer.onNext(moviePageDTO)
                    } else {
                        // Print a failure message
                        print("Failed to fetch data from CoreData even though the page exists")
                        
                        // Return CoreDataError
                        observer.onError(CoreDataError.fetchFailed)
                    }
                    observer.onCompleted()
                } else {
                    // Page does not exist locally, fetch from online
                    let onlineRepository = OnlineMovieRepository()
                    onlineRepository.fetchMovies(page: page)
                        .subscribe(onNext: { moviePageDTO in
                            // Save the fetched movie page to CoreData
                            self.saveMoviesPageToCoreData(moviePageDTO, context: context)
                            observer.onNext(moviePageDTO)
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


    private func saveMoviesPageToCoreData(_ moviePageDTO: MoviePageDTO, context: NSManagedObjectContext) {
        let moviesPageEntity = moviePageDTO.toEntity(context: context)
        do {
            try context.save()
        } catch {
            print("Failed to save data to CoreData: \(error)")
        }
    }
}

// Online Movie Repository
class OnlineMovieRepository: MovieRepositoryProtocol {
    func fetchMovies(page: Int) -> Observable<MoviePageDTO> {

       return MoviesAPIClient.fetchMovies(page: page)
    }
}
enum CoreDataError: Error {
    case fetchFailed
    // Add other Core Data-related errors as needed
}
