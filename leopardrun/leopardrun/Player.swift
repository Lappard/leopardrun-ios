import UIKit
import SpriteKit

public enum PlayerState: Int {

    case Stand = 0
    case Run = 1
    case Jump = 2
    case Duck = 3
    case Dead = 4
}

class Player: SpriteEntity {
    
    var countRunning = 0
    var currentState: PlayerState = PlayerState.Run
    var oldState: PlayerState = PlayerState.Stand

    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var isOnGround = true
    
    init() {
        
        super.init(atlasName: "Leopard", count: 10)
        
        self.xScale = 0.3
        self.yScale = 0.3
        self.position = CGPoint(x: 200, y: 600)
        
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
        }
        // for collision
        self.physicsBody!.contactTestBitMask = BodyType.player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update() {
        println(self.position)
        if(oldState != self.currentState){
            self.updateAnimation(currentState)
            oldState = currentState
        }
       
        if self.position.y < 120 || self.position.x < 0{
            currentState = .Dead
            NSNotificationCenter.defaultCenter().postNotificationName("player.dead", object: self)
        }
    }
    
    func isOnGround(onGround: Bool ) -> Void {
        self.isOnGround = onGround
        
        if(onGround == true){
            currentState = PlayerState.Run
        }
        
    }
    
    func jump() -> Void {
        if self.isOnGround {
            
            SoundManager.sharedInstance.playSound(Sounds.Jump.rawValue)
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: 350.0))
            currentState = PlayerState.Jump
            print("State: JUMP => ")
            println(currentState.rawValue)
            isOnGround(false)
        }
    }
    
    
    
}