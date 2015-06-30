import SpriteKit

class GameMultiScene: GameBaseScene, SKPhysicsContactDelegate {
    
    var distance = 0;
    
    var player : Player?
    
    var levelManager = LevelManager.sharedInstance
    
    var scoreManager = ScoreManager.sharedInstance
    
    //var wall = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 3, height: 1000))
    var wall = Wall()
    var wall2 = Wall()
    
    var gameOver = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.physicsWorld.contactDelegate = self
        self.view?.backgroundColor = UIColor.blackColor()
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        
        self.hud[scoreManager.scoreLabel] = CGPoint(x: 100, y: 100)
        
        
        wall.position = CGPoint(x: 000, y: 140)
        wall.physicsBody = SKPhysicsBody()
        wall.physicsBody?.affectedByGravity = false
        self.appendGameObject(wall)
        
        wall2.position = CGPoint(x: 000, y: 430)
        wall2.physicsBody = SKPhysicsBody()
        wall2.physicsBody?.affectedByGravity = false
        self.appendGameObject(wall2)
    }
    
    func centerCamera(node: SKNode) {
        if player?.currentState != .Dead {
            self.world!.position = CGPoint(x:(node.position.x * -1) + self.size.width / 2, y:100)
            
        }
        
    }
    
    func tapped(sender:UITapGestureRecognizer) {
        if let p = self.player {
            p.jump()
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == BodyType.player.rawValue && contact.bodyB.contactTestBitMask == BodyType.ground.rawValue
            || contact.bodyB.contactTestBitMask == BodyType.player.rawValue && contact.bodyA.contactTestBitMask == BodyType.ground.rawValue {
                
                self.player?.isOnGround(true)
                self.player?.currentState = PlayerState.Run
                
        } else {
            self.player?.isOnGround(false)
        }
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    }
    
    override func didSimulatePhysics() {
        
        if self.camera != nil && player != nil{
            self.centerCamera(self.player!)
        }
        self.camera!.physicsBody!.velocity.dx = 100
        self.player?.physicsBody?.velocity.dx = 100
        self.wall.physicsBody?.velocity.dx = 100
        self.wall2.physicsBody?.velocity.dx = 100
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        if(!gameOver){
            super.update()
            ScoreManager.sharedInstance.incScore(1)
        }
        
        isObstacleBehindWall()
        
        if (player?.currentState == .Dead || !isPlayerBeforeWall()) && !gameOver {
            
            SoundManager.sharedInstance.stopMusic()
            SoundManager.sharedInstance.playSound(Sounds.Dead.rawValue)
            
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 1.0)
            let scene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene!.scaleMode = .ResizeFill
            scene!.size = skView.bounds.size
            skView.presentScene(scene,transition: transition)
            gameOver = true
            
        }
    }
    
    func reset() -> Void {
        NetworkManager.sharedInstance.getLevelDataFromServer()
        ScoreManager.sharedInstance.reset()
        
        if let player = self.player {
            player.reset()
            
        } else {
            self.player = Player()
            self.appendGameObject(self.player!)
        }
    }
    
    
    func isPlayerBeforeWall() -> Bool {
        var result = false;
        if(player?.position.x > self.wall.position.x){
            result = true
        }
        return result;
    }
    
    func isObstacleBehindWall() -> Void {
        let count = levelManager.obstacles.count;
        
        let rotate = SKAction.rotateToAngle(CGFloat(3.14), duration: NSTimeInterval(1))
        
        for index in 0...count-1 {
            let currentObstacle:Obstacle = levelManager.obstacles[index]
            
            if(wall.position.x > currentObstacle.position.x){
                for fallIndex in 0...50 {
                    currentObstacle.position.y = currentObstacle.position.y-0.1;
                    
                    let rotate = SKAction.rotateToAngle(CGFloat(3.14), duration: NSTimeInterval(1))
                    
                    if (currentObstacle.type == "ground"){
                        currentObstacle.texture = SKTexture(imageNamed: "GroundFired.png")
                    }else {
                        currentObstacle.texture = SKTexture(imageNamed: "BlockFired.png")
                    }
                    
                    currentObstacle.runAction(rotate)
                    
                }
            }
        }
    }
    
}
