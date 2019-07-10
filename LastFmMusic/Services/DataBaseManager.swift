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
        let predicate = NSPredicate(format: "name == %@", albumDetail.name)
        if (self.getStoredObjects(predicate: predicate, entityName: Entities.albumDetails.rawValue).count == 0) {
            if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.albumDetails.rawValue),
                                                                    into: managedObjectContext) as? AlbumDetails {
                mapAlbumDetailsManagedObject(recordItem: recordItem, albumDetail: albumDetail)
            }
        }
        saveContextData()
        completionHandler(true)
    }
    
    func addArtistData(completionHandler:@escaping (Bool) -> Void,
                       artist: ArtistModel) {
        let predicate = NSPredicate(format: "name == %@", artist.name)
        if (self.getStoredObjects(predicate: predicate, entityName: Entities.artist.rawValue).count == 0) {
            if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.artist.rawValue),
                                                                    into: managedObjectContext) as? Artist {
                mapArtistManagedObject(recordItem: recordItem, artist: artist)
            }
        }
        saveContextData()
        completionHandler(true)
    }
    
    func addAlbumData(completionHandler:@escaping (Bool) -> Void,
                      albums: [AlbumsListModel]) {
        for album in albums {
            let predicate = NSPredicate(format: "albumName == %@", album.name)
            if (self.getStoredObjects(predicate: predicate, entityName: Entities.albums.rawValue).count == 0) {
                if let recordItem = NSEntityDescription.insertNewObject(forEntityName: (Entities.albums.rawValue),
                                                                        into: managedObjectContext) as? Albums {
                    mapAlbumManagedObject(recordItem: recordItem, album: album)
                }
            }
        }
        saveContextData()
        completionHandler(true)
    }
    
    
    
    // MARK: - Get Stored Records From DataBase
    
    func getStoredObjects(predicate: NSPredicate?, entityName: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fetchRequest.sortDescriptors = nil
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

