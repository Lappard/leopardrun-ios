import Foundation

class Challenge {
    var name : String = ""
    var levelData : JSON
    
    init(name : String) {
        self.name = name
        self.levelData = nil
    }
}
