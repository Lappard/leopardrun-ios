//
//  GameBaseScene.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation
import SpriteKit

class GameBaseScene : SKScene {
    
    var gameObjects = [SKSpriteNode]()
    var camera: SKNode?
    var world: SKNode?
    var overlay: SKNode? {
        didSet {
            if overlay != nil {
                self.addChild(overlay!)
            }
        }
        willSet(val) {
            if val == nil {
                overlay?.removeFromParent()
            }
        }
    }
    
    func appendGameObject(e : SKSpriteNode) -> Void {
        self.gameObjects.append(e)
        self.addChild(e)
    }
    
    func update() -> Void {
        for object : AnyObject in gameObjects {
            if let obj = object as? Entity {
                obj.update()
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.81)
        // Camera setup
        self.world = SKNode()
        self.world?.name = "world"
        addChild(self.world!)
        self.camera = SKNode()
        self.camera?.position = self.world!.position
        self.camera!.physicsBody = SKPhysicsBody()
        self.camera?.physicsBody?.affectedByGravity = false
        
        self.camera?.name = "camera"
        self.world?.addChild(self.camera!)
        
        // UI setup
        self.overlay = SKNode()
        self.overlay?.zPosition = 10
        self.overlay?.name = "overlay"
        addChild(self.overlay!)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Helvica")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        let swipeUp:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapped:"))
        view.addGestureRecognizer(swipeUp)
        
    }
}
