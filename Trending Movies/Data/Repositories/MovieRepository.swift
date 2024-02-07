//
//  MovieRepository.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//


import RxSwift
import CoreData

protocol MovieRepositoryProtocol {
    func fetchMovies(page: Int) -> Observable<[MovieSummaryDTO]>
}

class OnlineMovieRepository: MovieRepositoryProtocol {
    func fetchMovies(page: Int) -> Observable<[MovieSummaryDTO]> {
        return Observable.create { observer in
            // Make API call to fetch movies for the given page
            // Upon receiving the data, parse it and return the Observable
            // For demonstration, I'll assume a mocked Observable for now
            let movieSummaryDTOs: [MovieSummaryDTO] = [] // Mocked data
            print("Fetching online data for page \(page)")
            observer.onNext(movieSummaryDTOs)
            observer.onCompleted()

            return Disposables.create()
        }
    }
}

class OfflineMovieRepository: MovieRepositoryProtocol {
    let persistentContainer: NSPersistentContainer
    let onlineRepository: OnlineMovieRepository
    let disposeBag = DisposeBag()

    init(persistentContainer: NSPersistentContainer, onlineRepository: OnlineMovieRepository) {
        self.persistentContainer = persistentContainer
        self.onlineRepository = onlineRepository
    }

    func fetchMovies(page: Int) -> Observable<[MovieSummaryDTO]> {
        return Observable.create { observer in
            let context = self.persistentContainer.viewContext

            // Check if MoviesPageEntity exists for the given page
            let fetchRequest: NSFetchRequest<MoviesPageEntity> = MoviesPageEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "page == %d", page)

            do {
                let results = try context.fetch(fetchRequest)
                if let moviesPageEntity = results.first {
                    // MoviesPageEntity exists locally, return data
                    let movieSummaryDTOs = moviesPageEntity.toDTO()
                    print("Local data found for page \(page)")
                    observer.onNext(movieSummaryDTOs)
                    observer.onCompleted()
                } else {
                    // MoviesPageEntity does not exist locally, fetch from online
                    print("Local data not found for page \(page). Fetching from online.")
                    self.onlineRepository.fetchMovies(page: page)
                        .subscribe(onNext: { movieSummaryDTOs in
                            self.saveMoviesToCoreData(movieSummaryDTOs, page: page)
                            observer.onNext(movieSummaryDTOs)
                            observer.onCompleted()
                        }, onError: { error in
                            print("Error fetching online data: \(error)")
                            observer.onError(error)
                        })
                        .disposed(by: self.disposeBag)
                }
            } catch {
                print("Error fetching data locally: \(error)")
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    private func saveMoviesToCoreData(_ movieSummaryDTOs: [MovieSummaryDTO], page: Int) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            let moviesPageEntity = MoviesPageEntity(context: context)
            moviesPageEntity.page = Int32(page)
            moviesPageEntity.totalPages = Int32(movieSummaryDTOs.first?.totalPages ?? 0)
            
            let movieEntities = movieSummaryDTOs.compactMap { $0.movies.map { $0.toEntity(context: context) } }.flatMap { $0 }
            moviesPageEntity.movies = NSSet(array: movieEntities)
            
            do {
                try context.save()
                print("Data saved to CoreData for page \(page)")
            } catch {
                print("Failed to save data to CoreData: \(error)")
            }
        }
    }
}
