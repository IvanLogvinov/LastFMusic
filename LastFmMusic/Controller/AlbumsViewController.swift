//
//  AlbumsController.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumsViewController: UITableViewController {
    
    // MARK: - Constants
    
    private static let kCellHeightSize: CGFloat = 170
    private static let kCellErrorMsg = "Unexpected Cell Identifier"
    private static let kDetailsSegue = "DetailsSegue"
    private static let kDefaultReviewLaunches = 10
    
    // MARK: - Properties
    
    private var dataManager: DataManager!
    private var albumArray: [AlbumsListModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AlbumViewCell.nib(), forCellReuseIdentifier: AlbumViewCell.identifier())
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        tableView.refreshControl = refreshControl
        getAlbumsData()
       // AppReview().showReviewView(afterMinimumLaunchCount: AlbumsViewController.kDefaultReviewLaunches)
    }
    
    func getAlbumsData() {
        dataManager = DataManager()
        dataManager.getAlbumsList(completionHandler: { [weak self] (error, albumsArray) in
            if error == nil, let albumsArray = albumsArray {
                self?.albumArray = albumsArray
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
            }
        }, type: .Albums)
    }
    
    @objc func refreshPage(refreshControl: UIRefreshControl) {
        getAlbumsData()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumViewCell.identifier(), for: indexPath) as? AlbumViewCell else { fatalError(AlbumsViewController.kCellErrorMsg) }
        
        let albumModel = albumArray[indexPath.row]
        cell.setAlbumName(name: albumModel.name)
        cell.setAlbumImage(imageURL: albumModel.imageURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumItem = albumArray[indexPath.row]
        self.performSegue(withIdentifier: AlbumsViewController.kDetailsSegue, sender: albumItem)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AlbumsViewController.kCellHeightSize
    }
    
    //MARK: - UIStoryboardSegue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailsViewController {
            vc.albumItem = sender as? AlbumsListModel
        }
    }
}

