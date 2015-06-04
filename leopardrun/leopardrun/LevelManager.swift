//
//  LevelManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit
import UIKit

protocol LevelManagerDelegate {
    func ReceivedData() -> Void
}

/**
*  Manage the Level and creates/interpret the level structure
*/
class LevelManager : NetworkListener {
    
    private var hasInit : Bool = false
    
    private var nextPos = CGPoint(x: 0, y: 120)
    
    private var levelPartData : [JSON]?
    
    private var levelPartIndex : Int = 0
    
    var delegate : LevelManagerDelegate?
    
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
        
        NetworkManager.sharedInstance.delegate = self
        
    }
    
    /**
    create the next part of the level
    
    :returns: Array of obstacles which should be rendered
    */
    func getLevelPart() -> [Obstacle] {
        
        var obstacles = [Obstacle]()
        
        var top : Bool = false
        
        if let levelPart = levelPartData {
            var part = levelPart[levelPartIndex]
            
            for object in part.array! {
                let x : CGFloat = CGFloat(object["x"].number!),
                    y : CGFloat = CGFloat(object["y"].number!)
                
                switch(object["type"].string!) {
                case "g":
                    var ground = Obstacle.ground(CGPoint(x: nextPos.x + x , y: y * 100 + 120))
                    var ground2 = Obstacle.ground(CGPoint(x: nextPos.x + x , y: y * 100 + 120))
                    
                    obstacles.append(ground)
                    obstacles.append(ground2)
                    
                    // shift current pos for next interation
                    nextPos.x += ground.size.width
                    break;
                case "b":
                    println(CGPoint(x: nextPos.x + x, y: y * 100 + 120))
                    obstacles.append(Obstacle.block(CGPoint(x: nextPos.x + x, y: y + 300)))
                    break;
                default:
                    break;
                }
            }
        }
        
        if levelPartData?.count > levelPartIndex {
            levelPartIndex++
        }
        
        return obstacles
    }
    
    // Mark: Delegate methods
    
    func getLevelData(data : JSON) -> Void {
        
        levelPartData = data["process"]["level"]["levelparts"].array!
        println("count: " + levelPartData!.count.description)
        delegate?.ReceivedData()
    }

    
}