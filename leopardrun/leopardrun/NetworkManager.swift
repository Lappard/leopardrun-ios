//
//  NetworkManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class NetworkManager : NSObject, SRWebSocketDelegate {
    
    var socketio:SRWebSocket? = nil
    let server = "jonathanwiemers.de" // don't include http://
    let session:NSURLSession?
    
    override init()
    {
        let sessionConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.allowsCellularAccess = true
        sessionConfig.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 60
        sessionConfig.HTTPMaximumConnectionsPerHost = 1
        
        self.session = NSURLSession(configuration: sessionConfig)

        super.init()
        
        self.socketConnect("")

    }
    
    func socketConnect(token:NSString) {
        socketio = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "ws://\(server):1337")!))
        socketio!.delegate = self
        socketio!.open()
        
    }
    
    @objc func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // All incoming messages ( socket.on() ) are received in this function. Parsed with JSON
        println("MESSAGE: \(message)")
        
        var jsonError:NSError?
        let messageArray = (message as! NSString).componentsSeparatedByString(":::")
        let data:NSData = messageArray[messageArray.endIndex - 1].dataUsingEncoding(NSUTF8StringEncoding)!
        var json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
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
}