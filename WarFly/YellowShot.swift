//
//  YellowShot.swift
//  WarFly
//
//  Created by Даниил Франк on 03.01.2022.
//

import SpriteKit

class YellowShot: Shot {
    
    init(){
        let textureAtlas = SKTextureAtlas(named: "YellowAmmo")
        super.init(textureAtlas: textureAtlas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
