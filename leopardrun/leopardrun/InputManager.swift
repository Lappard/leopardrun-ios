//
//  InputManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class InputManager {
    struct Static {
        static var instance: InputManager?
    }
    
    class var sharedInstance: InputManager {
        if !(Static.instance != nil) {
            Static.instance = InputManager()
        }
        
        return Static.instance!
    }
}