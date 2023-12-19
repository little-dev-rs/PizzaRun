//
//  MainMenuScene.swift
//  PizzaRun iOS
//
//  Created by Lidia Michela Ambrosanio on 14/12/23.
//  Copyright © 2023 Waffle Whales. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    //MARK: - Systems
    override func didMove(to view: SKView) {
        setupBG()
        setupTitle()
        setUpMount()
        setupGrounds()
        setupGrounds2()
        setupNodes()
    }
    /*
     }
     override func update(_ currentTime: TimeInterval) {
     moveGrounds()
     
     }*/
    
    
    func setupBG() {
        let bgNode = SKSpriteNode(imageNamed: ("sky"))
        bgNode.zPosition = -1.0
        bgNode.anchorPoint = .zero
        bgNode.position = .zero
        addChild(bgNode)
    }
    
    func setupGrounds() {
        
        let groundNode = SKSpriteNode(imageNamed: "ground1")
        groundNode.name = "Ground"
        groundNode.anchorPoint = .zero
        groundNode.zPosition = 0.0
        groundNode.position = CGPoint(x: 0.0, y: 0.0)
        addChild(groundNode)
        
    }
    func setupGrounds2() {
        
        let groundNode = SKSpriteNode(imageNamed: "ground1")
        groundNode.name = "Ground"
        groundNode.anchorPoint = .zero
        groundNode.zPosition = 0.0
        groundNode.position = CGPoint(x: 1040, y: 0.0)
        addChild(groundNode)
        
    }
    func setUpMount() {
        var mount: SKSpriteNode!
        mount = SKSpriteNode(imageNamed: "mountns")
        mount.name = "Mount"
        mount.anchorPoint = .zero
        mount.position = CGPoint(x: 0.0, y: 400)
        mount.zPosition = -0.5
        addChild(mount)
    }
    func setupTitle(){
        let title = SKSpriteNode(imageNamed: "screentitle")
        title.name = "screentitle"
        title.setScale (0.5)
        title.zPosition = 2.0
        title.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2 + 290)
        addChild (title)
    }
    func setupNodes() {
        let play = SKSpriteNode(imageNamed: "play")
        play.name = "play"
        play.setScale (0.5)
        play.zPosition = 2.0
        play.position = CGPoint(x: size.width / 2 + 200, y: size.height / 2 - 25)
        
        //  play.position = CGPoint(x: size.width / 2 - 200, y: size.height / 2 - 25)
        addChild (play)
        
        let highscore = SKSpriteNode(imageNamed: "highscore")
        highscore.name = "highscore"
        highscore.setScale (0.5)
        highscore.zPosition = 2.0
        highscore.position = CGPoint(x: size.width / 2 - 250, y: size.height / 2 - 25)
        //highscore.position = CGPoint(x: size.width / 2 + 200, y: size.height / 2 - 25)
        addChild (highscore)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if touchedNode.name == "play" {
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.5))
        }
    }
}
