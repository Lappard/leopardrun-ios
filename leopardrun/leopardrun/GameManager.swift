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
        
        private var ressourceManager:RessourceManager
        private var soundManager:SoundManager
        private var inputManager:InputManager
        private var levelManager:LevelManager
        private var networkManager:NetworkManager
        private var scoreManager:ScoreManager
        
        init()
        {
            ressourceManager = RessourceManager()
            soundManager = SoundManager()
            inputManager = InputManager()
            levelManager = LevelManager()
            networkManager = NetworkManager()
            scoreManager = ScoreManager()
        }
        
    }
    
    class var sharedInstance: GameManager {
        if !(Static.instance != nil) {
            Static.instance = GameManager()
        }
        
        return Static.instance!
    }
}