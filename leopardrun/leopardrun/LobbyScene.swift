import SpriteKit

class LobbyScene: SKScene {
    
    private var nextY : CGFloat = 100.0
    private var nextScene : GameMultiScene?
    
    /// generate labels after array is assigned
    private var challenges : [Challenge]? {
        didSet {
            var index : Int = 0
            for c in self.challenges! {
                let label = SKLabelNode(fontNamed: "Chalkduster")
                label.text = c.name
                
                // tag workaround
                label.name = index.description
                
                label.fontSize = 40
                label.fontColor = SKColor.blackColor()
                label.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + self.nextY)
                
                self.nextY += 100.0
                index++
                
                self.addChild(label)
            }
        }
    }
    
    override init() {
        super.init()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.whiteColor()

        NetworkManager.sharedInstance.getLastChallenges({
            (challenges : [Challenge]) in
                self.challenges = challenges
        })
        
        NetworkManager.sharedInstance.getLevelDataFromServer()
        ScoreManager.sharedInstance.reset()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            let skLabel = touchedNode as? SKLabelNode
            
            // check label
            if let label = skLabel {
                
                // get index
                if let index = label.name?.toInt()  {
                    
                    // check nullable challenges
                    if self.challenges != nil {
                        
                        // get challenge
                        if let c = self.challenges?[index] {
                            if let nextScene = GameMultiScene.unarchiveFromFile("GameMultiScene") as? GameMultiScene {
                                nextScene.scaleMode = SKSceneScaleMode.AspectFill
                                nextScene.reset()
                                self.nextScene = nextScene
                                
                                self.view?.presentScene(nextScene)
                                
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        
    }
    
}
