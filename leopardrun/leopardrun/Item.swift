import UIKit
import SpriteKit

class Item: SpriteEntity {
    
    var runnerTextures:Array<SKTexture> = Array<SKTexture>()
    
    init() {
        
        super.init(atlasName: "Coin", count: 6)
        
        self.xScale = 1.0
        self.yScale = 1.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}