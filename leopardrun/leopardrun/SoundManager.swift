import Foundation
import AVFoundation

public enum Sounds : String{
    case Music = "music"
    case Fly = "fly"
    case Jump = "jump"
    case Dead = "dead"
}

class SoundManager {
    
    var sounds : Dictionary<String, NSURL> = Dictionary<String,NSURL>()
    var musics : Dictionary<String, NSURL> = Dictionary<String,NSURL>()
    var musicPlayer : AVAudioPlayer = AVAudioPlayer()
    var soundPlayer : AVAudioPlayer = AVAudioPlayer()
    
    class var sharedInstance: SoundManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: SoundManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SoundManager()
        }
        return Static.instance!
    }

    init()
    {
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        //Musik
        musics[Sounds.Music.rawValue] = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(Sounds.Music.rawValue, ofType: "wav")!)
        
        //Fly
        musics[Sounds.Fly.rawValue] = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(Sounds.Fly.rawValue, ofType: "wav")!)
        
        //Sounds
        sounds[Sounds.Jump.rawValue] = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(Sounds.Jump.rawValue, ofType: "wav")!)
        sounds[Sounds.Dead.rawValue] = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(Sounds.Dead.rawValue, ofType: "wav")!)
        
    }
    
    func playSound(sound : String){
        //var error:NSError?
        //soundPlayer = AVAudioPlayer(contentsOfURL: sounds[sound], error:&error)
        //soundPlayer.prepareToPlay()
        //soundPlayer.play()
    }
    func playMusic(music : String){
        
        var error:NSError?
        musicPlayer = AVAudioPlayer(contentsOfURL: musics[music], error:&error)

        musicPlayer.prepareToPlay()
        musicPlayer.play()
        
    }
    
    func stopMusic(){
        musicPlayer.stop()
    }
    
}