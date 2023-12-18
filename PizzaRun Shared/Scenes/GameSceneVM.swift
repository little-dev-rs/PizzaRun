//
//  GameSceneVM.swift
//  PizzaRun iOS
//
//  Copyright © 2023 Waffle Whales. All rights reserved.
//

import Foundation

class GameSceneVM {

    var character: GameObject = .init(imageName: "cook1",
                                      name: "Character",
                                      physicsCategory: PhysicsCategory.Character,
                                      contactCategory: PhysicsCategory.Ananas | PhysicsCategory.Tomato | PhysicsCategory.Cheese | PhysicsCategory.Basil | PhysicsCategory.Pizza | PhysicsCategory.Knife,
                                      zPosition: 5,
                                      scale: 3)
    
    var cloud: GameObject = .init(imageName: "cloud1", name: "Cloud", physicsCategory: PhysicsCategory.Cloud, contactCategory: nil, zPosition: 2.0, scale: 10)
    
    var obstacles: Set<GameObject> = [
        .init(imageName: "ananas", name: "Ananas", physicsCategory: PhysicsCategory.Ananas, contactCategory: PhysicsCategory.Character, scale: 3.0),
        .init(imageName: "tomato", name: "Tomato", physicsCategory: PhysicsCategory.Tomato, contactCategory: PhysicsCategory.Character, scale: 2),
        .init(imageName: "basil", name: "Basil", physicsCategory: PhysicsCategory.Basil, contactCategory: PhysicsCategory.Character, scale: 2),
        .init(imageName: "knife", name: "Knife", physicsCategory: PhysicsCategory.Knife, contactCategory: PhysicsCategory.Character, scale: 0.5)]

}
