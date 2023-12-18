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
        setupGrounds()
        
    }
    override func update(_ currentTime: TimeInterval) {
        moveGrounds()
    }
}
//MARK: - Configuration

extension MainMenu{
    
    func setupBG() {
        let bgNode = SKSpriteNode(imageNamed: ("sky"))
        bgNode.zPosition = -1.0
        bgNode.anchorPoint = .zero
        bgNode.position = .zero
        addChild(bgNode)
    }
    
    func setupGrounds() {
        for i in 0 ... 2 {
            let groundNode = SKSpriteNode(imageNamed: "ground1")
            groundNode.name = "Ground"
            groundNode.anchorPoint = .zero
            groundNode.zPosition = 0.0
            groundNode.position = CGPoint(x: -CGFloat(i)*groundNode.frame.width, y: 0.0)
            
        }
    }
    
    func moveGrounds() {
        enumerateChildNodes(withName: "Ground") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            
            if node.position.x < -self.frame.width {
                node.position.x += node.frame.width*2.0
            }
            
        }
    }
    
    func setupNodes() {
    let play = SKSpriteNode(imageNamed: "play")
    play.name = "play"
    play.setScale (1)
    play.zPosition = 10.0
    play.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - play.size.height - 50.0)
    addChild (play)
                            
    let highscore = SKSpriteNode(imageNamed: "highscore")
    highscore.name = "highscore"
    highscore.setScale (0.85)
    highscore.zPosition = 10.0
    highscore.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - highscore.size.height - 50.0)
    addChild (highscore)
                                 
    let setting = SKSpriteNode(imageNamed: "settings" )
    setting.name = "setting"
    setting.setScale(0.85)
    setting.zPosition = 10.0
    setting.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - setting.size.height - 50.0)
    addChild(setting)
                                 
    }
}
