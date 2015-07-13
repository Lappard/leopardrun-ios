import SpriteKit

class GameOverScene : SKScene {
    
    var backgroundImage = SKSpriteNode(imageNamed: "Background")
    
    var challenge : Challenge?
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.backgroundImage.zPosition = 0
        self.backgroundImage.size = self.size
        
        addChild(backgroundImage)
        
        // 2
        var message = "Game Over!"
        
        // 3
        let label = SKLabelNode(fontNamed: "Shojumaru")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        self.addChild(label)
        
        var scoreMessage = "Your Score is " + ScoreManager.sharedInstance.score.description
        
        let scoreLabel = SKLabelNode(fontNamed: "Shojumaru")
        scoreLabel.text = scoreMessage
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        
        self.addChild(scoreLabel)
        
        if let c = self.challenge {
            NetworkManager.sharedInstance.saveScore(c)
        }
        
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 1.0)
        var scene = MenuScene.unarchiveFromFile("MenuScene") as? MenuScene
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .ResizeFill
        scene!.size = skView.bounds.size
        skView.presentScene(scene, transition: transition)
    }
    
}