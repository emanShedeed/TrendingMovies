//
//  GenreRepository.swift
//  Trending Movies
//
//  Created by Mohamed on 07/02/2024.
//

import RxSwift
import CoreData

protocol GenreRepositoryProtocol {
    func fetchGenres() -> Observable<[GenreDTO]>
}


class OnlineGenreRepository: GenreRepositoryProtocol {
    func fetchGenres() -> Observable<[GenreDTO]> {
        // Implement logic to fetch genres from online source (API) and return Observable
        fatalError("Not implemented")
    }
}

class OfflineGenreRepository: GenreRepositoryProtocol {
    let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func fetchGenres() -> Observable<[GenreDTO]> {
        return Observable.create { observer in
            let context = self.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<GenreEntity> = GenreEntity.fetchRequest()

            do {
                let genres = try context.fetch(fetchRequest)
                if !genres.isEmpty {
                    let genreDTOs = genres.map { $0.toDTO() }
                    observer.onNext(genreDTOs)
                    observer.onCompleted()
                } else {
                    // Fetch from online repository if local data is empty
                    let onlineRepository = OnlineGenreRepository()
                    onlineRepository.fetchGenres()
                        .subscribe(onNext: { genreDTOs in
                            self.saveGenresToCoreData(genreDTOs)
                            observer.onNext(genreDTOs)
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

    private func saveGenresToCoreData(_ genreDTOs: [GenreDTO]) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            for genreDTO in genreDTOs {
                let genreEntity = genreDTO.toEntity(context: context)
                // Save the genre entity
            }

            do {
                try context.save()
            } catch {
                print("Failed to save genres to CoreData: \(error)")
            }
        }
    }
}

