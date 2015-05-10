//
//  File.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class SoundManager {
    struct Static {
        static var instance: SoundManager?
    }
    
    class var sharedInstance: SoundManager {
        if !(Static.instance != nil) {
            Static.instance = SoundManager()
        }
        
        return Static.instance!
    }
}