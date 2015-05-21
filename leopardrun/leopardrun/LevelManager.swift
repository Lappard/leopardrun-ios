//
//  LevelManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit
import UIKit

class LevelManager {
    
    private var hasInit : Bool = false
    
    private var nextPos = CGPoint(x: 0, y: 120)
    
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

    internal init()
    {
        if hasInit {
            fatalError("constructor is private")
        }
        
        hasInit = true
    }
    
    func getLevelPart() -> [Obstacle] {
        
        var obstacles = [Obstacle]()
        
        var top : Bool = false
        
        // create obstacles
        for(var i = 1; i < 6 ; i++) {
            var x = 200 * i
            var y = top ? 500 : 200
            
            top = !top
            
            obstacles.append(Obstacle.block(CGPoint(x: Int(nextPos.x) + x, y: y)))
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