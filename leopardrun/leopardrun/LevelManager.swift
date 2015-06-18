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
    
    private var nextXpos: CGFloat = 0
    
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
    
    
    
    
    func nextY(gridPos : CGFloat) -> CGFloat {
        switch(true){
        case (gridPos == 0):
            return 100
        case (gridPos == 1):
            return 200
        case (gridPos == 2):
            return 300
        case (gridPos == 3):
            return 400
        default:
            return 0;
        }
    }
    
    
    func nextX(gridPos : CGFloat, obs: Obstacle) -> CGFloat {
        // dont use magic number (153.600006103516)
        let nextPos : CGFloat = gridPos * 153.600006103516
        //println(gridPos.description + " " + nextPos.description + "body width: " + obs.size.width.description)
        return nextPos
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
                    y : CGFloat = CGFloat(object["y"].number!),
                yPos : CGFloat = nextY(y)
                
                switch(object["type"].string!) {
                case "g":
                    let ground = Obstacle.ground(CGPoint(x: 0, y: yPos))
                    ground.position.x = nextX(x, obs: ground)
                    obstacles.append(ground)
                    break
                case "b":
                    let box = Obstacle.block(CGPoint(x: 0, y: yPos))
                    box.position.x = nextX(x, obs: box)
                    obstacles.append(box)
                default:
                    break
                }
            }
        }
        if levelPartData?.count > levelPartIndex {
            levelPartIndex++
        }
        return obstacles
    }
    
    func getLevelData(data : JSON) -> Void {
        
        levelPartData = data["process"]["level"]["levelparts"].array!
        delegate?.ReceivedData()
    }

    
}