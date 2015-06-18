//
//  GameScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 30.04.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: GameBaseScene, SKPhysicsContactDelegate, LevelManagerDelegate {
    
    var distance = 0;
    
    var player : Player?
    
    var levelManager = LevelManager.sharedInstance
    
    var scoreManager = ScoreManager.sharedInstance
    
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.physicsWorld.contactDelegate = self
        
        levelManager.delegate = self
        
        self.view?.backgroundColor = UIColor.blackColor()
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Loading..."
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        
        self.hud[scoreManager.scoreLabel] = CGPoint(x: 100, y: 100)
        
        self.overlay = label
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func tapped(sender:UITapGestureRecognizer) {
        if let p = self.player {
            p.jump()
        }
    }
    
    
    func centerCamera(node: SKNode) {
        if player?.currentState != .Dead {
            self.world!.position = CGPoint(x:node.position.x * -1, y:100)
            //player?.currentState = .Dead
        }

    }
    
    func createLevelPart() -> Void {
        var obstacles = LevelManager.sharedInstance.getLevelPart()
        
        println("o count" + obstacles.count.description)
        
        for o in obstacles {
            self.world?.addChild(o)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == BodyType.player.rawValue && contact.bodyB.contactTestBitMask == BodyType.ground.rawValue
            || contact.bodyB.contactTestBitMask == BodyType.player.rawValue && contact.bodyA.contactTestBitMask == BodyType.ground.rawValue {
                self.player?.isOnGround(true)
                
        }
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    }

    override func didSimulatePhysics() {
        if self.camera != nil && player != nil{
            self.centerCamera(self.camera!)
        }
        self.camera!.physicsBody!.velocity.dx = 100
        self.player?.physicsBody?.velocity.dx = 100
    
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update()
        
        if player?.currentState != .Dead {
            ScoreManager.sharedInstance.incScore()
        } else {
            if let scene : GameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene {
                showScene(scene, self.view!)
                
                SoundManager.sharedInstance.playSound(Sounds.Dead.rawValue)
                SoundManager.sharedInstance.stopMusic()
                
            }
        }
    }
    
    func Reset() -> Void {
        NetworkManager.sharedInstance.getLevelDataFromServer()
        ScoreManager.sharedInstance.reset()
        
        if let player = self.player {
            player.reset()
            
        } else {
            self.player = Player()
            self.appendGameObject(self.player!)
        }
    }
    
    func ReceivedData() -> Void {
        self.overlay = nil
        createLevelPart()

        self.scoreManager.shouldCounting = true
        
        SoundManager.sharedInstance.playMusic("theme")
        
        
    }
}
