//
//  GameScene.swift
//  PizzaRun Shared
//
//  Copyright © 2023 Waffle Whales. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    var ground: SKSpriteNode!
    var character: SKSpriteNode!
    var cameraNode = SKCameraNode()
    var characterTextures: [SKTexture] = []
    var obstacles: [SKSpriteNode] = []
    var clouds: [SKSpriteNode] = []
    
    var cameraMovePointPerSecond: CGFloat = 450.0
    
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    var playableRect: CGRect {
        let ratio: CGFloat
        switch UIScreen.main.nativeBounds.height {
        case 2688, 1792, 2436:
            ratio = 2.16
        default:
            ratio = 16/9
        }
        
        let playableHeight = size.width / ratio
        let playableMargin = (size.height - playableHeight) / 2.0

        return CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
    }
    
    var cameraRect: CGRect {
        let width = playableRect.width
        let height = playableRect.height
        let x = cameraNode.position.x - size.width / 2.0 + (size.width - width )/2.0
        let y = cameraNode.position.y - size.height / 2.0 + (size.height - height )/2.0
        
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // MARK: - Systems
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    // < >
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
            
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        moveCamera()
        moveCharacter()
    }
}

// MARK: - Configuration

extension GameScene {
    
    func setupNodes() {
        createBackground()
        createGround()
        setupObstacles()
        spawnObstacles()
        createCharacter()
        setupClouds()
        spawnClouds()
        setupCamera()
    }
    
    func createBackground() {
        for i in 0...2 {
            let background = SKSpriteNode(imageNamed: "sky")
            background.name = "Background"
            background.anchorPoint = .zero
            background.position = CGPoint(x: CGFloat(i)*background.frame.width, y: 0.0)
            background.zPosition = -1
            addChild(background)
        }
    }
    
    func createGround() {
        for i in 0...2 {
            ground = SKSpriteNode(imageNamed: "ground1")
            ground.name = "Ground"
            ground.anchorPoint = .zero
            ground.position = CGPoint(x: CGFloat(i)*ground.frame.width, y: 0.0)
            ground.zPosition = 4.0
            addChild(ground)
        }

    }
    
    func createCharacter() {
        character = SKSpriteNode(imageNamed: "cook1")
        character.name = "Player"
        character.setScale(3)
        character.zPosition = 5.0
        character.position = CGPoint(x: frame.width/2 - 100,
                                  y: ground.frame.height + character.frame.height/2 - 20)
        addChild(character)
    }
    
    func setupCamera() {
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    func moveCamera() {
        let amountToMove = CGPoint(x: cameraMovePointPerSecond * CGFloat(dt), y: 0.0)
        cameraNode.position +=  amountToMove
        
        // Background
        enumerateChildNodes(withName: "Background") { (node, _) in
            let node = node as! SKSpriteNode
            
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                node.position = CGPoint(x: node.position.x + node.frame.width * 2, y: node.position.y)
            }
        }
        
        // Ground
        enumerateChildNodes(withName: "Ground") { (node, _) in
            let node = node as! SKSpriteNode
            
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                node.position = CGPoint(x: node.position.x + node.frame.width * 2, y: node.position.y)
            }
        }
        
    }
    
    func moveCharacter() {
        let amountToMove = cameraMovePointPerSecond * CGFloat(dt)
        
        // Load character textures for animation
         for i in 1...3 {
             let texture = SKTexture(imageNamed: "cook\(i)")
             characterTextures.append(texture)
         }
        
        // Run the character animation
         let animationAction = SKAction.animate(with: characterTextures, timePerFrame: 0.2)
         let repeatAction = SKAction.repeatForever(animationAction)
        character.run(repeatAction)
        
        character.position.x += amountToMove
    }
    
    func setupClouds() {
        for _ in 1...3 {
            let sprite = SKSpriteNode(imageNamed: "cloud1")
            sprite.name = "Cloud"
            sprite.setScale(2)
            clouds.append(sprite)
        }
        
        for _ in 1...3 {
            let sprite = SKSpriteNode(imageNamed: "cloud2")
            sprite.name = "Cloud"
            sprite.setScale(2)
            clouds.append(sprite)
        }
        
        let index = Int(arc4random_uniform(UInt32(clouds.count - 1)))
        let sprite = clouds[index].copy() as! SKSpriteNode
        sprite.zPosition = 2.0
        sprite.setScale(10)
        let randomYPosition = Double(CGFloat.random(in: 500...700))
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width / 2.0,
                                  y: ground.frame.height + randomYPosition)
        addChild(sprite)
    }
    
    func spawnClouds() {
        let random = Double(CGFloat.random(in: 1.5 ... 3))
        run(.repeatForever(.sequence([
            .wait(forDuration: random),
            .run { [weak self] in
                self?.setupClouds()
            }
        ])))
    }
    
    func setupObstacles() {

        for _ in 1...3 {
            let sprite = SKSpriteNode(imageNamed: "tomato")
            sprite.name = "Tomato"
            sprite.setScale(2)
            obstacles.append(sprite)
        }
//        
//        for _ in 1...3 {
//            let sprite = SKSpriteNode(imageNamed: "pizza")
//            sprite.name = "Pizza"
//            sprite.setScale(2)
//            obstacles.append(sprite)
//        }
//        
//        for _ in 1...3 {
//            let sprite = SKSpriteNode(imageNamed: "cheese")
//            sprite.name = "Cheese"
//            sprite.setScale(2)
//            obstacles.append(sprite)
//        }
//        
//        for _ in 1...3 {
//            let sprite = SKSpriteNode(imageNamed: "provola")
//            sprite.name = "Provola"
//            sprite.setScale(2)
//            obstacles.append(sprite)
//        }

        for _ in 1...3 {
            let sprite = SKSpriteNode(imageNamed: "basil")
            sprite.name = "Basil"
            sprite.setScale(2)
            obstacles.append(sprite)
        }
        
        for _ in 1...2 {
            let sprite = SKSpriteNode(imageNamed: "knife")
            sprite.name = "Knife"
            sprite.setScale(0.5)
            obstacles.append(sprite)
        }
        
        for _ in 1...2 {
            let sprite = SKSpriteNode(imageNamed: "ananas")
            sprite.name = "Ananas"
            sprite.setScale(3)
            obstacles.append(sprite)
        }
        
        let index = Int(arc4random_uniform(UInt32(obstacles.count - 1)))
        let sprite = obstacles[index].copy() as! SKSpriteNode
        sprite.zPosition = 4.0
        let randomYPosition = Double(CGFloat.random(in: 50 ... 500))
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width / 2.0,
                                  y: ground.frame.height + randomYPosition)
        addChild(sprite)
        
    }
    
    func spawnObstacles() {
        let random = Double(CGFloat.random(in: 1.5 ... 3))
        run(.repeatForever(.sequence([
            .wait(forDuration: random),
            .run { [weak self] in
                self?.setupObstacles()
            }
        ])))
    }
    
}
