//
//  PhysicsCategory.swift
//  PizzaRun iOS
//
//  Copyright © 2023 Waffle Whales. All rights reserved.
//

struct PhysicsCategory {
    static let Character: UInt32 = 0b1
    static let Ground: UInt32 = 0b10
    static let Obstacle: UInt32 = 0b100
    static let Cloud: UInt32 = 0b1000
    static let Ingridient: UInt32 = 0b10000
    static let Ananas: UInt32 = 0b100000
    static let Knife: UInt32 = 0b1000000
}
