import SpriteKit

class GameMultiScene: GameScene, SKPhysicsContactDelegate {
    
    var skyGhostHeight:CGFloat = 900.0
    
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
    
    var skyGhost : Sky?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
        
        self.ghost!.zPosition = 3
        
        if let p = self.player {
            self.ghost!.position = CGPoint(x: p.position.x+290, y: p.position.y)
            self.ghost!.isGhostMode = true
        }
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
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
    }
    
    override
    func didBeginContact(contact: SKPhysicsContact) {
        
        super.didBeginContact(contact)
        
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        player?.reset()
        self.ghost!.zPosition = 3
        self.ghost!.isGhostMode = true
        self.skyGhost = Sky()
        
        if let skyGhost = self.skyGhost{
            
            skyGhost.physicsBody?.velocity.dx = super.skyspeed
            skyGhost.position = CGPoint(x:self.ghost!.position.x, y: 650)
            
            addChild(skyGhost)
            
        }
        
        addChild(self.ghost!)
        
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
       
        if(self.ghost!.hasFeather){
            skyGhostHeight = 650.0
        } else {
            skyGhostHeight = 900.0
        }
        
        let p:CGPoint = CGPoint(x: self.ghost!.position.x, y: skyGhostHeight)
        self.skyGhost!.position = p
        
        println(ghost!.physicsBody?.velocity.dx)
        
    }
}
