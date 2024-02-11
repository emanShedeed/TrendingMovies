//
//  GenreRepository.swift
//  Trending Movies
//
//  Created by Eman Shedeed on 07/02/2024.
//

import RxSwift
import CoreData

// MARK: - Genre Repository Protocol

protocol GenreRepositoryProtocol {
    func fetchGenres() -> Observable<GenreListDTO>
}

// MARK: - Online Genre Repository

class OnlineGenreRepository: GenreRepositoryProtocol {
    func fetchGenres() -> Observable<GenreListDTO> {
        return MoviesAPIClient.fetchGenres()
    }
}

// MARK: - Offline Genre Repository

class OfflineGenreRepository: GenreRepositoryProtocol {
    let coreDataStorage: CoreDataStorageProtocol

    init(coreDataStorage: CoreDataStorageProtocol = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    func fetchGenres() -> Observable<GenreListDTO> {
        let onlineRepository = OnlineGenreRepository() // Create an instance of OnlineGenreRepository
        
        return Observable.create { observer in
            self.coreDataStorage.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()

                do {
                    let genres = try context.fetch(fetchRequest)
                    if !genres.isEmpty {
                        let genreDTOs = genres.map { $0.toDTO() }
                        let genreListDTO = GenreListDTO(genres: genreDTOs)
                        observer.onNext(genreListDTO)
                        observer.onCompleted()
                    } else {
                        print("No data found locally for page ")
                        observer.onError(CoreDataStorageError.readError)
                    }
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
        .catch { error in // Handle the error here
            // Fetch genres from the online repository
            return onlineRepository.fetchGenres()
                .do(onNext: { [weak self] genreList in
                    guard let self = self else { return }
                    self.coreDataStorage.performBackgroundTask { context in
                        self.saveGenresToCoreData(genreList.genres, context: context)
                    }
                })
        }
    }



    private func saveGenresToCoreData(_ genreDTOs: [GenreDTO], context: NSManagedObjectContext) {
           context.perform {
               for genreDTO in genreDTOs {
                   let genreEntity = genreDTO.toEntity(context: context)
                   // Save the genre entity
               }

               do {
                   try context.save()
               } catch {
                   // Handle the save error
                                 
                   print("Failed to save genres to CoreData: \(error)")
               }
           }
       }
}
