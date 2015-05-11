//
//  PhysicsManager.swift
//  leopardrun
//
//  Created by Ilyas Hallak on 11.05.15.
//  Copyright (c) 2015 Grandmaster Dumass!. All rights reserved.
//

import Foundation
import SpriteKit

class PhysicsManager: SKPhysicsWorld {
    
    override init() {
        super.init()
        self.gravity = CGVectorMake(0.0, -4.9)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}