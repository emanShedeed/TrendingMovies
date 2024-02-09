//
//  GenreRepository.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
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
    let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    func fetchGenres() -> Observable<GenreListDTO> {
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
                           // Fetch from online repository if local data is empty
                           let onlineRepository = OnlineGenreRepository()
                           onlineRepository.fetchGenres()
                               .subscribe(onNext: { genreList in
                                   // Save genres to CoreData
                                   self.saveGenresToCoreData(genreList.genres, context: context)
                                 
                                   observer.onNext(genreList)
                                   observer.onCompleted()
                               }, onError: { error in
                                   observer.onError(error)
                               })
                               .disposed(by: DisposeBag())
                       }
                   } catch {
                       observer.onError(error)
                   }
               }
               return Disposables.create()
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
