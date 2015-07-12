import SpriteKit

class GameMultiScene: GameScene, SKPhysicsContactDelegate {
    
    var challenge : Challenge? {
        didSet {
            if let data = self.challenge!.levelData {
                LevelManager.sharedInstance.setLevelJson(data)
                 // TODO: MAKE THIS BETTER
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
    
    var myTimer : NSTimer?
    
    var ghost : Player = Player(atlasName: "Ghost")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTimeInterval: NSTimeInterval = (currentTime - startTime) * 1000
        var ms = Int(elapsedTimeInterval)
        
        if currentAction <= ms && currentAction != -1 {
            ghost.jump()
            currentActionIndex++
            println("jump")
        }
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        ghost.zPosition = 3
        
        ghost.reset()
        ghost.position = CGPoint(x: 500, y: 450)
        ghost.isGhostMode = true
        
        player?.reset()
        
        addChild(ghost)
        
        
        var ghostScore = SKLabelNode(fontNamed: "Shojumaru")
        ghostScore.name = "ghostScore"
        if let score = self.challenge?.playerScore?.description {
            ghostScore.text = "Challenge Score \(score)"
            ghostScore.fontSize = CGFloat(16)
            ghostScore.fontColor = UIColor.blueColor()
            setHud(ghostScore, pos: CGPoint(x: 130, y: size.height - 150))
        }

    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
       
    }
}
