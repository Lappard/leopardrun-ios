import SpriteKit
import UIKit

class GameScene: GameBaseScene, SKPhysicsContactDelegate {
    
    var distance = 0;
    var player : Player?
    var ghost : Player?
    var sky : Sky?
    var levelManager = LevelManager.sharedInstance
    var scoreManager = ScoreManager.sharedInstance
    var wall = Wall()
    var wall2 = Wall()
    var gameOver = false;
    var backgroundImage = SKSpriteNode(imageNamed: "Background")
    var backgroundImage2 = SKSpriteNode(imageNamed: "Background")
    
    //Geschwindigkeiten der Bewegungen
    var wallspeed:CGFloat = 150
    var skyspeed:CGFloat = 150
    var runnerspeed:CGFloat = 150
    
    var timer : NSTimer?
    let startTime = NSDate.timeIntervalSinceReferenceDate()

    var playerActions : [Int] = [Int]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
    }
    
    func setHud(node : SKNode, pos : CGPoint) {
        
        if node.parent == nil {
            node.position = pos
            node.zPosition = 1337
            self.addChild(node)
        }
        
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        view.showsPhysics = true
        view.showsFPS = true
        view.showsNodeCount = true
        super.didMoveToView(view)
        self.backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.backgroundImage.zPosition = 0
        self.backgroundImage.size = self.size
        
        self.backgroundImage2.position = CGPoint(x: self.backgroundImage.size.width + (self.backgroundImage.size.width / 2), y: self.size.height / 2)
        self.backgroundImage2.zPosition = 0
        self.backgroundImage2.size = self.size

        
        self.addChild(backgroundImage)
        self.addChild(backgroundImage2)
        self.physicsWorld.contactDelegate = self
        self.view?.backgroundColor = UIColor.blackColor()
        
        setHud(scoreManager.scoreLabel, pos: CGPoint(x: size.width-150, y: size.height - 150))

        wall.position = CGPoint(x: 000, y: 140)
        wall.physicsBody = SKPhysicsBody()
        wall.physicsBody?.affectedByGravity = false
        wall.zPosition = 2
        self.appendGameObject(wall)
        
        wall2.position = CGPoint(x: 000, y: 430)
        wall2.physicsBody = SKPhysicsBody()
        wall2.physicsBody?.affectedByGravity = false
        wall2.zPosition = 2
        self.appendGameObject(wall2)
        
        scoreManager.start()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1.0 / 1000.0), target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)

    }
    
    func updateTime() {
        
    }
    
    func centerCamera(node: SKNode) {
        if player?.currentState != .Dead {
            self.world!.position = CGPoint(x:(node.position.x * -1) + self.size.width / 2, y:100)
        }
    }
    
    func tapped(sender:UITapGestureRecognizer) {
        if let p = self.player {
            p.jump()
            
            var currentTime = NSDate.timeIntervalSinceReferenceDate()
            var elapsedTime: NSTimeInterval = (currentTime - startTime) * 1000
            
            playerActions.append(Int(elapsedTime))
            println("timer interval \(playerActions.last)")
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //Items
        if (contact.bodyA.contactTestBitMask == BodyType.player.rawValue && contact.bodyB.contactTestBitMask == BodyType.item.rawValue){
            var playerNode:SKNode = contact.bodyA.node!;
            var itemNode:SKNode = contact.bodyB.node!;
            
            if(itemNode.userData!.valueForKey("type") as! String == "Coin"){
                self.scoreManager.addToScore(500.0)
            }
            
            if(itemNode.userData!.valueForKey("type") as! String == "Feather"){
                player!.hasFeather = true;
                player!.updateAnimation(PlayerState.Fly)
                SoundManager.sharedInstance.stopMusic()
                SoundManager.sharedInstance.playMusic("fly")
            }
            
            itemNode.removeFromParent()
        }
        
        //Ground
        if (contact.bodyA.contactTestBitMask == BodyType.player.rawValue || contact.bodyB.contactTestBitMask == BodyType.player.rawValue)
        {
            self.player!.isOnGround(true)
        }
        
    }
    
     override func didSimulatePhysics() {
        
        if self.camera != nil && player != nil{
            self.centerCamera(self.player!)
        }
        self.player?.physicsBody?.velocity.dx = runnerspeed
        self.sky?.physicsBody?.velocity.dx = skyspeed
        self.wall.physicsBody?.velocity.dx = wallspeed
        self.wall2.physicsBody?.velocity.dx = wallspeed
        self.ghost?.physicsBody?.velocity.dx = runnerspeed
        
        reorderBackground(self.backgroundImage)
        reorderBackground(self.backgroundImage2)
        self.backgroundImage.position.x -= 2
        self.backgroundImage2.position.x -= 2
    }
    
    func reorderBackground(spritenode: SKSpriteNode){
        if (spritenode.position.x + spritenode.size.width) < 0+(self.size.width / 2) {
            spritenode.position.x = self.size.width + self.size.width / 2
        }
    }
    
     override func update(currentTime: CFTimeInterval) {
        
        let count = levelManager.obstacles.count;
        
        var farestAway:CGFloat = 0;
        for index in 0...count-1 {
            let currentObstacle:Obstacle = levelManager.obstacles[index]
            if (farestAway < (currentObstacle.position.x - player!.position.x)){
                farestAway = currentObstacle.position.x - player!.position.x
            }
        }
        
        if(farestAway < 100 && farestAway > 0){
            createLevelPart()
        }
        
        let p:CGPoint = CGPoint(x: self.player!.position.x, y: 650.0)
        self.sky?.position = p
        
        if(!gameOver){
            super.update()
            scoreManager.update()
        }
        
        isObstacleBehindWall()
        
        if (player?.currentState == .Dead || !isPlayerBeforeWall()) && !gameOver {
            
            SoundManager.sharedInstance.stopMusic()
            SoundManager.sharedInstance.playSound(Sounds.Dead.rawValue)
            
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Up, duration: 1.0)
            let scene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene
            
            var c : Challenge = Challenge(name: getRandomName())
            c.actions = self.playerActions
            c.date = Int(NSDate().timeIntervalSince1970)
            c.playerScore = Float(ScoreManager.sharedInstance.score)
            c.owner = "iOS User"
            scene?.challenge = c
            
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene!.scaleMode = .ResizeFill
            scene!.size = skView.bounds.size
            skView.presentScene(scene,transition: transition)
            gameOver = true
        }
    }
    
    func getRandomName() -> String {
        
        var vs = ["a", "e", "i", "o", "u"]
        var cs = ["b", "d", "f", "g", "k", "l", "m", "n", "p", "r", "s", "t"]

        var maxVs : UInt32 = UInt32(vs.count)
        var maxCs : UInt32 = UInt32(cs.count)
        
        
        var name =  cs[Int(arc4random_uniform(maxCs))]
            name += vs[Int(arc4random_uniform(maxVs))]
            name += cs[Int(arc4random_uniform(maxCs))]
            name += vs[Int(arc4random_uniform(maxVs))]
            name += cs[Int(arc4random_uniform(maxCs))]
        
        return name
    }
    
    func reset() -> Void {
        NetworkManager.sharedInstance.getLevelDataFromServer()
        ScoreManager.sharedInstance.reset()
        levelManager.reset();
        
        if let player = self.player {
            player.reset()
        } else {
            self.ghost =  Player(kind: "ghost",atlasName: "Ghost")
            self.player = Player(kind: "player",atlasName: "Leopard")
            self.appendGameObject(self.player!)
            self.sky = Sky()
            self.appendGameObject(self.sky!)
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
                    currentObstacle.burn();
                    
                }
            }
        }
    
        }
    }
