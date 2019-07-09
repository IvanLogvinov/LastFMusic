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
    
    let launchCountUserDefaultsKey = "noOfLaunches"
    
    func isReviewViewToBeDisplayed(minimumLaunchCount:Int) -> Bool {
        let launchCount = UserDefaults.standard.integer(forKey: launchCountUserDefaultsKey)
        if launchCount >= minimumLaunchCount {
            return true
        } else {
            UserDefaults.standard.set((launchCount + 1), forKey: launchCountUserDefaultsKey)
        }
        print(launchCount)
        return false
    }
    
    func showReviewView(afterMinimumLaunchCount:Int){
        if(self.isReviewViewToBeDisplayed(minimumLaunchCount: afterMinimumLaunchCount)){
            SKStoreReviewController.requestReview()
        }
    }
}
