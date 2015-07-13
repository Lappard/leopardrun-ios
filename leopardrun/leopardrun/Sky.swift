import UIKit
import SpriteKit

class Sky: SpriteEntity {
    
    init() {
        
        super.init(atlasName: "Runner", count: 1)
        self.xScale = 0.3
        self.yScale = 0.3
        
        self.generateBodyByWidthHeigth(self.size.width)
        //self.position = CGPoint(x: 300, y: 600)
        
        if let physics = physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = false
            physics.mass = 0.1
            physics.density = 1
            /*
            planet.physicsBody.categoryBitMask = planetCategory;
            planet.physicsBody.collisionBitMask = planetCategory | edgeCategory;
            planet.physicsBody.contactTestBitMask = 0;
            */
//            physics.contactTestBitMask = BodyType.player.rawValue
            
            if let physic = self.physicsBody {
                physic.categoryBitMask = BodyType.sky.rawValue
                physic.collisionBitMask = 0
                physic.contactTestBitMask = 0
            }
            
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        
    }
    
    
}