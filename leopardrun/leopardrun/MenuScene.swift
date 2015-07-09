import Foundation
import SpriteKit

class MenuScene: SKScene, LevelManagerDelegate, LobbyDataLoaded {
    
    let startLabel = SKLabelNode(fontNamed: "Chalkduster")
    var nextScene : SKScene?
    // 6
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        
        // 1
        backgroundColor = SKColor.whiteColor()
        
        // 2
        var message = "Leopard Run!"
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        addChild(label)
        
        startLabel.text = "Single Player"
        startLabel.fontSize = 40
        startLabel.name = "single"
        startLabel.fontColor = SKColor.blackColor()
        startLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 50)
        addChild(startLabel)
        
        var multiLabel = SKLabelNode(fontNamed: "Chalkduster")
        multiLabel.text = "Multi Player"
        multiLabel.name = "multi"
        multiLabel.fontSize = 40
        multiLabel.fontColor = SKColor.blackColor()
        multiLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 120)
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
        scene!.scaleMode = .ResizeFill
        scene!.size = skView.bounds.size
        skView.presentScene(nextScene, transition: transition)
    }
    
    
    func ReceivedData() -> Void {
        let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 1.0)
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .ResizeFill
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
