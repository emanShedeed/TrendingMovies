//
//  SearchMovieRepository.swift
//  Trending Movies
//
//  Created by Mohamed on 10/02/2024.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

// Protocol for SearchMovieRepository
protocol SearchMovieRepositoryProtocol {
    func searchMovie(by query: String?, genreId: Int?) -> Observable<[MoviePageDTO.MovieSummaryDTO]>
}

// SearchMovieRepository class conforming to the protocol
class SearchMovieRepository: SearchMovieRepositoryProtocol {
    let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func searchMovie(by query: String?, genreId: Int?) -> Observable<[MoviePageDTO.MovieSummaryDTO]> {
        return Observable.create { observer in
            self.coreDataStorage.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<MovieSummaryEntity> = MovieSummaryEntity.fetchRequest()
                
                // Constructing the predicate conditionally based on the provided query and genreId
                var predicates: [NSPredicate] = []
                
                if let query = query ,!query.isEmpty {
                    predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", query))
                }
                
                if let genreId = genreId {
                    // Creating a predicate to filter based on genreId in the relationship
                    predicates.append(NSPredicate(format: "ANY genreIds.id == %d", genreId))
                }
                
                // Combining predicates using NSCompoundPredicate
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                fetchRequest.predicate = compoundPredicate
                
                do {
                    let movieSummaries = try context.fetch(fetchRequest)
                    let movieSummaryDTOs = movieSummaries.compactMap { $0.toDTO() }
                    observer.onNext(movieSummaryDTOs)
                    observer.onCompleted()
                } catch {
                    observer.onError(CoreDataStorageError.readError)
                }
            }
            return Disposables.create()
        }
    }

}
