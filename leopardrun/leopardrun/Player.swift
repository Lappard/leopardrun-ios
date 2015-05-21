import UIKit
import SpriteKit

class Player: SpriteEntity {
    
    var countRunning = 0
    var currentRunState = 1
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var isOnGround = false
    
    init() {
        
        super.init(atlasName: "Runner", count: 6)
        
        
        self.xScale = 2
        self.yScale = 2
        self.position = CGPoint(x: 200, y: 600)
        
        
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
        }
        // for collision
        self.physicsBody!.contactTestBitMask = BodyType.player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func update() {
    
    }
    
    func isOnGround(onGround: Bool ) -> Void {
        self.isOnGround = onGround;
    }
    
    func jump() -> Void {
        if self.isOnGround {
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: 50.0))
            isOnGround(false)
        }
    }
    
}