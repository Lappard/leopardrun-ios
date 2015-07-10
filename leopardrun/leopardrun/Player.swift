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

    var hasFeather = false;
    var countRunning = 0
    var currentState: PlayerState = PlayerState.Run
    var oldState: PlayerState = PlayerState.Stand

    var itemCount = 0;
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var isOnGround = false
    
    init(atlasName : String) {
        
        super.init(atlasName: atlasName, count: 10)
        self.xScale = 0.3
        self.yScale = 0.3

        self.generateBodyByWidthHeigth(self.size.width)
        println(self.size.width)
        self.position = CGPoint(x: 300, y: 450)
        
        
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
        
        if(hasFeather && itemCount > 0){
            itemCount -= 1;
            println(itemCount)
            if(itemCount == 0){
                self.hasFeather = false;
            }
        }

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

        if self.isOnGround || self.hasFeather {

            if atlasName == "Ghost" {
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: 150))

        }
        if self.isOnGround {
            SoundManager.sharedInstance.playSound(Sounds.Jump.rawValue)
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: 150))
            isOnGround(false)
        }
    }
    
}