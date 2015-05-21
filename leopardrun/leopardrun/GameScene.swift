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
    
    
    
    var camera: SKNode?
    var world: SKNode?
    var overlay: SKNode?
    
    
    var blocks:Array<Obstacle> = Array<Obstacle>()
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
        // Camera setup
        self.world = SKNode()
        self.world?.name = "world"
        addChild(self.world!)
        self.camera = SKNode()
        self.camera?.position = self.world!.position
        self.camera?.name = "camera"
        self.world?.addChild(self.camera!)
        
        // UI setup
        self.overlay = SKNode()
        self.overlay?.zPosition = 10
        self.overlay?.name = "overlay"
        addChild(self.overlay!)
        
        self.player = Player()
        
        self.world?.addChild(self.player!)
        
        ground = Obstacle.ground(CGPoint(x: self.size.width/2.0 , y: 120))
        ground2 = Obstacle.ground(CGPoint(x: 2*self.size.width/2.0 , y: 120))
        
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0) + 100, y: 200)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0) + 200, y: 500)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0) + 300, y: 200)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0) + 400, y: 500)))
        
        self.world?.addChild(blocks[0])
        self.world?.addChild(blocks[1])
        self.world?.addChild(blocks[2])
        self.world?.addChild(blocks[3])
        
        self.world?.addChild(ground!)
        self.world?.addChild(ground2!)
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func swipedUp(sender:UITapGestureRecognizer) {
        println("swiped up")
        // player!.physicsBody!.velocity.dy = 1000.0
        player!.physicsBody?.applyForce( CGVector(dx: 0, dy: 3000.0))
    }
    
    
    func centerCamera(node: SKNode) {
//        let cameraPositionInScene: CGPoint = self.convertPoint(node.position, fromNode: node)
        
        self.world!.position = CGPoint(x:node.position.x, y:node.position.y)
    }
    
    
    override func didSimulatePhysics() {
        if self.camera != nil {
            self.centerCamera(self.camera!)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update()
        self.camera?.position.x -= 1.0
//        self.player?.position.x += 1.0
        self.player?.physicsBody?.applyImpulse(CGVector(dx: 1.0, dy: 0.0))
        //        ground!.position.x -= 1.0
//        ground2!.position.x -= 1.0
      
//        for(var i=0; i < 4; i++)
//        {
//            blocks[i].position.x -= 1.0
//        }
        
    }
    
}
