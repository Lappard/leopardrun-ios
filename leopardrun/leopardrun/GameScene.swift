import SpriteKit
import UIKit

class GameScene: GameBaseScene, SKPhysicsContactDelegate {
    
    var distance = 0;
    
    var player : Player?
    
    var levelManager = LevelManager.sharedInstance
    
    var scoreManager = ScoreManager.sharedInstance
    
    var wall = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 3, height: 1000))
    
    
    var gameOver = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
        println("BreiteMenu: " + self.size.width.description)
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
        

        wall.position = CGPoint(x: 000, y: 100)
        wall.physicsBody = SKPhysicsBody()
        wall.physicsBody?.affectedByGravity = false
        self.appendGameObject(wall)
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
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(!gameOver){
            super.update()
            ScoreManager.sharedInstance.incScore()
        }
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
}
