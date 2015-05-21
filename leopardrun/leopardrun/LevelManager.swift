//
//  LevelManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit
import UIKit


/**
*  Manage the Level and creates/interpret the level structure
*/
class LevelManager {
    
    private var hasInit : Bool = false
    
    private var nextPos = CGPoint(x: 0, y: 120)
    
    /// Singleton Object
    class var sharedInstance: LevelManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LevelManager? = nil

        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LevelManager()
        }
        return Static.instance!
    }

    /**
    private init function (singleton)
    
    :returns: Obstacle Object
    */
    internal init()
    {
        if hasInit {
            fatalError("constructor is private")
        }
        
        hasInit = true
    }
    
    /**
    create the next part of the level
    
    :returns: Array of obstacles which should be rendered
    */
    func getLevelPart() -> [Obstacle] {
        
        var obstacles = [Obstacle]()
        
        var top : Bool = false
        
        // create obstacles
        for i in 0...12 {
            var x = 200 * i
            var y = top ? 500 : 200
            obstacles.append(Obstacle.block(CGPoint(x: Int(nextPos.x) + x, y: y)))
            
            top = !top
        }
        
        // create ground
        for index in 0...1 {
            var ground = Obstacle.ground(CGPoint(x: nextPos.x , y: 120))
            var ground2 = Obstacle.ground(CGPoint(x: nextPos.x , y: 120))
            
            obstacles.append(ground)
            obstacles.append(ground2)

            // shift current pos for next interation
            nextPos.x += ground.size.width
        }

        return obstacles
    }
    
    
}