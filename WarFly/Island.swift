//
//  Island.swift
//  WarFly
//
//  Created by Даниил Франк on 27.12.2021.
//

import SpriteKit
import GameplayKit

final class Island: SKSpriteNode,GameBackgroundSpritable {
    static func populateSptite(at point: CGPoint) -> Island {
        let islandImageName = configurateName()
        let island = Island(imageNamed: islandImageName)
        island.setScale(randomScaleFactor)
        island.zPosition = 1
        island.position = point
        
        island.run(move(from: point))
        island.run(rotateForRandomAngle())
        
        return island
    }
    
    fileprivate static func configurateName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
        let randomNumber = distribution.nextInt()
        let imageName = "is" + "\(randomNumber)"
        
        return imageName
    }
    
    fileprivate static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }
    
    fileprivate static func rotateForRandomAngle() -> SKAction {
        let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
        let randomNumber = CGFloat(distribution.nextInt())
        
        return SKAction.rotate(byAngle: randomNumber * (Double.pi / 180), duration: 0)
    }
    
    fileprivate static func move(from point: CGPoint) -> SKAction {
        let movePoint = CGPoint(x: point.x, y: -200)
        let moveDistance = point.y + 200
        let movementSpeed: CGFloat = 10.0
        let duration = moveDistance / movementSpeed
        
        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
}
