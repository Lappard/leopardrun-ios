import Foundation
import SpriteKit

enum BodyType : UInt32 {
    case player         = 1
    case box            = 2
    case ground         = 4
    case item           = 8
    case ghost          = 16
    case sky            = 32
}

class Entity : SKSpriteNode {
    
    var type:String
    
    init(texture: SKTexture!) {
        self.type = ""
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        self.type = ""
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
//        fatalError("update method have to override")
    }

    func onCollision(){
        
    }
    
    
    
}


class SpriteEntity : Entity {
    
    var textures : [SKTexture] = [SKTexture]()
    var imageCount : UInt = 0
    var atlasName = "";
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(atlasName : String, count : UInt) {

        self.atlasName = atlasName
        
        let textureAtlas = SKTextureAtlas(named: atlasName + ".atlas")
        imageCount = count
        
        for index in 1...imageCount {
            let t = textureAtlas.textureNamed(atlasName + "\(index)")
            textures.append(t)
        }
        super.init(texture: textures.first)
        
        generateBodyByTexture(textures.first!)
        
    }
    
    init(texturename : String){
        var tex = SKTexture(imageNamed: texturename);
        super.init(texture: tex)
        generateBodyByTexture(tex)
        
    }
    
    /**
        generate PhysicsBody as rect witch is better for collisions then genrating it by texture
    */
    func generateBodyByTexture(tex: SKTexture){
        self.physicsBody = SKPhysicsBody(polygonFromPath: CGPathCreateWithRoundedRect(CGRectMake(-tex.size().width / 2, -tex.size().height / 2, tex.size().width, tex.size().height), 10, 10, nil))
        self.texture = tex
    }
    
    /**
    --> testing <--
    generate PhysicsBody as rect witch is better for collisions then genrating it by texture
    */
    func generateBodyByWidthHeigth(widthHeight: CGFloat){
        
            self.physicsBody = SKPhysicsBody(polygonFromPath: CGPathCreateWithRoundedRect(CGRectMake(-widthHeight / 2, -widthHeight / 2, widthHeight, widthHeight), 10, 10, nil))
        
    }
   
    
    /**
        this should not be in the sprite entity..
    */

}