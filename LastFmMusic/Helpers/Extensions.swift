//
//  Extensions.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import UIKit

extension UIView {
    class public func identifier() -> String {
        return String(describing: self)
    }
    
    class public func nib(bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: self.identifier(), bundle: bundle)
    }
}
