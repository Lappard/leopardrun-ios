//
//  GameManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation
import SpriteKit

class GameManager : SKScene {
    

        
    private var ressourceManager : RessourceManager = RessourceManager()
    private var soundManager : SoundManager = SoundManager()
    private var inputManager : InputManager = InputManager()
    private var levelManager : LevelManager = LevelManager()
    private var networkManager : NetworkManager = NetworkManager()
    private var scoreManager : ScoreManager = ScoreManager()
    //private var physicsManager : PhysicsManager = PhysicsManager()

    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.9)
    }

    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Helvica")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
    }
}