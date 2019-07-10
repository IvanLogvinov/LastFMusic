//
//  AlbumModel.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

struct AlbumsListModel {
    let name: String
    let imageURL: String
    let image: UIImage?
    let artist: ArtistModel
    
    init(name: String, artist: ArtistModel, imageURL: String) {
        self.name = name
        self.imageURL = imageURL
        self.artist = artist
        self.image = nil
    }
}
