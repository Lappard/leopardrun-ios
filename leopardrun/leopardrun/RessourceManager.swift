//
//  RessourceManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class RessourceManager {
    struct Static {
        static var instance: RessourceManager?
    }
    
    class var sharedInstance: RessourceManager {
        if !(Static.instance != nil) {
            Static.instance = RessourceManager()
        }
        
        return Static.instance!
    }
}