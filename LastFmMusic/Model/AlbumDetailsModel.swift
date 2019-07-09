//
//  AlbumDetailsModel.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailModel {
    var name: String
    var trackCount: Int
    var publishDate: String?
    var artist: ArtistModel?
    var url: String
    
    init(name: String, trackCount: Int, publishDate: String?, url: String) {
        self.name = name
        self.trackCount = trackCount
        self.publishDate = publishDate
        self.url = url
    }
}
