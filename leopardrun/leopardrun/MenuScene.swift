import Foundation
import SpriteKit

class MenuScene: SKScene, LevelManagerDelegate, LobbyDataLoaded {
    
    var font:String = "Shojumaru"
    var startLabel:SKLabelNode = SKLabelNode()
    var multiLabel:SKLabelNode = SKLabelNode()
    
    var backgroundImage = SKSpriteNode(imageNamed: "Background")
    
    var nextScene : SKScene?
    // 6
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        
        // 1
        //backgroundColor = SKColor.whiteColor()
        
        self.backgroundImage.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.backgroundImage.zPosition = 0
        self.backgroundImage.size = self.size
        addChild(backgroundImage)
        
        let logo = SKSpriteNode(imageNamed: "Logo")
        logo.position = CGPoint(x: size.width/2, y: size.height/2 + 60)
        logo.size = CGSize(width: 150, height: 150)
        addChild(logo)
        
        let buttonStart = SKSpriteNode(imageNamed: "Button")
        buttonStart.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        buttonStart.size = CGSize(width: buttonStart.size.width+40, height: buttonStart.size.height)
        addChild(buttonStart)
        
        let buttonChallenge = SKSpriteNode(imageNamed: "Button")
        buttonChallenge.position = CGPoint(x: size.width/2, y: size.height/2 - 110)
        buttonChallenge.size = CGSize(width: buttonStart.size.width+130, height: buttonChallenge.size.height)
        addChild(buttonChallenge)
        
        var shadow:SKLabelNode = SKLabelNode()
        shadow.fontName = font
        shadow.text = "New Game"
        shadow.fontSize = 30
        shadow.name = "single"
        shadow.fontColor = SKColor.blackColor()
        shadow.position = CGPoint(x: buttonStart.position.x-1, y: buttonStart.position.y-12)
        
        startLabel.fontName = font
        startLabel.text = "New Game"
        startLabel.fontSize = 30
        startLabel.name = "single"
        startLabel.fontColor = SKColor.whiteColor()
        startLabel.position = CGPoint(x: buttonStart.position.x, y: buttonStart.position.y-10)
        
        addChild(shadow)
        addChild(startLabel)
        
        var shadow2:SKLabelNode = SKLabelNode()
        shadow2.fontName = font
        shadow2.text = "Challenge-Mode"
        shadow2.fontSize = 30
        shadow2.name = "single"
        shadow2.fontColor = SKColor.blackColor()
        shadow2.position = CGPoint(x: buttonChallenge.position.x-1, y: buttonChallenge.position.y-12)
        
        multiLabel.fontName = font
        multiLabel.text = "Challenge-Mode"
        multiLabel.name = "multi"
        multiLabel.fontSize = 30
        startLabel.fontColor = SKColor.whiteColor()
        multiLabel.position = CGPoint(x: buttonChallenge.position.x, y: buttonChallenge.position.y-10)
        
        addChild(shadow2)
        addChild(multiLabel)
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            
            if touchedNode.name == "multi" {
                if let lobbyScene = LobbyScene.unarchiveFromFile("LobbyScene") as? LobbyScene {
                    lobbyScene.dataLoadedDelegate = self
                    lobbyScene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    nextScene = lobbyScene
                }
                
            }
            if touchedNode.name == "single" {
                nextScene = GameScene.unarchiveFromFile("GameScene") as? GameScene
                nextScene!.scaleMode = SKSceneScaleMode.AspectFill
                NetworkManager.sharedInstance.currentMethod = NetworkMethod.LevelData
                LevelManager.sharedInstance.delegate = self
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    func DataLoaded() {
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .AspectFill
        scene!.size = skView.bounds.size
        if nextScene != nil {
            skView.presentScene(nextScene, transition: transition)
        }
        nextScene = nil
    }
    
    func ReceivedData() -> Void {
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .AspectFill
        scene!.size = skView.bounds.size
        skView.presentScene(nextScene, transition: transition)
    }

    override func willMoveFromView(view: SKView) {
        if view.gestureRecognizers != nil {
            for gesture in view.gestureRecognizers! {
                if let recognizer = gesture as? UISwipeGestureRecognizer {
                    view.removeGestureRecognizer(recognizer)
                }
            }
        }
    }

    
    
}
