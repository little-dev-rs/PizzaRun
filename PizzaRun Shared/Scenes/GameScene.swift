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
    var mount: SKSpriteNode!
    var character: SKSpriteNode!
    var cameraNode = SKCameraNode()
    var obstacles: [SKSpriteNode] = []
    var clouds: [SKSpriteNode] = []
    
    var cameraMovePointPerSecond: CGFloat = 450.0
    
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    var playTime: CGFloat = 3.0
    
    var onGround = true
    var velocityY: CGFloat = 0.0
    var gravity: CGFloat = 0.8
    var characterPosY: CGFloat =  0.0
    var pauseNode: SKSpriteNode!
    var containerNode = SKNode()
    
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        
        if node.name == "pause" {
            if isPaused { return }
            createPanel ()
            lastUpdateTime = 0.0
            dt = 0.0
            isPaused = true
            
        } else if node.name == "resume" {
            containerNode.removeFromParent ()
            isPaused = false
            
        }else if node.name == "quit" {
            
        } else {
            if !isPaused{
                if onGround {
                    onGround = false
                    velocityY = -25.0
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if velocityY < -12.5{
            velocityY = -12.5
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
            
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        moveCamera()
        moveCharacter()
        
        velocityY += gravity
        character.position.y -= velocityY
        
        if character.position.y < characterPosY {
            character.position.y = characterPosY
            velocityY = 0.0
            onGround = true
        }
    }
}

// MARK: - Configuration

extension GameScene {
    
    func setupNodes() {
        createBackground()
        createMount()
        createGround()
        spawnObstacles()
        createCharacter()
        setupClouds()
        spawnClouds()
        setupPause()
        setupCamera()
        
      
        
        
        
        
    }
 
    func setupPause() {
        pauseNode = SKSpriteNode(imageNamed: "pause")
        pauseNode.setScale (0.5)
        pauseNode.zPosition = 10
        pauseNode.name = "pause"
        pauseNode.position = CGPoint(x: playableRect.width/2.0 - pauseNode.frame.width/2.0 - 60.0,
                                     y: playableRect.height/2.0 - pauseNode.frame.height/2.0 - 150.0)
        cameraNode.addChild(pauseNode)
        
    }
    
    func createPanel() {
        cameraNode.addChild (containerNode)
        
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.zPosition = 20
        panel.position = .zero
        containerNode.addChild(panel)
        
        let resume = SKSpriteNode(imageNamed: "resume" )
        resume.zPosition = 30
        resume.name = "resume"
        resume.setScale(0.7)
        resume.position = CGPoint(x: -panel.frame.width/2.0 + resume.frame.width*1.5, y: 0.0)
        panel.addChild(resume)
        
        
        let quit = SKSpriteNode(imageNamed: "back")
        quit.zPosition = 70.0
        quit.name = "quit"
        quit.setScale(0.7)
        quit.position = CGPoint(x: panel.frame.width/2.0 - quit.frame.width*1.5, y: 0.0)
        panel.addChild(quit)
        
        
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
        for i in 0...4 {
            ground = SKSpriteNode(imageNamed: "ground1")
            ground.name = "Ground"
            ground.anchorPoint = .zero
            ground.position = CGPoint(x: CGFloat(i)*ground.frame.width, y: 0.0)
            ground.zPosition = 4.0
            addChild(ground)
        }

    }
    
    func createMount() {
        mount = SKSpriteNode(imageNamed: "mountns")
        mount.name = "Mount"
        mount.anchorPoint = .zero
        mount.position = CGPoint(x: cameraNode.frame.width/2, y: 400)
        mount.zPosition = 1.0
        addChild(mount)
    }
    
    func createCharacter() {
        character = SKSpriteNode(imageNamed: "cook1")
        character.name = "Player"
        character.setScale(3)
        character.zPosition = 5.0
        character.position = CGPoint(x: frame.width/2 - 100,
                                  y: ground.frame.height + character.frame.height/2 - 25)
        characterPosY = character.position.y
        addChild(character)

        var textures: [SKTexture] = []
        for i in 1...7 {
            let texture = SKTexture(imageNamed: "cook\(i)")
            textures.append(texture)
        }
        character.run(.repeatForever(.animate(with: textures, timePerFrame: 0.083)))
    }
    
    func setupCamera() {
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    func moveCamera() {
        let amountToMove = CGPoint(x: cameraMovePointPerSecond * CGFloat(dt), y: 0.0)
        cameraNode.position +=  amountToMove
        mount.position +=  amountToMove
        
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
                node.position = CGPoint(x: node.position.x + node.frame.width * 3, y: node.position.y)
            }
        }
        
    }
    
    func moveCharacter() {
        let amountToMove = cameraMovePointPerSecond * CGFloat(dt)
        character.position.x += amountToMove
    }
    
    func setupClouds() {
        for _ in 1...4 {
            let sprite = SKSpriteNode(imageNamed: "cloud1")
            sprite.name = "Cloud"
            sprite.setScale(4)
            clouds.append(sprite)

        }

        let index = Int(arc4random_uniform(UInt32(clouds.count - 1)))
        let sprite = clouds[index].copy() as! SKSpriteNode
        sprite.zPosition = 2.0
        sprite.setScale(0.3)
        let randomYPosition = Double(CGFloat.random(in: 600...700))
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width / 2.0,
                                  y: ground.frame.height + randomYPosition)
        addChild(sprite)
        
        var textures: [SKTexture] = []
        for i in 1...2 {
            let texture = SKTexture(imageNamed: "cloud\(i)")
            textures.append(texture)
        }
        sprite.run(.repeatForever(.animate(with: textures, timePerFrame: 1)))
    }
    
    func spawnClouds() {
        let random = Double(CGFloat.random(in: 1.5 ... 6))
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

    //    for _ in 1...3 {
     //       let sprite = SKSpriteNode(imageNamed: "pizza")
     //       sprite.name = "Pizza"
     //       sprite.setScale(2)
      //      obstacles.append(sprite)
      //  }
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
        
        for _ in 1...1 {
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
        let randomYPosition = Double(CGFloat.random(in: sprite.frame.height / 2 ... 450))
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width / 2.0,
                                  y: ground.frame.height + randomYPosition)
        addChild(sprite)
        sprite.run(.sequence([
            .wait(forDuration: 10.0),
            .removeFromParent()
        ]))
    }
    
    func spawnObstacles() {
        // wait on start
        run(.wait(forDuration: 5))
        
        let random = Double(CGFloat.random(in: 1.5 ... 3))//playTime))
        run(.repeatForever(.sequence([
            .wait(forDuration: random),
            .run { [weak self] in
                self?.setupObstacles()
                
//                self?.playTime -= 0.01
//
//                if CGFloat(self?.playTime ?? 0.0) <= 1.0 {
//                    self?.playTime = 1.0
//                }
            }
        ])))
        
//        run(.repeatForever(.sequence([
//            .wait(forDuration: 5.0),
//            .run {
//                self.playTime -= 0.01
//
//                if self.playTime <= 1.0 {
//                    self.playTime = 1.0
//                }
//            }
//        ])))
    }
    
}
