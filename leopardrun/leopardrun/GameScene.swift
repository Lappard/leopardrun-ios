//
//  GameScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 30.04.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: GameManager {
    
    var player : Player?
    var ground : Obstacle?
    var ground2 : Obstacle?
    
    var countRunning = 0
    var currentRunState = 1;
    
    var blocks:Array<Obstacle> = Array<Obstacle>()
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.player = Player()
        self.ground = Obstacle()
        self.ground2 = Obstacle()
        
        self.appendGameObject(self.player!)
        
        ground = Obstacle.ground(CGPoint(x: self.size.width/2.0 , y: 120))
        ground2 = Obstacle.ground(CGPoint(x: 2*self.size.width/2.0 , y: 120))
        
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0)+100, y: 200)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0)+200, y: 500)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0)+300, y: 200)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0)+400, y: 500)))
        
        self.addChild(blocks[0])
        self.addChild(blocks[1])
        self.addChild(blocks[2])
        self.addChild(blocks[3])
        
        self.addChild(ground!)
        self.addChild(ground2!)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        println("swiped up")
        player!.physicsBody!.velocity.dy = 1000.0
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update()
        
        ground!.position.x-=1.0
        ground2!.position.x-=1.0
      
        for(var i=0; i<4; i++)
        {
            blocks[i].position.x-=1.0
        }
        
    }
    
}
