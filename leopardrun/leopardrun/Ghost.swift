import UIKit
import SpriteKit


class Ghost: Player {
    
    init() {
        
        super.init(kind: "ghost", atlasName : "Ghost")
        
        self.xScale = 0.3
        self.yScale = 0.3
        self.position = CGPoint(x: 200, y: 600)
        self.generateBodyByWidthHeigth(self.size.width)
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
            physics.mass = 0.1
            physics.density = 1
            
            physics.usesPreciseCollisionDetection = true
            physics.categoryBitMask = BodyType.ghost.rawValue
            physics.collisionBitMask = BodyType.box.rawValue | BodyType.ground.rawValue | BodyType.sky.rawValue
            physics.contactTestBitMask = BodyType.box.rawValue | BodyType.ground.rawValue | BodyType.item.rawValue | BodyType.sky.rawValue
        }
        
        self.isCharacterOnGround(false)
        println("ghost category "+self.physicsBody!.categoryBitMask.description)
        
        self.userData = NSMutableDictionary()
        self.userData!.setValue("ghost", forKey: "type")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        
        if(self.oldState != self.currentState){
            self.updateAnimation(self.currentState)
            self.oldState = self.currentState
        }
        
        if(hasFeather){
            
            if(SoundManager.sharedInstance.ghostMusicPlayerInBackground.playing){
                
            } else {
                self.hasFeather = false;
                self.updateAnimation(PlayerState.Run)
                self.velocity = 150
                SoundManager.sharedInstance.ghostMusicPlayerInBackground.stop()
            }
        }
    }
    
    
    override func jump() -> Void {
        if self.isOnGround || self.hasFeather {
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: self.velocity))
            print("jump method ghost")
            if(!self.hasFeather){
                self.isCharacterOnGround(false)
            }
        }
    }
    
    override func isCharacterOnGround(onGround: Bool ) -> Void {
        
        self.isOnGround = onGround
        
        if(self.isOnGround == true && !hasFeather){
            currentState = PlayerState.Run
            velocity = 150;
        }
        else if (isOnGround && hasFeather){
            currentState = PlayerState.Fly
            velocity = 50;
        } else {
            currentState = PlayerState.Jump
            velocity = 150;
        }
        
    }
    
    override func updateAnimation(state: PlayerState) -> Void {
        
        if(state == PlayerState.Fly){
            self.atlasName = "GhostFly"
        } else {
            self.atlasName = "Ghost"
        }
        
        //Jump-State
        if(state == PlayerState.Jump){
            self.textures.removeAll(keepCapacity: true)
            let textureAtlas = SKTextureAtlas(named: self.atlasName + ".atlas")
            
            //Nur das Springsprite
            let t = textureAtlas.textureNamed(self.atlasName + "\(6)")
            self.textures.append(t)
            
        }
        
        //Run-State
        if(state == PlayerState.Run){
            self.textures.removeAll(keepCapacity: true)
            let textureAtlas = SKTextureAtlas(named: self.atlasName + ".atlas")
            
            //Komplettes Spriteatlas
            for index in 1...10 {
                let t = textureAtlas.textureNamed(self.atlasName + "\(index)")
                self.textures.append(t)
            }
            
        }
        
        //Fly-State
        if(state == PlayerState.Fly){
            textures.removeAll(keepCapacity: true)
            let textureAtlas = SKTextureAtlas(named: self.atlasName + ".atlas")
            
            //Komplettes Spriteatlas (Fly)
            for index in 1...10 {
                let t = textureAtlas.textureNamed(self.atlasName + "\(index)")
                self.textures.append(t)
            }
            
        }
        
        //Stare neue Animation!
        self.startAnimating()
    }
    
    
    override func startAnimating() -> Void {
        self.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.07, resize: false, restore: true)), withKey:"walking")
    }
    
}