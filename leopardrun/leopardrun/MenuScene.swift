//
//  MenuScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 19.05.15.
//  Copyright (c) 2015 Grandmaster Dumass!. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    let startLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    // 6
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 1
        backgroundColor = SKColor.whiteColor()
        
        // 2
        var message = "Leopard Run!"
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        addChild(label)

        startLabel.text = "Start Game"
        startLabel.fontSize = 40
        startLabel.fontColor = SKColor.blackColor()
        startLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        addChild(startLabel)
        
        
    }
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            showScene(scene, self.view!)
        }
    }
    
    
}
