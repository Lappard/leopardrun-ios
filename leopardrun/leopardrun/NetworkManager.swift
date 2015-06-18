//
//  NetworkManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

protocol NetworkListener {
    func getLevelData(data : JSON) -> Void
}

class NetworkManager : NSObject, SRWebSocketDelegate {
    
    var socketio:SRWebSocket? = nil
    let server = "jonathanwiemers.de" // don't include http://
    let session:NSURLSession?
    
    var delegate : NetworkListener?
    
    var guid : String = ""

    class var sharedInstance: NetworkManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: NetworkManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkManager()
        }
        return Static.instance!
    }
    
    internal override init()
    {
        let sessionConfig:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.allowsCellularAccess = true
        sessionConfig.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        sessionConfig.timeoutIntervalForRequest = 30
        sessionConfig.timeoutIntervalForResource = 60
        sessionConfig.HTTPMaximumConnectionsPerHost = 1
        
        self.session = NSURLSession(configuration: sessionConfig)

        super.init()
        
        getLevelDataFromServer()
    }
    
    func getLevelDataFromServer() -> Void {
        self.socketConnect("")
    }
    
    func socketConnect(token:NSString) {
        socketio = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "ws://\(server):1337")!))
        socketio!.delegate = self
        socketio!.open()
        
    }
    
    @objc func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // All incoming messages ( socket.on() ) are received in this function. Parsed with JSON
        
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)

        var json = JSON(data: data!)
        
        // get guid from server
        if let id = json["guid"].string {
            guid = id
            socketio!.send("{\"method\":\"createLevel\"}")
        }
        
        // get level stuff form server
        if let process : [String : JSON] = json["process"].dictionary {
            
            delegate?.getLevelData(json)
        }
    }

}