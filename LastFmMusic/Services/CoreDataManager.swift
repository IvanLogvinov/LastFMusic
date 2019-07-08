//
//  CoreDataManager.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import CoreData

enum Entities: String {
    case albums = "Albums"
    case albumDetails = "AlbumDetails"
}

class CoreDataManager {
    
    // MARK: - Properties
    
    static let dataBaseName = "LastFmApp"
    
    var persistentContainer: NSPersistentContainer
    var privateContext: NSManagedObjectContext
    private static var sharedCoreDataManager: CoreDataManager = {
        let coreDataManager = CoreDataManager()
        return coreDataManager
    }()
    
    
    func saveContext() {
        if privateContext.hasChanges {
            do {
                try privateContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Initialization
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: CoreDataManager.dataBaseName)
        self.persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                debugPrint("Failed to load Core Data stack: \(error)")
            }
        }
        self.privateContext = self.persistentContainer.newBackgroundContext()
    }
    
    
    // MARK: - Accessors
    
    class func shared() -> CoreDataManager {
        return sharedCoreDataManager
    }
}

