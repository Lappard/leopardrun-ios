//
//  GameScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 30.04.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SRWebSocketDelegate {
    
    let sprite = SKSpriteNode(imageNamed:"Spaceship")
    var socketio:SRWebSocket? = nil
    let server = "jonathanwiemers.de" // don't include http://
    let session:NSURLSession?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Helvica")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        // self.addChild(myLabel)
        
        create(CGPoint(x: 440, y: 300))
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

        socketConnect("")
    }
    
    
    
    func socketConnect(token:NSString) {
        socketio = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "wss://\(server):1337")!))
        socketio!.delegate = self
        socketio!.open()
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
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
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // All incoming messages ( socket.on() ) are received in this function. Parsed with JSON
        println("MESSAGE: \(message)")
        
        var jsonError:NSError?
        let messageArray = (message as! NSString).componentsSeparatedByString(":::")
        let data:NSData = messageArray[messageArray.endIndex - 1].dataUsingEncoding(NSUTF8StringEncoding)!
        var json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
        
        
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
