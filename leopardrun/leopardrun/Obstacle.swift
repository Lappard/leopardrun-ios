import UIKit
import SpriteKit

class Obstacle: Entity {
    
    init(imageNamed : String) {
        super.init(texture: SKTexture(imageNamed: imageNamed))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func block(location: CGPoint) -> Obstacle {
        let obstacle = Obstacle(imageNamed:"Block.png")
        
        obstacle.xScale = 2.5
        obstacle.yScale = 2.5
        obstacle.position = location
        
        obstacle.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Block.png"), size: obstacle.size)
        if let physics = obstacle.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = false
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
        }
        return obstacle
    }
    
    class func ground(location: CGPoint) -> Obstacle {
        let sprite = Obstacle(imageNamed:"Ground.png")
        
        sprite.xScale = 3
        sprite.yScale = 3
        sprite.position = location
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Ground.png"), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = false;
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
        }
        return sprite
    }
}