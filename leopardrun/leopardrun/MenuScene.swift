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

        startLabel.text = "Single Player"
        startLabel.fontSize = 40
        startLabel.name = "single"
        startLabel.fontColor = SKColor.blackColor()
        startLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        addChild(startLabel)
        
        var multiLabel = SKLabelNode(fontNamed: "Chalkduster")
        multiLabel.text = "Multi Player"
        multiLabel.name = "multi"
        multiLabel.fontSize = 40
        multiLabel.fontColor = SKColor.blackColor()
        multiLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 120)
        addChild(multiLabel)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            
            if touchedNode.name == "multi" {
                if let scene = GameMultiScene.unarchiveFromFile("GameMultiScene") as? GameMultiScene {
                    showScene(scene, self.view!)
                }
            }
            if touchedNode.name == "single" {
                if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                    scene.Reset()
                    showScene(scene, self.view!)
                }
            }
            
        }
        

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

    }
    
    
}
