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
    
    var itemCount = 0;
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var isOnGround = false
    
    init(atlasName : String) {
        
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
            physics.contactTestBitMask = BodyType.player.rawValue
        }
        
        self.isOnGround(false)
    }
    
    func reset() -> Void {
        self.position = CGPoint(x: 200, y: 450)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update() {
        
        if(oldState != self.currentState){
            self.updateAnimation(currentState)
            oldState = currentState
        }
        
        if(hasFeather && itemCount > 0){
            itemCount -= 1;
            println(itemCount)
            if(itemCount == 0){
                self.hasFeather = false;
                updateAnimation(PlayerState.Run)
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

        if self.isOnGround || self.hasFeather {
            SoundManager.sharedInstance.playSound(Sounds.Jump.rawValue)
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: velocity))
            if(!self.hasFeather){
                isOnGround(false)
            }
        }
    }
}