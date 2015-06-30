import UIKit
import SpriteKit

class Item: SpriteEntity {
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var kind:String
    
    init() {
        
        self.kind="coin"
        
        super.init(atlasName: "Coin", count: 6)
        
        self.xScale = 1.0
        self.yScale = 1.0
        self.position = CGPoint(x: 200, y: 50)
        
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
        }
        self.physicsBody!.mass = 1
        self.physicsBody!.density = 1
        // for collision
        self.physicsBody!.contactTestBitMask = BodyType.player.rawValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}