//
//  Background.swift
//  WarFly
//
//  Created by Даниил Франк on 26.12.2021.
//

import SpriteKit

class Background: SKSpriteNode {
    
    static func populateBackground(at point: CGPoint) -> Background{
        
        let background = Background(imageNamed: "background")
        background.position = point
        background.zPosition = 0
        
        return background
    }
}
