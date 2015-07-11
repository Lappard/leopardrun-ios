import UIKit
import SpriteKit

class Item: SpriteEntity {
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var kind:String
    
    init(var kind:String, var spriteCount:UInt, x:Int, y:Int) {
        
        self.kind=kind
        
        super.init(atlasName: kind, count: spriteCount)
        
        self.xScale = 1.0
        self.yScale = 1.0
        self.position = CGPoint(x: x, y: y)
        
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
            physics.contactTestBitMask = BodyType.item.rawValue
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