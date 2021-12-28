//
//  Cloud.swift
//  WarFly
//
//  Created by Даниил Франк on 27.12.2021.
//


import SpriteKit
import GameplayKit


final class Cloud: SKSpriteNode, GameBackgroundSpritable {
    static func populate() -> Cloud {
        let cloudImageName = configurateName()
        let cloud = Cloud(imageNamed: cloudImageName)
        cloud.setScale(randomScaleFactor)
        cloud.position = randomPoint()
        cloud.zPosition = 10
        
        cloud.run(move(from: cloud.position ))
        
        return cloud
    }
    
    fileprivate static func configurateName() -> String {
        let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomNumber = distribution.nextInt()
        let imageName = "cl" + "\(randomNumber)"
        
        return imageName
    }
    
    fileprivate static var randomScaleFactor: CGFloat {
        let distribution = GKRandomDistribution(lowestValue: 20, highestValue: 30)
        let randomNumber = CGFloat(distribution.nextInt()) / 10
        
        return randomNumber
    }

    fileprivate static func move(from point: CGPoint) -> SKAction {
        let movePoint = CGPoint(x: point.x, y: -200)
        let moveDistance = point.y + 200
        let movementSpeed: CGFloat = 150.0
        let duration = moveDistance / movementSpeed

        return SKAction.move(to: movePoint, duration: TimeInterval(duration))
    }
}
