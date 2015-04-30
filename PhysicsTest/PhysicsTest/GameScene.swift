//
//  GameScene.swift
//  PhysicsTest
//
//  Created by Felix-André Böttger on 30.04.15.
//  Copyright (c) 2015 lappart. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.9)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let sprite = StarNode.star(touch.locationInNode(self))
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
}
