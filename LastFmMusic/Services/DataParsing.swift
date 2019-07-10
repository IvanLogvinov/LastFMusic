//
//  DataParsing.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/10/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import SwiftyJSON

func parseAlbumData(json: JSON) -> [AlbumsListModel]? {
    var albumModelsArray: [AlbumsListModel] = []
    
    for (_,subJson):(String, JSON) in json["albums"]["album"] {
        if let albumName = subJson["name"].string,
            let imageURL = subJson["image"][2]["#text"].string,
            let artistName = subJson["artist"]["name"].string {
            
            albumModelsArray.append(AlbumsListModel.init(name: albumName,
                                                         artist: ArtistModel.init(name: artistName, listeners: 0),
                                                         imageURL: imageURL))
        }
    }
    return albumModelsArray
}

func parseDetailsData(json: JSON) -> AlbumDetailModel? {
    var albumDetails: AlbumDetailModel!
    let subJson = json["album"]
    
    albumDetails = AlbumDetailModel.init(
        name: subJson["name"].string ?? "",
        trackCount: Int(subJson["tracks"]["track"].count),
        publishDate: subJson["wiki"]["published"].string ?? kNotSpecifiedPlaceholder,
        url: subJson["url"].string ?? "")
    
    return albumDetails
}

func parseArtistData(json: JSON) -> ArtistModel? {
    var artist: ArtistModel!
    artist = ArtistModel.init(name: json["artist"]["name"].string ?? "",
                              listeners: json["artist"]["stats"]["listeners"].intValue)
    return artist
}

