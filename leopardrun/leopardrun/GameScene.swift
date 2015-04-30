//
//  GameScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 30.04.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let sprite = SKSpriteNode(imageNamed:"Spaceship")
    var socketio:SRWebSocket? = nil
    let server = "example.com" // don't include http://
    let session:NSURLSession? = nil
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Helvica")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        // self.addChild(myLabel)
        
        create(CGPoint(x: 440, y: 300))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            

            sprite.position = location
        }
        
        var dict = [
            "position": [
                "x" : position.x,
                "y" : position.y
            ]
        ]
        
        /*
        * What you would see in a traditional
        * Socket.IO app.js file.
        *
        * socket.emit("test", {
        *   Button: "Pressed"
        * });
        *
        *
        */
        
        var jsonSendError:NSError?
        var jsonSend = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(0), error: &jsonSendError)
        var jsonString = NSString(data: jsonSend!, encoding: NSUTF8StringEncoding)
        println("JSON SENT \(jsonString)")
        
        let str:NSString = "5:::\(jsonString)"
        socketio?.send(str)
        
    }
   
    func create(point : CGPoint) -> Void {
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = point
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}
