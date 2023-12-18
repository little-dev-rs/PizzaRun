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
    
    let creator: Creator = ObjectCreator()
    let viewModel: GameSceneVM = GameSceneVM()
    
    var lifeNodes: [SKSpriteNode] = []
    var lifeCounter: Int = 3 {
        didSet {
            if lifeNodes.isEmpty == false {
                let removedNode = lifeNodes.removeLast()
                removedNode.removeFromParent()
                if lifeNodes.isEmpty {
                    createPanel() // here show gameOver screen
                    tomatoScoreNode.removeFromParent()
                    tomatoScoreLabel.removeFromParent()
                    basilScoreNode.removeFromParent()
                    basilScoreLabel.removeFromParent()
                    cheeseScoreNode.removeFromParent()
                    cheeseScoreLabel.removeFromParent()
//                    pizzaScoreNode.removeFromParent()
//                    pizzaScoreLabel.removeFromParent()
                }
            }
        }
    }
    
    var pizzaCounter: Int = 0 {
        didSet {
            updateLabel(pizzaScoreLabel, to: pizzaCounter)
        }
    }
    
    var basilCounter: Int = 0 {
        didSet {
            updateLabel(basilScoreLabel, to: basilCounter)
        }
    }
    var cheeseCounter: Int = 0 {
        didSet {
            updateLabel(cheeseScoreLabel, to: cheeseCounter)
        }
    }
    var tomatoCounter: Int = 0 {
        didSet {
            updateLabel(tomatoScoreLabel, to: tomatoCounter)
        }
    }
    
    var tomatoScoreNode: SKSpriteNode!
    var basilScoreNode: SKSpriteNode!
    var cheeseScoreNode: SKSpriteNode!
    var pizzaScoreNode: SKSpriteNode!
    
    var tomatoScoreLabel = SKLabelNode(fontNamed: "Krungthep" )
    var basilScoreLabel = SKLabelNode(fontNamed: "Krungthep" )
    var cheeseScoreLabel = SKLabelNode(fontNamed: "Krungthep" )
    var pizzaScoreLabel = SKLabelNode(fontNamed: "Krungthep" )
    var backgroundMusic: SKAudioNode!
    
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
        if let musicURL = Bundle.main.url(forResource: "collection_", withExtension: "m4a") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
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
            if !isPaused {
                if onGround {
                    onGround = false
                    velocityY = -25.0
                }
            }
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
        setupLife()
        setupTomatoScore()
        setupBasilScore()
        setupCheeseScore()
        setupPizzaScore()
        physicsWorld.contactDelegate = self
        view?.showsPhysics = false
    }
    
    func setupPause() {
        pauseNode = SKSpriteNode(imageNamed: "pause")
        pauseNode.setScale (0.15)
        pauseNode.zPosition = 10
        pauseNode.name = "pause"
        pauseNode.position = CGPoint(x: playableRect.width/2.0 - pauseNode.frame.width/2.0 - 60.0,
                                     y: playableRect.height/2.0 - pauseNode.frame.height/2.0 - 150.0)
        cameraNode.addChild(pauseNode)
    }
    
    func createPanel() {
        cameraNode.addChild(containerNode)
        
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
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
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

        character.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: character.size.width / 2, height: character.size.height))
        character.physicsBody?.allowsRotation = false
        character.physicsBody?.restitution = 0.0
        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.categoryBitMask = PhysicsCategory.Character
        character.physicsBody?.contactTestBitMask = PhysicsCategory.Ananas// | PhysicsCategory.Obstacle | PhysicsCategory.Knife // add more
        
        addChild(character)

        var textures: [SKTexture] = []
        for i in 0...7{
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
        let cloudModel = viewModel.cloud
        let sprite = SKSpriteNode(imageNamed: cloudModel.imageName)
        sprite.name = cloudModel.name
        sprite.setScale(cloudModel.scale)
        sprite.zPosition = cloudModel.zPosition
        
        let randomYPosition = Double(CGFloat.random(in: 500...600))
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width / 2.0,
                                  y: ground.frame.height + randomYPosition)
        sprite.setScale(0.3)
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
        viewModel.obstacles.forEach { object in
            print(viewModel.obstacles)
            for _ in 1...object.repeatCount {
                let sprite = creator.createSprite(model: object)
                obstacles.append(sprite)
            }
        }
        let index = Int(arc4random_uniform(UInt32(obstacles.count - 1)))
        let sprite = obstacles[index].copy() as! SKSpriteNode
        let randomYPosition = Double(CGFloat.random(in: sprite.frame.height / 2 ... 450))
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width / 2.0,
                                  y: ground.frame.height + randomYPosition)

        addChild(sprite)
        sprite.run(.sequence([
            .wait(forDuration: 5.0),
            .removeFromParent()
        ]))
    }

    func setupLife() {
        for i in 0...lifeCounter-1 {
            let node = SKSpriteNode(imageNamed: "heart_cropped")
            node.name = "Heart"
            node.setScale(0.1)
            node.zPosition = 11
            node.anchorPoint = .zero
            let iterationOffset = CGFloat(i*Int(node.frame.width) + i*10)
            node.position = CGPoint(x: playableRect.minX - playableRect.width / 2 + iterationOffset + node.frame.width / 2,
                                    y: playableRect.minY + 140)//node.frame.height)
            lifeNodes.append(node)
        }
        lifeNodes.forEach { node in
            cameraNode.addChild(node)
        }
    }

    func setupTomatoScore() {
        tomatoScoreNode = SKSpriteNode(imageNamed: "tomato")
        tomatoScoreNode.setScale(1)
        tomatoScoreNode.zPosition = 50.0 // ??
        tomatoScoreNode.position = CGPoint(x: playableRect.minX,
                                           y: playableRect.minY + 200)
        cameraNode.addChild(tomatoScoreNode)

        tomatoScoreLabel.text = "\(tomatoCounter)"
        tomatoScoreLabel.fontSize = 60.0
        tomatoScoreLabel.horizontalAlignmentMode = .left
        tomatoScoreLabel.verticalAlignmentMode = .top
        tomatoScoreLabel.zPosition = 50.0 // ??
        tomatoScoreLabel.position = CGPoint(x: tomatoScoreNode.position.x + 60,
                                            y: playableRect.minY + 222)// + tomatoScoreNode.frame.height) //
        cameraNode.addChild(tomatoScoreLabel)
    }
    
    func setupBasilScore() {
        basilScoreNode = SKSpriteNode(imageNamed: "basil_cropped")
        basilScoreNode.setScale(1.3)
        basilScoreNode.zPosition = 50.0 // ??
        basilScoreNode.position = CGPoint(x: tomatoScoreLabel.position.x + 100,
                                          y: playableRect.minY + 200)
        cameraNode.addChild(basilScoreNode)

        basilScoreLabel.text = "\(basilCounter)"
        basilScoreLabel.fontSize = 60.0
        basilScoreLabel.horizontalAlignmentMode = .left
        basilScoreLabel.verticalAlignmentMode = .top
        basilScoreLabel.zPosition = 50.0 // ??
        basilScoreLabel.position = CGPoint(x: basilScoreNode.position.x + 60,
                                           y: playableRect.minY + 222)
        cameraNode.addChild(basilScoreLabel)
    }
    
    func setupCheeseScore() {
            cheeseScoreNode = SKSpriteNode(imageNamed: "cheese_cropped")
            cheeseScoreNode.setScale(0.18)
            cheeseScoreNode.zPosition = 50.0 // ??
            cheeseScoreNode.position = CGPoint(x: basilScoreLabel.position.x + 100,
                                               y: playableRect.minY + 200)
            cameraNode.addChild(cheeseScoreNode)

            cheeseScoreLabel.text = "\(cheeseCounter)"
            cheeseScoreLabel.fontSize = 60.0
            cheeseScoreLabel.horizontalAlignmentMode = .left
            cheeseScoreLabel.verticalAlignmentMode = .top
            cheeseScoreLabel.zPosition = 50.0 // ??
            cheeseScoreLabel.position = CGPoint(x: cheeseScoreNode.position.x + 60,
                                                y: playableRect.minY + 222)
            cameraNode.addChild(cheeseScoreLabel)
    }

    func setupPizzaScore() {
        pizzaScoreNode = SKSpriteNode(imageNamed: "pizza_cropped")
        pizzaScoreNode.setScale(0.08)
        pizzaScoreNode.zPosition = 50.0 // ??
        pizzaScoreNode.position = CGPoint(x: cheeseScoreLabel.position.x + 130,
                                           y: playableRect.minY + 200)
        cameraNode.addChild(pizzaScoreNode)

        pizzaScoreLabel.text = "\(pizzaCounter)"
        pizzaScoreLabel.fontSize = 60.0
        pizzaScoreLabel.horizontalAlignmentMode = .left
        pizzaScoreLabel.verticalAlignmentMode = .top
        pizzaScoreLabel.zPosition = 50.0 // ??
        pizzaScoreLabel.position = CGPoint(x: pizzaScoreNode.position.x + 90,
                                            y: playableRect.minY + 222)
        cameraNode.addChild(pizzaScoreLabel)
    }

    func spawnObstacles() {
        // wait on start
        run(.wait(forDuration: 5))
        
        let random = Double(CGFloat.random(in: 1.5 ... 3))//playTime))
        run(.repeatForever(.sequence([
            .wait(forDuration: random),
            .run { [weak self] in
                self?.setupObstacles()
            }
        ])))
    }
    
    func updateLabel(_ label: SKLabelNode, to count: Int) {
        label.text = "\(count)"
    }

}

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let object = contact.bodyA.categoryBitMask == PhysicsCategory.Character ? contact.bodyB : contact.bodyA
        
        if let node = object.node {
            node.removeFromParent()
        }
        switch object.categoryBitMask {
        case PhysicsCategory.Ananas:
            cameraMovePointPerSecond += 150.0
        case PhysicsCategory.Knife:
            lifeCounter -= 1
        case PhysicsCategory.Tomato:
            tomatoCounter += 1
        case PhysicsCategory.Basil:
            basilCounter += 1
        case PhysicsCategory.Cheese:
            cheeseCounter += 1
        case PhysicsCategory.Pizza:
            pizzaCounter += 1
        default:
            return
        }
    }
    
}

// MARK: - Touches

extension GameScene {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if velocityY < -12.5 {
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
