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
        
        //Items
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.item.rawValue){
            var playerNode:SKNode = contact.bodyA.node!
            var itemNode:SKNode = contact.bodyB.node!
            
            if(itemNode.userData!.valueForKey("type") as! String == "Coin"){
                self.scoreManager.addToScore(500.0)
                itemNode.removeFromParent()
            }
            
            if(itemNode.userData!.valueForKey("type") as! String == "Feather"){
                player!.hasFeather = true
                player!.velocity = 50
                player!.updateAnimation(PlayerState.Fly)
                SoundManager.sharedInstance.stopMusic()
                SoundManager.sharedInstance.playMusic("fly")
            }
            
            if(isPlayerLeading()){
                
            } else {
                itemNode.removeFromParent()
            }
            
        }
        
        if (contact.bodyA.categoryBitMask == BodyType.item.rawValue && contact.bodyB.categoryBitMask == BodyType.ghost.rawValue){
            var itemNode:SKNode = contact.bodyA.node!
            var ghostNode:SKNode = contact.bodyB.node!
            
            if(itemNode.userData!.valueForKey("type") as! String == "Feather"){
                self.ghost!.hasFeather = true
                self.ghost!.updateAnimation(PlayerState.Fly)
                self.ghost!.velocity = 50
                
                SoundManager.sharedInstance.playMutedMusicForGhost("fly")
                
                if(isPlayerLeading()){
                    itemNode.removeFromParent()
                }
                
            }
            
        }
        
        //Ground
        if (contact.bodyA.categoryBitMask == BodyType.player.rawValue && contact.bodyB.categoryBitMask == BodyType.ground.rawValue
            || contact.bodyA.categoryBitMask == BodyType.ground.rawValue && contact.bodyB.categoryBitMask == BodyType.player.rawValue)
        {
            self.player!.isCharacterOnGround(true)
        }
        
        //Ground
        if (contact.bodyA.categoryBitMask == BodyType.ghost.rawValue && contact.bodyB.categoryBitMask == BodyType.ground.rawValue
            || contact.bodyA.categoryBitMask == BodyType.ground.rawValue && contact.bodyB.categoryBitMask == BodyType.ghost.rawValue)
        {
            self.ghost!.isCharacterOnGround(true)
        }
        
    }
    
    override func reset() {
        super.reset()
        self.ghost =  Ghost()
        self.ghost?.reset()
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.ghost!.zPosition = 3
        self.skyGhost = Sky()
        
        if let skyGhost = self.skyGhost{
            skyGhost.physicsBody?.velocity.dx = super.skyspeed
            skyGhost.position = CGPoint(x:self.ghost!.position.x, y: 650)
        }
        
        self.world?.addChild(self.ghost!)
        self.world?.addChild(self.skyGhost!)
        
        var ghostScore = SKLabelNode(fontNamed: "Shojumaru")
        ghostScore.name = "ghostScore"
        if let score = self.challenge?.playerScore?.description {
            ghostScore.text = "Challenge Score \(score)"
            ghostScore.fontSize = CGFloat(16)
            ghostScore.fontColor = UIColor.blueColor()
            setHud(ghostScore, pos: CGPoint(x: 130, y: size.height - 150))
        }

    }
    
    override func loadGameOver() {
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 1.0)
        let scene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene
        
        var c : Challenge = Challenge(name: getRandomName())
        c.actions = self.playerActions
        c.date = Int(NSDate().timeIntervalSince1970)
        c.playerScore = Float(ScoreManager.sharedInstance.score)
        c.owner = "iOS User"
        c.levelData = self.challenge?.levelData
        scene?.challenge = c
        
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .ResizeFill
        scene!.size = skView.bounds.size
        skView.presentScene(scene,transition: transition)
        gameOver = true

    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        self.ghost?.physicsBody?.velocity.dx = runnerspeed
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        
        let p:CGPoint = CGPoint(x: self.ghost!.position.x, y: skyGhostHeight)
        self.skyGhost!.position = p
        
        if(self.ghost!.hasFeather){
            skyGhostHeight = 650
        } else {
            skyGhostHeight = 900
        }
        
        
    }
    
    func isPlayerLeading() -> Bool{
        
        if(player!.position.x > ghost!.position.x){
            return true;
        } else {
            return false
        }
        
    }
    
}
