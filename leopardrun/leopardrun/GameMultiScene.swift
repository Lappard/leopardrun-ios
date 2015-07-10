import SpriteKit

class GameMultiScene: GameScene, SKPhysicsContactDelegate {
    
    var challenge : Challenge? {
        didSet {
            if let data = self.challenge!.levelData {
                LevelManager.sharedInstance.setLevelJson(data)
                LevelManager.sharedInstance.delegate = nil
            }
        }
    }

    private var currentActionIndex : Int = 0
    
    var currentAction : Int {
        get {
            if let  c = self.challenge,
                    actions = c.actions
            {
                if actions.count > currentActionIndex {
                    return actions[currentActionIndex]
                } else {
                    return -1
                }
            }
            return -1
        }
    }
    
    var ghost : Player = Player(atlasName: "Ghost")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        addChild(ghost)
        
        println("didmovetoview")
    }
    
    var msSum = 0
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        var x : Int = Int(currentTime / 10000.0)
        msSum += x


        println(msSum.description + " >= " + currentAction.description)
        if currentAction > -1 && msSum >= currentAction / 100 {
            currentActionIndex++
            ghost.jump()

        }
        //
    }
}
