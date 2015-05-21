
import Foundation

class RessourceManager {
    
    class var sharedInstance: RessourceManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: RessourceManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = RessourceManager()
        }
        return Static.instance!
    }
    
    init()
    {
        
    }
}