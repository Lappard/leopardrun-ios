import Foundation
import SpriteKit

enum BodyType : UInt32 {
    case player         = 2
    case ground         = 4
    case box            = 6
    case item           = 8
    case anotherBody2   = 16
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
        startAnimating()
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
    
    func startAnimating() -> Void {
        self.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.07, resize: false, restore: true)), withKey:"walking")
    }
    
    /**
        this should not be in the sprite entity..
    */
    func updateAnimation(state: PlayerState) -> Void {
        
        if(state == PlayerState.Fly){
            self.atlasName = "LeopardFly"
        } else {
            self.atlasName = "Leopard"
        }
        
        //Jump-State
        if(state == PlayerState.Jump){
            textures.removeAll(keepCapacity: true)
            let textureAtlas = SKTextureAtlas(named: self.atlasName + ".atlas")
            
            //Nur das Springsprite
            let t = textureAtlas.textureNamed(atlasName + "\(6)")
            textures.append(t)
            
        }
        
        //Run-State
        if(state == PlayerState.Run){
            textures.removeAll(keepCapacity: true)
            let textureAtlas = SKTextureAtlas(named: self.atlasName + ".atlas")
            
            //Komplettes Spriteatlas
            for index in 1...10 {
                let t = textureAtlas.textureNamed(atlasName + "\(index)")
                textures.append(t)
            }
            
        }
        
        //Fly-State
        if(state == PlayerState.Fly){
            textures.removeAll(keepCapacity: true)
            let textureAtlas = SKTextureAtlas(named: self.atlasName + ".atlas")
            
            //Komplettes Spriteatlas
            for index in 1...10 {
                let t = textureAtlas.textureNamed(atlasName + "\(index)")
                textures.append(t)
            }
            
        }
        
        
        
        //Stare neue Animation!
        startAnimating()
    }


}