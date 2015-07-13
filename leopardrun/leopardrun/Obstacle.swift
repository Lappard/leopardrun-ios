import UIKit
import SpriteKit

class Obstacle: SpriteEntity {
    var textureBurned: SKTexture?
    var burned = false
    init(imageNamed : String) {
        super.init(texturename: imageNamed)
        
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
        
        if let physics = obstacle.physicsBody {
            physics.allowsRotation = false
            physics.dynamic = false;
            //should not slow down the player
            physics.linearDamping = 0.0
            physics.angularDamping = 0.0
            physics.friction = 0.0
            physics.categoryBitMask = BodyType.box.rawValue
            physics.contactTestBitMask = BodyType.player.rawValue
            physics.collisionBitMask = BodyType.player.rawValue

        }
        return obstacle
    }
    
    class func ground(location: CGPoint) -> Obstacle {
        let ground = Obstacle(imageNamed:"Ground.png")
        ground.textureBurned = SKTexture(imageNamed: "GroundFired.png")
        ground.type="ground"
        
        ground.xScale = 0.3
        ground.yScale = 0.3
        
//        ground.size = CGSize(width: 200, height: 200)
        
        ground.position = location
        
        if let physics = ground.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = false;
            //should not slow down the player
            physics.linearDamping = 0.0
            physics.angularDamping = 0.0
            physics.friction = 0.0
            /*
            planet.physicsBody.categoryBitMask = planetCategory;
            planet.physicsBody.collisionBitMask = planetCategory | edgeCategory;
            planet.physicsBody.contactTestBitMask = 0;
            */
            
            physics.categoryBitMask = BodyType.ground.rawValue
            physics.collisionBitMask = BodyType.player.rawValue
            physics.contactTestBitMask = BodyType.player.rawValue

        }
        return ground
    }
    
    
    /**
        burn if not allready burned
    */
    func burn(){
        if(!burned){
            let rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: NSTimeInterval(1))
            let rotateInfinit = SKAction.repeatActionForever(rotate)
            self.runAction(rotateInfinit)
            self.texture = self.textureBurned
            self.burned = true;
        }
    }
}