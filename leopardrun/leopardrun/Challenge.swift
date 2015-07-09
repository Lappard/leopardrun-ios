import Foundation

class Challenge {
    var levelData : [JSON]?
    
    /*
    "Owner" : "AndroidUser",
    "PlayerScore" : 820,
    "Date" : 1844606626,
    "GameName" : "mibbad",
    */
    
    var actions : [Int]?
    
    var owner : String?
    
    var date : Int?
    
    var gameName : String?
    
    var playerScore : Float?
    
    init(name : String) {
        self.gameName = name
    }
}
