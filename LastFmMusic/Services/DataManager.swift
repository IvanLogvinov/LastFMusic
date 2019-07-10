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
    case albums
    case albumDetails
    case artist
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
    
    func getURLForDataType(type: DataType, object: AnyObject?) -> String {
        switch type {
        case .albums:
            return "?method=tag.gettopalbums&tag=hip+hop"
        case .albumDetails:
            guard let object = object as? AlbumsListModel else { return "" }
            return "?method=album.getinfo" + "&artist="
                + object.artist.name.replacingOccurrences(of: " ", with: "+")
                + "&album=" + object.name.replacingOccurrences(of: " ", with: "+")
        case .artist:
            guard let object = object as? ArtistModel else { return "" }
            return "?method=artist.getinfo" + "&artist=" + object.name.replacingOccurrences(of: " ", with: "+")
        }
    }
    
    func getAlbumsList(completionHandler:@escaping (_ error: String?, _ albumArray: [AlbumsListModel]?) -> Void,
                       type: DataType) {
        completionHandler(nil, self.getStoredAlbums())
        networkManager.getAlbumData(completionHandler: { (modelArray, error) in
            if error == nil {
                guard let modelArray = modelArray else { assert(false, Error.errorJson.rawValue) }
                self.dataBaseManager.addAlbumData(completionHandler: { (status) in
                    completionHandler(nil, self.getStoredAlbums())
                }, albums: modelArray)
            }
        }, url: getURLForDataType(type: type, object: nil))
    }
    
    func getAlbumDetails(completionHandler:@escaping (_ error: String?, _ detailsArray: AlbumDetailModel?) -> Void,
                         type: DataType, albumModel: AlbumsListModel) {
        completionHandler(nil, self.getStoredAlbumDetails())
        networkManager.getAlbumDetailData(completionHandler: { (album, error) in
            if error == nil {
                guard let album = album else { assert(false, Error.errorJson.rawValue) }
                self.dataBaseManager.addAlbumDetailsData(completionHandler: { (status) in
                    completionHandler(nil, self.getStoredAlbumDetails())
                }, albumDetail: album)
            }
        }, url: getURLForDataType(type: type, object: albumModel as AnyObject))
    }
    
    func getArtistDetails(completionHandler:@escaping (_ error: String?, _ detailsArray: ArtistModel?) -> Void,
                          type: DataType, artistModel: ArtistModel) {
        completionHandler(nil, self.getStoredArtist())
        networkManager.getArtistData(completionHandler: { (artist, error) in
            if error == nil {
                guard let artist = artist else { assert(false, Error.errorJson.rawValue) }
                self.dataBaseManager.addArtistData(completionHandler: { (status) in
                    completionHandler(nil, self.getStoredArtist())
                }, artist: artist)
            }
        }, url: getURLForDataType(type: type, object: artistModel as AnyObject))
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
    
    // MARK: - Get Stored Data
    
    func getStoredAlbums() -> [AlbumsListModel]? {
        let storedAlbums = dataBaseManager.getStoredObjects(
            entityName: Entities.albums.rawValue) as? [Albums]
        guard let data = storedAlbums else { return [] }
        return mapStoredAlbums(storedData: data)
    }
    
    func getStoredAlbumDetails() -> AlbumDetailModel? {
        let storedAlbumDetails = dataBaseManager.getStoredObjects(
            entityName: Entities.albumDetails.rawValue) as? [AlbumDetails]
        guard let data = storedAlbumDetails else { return nil }
        return mapStoredAlbumDetail(storedData: data)
    }
    
    func getStoredArtist() -> ArtistModel? {
        let storedArtist = dataBaseManager.getStoredObjects(
            entityName: Entities.artist.rawValue) as? [Artist]
        guard let data = storedArtist else { return nil }
        return mapStoredArtist(storedData: data)
    }
    
  
}
