//
//  GameScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 30.04.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SRWebSocketDelegate {
    
    var sprite = ShipNode()
    var ground = Obstacle()
    var ground2 = Obstacle()
    
    var countRunning = 0
    var currentRunState = 1;
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    
    var blocks:Array<Obstacle> = Array<Obstacle>()
    
    var socketio:SRWebSocket? = nil
    let server = "jonathanwiemers.de" // don't include http://
    let session:NSURLSession?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Helvica")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.9)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        sprite = ShipNode.ship(CGPoint(x: 200, y: 600))
        ground = Obstacle.ground(CGPoint(x: self.size.width/2.0 , y: 120))
        ground2 = Obstacle.ground(CGPoint(x: 2*self.size.width/2.0 , y: 120))
        
        for (var i:Int = 1; i < 7; i++)
        {
            var s:String = i.description
            var current:SKTexture = SKTexture(imageNamed: "run"+s)
            runnerTextures.append(current)
        }
        
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0)+100, y: 200)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0)+200, y: 500)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0)+300, y: 200)))
        blocks.append(Obstacle.block(CGPoint(x: (self.size.width/2.0)+400, y: 500)))
        
        self.addChild(blocks[0])
        self.addChild(blocks[1])
        self.addChild(blocks[2])
        self.addChild(blocks[3])
        
        self.addChild(ground)
        self.addChild(ground2)
        
        self.addChild(sprite)
        
    }
    /*
    override init(size: CGSize) {
        self.init()
        super.init(size: size)
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        
        let sessionConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.allowsCellularAccess = true
        sessionConfig.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 60
        sessionConfig.HTTPMaximumConnectionsPerHost = 1
        
        self.session = NSURLSession(configuration: sessionConfig)
        
        super.init(coder: aDecoder)

        self.sprite = ShipNode()
        self.ground = Obstacle()
        socketConnect("")
    }
    
    func socketConnect(token:NSString) {
        socketio = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "ws://\(server):1337")!))
        socketio!.delegate = self
        socketio!.open()
        
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        println("swiped up")
        sprite.physicsBody!.velocity.dy = 1000.0
    }
    
    /*override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            sprite.position = location
        }
        
        var dict = [
            "position": [
                "x" : sprite.position.x,
                "y" : sprite.position.y
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
        
        // println("JSON SENT \(jsonString)")
        
        let str : NSString = jsonString!
        socketio!.send(str)
    }*/
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // All incoming messages ( socket.on() ) are received in this function. Parsed with JSON
        println("MESSAGE: \(message)")
        
        var jsonError:NSError?
        let messageArray = (message as! NSString).componentsSeparatedByString(":::")
        let data:NSData = messageArray[messageArray.endIndex - 1].dataUsingEncoding(NSUTF8StringEncoding)!
        var json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
        
        
    }
    
    func animatePlayer()
    {
        
        if currentRunState==5
        {
            currentRunState=0
        } else {
            currentRunState++
        }
        
        sprite.texture = runnerTextures[currentRunState]
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        ground.position.x-=1.0
        ground2.position.x-=1.0
      
        for(var i=0; i<4; i++)
        {
            blocks[i].position.x-=1.0
        }
        
        if countRunning==2{
            animatePlayer()
            countRunning = 0
        }
        else {
            countRunning++
        }
    }
    
}
