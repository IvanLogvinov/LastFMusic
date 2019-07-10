//
//  AppReview.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/9/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import UIKit
import StoreKit

class AppReview {

    let kDefaultReviewLaunches = 10
    let launchCountUserDefaultsKey = "noOfLaunches"
    
    func showReviewView() {
        let launchCount = UserDefaults.standard.integer(forKey: launchCountUserDefaultsKey)
        if launchCount >= kDefaultReviewLaunches {
            SKStoreReviewController.requestReview()
            UserDefaults.standard.set(0, forKey: launchCountUserDefaultsKey)
        } else {
            UserDefaults.standard.set((launchCount + 1), forKey: launchCountUserDefaultsKey)
        }
        print(launchCount)
    }
}
