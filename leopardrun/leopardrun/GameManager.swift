//
//  GameManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class GameManager {
    struct Static {
        static var instance: GameManager?
    }
    
    class var sharedInstance: GameManager {
        if !(Static.instance != nil) {
            Static.instance = GameManager()
        }
        
        return Static.instance!
    }
}