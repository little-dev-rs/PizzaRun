//
//  GameObject.swift
//  PizzaRun iOS
//
//  Copyright © 2023 Waffle Whales. All rights reserved.
//

import Foundation

struct GameObject: Hashable {

    let imageName: String
    let name: String
    let physicsCategory: UInt32
    let contactCategory: UInt32?
    var zPosition: CGFloat = 5.0
    let scale: Double
    var repeatCount: Int = 1

    // Implementing Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageName)
        hasher.combine(name)
        hasher.combine(physicsCategory)
        hasher.combine(contactCategory)
        hasher.combine(zPosition)
        hasher.combine(scale)
        hasher.combine(repeatCount)
    }

    // Implementing Equatable protocol
    static func ==(lhs: GameObject, rhs: GameObject) -> Bool {
        return lhs.imageName == rhs.imageName &&
        lhs.name == rhs.name &&
        lhs.physicsCategory == rhs.physicsCategory &&
        lhs.contactCategory == rhs.contactCategory &&
        lhs.zPosition == rhs.zPosition &&
        lhs.scale == rhs.scale &&
        lhs.repeatCount == rhs.repeatCount
    }

}
