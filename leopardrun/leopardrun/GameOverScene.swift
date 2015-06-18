//
//  GameOverScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 16.06.15.
//  Copyright (c) 2015 Grandmaster Dumass!. All rights reserved.
//

import SpriteKit

class GameOverScene : SKScene {
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 1
        backgroundColor = SKColor.whiteColor()
        
        // 2
        var message = "Game Over!"
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        addChild(label)
        
        var scoreMessage = "Your Score is " + ScoreManager.sharedInstance.score.description
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = scoreMessage
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        
        addChild(scoreLabel)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let scene = MenuScene.unarchiveFromFile("MenuScene") as? MenuScene {
            showScene(scene, self.view!)
        }
    }
    
}