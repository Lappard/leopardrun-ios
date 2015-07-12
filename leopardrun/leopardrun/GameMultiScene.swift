import SpriteKit

class GameMultiScene: GameScene, SKPhysicsContactDelegate {
    
    var challenge : Challenge? {
        didSet {
            if let data = self.challenge!.levelData {
                LevelManager.sharedInstance.setLevelJson(data)
                 // TODO: MAKE THIS BETTER
                LevelManager.sharedInstance.delegate = nil
            }
        }
    }

    private var currentActionIndex : Int = 0
    
    var currentAction : Int {
        get {
            if let  c = self.challenge,
                    actions = c.actions
            {
                if actions.count > currentActionIndex {
                    return actions[currentActionIndex]
                } else {
                    return -1
                }
            }
            return -1
        }
    }
    
    var myTimer : NSTimer?
    
    var ghost : Player = Player(atlasName: "Ghost")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reset()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        ghost.zPosition = 3
        ghost.reset()
        
        addChild(ghost)
        
        var timerInterval = NSTimeInterval(currentAction / 1000)
        
        myTimer = NSTimer(timeInterval: timerInterval, target: self, selector:"doGhostAction", userInfo: nil, repeats: false)
        myTimer?.fire()
    }
    
    func doGhostAction() {
        currentActionIndex++
        ghost.jump()
        println("ghost jump")
        if currentAction != -1 {
            var timerInterval = NSTimeInterval(currentAction / 1000)
            myTimer = NSTimer(timeInterval: timerInterval, target: self, selector:"doGhostAction", userInfo: nil, repeats: false)
            myTimer?.fire()
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
       
    }
}
