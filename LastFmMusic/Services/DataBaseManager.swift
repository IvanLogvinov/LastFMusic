//
//  DataBaseManager.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class DataBaseManager {
    
    let managedObjectContext =  CoreDataManager.shared().privateContext
    
    // MARK: - Add New Records
    
    func addAlbumData(completionHandler:@escaping (Bool) -> Void,
                      json: JSON, type: DataType) {
        
        
        deleteEntityData(entityName: Entities.albums.rawValue)
        
        if  type == DataType.Albums {
            for (_,subJson):(String, JSON) in json["albums"]["album"] {
                if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.albums.rawValue),
                                                                        into: managedObjectContext) as? Albums {
                    recordItem.name = subJson["name"].string
                    recordItem.imageURL = subJson["image"][2]["#text"].string
                }
            }
        } else {
            
        }
        
        saveContextData()
        completionHandler(true)
    }
    
    
    
    // MARK: - Get Stored Records From DataBase
    
    func getStoredObjects(predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?, entityName: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let sortDescriptor = sortDescriptor {
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        fetchRequest.predicate = predicate
        var storedRecords: [NSManagedObject] = []
        do {
            if let storedRecordsArr = try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                storedRecords = storedRecordsArr
            }
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        return storedRecords
    }
    
    
    // MARK: - Save/Delete Data
    
    func saveContextData() {
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func deleteEntityData(entityName: String) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try managedObjectContext.execute(request)
        } catch {}
    }
    
}

