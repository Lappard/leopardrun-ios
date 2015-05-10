import UIKit
import SpriteKit

class ShipNode: SKSpriteNode {
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func ship(location: CGPoint) -> ShipNode {
        let sprite = ShipNode(imageNamed:"run1.png")
        
        sprite.xScale = 2
        sprite.yScale = 2
        sprite.position = location
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "run1.png"), size: sprite.size)
        
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true;
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
        }
        return sprite
    }
}