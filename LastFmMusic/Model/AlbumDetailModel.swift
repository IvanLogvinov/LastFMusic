//
//  AlbumDetailsModel.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

struct AlbumDetailModel {
    let name: String
    let trackCount: Int
    let publishDate: String?
    var artist: ArtistModel?
    let url: String
    
    init(name: String, trackCount: Int, publishDate: String?, url: String) {
        self.name = name
        self.trackCount = trackCount
        self.publishDate = publishDate
        self.url = url
    }
}
