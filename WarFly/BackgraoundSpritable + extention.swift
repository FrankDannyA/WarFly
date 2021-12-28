//
//  BackgraoundSpritable + extention.swift
//  WarFly
//
//  Created by Даниил Франк on 28.12.2021.
//

import SpriteKit
import GameplayKit

protocol GameBackgroundSpritable {
    static func populate() -> Self
    static func randomPoint() -> CGPoint
}

extension GameBackgroundSpritable {
    static func randomPoint() -> CGPoint {
        let screen = UIScreen.main.bounds
        let distribution = GKRandomDistribution(lowestValue: Int(screen.size.height) + 100,
                                                highestValue: Int(screen.size.height) + 200)
        let y = CGFloat(distribution.nextInt())
        let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
        return CGPoint(x: x, y: y)
    }
}
