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
    private var ghost : Player?
    
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
    var skyGhost : Sky?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTimeInterval: NSTimeInterval = (currentTime - startTime) * 1000
        var ms = Int(elapsedTimeInterval)
        
        if currentAction <= ms && currentAction != -1 {
            self.ghost!.jump()
            currentActionIndex++
        }
    }
    
    override func didBeginContact(contact: SKPhysicsContact) {
        super.didBeginContact(contact)
    }
    
    override func reset() {
        super.reset()
        self.ghost =  Player(kind: "ghost",atlasName: "Ghost")
//        self.ghost?.reset()
    }
    
    override func didMoveToView(view: SKView) {
//        reset()
        super.didMoveToView(view)
        self.ghost!.zPosition = 3
        self.ghost!.isGhostMode = true
        self.skyGhost = Sky()
        
        if let skyGhost = self.skyGhost{
            skyGhost.physicsBody?.velocity.dx = super.skyspeed
            skyGhost.position = CGPoint(x:self.ghost!.position.x, y: 650)
            addChild(skyGhost)
        }
        
        self.world?.addChild(self.ghost!)
        
        var ghostScore = SKLabelNode(fontNamed: "Shojumaru")
        ghostScore.name = "ghostScore"
        if let score = self.challenge?.playerScore?.description {
            ghostScore.text = "Challenge Score \(score)"
            ghostScore.fontSize = CGFloat(16)
            ghostScore.fontColor = UIColor.blueColor()
            setHud(ghostScore, pos: CGPoint(x: 130, y: size.height - 150))
        }

    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        self.ghost?.physicsBody?.velocity.dx = runnerspeed
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
       
        let p:CGPoint = CGPoint(x: self.ghost!.position.x, y: 750.0)
        self.skyGhost!.position = p
        
    }
}
