//
//  FakeCoreDataStorage.swift
//  Trending MoviesTests
//
//  Created by Mohamed on 11/02/2024.
//


import CoreData
@testable import Trending_Movies


// MARK: - FakeCoreDataStorage

class FakeCoreDataStorage: CoreDataStorageProtocol {

    var inMemoryContainer: NSPersistentContainer

    init() {
        inMemoryContainer = NSPersistentContainer(name: "FakeContainer") // Use a different container name for testing
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // Use an in-memory store for testing
        inMemoryContainer.persistentStoreDescriptions = [description]
        inMemoryContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("FakeCoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer {
        return inMemoryContainer
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("FakeCoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
