//
//  Island.swift
//  WarFly
//
//  Created by Даниил Франк on 27.12.2021.
//

import SpriteKit
import GameplayKit

class Island: SKSpriteNode {

    static func populateIsland(at point: CGPoint) -> Island {
        let islandImageName = configurateImageName()
        let island = Island(imageNamed: islandImageName)
        island.setScale(randomScaleFactor)
        island.zPosition = 1
        island.position = point
        island.run(rotateForRandomAngle())
        
        return island
    }
    
    static func configurateImageName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = distribution.nextInt()
        let imageName = "is" + "\(randomNumber)"
        
        return imageName
    }
    
    static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
    static func rotateForRandomAngle() -> SKAction {
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt())
        
        return SKAction.rotate(byAngle: randomNumber * (Double.pi / 180), duration: 0)
    }
}
