import SpriteKit

class ScoreManager {
    
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    internal let scorePerSecound:Double = 50
    internal var shouldCounting = false
    
    var scores : [Int] = [Int]()
    var extraPoints: Double = 0
    
    internal var startTime : Double = 0
    internal var score : Int = 0
    
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
        scoreLabel.text = "Score 0";
        score = 0;
        self.startTime = 0;

    }

    /* starttime - current time * time per secound */
    func update() -> Void{
        var current : Double = NSDate.timeIntervalSinceReferenceDate()
        var timePast : Double = Double(current) - Double(self.startTime)
        var scoreF : Double = timePast * self.scorePerSecound
        
        scoreF += extraPoints
        
        self.score = Int(scoreF)
        scoreLabel.text = "Score " + score.description
        
    }
    
    func currentTimeMillis() -> Double{
        var nowDouble = NSDate().timeIntervalSince1970
        return Double(nowDouble*1000)
    }
    
    func start() -> Void {
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    @objc func playerIsDead(notification : NSNotification) {
        shouldCounting = false
        self.saveCurrrentScore()
    }
    
    func addToScore(var score:Double) -> Void{
        self.extraPoints += score
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