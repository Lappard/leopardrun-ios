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
    
    var levelManager = LevelManager()
    
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        self.camera?.position.x -= 2.0
        self.player?.position.x += 2.0
        distance += 2
        println(distance)
        if (distance > 700){
            distance = 0
            createLevelPart()
        }
//        self.player?.physicsBody?.applyImpulse(CGVector(dx: 1.0, dy: 0.0))

        
    }
    
}
