//
//  GameScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 30.04.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: GameBaseScene {
    
    var player : Player?
    var ground : Obstacle?
    var ground2 : Obstacle?
    
    var countRunning = 0
    var currentRunState = 1
    
    
    var levelManager = LevelManager()
    
    
    var blocks:Array<Obstacle> = Array<Obstacle>()
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.player = Player()
        
        self.appendGameObject(self.player!)
        
        
        var obstacles = LevelManager.sharedInstance.getLevelPart()
        
        for o in obstacles {
            self.addChild(o)
        }
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func swipedUp(sender:UITapGestureRecognizer) {
        println("swiped up")
        // player!.physicsBody!.velocity.dy = 1000.0
        player!.physicsBody?.applyForce( CGVector(dx: 0, dy: 3000.0))
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update()
        
        
    }
    
}
