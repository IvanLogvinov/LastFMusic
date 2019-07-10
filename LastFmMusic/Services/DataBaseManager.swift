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
    
    let managedObjectContext =  CoreDataManager.shared().getContext()
    
    // MARK: - Add New Records
    
    func addAlbumDetailsData(completionHandler:@escaping (Bool) -> Void,
                             albumDetail: AlbumDetailModel) {
        
        // TODO: add check for duplicates and disable database clean
        deleteEntityData(entityName: Entities.albumDetails.rawValue)
        
        if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.albumDetails.rawValue),
                                                                into: managedObjectContext) as? AlbumDetails {
            mapAlbumDetailsManagedObject(recordItem: recordItem, albumDetail: albumDetail)
        }
        saveContextData()
        completionHandler(true)
    }
    
    func addArtistData(completionHandler:@escaping (Bool) -> Void,
                       artist: ArtistModel) {
        deleteEntityData(entityName: Entities.artist.rawValue)
        // TODO: add check for duplicates and disable database clean
        if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.artist.rawValue),
                                                                into: managedObjectContext) as? Artist {
            mapArtistManagedObject(recordItem: recordItem, artist: artist)
        }
        saveContextData()
        completionHandler(true)
    }
    
    func addAlbumData(completionHandler:@escaping (Bool) -> Void,
                      albums: [AlbumsListModel]) {
        deleteEntityData(entityName: Entities.albums.rawValue)
        // TODO: add check for duplicates and disable database clean
        for album in albums {
            if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.albums.rawValue),
                                                                    into: managedObjectContext) as? Albums {
                mapAlbumManagedObject(recordItem: recordItem, album: album)
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

