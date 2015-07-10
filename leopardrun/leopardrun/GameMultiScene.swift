import SpriteKit

class GameMultiScene: GameScene, SKPhysicsContactDelegate {
    
    var challenge : Challenge? {
        didSet {
            if let data = self.challenge!.levelData {
                levelManager.setLevelJson(data)
                // TODO: MAKE THIS BETTER
                levelManager.delegate = nil
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
        reset()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        world?.addChild(ghost)
    }
    
    var msSum = 0
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        var x : Int = Int(currentTime / 10000.0)
        msSum += x


//        println(msSum.description + " >= " + currentAction.description)
        if currentAction > -1 && msSum >= currentAction / 100 {
            currentActionIndex++
            ghost.jump()

        }
        //
    }
}
