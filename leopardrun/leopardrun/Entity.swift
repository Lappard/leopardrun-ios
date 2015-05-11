//
//  Entity.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation
import SpriteKit

class Entity : SKSpriteNode
{
    
    init(texture: SKTexture!) {
        //super.init(texture: texture) You can't do this because you are not calling a designated initializer.
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update() {
        fatalError("update method have to override")
    }
}