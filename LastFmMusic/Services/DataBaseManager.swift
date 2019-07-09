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
        deleteEntityData(entityName: Entities.albumDetails.rawValue)
        deleteEntityData(entityName: Entities.artist.rawValue)
        
        if  (type == DataType.Albums) {
            for (_,subJson):(String, JSON) in json["albums"]["album"] {
                if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.albums.rawValue),
                                                                        into: managedObjectContext) as? Albums {
                    recordItem.albumName = subJson["name"].string
                    recordItem.imageURL = subJson["image"][2]["#text"].string
                    recordItem.artistName = subJson["artist"]["name"].string
                }
            }
        } else if (type == DataType.AlbumDetails) {
            if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.albumDetails.rawValue),
                                                                    into: managedObjectContext) as? AlbumDetails {
                let subJson = json["album"]
                recordItem.name = subJson["name"].string
                recordItem.publishDate = subJson["wiki"]["published"].string
                recordItem.tracksCount = Int16(subJson["tracks"]["track"].count)
                recordItem.url = subJson["url"].string
            }
        } else if (type == DataType.Artist) {
            if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.artist.rawValue),
                                                                    into: managedObjectContext) as? Artist {
                recordItem.name = json["artist"]["name"].string
                recordItem.listeners = json["artist"]["stats"]["listeners"].int64Value
            }
        }
        
        saveContextData()
        completionHandler(true)
    }
    
    
    
    // MARK: - Get Stored Records From DataBase
    
    func getStoredObjects(entityName: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fetchRequest.sortDescriptors = nil
        fetchRequest.predicate = nil
        
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

