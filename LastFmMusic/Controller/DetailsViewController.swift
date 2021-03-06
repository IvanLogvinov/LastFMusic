//
//  DetailsViewController.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit
import FBSDKShareKit

class DetailsViewController: UIViewController, Storyboarded {
    
    // MARK: - Dependency Properties

    weak var coordinator: MainCoordinator?
    var albumItem: AlbumsListModel!
    var dataManager: DataManager!
    
    // MARK: - Private Properties
    
    private var detailsModel: AlbumDetailModel?
    
    // MARK: - View Outlets
    
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var tracksCountLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistListeners: UILabel!
    
    @IBOutlet weak var shareView: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbumData()
    }
    
    // MARK: - Get Data Methods
    
    func getAlbumData() {
        dataManager?.getAlbumDetails(completionHandler: { [weak self] (error, detailsModel) in
            if error == nil, let detailsModel = detailsModel {
                self?.detailsModel = detailsModel
                self?.getArtistData()
            }
        }, type: .albumDetails, albumModel: albumItem)
    }
    
    func getArtistData() {
        dataManager.getArtistDetails(completionHandler: { [weak self] (error, artistModel) in
            if error == nil, let artistModel = artistModel {
                self?.detailsModel?.artist = artistModel
                self?.setUpContent()
            }
        }, type: .artist, artistModel: albumItem.artist)
    }
    
    // MARK: - Actions
    
    @IBAction func actionShare(_ sender: Any) {
        let content = ShareLinkContent()
        
        if let url = detailsModel?.url {
            content.contentURL = URL(string: url)!
        }
        
        if let albumName = detailsModel?.name,
           let artistName = detailsModel?.artist?.name {
            content.quote = "Listen to: " + albumName + " by " + artistName
        }
        let dialog = ShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.delegate = nil
        dialog.show()
    }
    
    // MARK: - Views Setup
    
    func setUpContent() {
        albumName.text = detailsModel?.name
        publishDateLabel.text = detailsModel?.publishDate
        artistName.text = detailsModel?.artist?.name
        if let listeners = detailsModel?.artist?.listeners,
           let trackCount = detailsModel?.trackCount {
            artistListeners.text = String(listeners)
            tracksCountLabel.text = String(trackCount)
        }
    }
    
}
