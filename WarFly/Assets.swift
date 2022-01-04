//
//  Assets.swift
//  WarFly
//
//  Created by Даниил Франк on 04.01.2022.
//

import SpriteKit

class Assets {
    static let shared = Assets()
    
    let yellowAmmoAtlas = SKTextureAtlas(named: "YellowAmmo")
    let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
    let bluePowerUpAtlas = SKTextureAtlas(named: "BluePowerUp")
    let enemy_2Atlas = SKTextureAtlas(named: "Enemy_2")
    let enemy_1Atlas = SKTextureAtlas(named: "Enemy_1")
    let playerPlaneAtlas = SKTextureAtlas(named: "PlayerPlane")
    
    func prelodAtlases(){
        yellowAmmoAtlas.preload { print("yellowAmmoAtlas.preload") }
        greenPowerUpAtlas.preload { print("greenPowerUpAtlas.preload") }
        bluePowerUpAtlas.preload { print("bluePowerUpAtlas.preload") }
        enemy_2Atlas.preload { print("enemy_2Atlas.preload") }
        enemy_1Atlas.preload { print("enemy_1Atlas.preload") }
        playerPlaneAtlas.preload { print("playerPlaneAtlas.preload") }
    }
}
