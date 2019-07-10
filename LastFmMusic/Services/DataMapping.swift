//
//  DataMapping.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/10/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation

// MARK: - Map from ManagedObject object to model

let kNotSpecifiedPlaceholder = "not specified"

func mapStoredAlbumDetail(storedData: [AlbumDetails]) -> AlbumDetailModel? {
    if storedData.count == 0 {
        return nil
    }
    var albumDetailModel: AlbumDetailModel!
    if let item = storedData.first,
        let name = item.name,
        let url = item.url {
        
        var publishDate = item.publishDate
        if (publishDate == nil) {
            publishDate = kNotSpecifiedPlaceholder
        }
        albumDetailModel = (AlbumDetailModel(name: name,
                                             trackCount: Int(item.tracksCount),
                                             publishDate: publishDate,
                                             url: url))
    }
    return albumDetailModel
}

func mapStoredAlbums(storedData: [Albums]) -> [AlbumsListModel]? {
    var albumModelsArray: [AlbumsListModel] = []
    for item in storedData {
        guard let albumName = item.albumName,
            let imageURL = item.imageURL,
            let artistName = item.artistName
            else  { return [] }
        albumModelsArray.append(
            AlbumsListModel(name: albumName,
                            artist: ArtistModel(name: artistName, listeners: 0),
                            imageURL: imageURL))
    }
    return albumModelsArray
}

func mapStoredArtist(storedData: [Artist]) -> ArtistModel? {
    var artistModel: ArtistModel!
    if let item = storedData.first,
        let name = item.name {
        artistModel = (ArtistModel.init(name: name,
                                        listeners: Int(item.listeners)))
    }
    return artistModel
}

// MARK: - Map from model object to ManagedObject

func mapAlbumDetailsManagedObject(recordItem: AlbumDetails, albumDetail: AlbumDetailModel) {
    recordItem.name = albumDetail.name
    recordItem.publishDate = albumDetail.publishDate
    recordItem.tracksCount = Int16(albumDetail.trackCount)
    recordItem.url = albumDetail.url
}

func mapArtistManagedObject(recordItem: Artist, artist: ArtistModel) {
    recordItem.name = artist.name
    recordItem.listeners = Int64(artist.listeners)
}

func mapAlbumManagedObject(recordItem: Albums, album: AlbumsListModel) {
    recordItem.albumName = album.name
    recordItem.imageURL = album.imageURL
    recordItem.artistName = album.artist.name
}
