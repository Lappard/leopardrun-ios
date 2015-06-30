//
//  LobbyScene.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 29.06.15.
//  Copyright (c) 2015 Grandmaster Dumass!. All rights reserved.
//

import SpriteKit

class LobbyScene: SKScene {
    
    let clientId : String = "1076836895729-qekh78jtt8bugiqjlbd268tknss16l8c.apps.googleusercontent.com"

    override init() {
        super.init()
        
        // GPGManager.
        if !GPGManager.sharedInstance().signedIn {
            GPGManager.sharedInstance().signInWithClientID(self.clientId, silently: false)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if !GPGManager.sharedInstance().signedIn {
            GPGManager.sharedInstance().signInWithClientID(self.clientId, silently: false)
        }
    }
    
    private func requestSignIn() {
        
    }
}
