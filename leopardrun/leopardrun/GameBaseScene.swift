import Foundation
import SpriteKit

class GameBaseScene : SKScene {
    
    var gameObjects = [SKNode]()
    var camera: SKNode?
    var world: SKNode?
    
    var overlay: SKNode? {
        didSet {
            if overlay != nil {
                self.addChild(overlay!)
            }
        }
        willSet(val) {
            if val == nil {
                //overlay?.removeFromParent()
            }
        }
    }
       
    
    
    func appendGameObject(e : SKNode) -> Void {
        e.zPosition = 2
        self.world?.addChild(e)
    }
    
    func update() -> Void {
        for object : AnyObject in self.world!.children {
            if let obj = object as? Entity {
                obj.update()
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.physicsWorld.gravity = CGVectorMake(0.0, -9.81)

        // Camera setup
        self.world = SKNode()
        self.world?.name = "world"
        addChild(self.world!)
        self.camera = SKNode()
        self.camera?.position = self.world!.position
        self.camera!.physicsBody = SKPhysicsBody()
        self.camera?.physicsBody?.affectedByGravity = false
        
        self.camera?.name = "camera"
        self.world?.addChild(self.camera!)
        
        // UI setup
        self.overlay = SKNode()
        self.overlay?.zPosition = 10
        self.overlay?.name = "overlay"
        addChild(self.overlay!)

    }
    
    override func didMoveToView(view: SKView) {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapped:"))
        view.addGestureRecognizer(tap)
        createLevelPart()
        SoundManager.sharedInstance.playMusic("music")
        ScoreManager.sharedInstance.shouldCounting = true
        
        
    }
        
    func createLevelPart() -> Void {
        var part = LevelManager.sharedInstance.getLevelPart()
        var obstacles = part.0;
        var coins = part.1;
        for o in obstacles {
            self.appendGameObject(o)
        }
        
        for c in coins {
            self.appendGameObject(c)
        }
    }
    
    
    override func willMoveFromView(view: SKView) {
        if view.gestureRecognizers != nil {
            for gesture in view.gestureRecognizers! {
                if let recognizer = gesture as? UITapGestureRecognizer {
                    view.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
    
    

    
    
}
