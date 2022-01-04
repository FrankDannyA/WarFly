//
//  BluePowerUp.swift
//  WarFly
//
//  Created by Даниил Франк on 01.01.2022.
//

import SpriteKit

class BluePowerUp: PowerUp {
    init(){
        let textureAtlas = Assets.shared.bluePowerUpAtlas
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

