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
    case Artist
}

class DataManager {
    
    private static let kNotSpecifiedPlaceholder = "not specified"
    
    // MARK: - Properties
    
    private var networkManager: NetworkManager
    private var dataBaseManager: DataBaseManager
    
    // MARK: - Lifecycle
    
    init() {
        networkManager = NetworkManager()
        dataBaseManager = DataBaseManager()
    }
    
    // MARK: - GET Requests
    
    func getURLForDataType(type: DataType, object: AnyObject?) -> String {
        switch type {
        case .Albums:
            return "?method=tag.gettopalbums&tag=hip+hop"
        case .AlbumDetails:
            let object = object as? AlbumsListModel
            return "?method=album.getinfo" + "&artist="
                + object!.artist.name.replacingOccurrences(of: " ", with: "+")
                + "&album=" + object!.name.replacingOccurrences(of: " ", with: "+")
        case .Artist:
            let object = object as? ArtistModel
            return "?method=artist.getinfo" + "&artist=" + object!.name.replacingOccurrences(of: " ", with: "+")
        }
    }
    
    func getAlbumsList(completionHandler:@escaping (_ error: String?, _ albumArray: [AlbumsListModel]?) -> Void,
                       type: DataType) {
        completionHandler(nil, self.getStoredAlbums())
        networkManager.getData(completionHandler: { (json, error) in
            if error == nil {
                guard let json = json else { assert(false, "Error with response JSON") }
                self.dataBaseManager.addAlbumData(completionHandler: { (status) in
                    completionHandler(nil, self.getStoredAlbums())
                }, json: json, type: type)
            }
        }, url: getURLForDataType(type: type, object: nil))
    }
    
    func getAlbumDetails(completionHandler:@escaping (_ error: String?, _ detailsArray: AlbumsDetailsModel?) -> Void,
                         type: DataType, albumModel: AlbumsListModel) {
        completionHandler(nil, self.getStoredAlbumDetails())
        networkManager.getData(completionHandler: { (json, error) in
            if error == nil {
                guard let json = json else { assert(false, "Error with response JSON") }
                self.dataBaseManager.addAlbumData(completionHandler: { (status) in
                    completionHandler(nil, self.getStoredAlbumDetails())
                }, json: json, type: type)
            }
        }, url: getURLForDataType(type: type, object: albumModel))
    }
    
    func getArtistDetails(completionHandler:@escaping (_ error: String?, _ detailsArray: ArtistModel?) -> Void,
                          type: DataType, artistModel: ArtistModel) {
        completionHandler(nil, self.getStoredArtist())
        networkManager.getData(completionHandler: { (json, error) in
            if error == nil {
                guard let json = json else { assert(false, "Error with response JSON") }
                self.dataBaseManager.addAlbumData(completionHandler: { (status) in
                    completionHandler(nil, self.getStoredArtist())
                }, json: json, type: type)
            }
        }, url: getURLForDataType(type: type, object: nil))
    }
    
    func getStoredArtist() -> ArtistModel? {
        let storedArtist = dataBaseManager.getStoredObjects(entityName: Entities.artist.rawValue) as? [Artist]
        var artistModel: ArtistModel!
        if let storedArtist = storedArtist {
            if let item = storedArtist.first,
                let name = item.name {
                artistModel = (ArtistModel.init(name: name, listeners: Int(item.listeners)))
            }
        }
        return artistModel
    }
    
    func getStoredAlbums() -> [AlbumsListModel] {
        let storedAlbums = dataBaseManager.getStoredObjects(entityName: Entities.albums.rawValue) as? [Albums]
        
        var albumModelsArray: [AlbumsListModel] = []
        
        if let storedAlbums = storedAlbums {
            for item in storedAlbums {
                guard let albumName = item.albumName,
                    let imageURL = item.imageURL,
                    let artistName = item.artistName
                    else  { return [] }
                albumModelsArray.append(AlbumsListModel(name: albumName,
                                                        artist: ArtistModel(name: artistName, listeners: 0),
                                                        imageURL: imageURL))
            }
        }
        
        return albumModelsArray
    }
    
    func getStoredAlbumDetails() -> AlbumsDetailsModel? {
        let storedAlbum = dataBaseManager.getStoredObjects(entityName: Entities.albumDetails.rawValue) as? [AlbumDetails]
        
        if storedAlbum?.count == 0 {
            return nil
        }
        
        var albumDetailModel: AlbumsDetailsModel!
        
        if let storedAlbum = storedAlbum {
            if let item = storedAlbum.first,
                let name = item.name,
                let url = item.url {
                
                var publishDate = item.publishDate
                if (publishDate == nil) {
                    publishDate = DataManager.kNotSpecifiedPlaceholder
                }
                
                albumDetailModel = (AlbumsDetailsModel(name: name,
                                                       trackCount: Int(item.tracksCount),
                                                       publishDate: publishDate,
                                                       url: url))
            }
        }
        return albumDetailModel
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
