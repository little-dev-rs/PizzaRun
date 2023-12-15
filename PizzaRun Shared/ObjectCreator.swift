//
//  ObjectCreator.swift
//  PizzaRun iOS
//
//  Copyright © 2023 Waffle Whales. All rights reserved.
//

import SpriteKit

protocol Creator {
    
    func createSprite(model: GameObject) -> SKSpriteNode
    
}

class ObjectCreator: Creator {

    func createSprite(model: GameObject) -> SKSpriteNode {
        let sprite = SKSpriteNode(imageNamed: model.imageName)
        sprite.name = model.name
        sprite.setScale(model.scale)
        sprite.zPosition = model.zPosition
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.categoryBitMask = model.physicsCategory
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.affectedByGravity = false
        if let contactCategory = model.contactCategory {
            sprite.physicsBody?.contactTestBitMask = contactCategory
        }
        return sprite
    }
    
}
