import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            if let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as? SKScene {
                archiver.finishDecoding()
                return scene
            }
        }
        return nil
    }
}

func showScene(scene : SKScene, view : SKView?) -> Void {
    // Configure the view.
    if let skView = view as SKView? {
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .ResizeFill
        
        skView.presentScene(scene)
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        if let scene = MenuScene.unarchiveFromFile("MenuScene") as? MenuScene {
            let skView = self.view! as! SKView
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Right, duration: 1.0)
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .AspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene,transition: transition)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
