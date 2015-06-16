import UIKit
import SpriteKit

class Player: SpriteEntity {
    
    enum MoveState: Int {
        case Stand = 0
        case Run = 1
        case Jump = 2
        case Duck = 3
        case Dead = 4
    }
    
    var countRunning = 0
    var currentRunState = MoveState.Run
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
        
        switch(currentRunState){
        
            case MoveState.Jump:
                
                println("jump")
            
            default:
                break
            
        }
        
    }
    
    func isOnGround(onGround: Bool ) -> Void {
        self.isOnGround = onGround;
        
        if(onGround == true){
            currentRunState = MoveState.Run
            print("State: ")
            println(currentRunState.rawValue)
        }
        
    }
    
    func jump() -> Void {
        if self.isOnGround {
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: 350.0))
            currentRunState = MoveState.Jump
            print("State: JUMP => ")
            println(currentRunState.rawValue)
            isOnGround(false)
        }
    }
    
    
    
}