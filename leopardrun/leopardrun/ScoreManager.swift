//
//  ScoreManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class ScoreManager {
    struct Static {
        static var instance: ScoreManager?
    }
    
    class var sharedInstance: ScoreManager {
        if !(Static.instance != nil) {
            Static.instance = ScoreManager()
        }
        
        return Static.instance!
    }
}