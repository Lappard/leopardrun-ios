import SpriteKit
import UIKit

protocol LevelManagerDelegate {
    func ReceivedData() -> Void
}

/**
*  Manage the Level and creates/interpret the level structure
*/
class LevelManager : NetworkListener {
    
    private var hasInit : Bool = false
    
    private var nextPos = CGPoint(x: 0, y: 120)
    
    private var levelPartData : [JSON]?
    
    private var levelPartIndex : Int = 0
    
    private var ground = Obstacle.ground(CGPoint(x: 0, y: 0))
    
    private var lastX : CGFloat = 0
    
    private var levelPartSize : Int = 0
    
    var obstacles = [Obstacle]()
    var items = [Item]()
    
    var delegate : LevelManagerDelegate?
    
    /// Singleton Object
    class var sharedInstance: LevelManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LevelManager? = nil
            
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LevelManager()
        }
        
        return Static.instance!
    }
    
    /**
    private init function (singleton)
    
    :returns: Obstacle Object
    */
    internal init()
    {
        if hasInit {
            fatalError("constructor is private")
        }
        
        hasInit = true
        
        NetworkManager.sharedInstance.delegate = self
        
    }
    
    
    func reset(){
        self.levelPartSize = 0;
        self.levelPartIndex = 0;
        self.lastX = 0;
        self.obstacles = [Obstacle]()
        self.items = [Item]()
    }
    
    
    
    /**
    desc
    
    :param: gridPos
    
    :returns:
    */
    func nextY(gridPos : CGFloat) -> CGFloat {
        switch(true){
        case (gridPos == 0):
            return 100
        case (gridPos == 1):
            return 100 + ground.size.height
        case (gridPos == 2):
            return 100 + ground.size.height * 2
        case (gridPos == 3):
            return 100 + ground.size.height * 3
        default:
            return 0;
        }
    }
    
    /**
    desc
    
    :param: gridPos
    :param: obs
    
    :returns:
    */
    func nextX(gridPos : CGFloat, obs: Obstacle) -> CGFloat {
        //we have 28 grounds in every level part. shound not be used as number here. calculate earlier!
        let nextPos : CGFloat = ((CGFloat(levelPartIndex) * CGFloat(28)) + gridPos) * ground.size.width
        return nextPos
    }
    
    func nextXForItems(gridPos : CGFloat, obs: Item) -> CGFloat {
        //we have 28 grounds in every level part. shound not be used as number here. calculate earlier!
        let nextPos : CGFloat = ((CGFloat(levelPartIndex) * CGFloat(28)) + gridPos) * ground.size.width
        return nextPos
    }
    
    /**
    create the next part of the level
    
    :returns: Array of obstacles which should be rendered
    */
    func getLevelPart() -> ([Obstacle],[Item]) {
        var obstacles = [Obstacle]()
        var coins = [Item]()
        var top : Bool = false
        if let levelPart = levelPartData {
            var part = levelPart[levelPartIndex]
            self.levelPartSize = part.array!.count
            
            for object in part.array! {
                let x : CGFloat = CGFloat(object["x"].number!),
                y : CGFloat = CGFloat(object["y"].number!),
                yPos : CGFloat = nextY(y)
                
                switch(object["type"].string!) {
                    case "g":
                        let ground = Obstacle.ground(CGPoint(x: 0, y: yPos))
                        ground.position.x = nextX(x, obs: ground)
                        obstacles.append(ground)
                        break
                    case "b":
                        let box = Obstacle.block(CGPoint(x: 0, y: yPos))
                        box.position.x = nextX(x, obs: box)
                        obstacles.append(box)
                        break
                    /*case "c":
                        let coin = Item(kind: "Coin", spriteCount: 6, x:0, y:0)
                        coin.position.x = nextXForItems(x, obs: coin)
                        items.append(coin)
                        break
                    case "f":
                        let feather = Item(kind: "Feather", spriteCount: 10, x:0, y:0)
                        feather.position.x = nextXForItems(x, obs: feather)
                        items.append(feather)
                        break*/
                    default:
                        break
                }
            }
        }
        
        
        if levelPartData?.count > levelPartIndex {
            levelPartIndex++
        }

        if let last = obstacles.last?.position.x {
            self.lastX = last
        }
        self.obstacles.extend(obstacles)
        self.items.extend(items)
        return (obstacles, items)
    }
    
    func setLevelJson(json : [JSON]) {
        levelPartData = json
        NetworkManager.sharedInstance.levelData = json.first
    }
    
    func getLevelData(data : JSON) -> Void {
        if let data = data["process"]["level"]["levelparts"].array {
            levelPartData = data
        }
        
        delegate?.ReceivedData()
    }
    
    
}