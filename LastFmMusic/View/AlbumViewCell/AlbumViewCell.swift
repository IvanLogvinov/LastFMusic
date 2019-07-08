//
//  AlbumViewCell.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.zero
    }
    
    func setAlbumName(name: String) {
        albumNameLabel.text = name
    }
    
    func setAlbumImage(imageURL: String) {
        if !imageURL.isEmpty {
            albumImageView.kf.setImage(with: URL(string: imageURL))
        } else {
            albumImageView.image = UIImage(named: "no_img")
        }
    }
    
}
