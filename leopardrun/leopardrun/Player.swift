import UIKit
import SpriteKit

class Player: Entity {
    
    var countRunning = 0
    var currentRunState = 1
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    
    init() {
        // super.init(imageNamed:"bubble") You can't do this because you are not calling a designated initializer.
        let texture = SKTexture(imageNamed: "bubble")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        for (var i:Int = 1; i < 7; i++) {
            var current : SKTexture = SKTexture(imageNamed: "run" + i.description) // run1, run2, ...
            runnerTextures.append(current)
        }
        
        self.xScale = 2
        self.yScale = 2
        self.position = CGPoint(x: 200, y: 600)
        
        self.texture = SKTexture(imageNamed: "run1.png")
       
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "run1.png"), size: CGSize(width: 100, height: 300))

        
        if let physics = physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = false
            physics.dynamic = true
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animatePlayer() {
        
        if currentRunState==5
        {
            currentRunState=0
        } else {
            currentRunState++
        }
        
       texture = runnerTextures[currentRunState]
        
        
    }
    
    override func update() {
        if countRunning == 2 {
            animatePlayer()
            countRunning = 0
        } else {
            countRunning++
        }
    }
}