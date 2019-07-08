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
    
    init(name: String, imageURL: String) {
        self.name = name
        self.imageURL = imageURL
    }
}
