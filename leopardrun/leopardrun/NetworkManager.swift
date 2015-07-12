import Foundation

protocol NetworkListener {
    func getLevelData(data : JSON) -> Void
}

public enum NetworkMethod : String {
    case SaveGames = "getSaveGames",
         LevelData = "getLevelData",
         SaveScore = "saveGame"
}

class NetworkManager : NSObject, SRWebSocketDelegate {
    
    var socketio:SRWebSocket? = nil
    let server = "jonathanwiemers.de" // don't include http://
    let session:NSURLSession?
    
    var delegate : NetworkListener?
    
    var currentMethod : NetworkMethod = NetworkMethod.LevelData
    
    var guid : String = ""

    private var completedBlock : ([AnyObject] -> Void)?
    
    var levelData : JSON?
    
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
    
    func get(method : NetworkMethod, completed: [AnyObject] -> Void) -> Void {
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
                socketio!.send("{\"method\":\"createLevel\"}")
            }
        }
        
//        println(json)
        
        // get level stuff from server
        if let process : [String : JSON] = json["process"].dictionary {
            if currentMethod.rawValue == NetworkMethod.LevelData.rawValue {
                println("daten erhalten" + json.description)
                delegate?.getLevelData(json)
                levelData = json
            }
        }
        
        // GameName
        
        if let method : String = json["method"].string {
            
            switch(method) {
                case NetworkMethod.SaveGames.rawValue:
                    println("savegames daten erhalten" + method)
                    var list = [Challenge]()
                
                    
                    if let process = json["process"].dictionary {
                        
                        if let games = process["games"]?.array {
                            
                            var list = [Challenge]()
                            
                            for game in games {
                                

                                //             completedBlock!(list)
                                var c = Challenge(name: game["gameName"].string!)
                                c.owner = game["owner"].string!
                                c.playerScore = game["playerScore"].floatValue
                                c.date = game["date"].intValue
                                
                                if let level = game["level"].dictionary {
                                    if let levelparts = level["levelparts"]?.array {
                                        c.levelData = levelparts
                                    }
                                }
                                
                                if let actions = game["actions"].array {
                                    var newActions = [Int]()
                                    for act in actions {
                                        if let number = act.int {
                                            newActions.append(number)
                                        }
                                    }
                                    
                                    c.actions = newActions
                                }
                                
                                list.append(c)
                            }
                            
                            completedBlock!(list)
                            
                        }
                        
                        
                    }

                    break
            default:
                break
            }
        }
    }
    
    func saveScore(challenge : Challenge) {
        
        let score = Int(challenge.playerScore!)
        var levelData = self.levelData!["process"]["level"]
        
        
        self.currentMethod = NetworkMethod.SaveScore
        
        var jsonString = "{ "
        jsonString += "\"method\":\"saveGame\","
        jsonString += "\"gameData\" : {"
        jsonString += "\"gameName\":\"\(challenge.gameName!)\","
        jsonString += "\"owner\": \"\(challenge.owner!)\","
        jsonString += "\"actions\":\(challenge.actions!),"
        jsonString += " \"date\":\"\(challenge.date!)\","
        jsonString += "\"level\":\(levelData),"
        jsonString += "\"playerScore\": \(score.description)"
        jsonString += "}}"
                
        socketio!.send(jsonString)
       
        
        println(jsonString)
        
       

    }
}