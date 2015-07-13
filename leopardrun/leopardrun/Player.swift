import UIKit
import SpriteKit

public enum PlayerState: Int {

    case Stand = 0
    case Run = 1
    case Jump = 2
    case Fly = 3;
    case Duck = 4
    case Dead = 5
}

class Player: SpriteEntity {

    var hasFeather = false;
    var countRunning = 0
    var currentState: PlayerState = PlayerState.Run
    var oldState: PlayerState = PlayerState.Stand

    var velocity = 150;
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var isOnGround = false
    
    var isGhostMode = false
    
    init(kind: String, atlasName : String) {
        
        super.init(atlasName: atlasName, count: 10)
        self.xScale = 0.3
        self.yScale = 0.3
        self.position = CGPoint(x: 200, y: 450)
        self.generateBodyByWidthHeigth(self.size.width)
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
            physics.mass = 0.1
            physics.density = 1
            
            physics.categoryBitMask = BodyType.player.rawValue
            physics.collisionBitMask = BodyType.box.rawValue | BodyType.ground.rawValue | BodyType.item.rawValue | BodyType.sky.rawValue
            physics.contactTestBitMask = BodyType.box.rawValue | BodyType.ground.rawValue | BodyType.item.rawValue | BodyType.sky.rawValue
        }
        
        self.isOnGround(false)
        
        self.userData = NSMutableDictionary()
        self.userData!.setValue(kind, forKey: "type")
        
    }
    
    func reset() -> Void {
        self.position = CGPoint(x: 200, y: 600)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        
        if(oldState != self.currentState){
            self.updateAnimation(currentState)
            oldState = currentState
        }
        
        if(hasFeather){
            
            if(SoundManager.sharedInstance.musicPlayer.playing){
                
            } else {
                hasFeather = false;
                self.hasFeather = false;
                updateAnimation(PlayerState.Run)
                SoundManager.sharedInstance.playMusic("music")
            }
            
        }
    }
    
    func isOnGround(onGround: Bool ) -> Void {
        
            self.isOnGround = onGround
        
            if(onGround && !hasFeather){
                currentState = PlayerState.Run
                velocity = 150;
            }
             else if (onGround && hasFeather){
                currentState = PlayerState.Fly
                velocity = 50;
            } else {
                currentState = PlayerState.Jump
                velocity = 150;
            }
        
    }
    
    func refreshState(state: PlayerState) -> Void {
        self.currentState = state
    }
    
    func jump() -> Void {
        if self.isOnGround || self.hasFeather || isGhostMode {
            SoundManager.sharedInstance.playSound(Sounds.Jump.rawValue)
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: velocity))
            print("jump method hero")
            if(!self.hasFeather){
                isOnGround(false)
            }
        }
    }
}