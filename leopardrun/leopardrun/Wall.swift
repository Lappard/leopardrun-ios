import UIKit
import SpriteKit

class Wall: SpriteEntity {
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    
    init() {
        
        super.init(atlasName: "Firewall", count: 15)
        
        self.xScale = 1.5
        self.yScale = 1.0
        startAnimating()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}