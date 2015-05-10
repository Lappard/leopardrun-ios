//
//  NetworkManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class NetworkManager {
    struct Static {
        static var instance: NetworkManager?
    }
    
    class var sharedInstance: NetworkManager {
        if !(Static.instance != nil) {
            Static.instance = NetworkManager()
        }
        
        return Static.instance!
    }
}