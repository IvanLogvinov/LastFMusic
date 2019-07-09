//
//  AlbumModel.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

class AlbumsListModel {
    var name: String
    var imageURL: String
    var image: UIImage?
    var artist: ArtistModel
    
    init(name: String, artist: ArtistModel, imageURL: String) {
        self.name = name
        self.imageURL = imageURL
        self.artist = artist
    }
}
