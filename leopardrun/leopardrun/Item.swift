import UIKit
import SpriteKit

class Item: SpriteEntity {
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var kind:String
    
    init(var kind:String, var spriteCount:UInt, x:CGFloat, y:CGFloat) {
        
        self.kind=kind
        
        super.init(atlasName: kind, count: spriteCount)
        
        self.xScale = 1.0
        self.yScale = 1.0
        self.position = CGPoint(x: x, y: y)
        
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
            physics.categoryBitMask = BodyType.item.rawValue
            physics.contactTestBitMask = BodyType.player.rawValue | BodyType.ghost.rawValue | BodyType.ground.rawValue | BodyType.box.rawValue
            physics.collisionBitMask = BodyType.ground.rawValue | BodyType.box.rawValue

        }
        self.physicsBody!.mass = 1
        self.physicsBody!.density = 1
        
        self.userData = NSMutableDictionary()
        self.userData!.setValue(kind, forKey: "type")

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}