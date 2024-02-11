//
//  CoreDataStorage.swift
//  Trending Movies
//
//  Created by Mohamed on 08/02/2024.
//

import CoreData

// MARK: - CoreDataStorageProtocol

protocol CoreDataStorageProtocol {
    var persistentContainer: NSPersistentContainer { get }
    func saveContext()
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

// MARK: - CoreDataStorageError

enum CoreDataStorageError: Error, Equatable {
    case readError
    case saveError(Error)
    case deleteError
    // Add other cases if needed

    // Implement the Equatable protocol
    static func ==(lhs: CoreDataStorageError, rhs: CoreDataStorageError) -> Bool {
        switch (lhs, rhs) {
        case (.readError, .readError):
            return true
        // Add cases for other error types if needed
        default:
            return false
        }
    }
}

// MARK: - CoreDataStorage

final class CoreDataStorage: CoreDataStorageProtocol {

    static let shared = CoreDataStorage()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trending_Movies")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}

