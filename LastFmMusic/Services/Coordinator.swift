//
//  Router.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 21.12.2020.
//  Copyright © 2020 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let dataManager = DataManager()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = AlbumsViewController.instantiate()
        vc.coordinator = self
        vc.dataManager = dataManager
        navigationController.pushViewController(vc, animated: false)
    }

    func detailsViewController(albumItem: AlbumsListModel) {
        let vc = DetailsViewController.instantiate()
        vc.coordinator = self
        vc.dataManager = dataManager
        vc.albumItem = albumItem
        navigationController.pushViewController(vc, animated: false)
    }
}
