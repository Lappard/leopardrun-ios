import SpriteKit
import UIKit

class GameScene: GameBaseScene, SKPhysicsContactDelegate {
    
    var distance = 0;
    
    var player : Player?
    
    var levelManager = LevelManager.sharedInstance
    
    var scoreManager = ScoreManager.sharedInstance
    
    var wall = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 3, height: 1000))
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
        
        self.physicsWorld.contactDelegate = self
        self.view?.backgroundColor = UIColor.blackColor()
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Loading..."
        label.fontSize = 40
        label.fontColor = SKColor.whiteColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        
        self.hud[scoreManager.scoreLabel] = CGPoint(x: 100, y: 100)
        
        
        self.overlay = label
        wall.position = CGPoint(x: 300, y: 100)
        wall.physicsBody = SKPhysicsBody()
        wall.physicsBody?.affectedByGravity = false
        self.appendGameObject(wall)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    func tapped(sender:UITapGestureRecognizer) {
        if let p = self.player {
            p.jump()
        }
    }
    
    
    func centerCamera(node: SKNode) {
        if player?.currentState != .Dead {
            self.world!.position = CGPoint(x:node.position.x * -1, y:100)

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
            self.centerCamera(self.camera!)
        }
        self.camera!.physicsBody!.velocity.dx = 100
        self.player?.physicsBody?.velocity.dx = 100
        self.wall.physicsBody?.velocity.dx = 110
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update()
        
        if player?.currentState == .Dead || !isPlayerBeforeWall(){
            if let scene : GameOverScene = GameOverScene.unarchiveFromFile("GameOverScene") as? GameOverScene {
                SoundManager.sharedInstance.stopMusic()
                SoundManager.sharedInstance.playSound(Sounds.Dead.rawValue)
                
                showScene(scene, self.view!)
            }
        }
        ScoreManager.sharedInstance.incScore()
        
        
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
        println(player?.position.x.description)
        var result = false;
        if(player?.position.x > self.wall.position.x){
            result = true
        }
        return result;
    }
}
