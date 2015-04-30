import UIKit
import SpriteKit

class StarNode: SKSpriteNode {
    class func star(location: CGPoint) -> StarNode {
        let sprite = StarNode(imageNamed:"star.png")
        
        sprite.xScale = 0.05
        sprite.yScale = 0.05
        sprite.position = location
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "star.png"), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true;
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
        }
        return sprite
    }
}