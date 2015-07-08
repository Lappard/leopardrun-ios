import Foundation

protocol NetworkListener {
    func getLevelData(data : JSON) -> Void
}

public enum NewtworkMethod : String {
    case SaveGames = "getSaveGames",
         LevelData = "getLevelData"
}

class NetworkManager : NSObject, SRWebSocketDelegate {
    
    var socketio:SRWebSocket? = nil
    let server = "jonathanwiemers.de" // don't include http://
    let session:NSURLSession?
    
    var delegate : NetworkListener?
    
    var currentMethod : NewtworkMethod = NewtworkMethod.LevelData
    
    var guid : String = ""

    private var completedBlock : ([AnyObject] -> Void)?
    
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
        
    }
    
    func getLevelDataFromServer() -> Void {
        self.socketConnect("")
    }
    
    func socketConnect(token:NSString) {
        socketio = SRWebSocket(URLRequest: NSURLRequest(URL: NSURL(string: "ws://\(server):1337")!))
        socketio!.delegate = self
        socketio!.open()
        
    }
    
    func getLastChallenges(completed: ([AnyObject]) -> Void) -> Void {
        
        var ch = [Challenge]()
        
        ch.append(Challenge(name: "schnellste maus von mexiko"))
        ch.append(Challenge(name: "refactor this"))
        ch.append(Challenge(name: "lorem huso"))
        
        self.completedBlock = completed
        
        //socketio!.send("{\"method\":\"getSaveGames\"}")
    }
    
    func get(method : NewtworkMethod, completed: [AnyObject] -> Void) -> Void {
        self.currentMethod = method
        self.completedBlock = completed
    }
    
    // {"method":"getSaveGames"}
    
    
    @objc func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // All incoming messages ( socket.on() ) are received in this function. Parsed with JSON
        
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)

        var json = JSON(data: data!)
        
        // get guid from server
        if let id = json["guid"].string {
            guid = id
            
            switch(self.currentMethod) {
                case .SaveGames:
                    socketio!.send("{\"method\":\"getSaveGames\"}")
                break
            default:
                socketio!.send("{\"method\":\"getLevelData\"}")
            }
        }
        
        println(json)
        
        // get level stuff form server
        if let process : [String : JSON] = json["process"].dictionary {
            println("daten erhalten" + json.description)
            delegate?.getLevelData(json)
        }
        
        // GameName
        
        if let process : [JSON] = json.array {
            
            println("savegames daten erhalten" + process.description)
            
        }
    }

}