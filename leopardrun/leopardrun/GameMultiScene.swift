import SpriteKit

class GameMultiScene: GameScene, SKPhysicsContactDelegate {
    
    var challenge : Challenge? {
        didSet {
            if let data = self.challenge!.levelData {
                LevelManager.sharedInstance.setLevelJson(data)
                LevelManager.sharedInstance.delegate = nil
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        println("didmovetoview")
    }
}
