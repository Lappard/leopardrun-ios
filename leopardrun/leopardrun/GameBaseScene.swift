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
    
    var gameObjects = [Entity]()
    
    func appendGameObject(e : Entity) -> Void {
        self.gameObjects.append(e)
        self.addChild(e)
    }
    
    func update() -> Void {
        for objects in gameObjects {
            objects.update()
        }
    }
    
    override init() {
        super.init()
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.81)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Helvica")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        
        
        let swipeUp:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("swipedUp:"))
        view.addGestureRecognizer(swipeUp)
        
    }
}