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

    var items:Array<Item> = Array<Item>();
    
    var countRunning = 0
    var currentState: PlayerState = PlayerState.Run
    var oldState: PlayerState = PlayerState.Stand

    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    var isOnGround = false
    
    init() {
        
        super.init(atlasName: "Leopard", count: 10)
        self.xScale = 0.3
        self.yScale = 0.3

        self.generateBodyByWidthHeigth(self.size.width)
        println(self.size.width)
        self.position = CGPoint(x: 300, y: 700)
        
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
            self.physicsBody?.applyImpulse( CGVector(dx: 0, dy: 150))
            isOnGround(false)
        }
    }
    
    func addItem(var i:Item) -> Void{
        self.items.append(i);
    }
    
}