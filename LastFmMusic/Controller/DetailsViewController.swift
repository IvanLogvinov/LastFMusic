//
//  DetailsViewController.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Dependency Properties
    
    var albumItem: AlbumsListModel?
    private var detailsModel: AlbumsDetailsModel?
    
    // MARK: - View Outlets
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleName: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContent()
        DataManager().getAlbumDetails(completionHandler: { [weak self] (error, detailsModel) in
            if error == nil, let detailsModel = detailsModel {
                self?.detailsModel = detailsModel
            }
            }, type: .AlbumDetails)
    }
    
    // MARK: - Custom Methods
    
    func setUpContent() {
        if albumItem != nil {
            articleImageView.kf.setImage(with: URL(string: (albumItem?.imageURL)!))
            articleName.text = albumItem?.name
        }
    }
}
