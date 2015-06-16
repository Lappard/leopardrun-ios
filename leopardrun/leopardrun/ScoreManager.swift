//
//  ScoreManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit

class ScoreManager {
    
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    internal var score = 0
    
    class var sharedInstance: ScoreManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ScoreManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ScoreManager()
        }
        return Static.instance!
    }

    init()
    {
        reset()
    }
    
    func reset() -> Void {
        scoreLabel.text = "Score 0"
    }
    
    func incScore() {
        score++
        scoreLabel.text = "Score " + score.description
    }
    
    func addScore(value : Int) {
        scoreLabel.text = "Score " + value.description
    }
}