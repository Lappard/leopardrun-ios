import SpriteKit

class GameOverScene : SKScene {
    
    var backgroundImage = SKSpriteNode(imageNamed: "Background")
    
    var challenge : Challenge?
    
    var gameNameTextfield : UITextField?
    
    var userNameTextfield : UITextField?
    
    var okBtn : SKLabelNode?
    
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
        
        gameNameTextfield = UITextField(frame: CGRectMake(0, 0, 200, 30))
        gameNameTextfield!.placeholder = "Enter Game Name"
        gameNameTextfield!.borderStyle = UITextBorderStyle.Line
        if let center = self.view?.center {
            gameNameTextfield!.center.x = center.x - 160
            gameNameTextfield!.center.y = center.y - 50
        }
        self.view?.addSubview(gameNameTextfield!)
        
        // username textfield
        userNameTextfield = UITextField(frame: CGRectMake(0, 0, 200, 30))
        userNameTextfield!.placeholder = "Enter Your Name"
        userNameTextfield!.borderStyle = UITextBorderStyle.Line
        if let center = self.view?.center {
            userNameTextfield!.center.x = center.x + 80
            userNameTextfield!.center.y = center.y - 50
        }
        self.view?.addSubview(userNameTextfield!)
        
        // OK BUTTON
        self.okBtn = SKLabelNode(fontNamed: "Shojumaru")
        self.okBtn?.text = "Save"
        self.okBtn?.name = "Save"
        self.okBtn?.fontSize = 30
        if let center = self.view?.center {
            self.okBtn?.position = CGPoint(x: center.x + 240, y: center.y+40)
        }
        self.okBtn?.fontColor = SKColor.blackColor()
        addChild(self.okBtn!)
        
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
        
        
        
        let nextLabel = SKLabelNode(fontNamed: "Shojumaru")
        nextLabel.text = "Continue"
        nextLabel.name = "Next"

        nextLabel.fontSize = 40
        nextLabel.fontColor = SKColor.blackColor()
        nextLabel.position = CGPoint(x: size.width/2, y: 10)
        
        self.addChild(nextLabel)

    }

    func showNextScene() {
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 1.0)
        var scene = MenuScene.unarchiveFromFile("MenuScene") as? MenuScene
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .ResizeFill
        scene!.size = skView.bounds.size
        skView.presentScene(scene, transition: transition)
        
        userNameTextfield?.removeFromSuperview()
        gameNameTextfield?.removeFromSuperview()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            let skLabel = touchedNode as? SKLabelNode
            println(skLabel?.name)
            if let label = skLabel {
                if label.name == "Save" {
                    if let c = self.challenge {
                        if !gameNameTextfield!.text.isEmpty {
                            c.gameName = gameNameTextfield!.text
                        }
                        if !userNameTextfield!.text.isEmpty {
                            c.owner = userNameTextfield!.text
                        }
                        NetworkManager.sharedInstance.saveScore(c)
                        self.showNextScene()
                        
                    }
                } else if label.name == "Next" {
                    self.showNextScene()
                }
            }
            
            
        }
    }
    
}