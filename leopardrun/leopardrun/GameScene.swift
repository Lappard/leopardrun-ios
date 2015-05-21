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
    
    var distance = 0;
    
    
    var player : Player?
    var ground : Obstacle?
    var ground2 : Obstacle?
    
    var countRunning = 0
    var currentRunState = 1
    
    var levelManager = LevelManager()
    
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
        
        
        createLevelPart()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func swipedUp(sender:UITapGestureRecognizer) {
        player!.physicsBody?.applyForce( CGVector(dx: 0, dy: 3000.0))
    }
    
    
    func centerCamera(node: SKNode) {
        self.world!.position = CGPoint(x:node.position.x, y:node.position.y )
    }
    
    
    func createLevelPart() -> Void {
        var obstacles = LevelManager.sharedInstance.getLevelPart()
        
        for o in obstacles {
            self.world?.addChild(o)
        }
    }
    

    override func didSimulatePhysics() {
        if self.camera != nil {
            self.centerCamera(self.camera!)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update()
        self.camera?.position.x -= 1.0
        self.player?.position.x += 1.0
        distance++
        if (distance > 500){
            distance = 0
            createLevelPart()
        }
//        self.player?.physicsBody?.applyImpulse(CGVector(dx: 1.0, dy: 0.0))

        
    }
    
}
