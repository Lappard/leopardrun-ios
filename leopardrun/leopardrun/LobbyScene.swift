import SpriteKit

protocol LobbyDataLoaded {
    func DataLoaded()
}

class LobbyScene: SKScene {
    
    private var nextY : CGFloat = 100.0
    private var nextScene : GameMultiScene?
    
    var dataLoadedDelegate : LobbyDataLoaded?
    
    /// generate labels after array is assigned
    private var challenges : [Challenge]? {
        didSet {
            var index : Int = 0
            for c in self.challenges! {
                let label = SKLabelNode(fontNamed: "Chalkduster")
                label.text = c.gameName!
                
                // tag workaround
                label.name = index.description
                
                label.fontSize = 40
                label.fontColor = SKColor.blackColor()
                label.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + self.nextY)
                
                self.nextY += 40.0
                index++
                
                self.addChild(label)
                
                if index == 5 {
                    break
                }
            }
            
            dataLoadedDelegate?.DataLoaded()
        }
    }
    
    override init() {
        super.init()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.whiteColor()
        ScoreManager.sharedInstance.reset()
        getChellenges()
    }
    
    func getChellenges(){
        NetworkManager.sharedInstance.get(NetworkMethod.SaveGames, completed: {
            (ch : [AnyObject]) in
            if let challenges = ch as? [Challenge] {
                self.challenges = challenges
            }
        })
        NetworkManager.sharedInstance.getLevelDataFromServer()
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
                            if let scene = GameMultiScene.unarchiveFromFile("GameMultiScene") as? GameMultiScene {
                                scene.challenge = c
                                nextScene = scene
                                let skView = self.view! as SKView
                                let transition = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 1.0)
                                nextScene!.scaleMode = .AspectFill
                                skView.presentScene(nextScene, transition: transition)
                            }
                        }
                    }
                }
            }
        }
    }
}
