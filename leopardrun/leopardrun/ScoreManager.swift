//
//  ScoreManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class ScoreManager {
     
    class var sharedInstance: ScoreManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ScoreManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ScoreManager()
        }
        return Static.instance!
    }

    init()
    {
        
    }
}