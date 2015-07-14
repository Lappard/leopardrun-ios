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
    private var ghost : Ghost!
    
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
        
        if (contact.bodyA.contactTestBitMask == BodyType.ghost.rawValue && contact.bodyB.contactTestBitMask == BodyType.item.rawValue){
            var ghostNode:SKNode = contact.bodyA.node!;
            var itemNode:SKNode = contact.bodyB.node!;
            
            if(itemNode.userData!.valueForKey("type") as! String == "Feather"){
                self.ghost!.hasFeather = true;
                self.ghost!.updateAnimation(PlayerState.Fly)
                SoundManager.sharedInstance.stopMusic()
                SoundManager.sharedInstance.playMutedMusicForGhost("fly")
            }
            
        }
        
        //Ground
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ground.rawValue
            || contact.bodyA.categoryBitMask == BodyType.ground.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue)
        {
            self.player!.isOnGround(true)
        }
        
        //Ground
        if (contact.bodyA.categoryBitMask == BodyType.ghost.rawValue && contact.bodyB.categoryBitMask == BodyType.ground.rawValue
            || contact.bodyA.categoryBitMask == BodyType.ground.rawValue && contact.bodyB.categoryBitMask == BodyType.ghost.rawValue)
        {
            self.ghost!.isOnGround(true)
        }
        
    }
    
    override func reset() {
        super.reset()
        self.ghost =  Ghost()
        self.ghost?.reset()
    }
    
    override func didMoveToView(view: SKView) {
//      reset()
        super.didMoveToView(view)
        self.ghost!.zPosition = 3
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
       
        if(self.ghost!.hasFeather){
            skyGhostHeight = 650.0
        } else {
            skyGhostHeight = 900.0
        }
        
        let p:CGPoint = CGPoint(x: self.ghost!.position.x, y: skyGhostHeight)
        self.skyGhost!.position = p
        
    }
}
