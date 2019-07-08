//
//  AlbumDetailsModel.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

class AlbumsDetailsModel {
    var name: String
    var trackCount: Int
    var publishDate: Date
    var artist: ArtistModel?
    
    init(name: String, trackCount: Int, publishDate: Date) {
        self.name = name
        self.trackCount = trackCount
        self.publishDate = publishDate
    }
}
