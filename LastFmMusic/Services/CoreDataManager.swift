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
    case artist = "Artist"
}

class CoreDataManager {
    
    // MARK: - Constant
    
    private static let dataBaseName = "LastFmApp"
    
    // MARK: - Properties
    
    private var persistentContainer: NSPersistentContainer
    private var privateContext: NSManagedObjectContext
    
    private static var sharedCoreDataManager: CoreDataManager = {
        let coreDataManager = CoreDataManager()
        return coreDataManager
    }()
    
    // MARK: - Init
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: CoreDataManager.dataBaseName)
        self.persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                debugPrint("Failed to load Core Data stack: \(error)")
            }
        }
        self.privateContext = self.persistentContainer.newBackgroundContext()
    }
    
    func getContext() -> NSManagedObjectContext {
        return privateContext
    }
    
    
    // MARK: - Accessors
    
    class func shared() -> CoreDataManager {
        return sharedCoreDataManager
    }
}

