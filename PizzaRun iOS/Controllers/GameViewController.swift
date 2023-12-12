//
//  GameViewController.swift
//  PizzaRun iOS
//
//  Copyright © 2023 Waffle Whales. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: .init(width: 2048, height: 1536))//GameScene.newGameScene()
        scene.scaleMode = .aspectFill


        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = false
        skView.presentScene(scene)

    }

}
