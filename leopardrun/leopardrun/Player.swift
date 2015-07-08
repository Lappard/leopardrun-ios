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
    var isOnGround = false
    
    init() {
        
        super.init(atlasName: "Leopard", count: 10)
        
        self.xScale = 0.3
        self.yScale = 0.3
        self.position = CGPoint(x: 300, y: 700)
        
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
            physics.mass = 1
            physics.density = 1
            physics.contactTestBitMask = BodyType.player.rawValue
        }
        
        self.isOnGround(false)
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
//        if self.position.y < 120 || self.position.x < 0{
//            currentState = .Dead
//            NSNotificationCenter.defaultCenter().postNotificationName("player.dead", object: self)
//        }
    }
    
    func isOnGround(onGround: Bool ) -> Void {
        self.isOnGround = onGround
        if(onGround == true){
           
                currentState = PlayerState.Run
            
        }else{
            
                currentState = PlayerState.Jump
            
        }
    }
    
    func refreshState(state: PlayerState) -> Void {
        self.currentState = state
    }
    
    func jump() -> Void {
        if self.isOnGround {
            SoundManager.sharedInstance.playSound(Sounds.Jump.rawValue)
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: 1500))
            isOnGround(false)
        }
    }
    
}