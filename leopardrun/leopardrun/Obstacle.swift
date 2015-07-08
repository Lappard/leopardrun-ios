import UIKit
import SpriteKit

class Obstacle: Entity {
    var textureBurned: SKTexture?
    var burned = false
    init(imageNamed : String) {
        super.init(texture: SKTexture(imageNamed: imageNamed))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func block(location: CGPoint) -> Obstacle {
        let obstacle = Obstacle(imageNamed:"Block.png")
        
        obstacle.type="block"
        obstacle.textureBurned = SKTexture(imageNamed:"BlockFired.png")
        obstacle.xScale = 2
        obstacle.yScale = 2
        obstacle.position = location
        
        obstacle.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Block.png"), size: obstacle.size)
        if let physics = obstacle.physicsBody {
            physics.allowsRotation = false
            physics.dynamic = false;
            //should not slow down the player
            physics.linearDamping = 0.0
            physics.angularDamping = 0.0
            physics.friction = 0.0
            
        }
        // for collision
        obstacle.physicsBody!.contactTestBitMask = BodyType.box.rawValue
        return obstacle
    }
    
    class func ground(location: CGPoint) -> Obstacle {
        let ground = Obstacle(imageNamed:"Ground.png")
        ground.textureBurned = SKTexture(imageNamed: "GroundFired.png")
        ground.type="ground"
        
        ground.xScale = 0.3
        ground.yScale = 0.3
        
        ground.position = location
        
        ground.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Ground.png"), size: ground.size)
        if let physics = ground.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = false;
            //should not slow down the player
            physics.linearDamping = 0.0
            physics.angularDamping = 0.0
            physics.friction = 0.0
        }
        // for collision
        ground.physicsBody!.contactTestBitMask = BodyType.ground.rawValue
        return ground
    }
    
    
    /**
        burn if not allready burned
    */
    func burn(){
        if(!burned){
            let rotate = SKAction.rotateToAngle(CGFloat(3.14), duration: NSTimeInterval(1))
            self.runAction(rotate)
            self.texture = self.textureBurned
            self.burned = true;
        }
    }
}