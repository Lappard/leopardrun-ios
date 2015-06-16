//
//  Entity.swift
//  leopardrun
//
//  Created by Felix-André Böttger on 10.05.15.
//  Copyright (c) 2015 Ilyas Hallakoglu. All rights reserved.
//

import Foundation
import SpriteKit

enum BodyType : UInt32 {
    
    case player = 1
    case ground = 2
    case box = 4
    case anotherBody1 = 8
    case anotherBody2 = 16
    
}

class Entity : SKSpriteNode {
    
    
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


class SpriteEntity : Entity {
    
    var textures : [SKTexture] = [SKTexture]()
    var imageCount : UInt = 0
    var atlasName = "";
    
    init(atlasName : String, count : UInt) {
        
        self.atlasName = atlasName
        
        let textureAtlas = SKTextureAtlas(named: atlasName + ".atlas")
        imageCount = count
        
        for index in 1...imageCount {
            let t = textureAtlas.textureNamed(atlasName + "\(index)")
            textures.append(t)
        }
        
        super.init(texture: textures.first)
        
        self.texture = textures.first
        
         self.physicsBody = SKPhysicsBody(texture: textures.first, size: CGSize(width: textures.first!.size().width, height: textures.first!.size().height))
        
        startAnimating()
    }
    
    func startAnimating() -> Void {
        self.runAction( SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: false, restore: true)), withKey:"walking")
    }
    
    func updateAnimation(state: PlayerState) -> Void {
        
        //Jump-State
        if(state == PlayerState.Jump){
            textures.removeAll(keepCapacity: true)
            let textureAtlas = SKTextureAtlas(named: self.atlasName + ".atlas")
            
            //Nur das Springsprite
            let t = textureAtlas.textureNamed(self.atlasName + "\(6)")
            textures.append(t)
            
        }
        
        //Run-State
        if(state == PlayerState.Run){
            textures.removeAll(keepCapacity: true)
            let textureAtlas = SKTextureAtlas(named: self.atlasName + ".atlas")
           
            //Komplettes Spriteatlas
            for index in 1...10 {
                let t = textureAtlas.textureNamed(atlasName + "\(index)")
                textures.append(t)
            }
            
        }
        
        //Stare neue Animation!
        startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}