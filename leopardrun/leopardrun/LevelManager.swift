//
//  LevelManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class LevelManager {
    struct Static {
        static var instance: LevelManager?
    }
    
    class var sharedInstance: LevelManager {
        if !(Static.instance != nil) {
            Static.instance = LevelManager()
        }
        
        return Static.instance!
    }
}