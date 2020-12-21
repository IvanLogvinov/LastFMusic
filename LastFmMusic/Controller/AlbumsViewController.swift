//
//  AlbumsController.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumsViewController: UITableViewController, Storyboarded {
    
    // MARK: - Constants
    
    private static let kCellHeightSize: CGFloat = 170
    private static let kDetailsSegue = "DetailsSegue"
    
    // MARK: - Properties

    var coordinator: MainCoordinator?
    var dataManager: DataManager!
    private var albumArray: [AlbumsListModel] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AlbumViewCell.nib(), forCellReuseIdentifier: AlbumViewCell.identifier())
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        tableView.refreshControl = refreshControl
        getAlbumsData()
    }
    
    func getAlbumsData() {
        dataManager.getAlbumsList(completionHandler: { [weak self] (error, albumsArray) in
            if error == nil, let albumsArray = albumsArray {
                self?.albumArray = albumsArray
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
            }
        }, type: .albums)
    }
    
    @objc func refreshPage(refreshControl: UIRefreshControl) {
        getAlbumsData()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumViewCell.identifier(), for: indexPath) as? AlbumViewCell else { fatalError(Error.cellErrorMsg.rawValue) }
        
        let albumModel = albumArray[indexPath.row]
        cell.setAlbumData(albumModel: albumModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumItem = albumArray[indexPath.row]
        coordinator?.detailsViewController(albumItem: albumItem)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AlbumsViewController.kCellHeightSize
    }
}
