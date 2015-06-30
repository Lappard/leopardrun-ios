import UIKit
import SpriteKit

class Wall: SpriteEntity {
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    
    init() {
        
        super.init(atlasName: "Firewall", count: 7)
        
        self.xScale = 1.0
        self.yScale = 1.5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}