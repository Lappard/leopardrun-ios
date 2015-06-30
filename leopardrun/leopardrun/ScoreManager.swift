import SpriteKit

class ScoreManager {
    
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    internal var shouldCounting = false
    
    var scores : [Int] = [Int]()
    
    internal var score = 0
    
    class var sharedInstance: ScoreManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ScoreManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ScoreManager()
        }
        return Static.instance!
    }

    init()
    {
        scoreLabel.name = "scoreLabel"
        reset()
        if let s = NSUserDefaults.standardUserDefaults().objectForKey("scores") as? [Int] {
            scores = s
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerIsDead:", name: "player.dead", object: nil)
    }
    
    func reset() -> Void {
        scoreLabel.text = "Score 0"
        score = 0;
    }
    
    func incScore(value : Int) -> Void {
        if shouldCounting {
            score+=value
            scoreLabel.text = "Score " + score.description
        }
    }
    
    func addScore(value : Int) {
        scoreLabel.text = "Score " + value.description
    }
    
    @objc func playerIsDead(notification : NSNotification) {
        shouldCounting = false
        self.saveCurrrentScore()
    }
    
    func saveCurrrentScore() {
        
        scores.append(score)
        
        scores.sort {
            return $0 > $1
        }
        
        NSUserDefaults.standardUserDefaults().setObject(scores, forKey: "scores")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        var max = scores.count < 10 ? scores.count - 1 : 9;
        
        for index in 0...max {
            println("score: " + scores[index].description)
        }
        
        

    }
}