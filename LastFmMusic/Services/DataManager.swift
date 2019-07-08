//
//  DataManager.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

enum DataType {
    case Albums
    case AlbumDetails
}

class DataManager {
    
    // MARK: - Properties
    
    private var networkManager: NetworkManager
    private var dataBaseManager: DataBaseManager
    
    // MARK: - Lifecycle
    
    init() {
        networkManager = NetworkManager()
        dataBaseManager = DataBaseManager()
    }
    
    // MARK: - GET Requests
    
    func getAlbumsList(completionHandler:@escaping (_ error: String?, _ albumArray: [AlbumsListModel]?) -> Void, type: DataType) {
        completionHandler(nil, self.getStoredAlbums())
        networkManager.getAlbumsList(completionHandler: { (json, error) in
            if error == nil {
                guard let json = json else { assert(false, "Error with response JSON") }
                self.dataBaseManager.addAlbumData(completionHandler: { (status) in
                    completionHandler(nil, self.getStoredAlbums())
                }, json: json, type: type)
            }
        })
    }
    
    func getAlbumDetails(completionHandler:@escaping (_ error: String?, _ detailsArray: AlbumsDetailsModel?) -> Void, type: DataType) {
        completionHandler(nil, self.getStoredAlbumDetails())
        networkManager.getAlbumsList(completionHandler: { (json, error) in
            if error == nil {
                guard let json = json else { assert(false, "Error with response JSON") }
                self.dataBaseManager.addAlbumData(completionHandler: { (status) in
                    completionHandler(nil, self.getStoredAlbumDetails())
                }, json: json, type: type)
            }
        })
    }
    
    func getStoredAlbums() -> [AlbumsListModel] {
        let storedNews = dataBaseManager.getStoredObjects(predicate: nil, sortDescriptor: nil, entityName: Entities.albums.rawValue) as? [Albums]
        
        var albumModelsArray: [AlbumsListModel] = []
        
        if let storedNews = storedNews {
            for item in storedNews {
                guard let name = item.name,
                    let imageURL = item.imageURL else  { return [] }
                albumModelsArray.append(AlbumsListModel(name: name, imageURL: imageURL))
            }
        }
        
        return albumModelsArray
    }
    
    func getStoredAlbumDetails() -> AlbumsDetailsModel {
        let storedNews = dataBaseManager.getStoredObjects(predicate: nil, sortDescriptor: nil, entityName: Entities.albumDetails.rawValue) as? [AlbumDetails]
        
        var albumDetailModelArray: AlbumsDetailsModel!
        
        if let storedNews = storedNews {
            for item in storedNews {
                guard let name = item.name,
                    let date = item.publishDate
                    else  { return albumDetailModelArray }
                albumDetailModelArray = (AlbumsDetailsModel(name: name,
                                                            trackCount: Int(item.tracksCount),
                                                            publishDate: date))
            }
        }
        return albumDetailModelArray
    }
    
    func getImage(completionHandler: @escaping (UIImage?) -> Void, by url: String) {
        networkManager.getImage(by: url, completionHandler: { (image, error) in
            if error == nil {
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
        })
    }
    
}
