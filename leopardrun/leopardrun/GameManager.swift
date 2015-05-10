//
//  GameManager.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation

class GameManager {
    
    struct Static {
        static var instance: GameManager?
        private var ressourceManager:RessourceManager = RessourceManager()
        private var soundManager:SoundManager = SoundManager()
        private var inputManager:InputManager = InputManager()
        private var levelManager:LevelManager = LevelManager()
        private var networkManager:NetworkManager = NetworkManager()
        private var scoreManager:ScoreManager = ScoreManager()
        
    }
    
    class var sharedInstance: GameManager {
        if !(Static.instance != nil) {
            Static.instance = GameManager()
        }
        
        return Static.instance!
    }
}