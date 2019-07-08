//
//  ArtistModel.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

class ArtistModel {
    var name: String
    var listeners: Int
    
    init(name: String, listeners: Int) {
        self.name = name
        self.listeners = listeners
    }
}
