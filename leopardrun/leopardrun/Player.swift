import UIKit
import SpriteKit

class Player: SpriteEntity {
    
    var countRunning = 0
    var currentRunState = 1
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    
    init() {
        let texture = SKTexture(imageNamed: "run1")
        
        super.init(atlasName: "Runner", count: 6)
        
        
        self.xScale = 2
        self.yScale = 2
        self.position = CGPoint(x: 200, y: 600)
        
        
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
           // animatePlayer()
            countRunning = 0
        } else {
            countRunning++
        }
    }
}