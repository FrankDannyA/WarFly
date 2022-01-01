//
//  GameScene.swift
//  WarFly
//
//  Created by Даниил Франк on 26.12.2021.
//
//Добавить рандомную позицию для облаков чтобы и над самолетом пролетали
//Добавить анимацю поворота для вражины

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var player: PlayerPlane!
    
    override func didMove(to view: SKView) {
        configurateStarsScene()
        spawnCloud()
        spawnIsland()
        player.performFly()
        spawnPowerUp()
        spawnEnemies()
        
}
    
    override func didSimulatePhysics(){
        player.checkPosition()
        
        enumerateChildNodes(withName: "sprite") { node, stop in
            if node.position.y < -100 {
                node.removeFromParent()
            }
        }
    }
    
    fileprivate func configurateStarsScene(){
        let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        let background = Background.populateBackground(at: screenCenterPoint)
        background.size = self.size
        self.addChild(background)
        
        let screen = UIScreen.main.bounds
            
        let island1 = Island.populate(at: CGPoint(x: 100, y: 200))
        self.addChild(island1)
        
        let island2 = Island.populate(at: CGPoint(x: self.size.width - 100, y: self.size.width - 200))
        self.addChild(island2)
        
        player = PlayerPlane.populate(at: CGPoint(x: screen.size.width / 2, y: 100))
        self.addChild(player)
    }
    
    fileprivate func spawnEnemy(){
        let enemyTextureAtlas1 = SKTextureAtlas(named: "Enemy_1")
        let enemyTextureAtlas2 = SKTextureAtlas(named: "Enemy_2")
        SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in
            
            let randomNumber = Int(arc4random_uniform(2))
            let arrayOfAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
            let textureAtlas = arrayOfAtlases[randomNumber]
            
            let waitActions = SKAction.wait(forDuration: 1.0)
            let spawnEnemy = SKAction.run { [unowned self] in
                let textureNames = textureAtlas.textureNames.sorted()
                let texture = textureAtlas.textureNamed(textureNames[12])
                let enemy = Enemy(enemyTexture: texture)
                enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 110)
                self.addChild(enemy)
                enemy.flySpiral()
            }
            let spawnAction = SKAction.sequence([waitActions, spawnEnemy])
            let repeatActions = SKAction.repeat(spawnAction, count: 3)
            self.run(repeatActions)
        }
    }
    
    fileprivate func spawnEnemies(){
        let wait = SKAction.wait(forDuration: 3.0)
        let spawnSpiralAction = SKAction.run { [unowned self] in
            self.spawnEnemy()
        }
        
        run(SKAction.repeatForever(SKAction.sequence([wait, spawnSpiralAction])))
    }
    
    fileprivate func spawnPowerUp(){
        let powerUp = BluePowerUp()
        powerUp.performRotation()
        powerUp.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(powerUp)
    }
    
    fileprivate func spawnCloud(){
        let spawnCloudWait = SKAction.wait(forDuration: 1)
        let spawnCloudAction = SKAction.run {
            let cloud = Cloud.populate(at: nil)
            self.addChild(cloud)
        }
        
        let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction])
        let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
        
        run(spawnCloudForever)
    }
    
    fileprivate func spawnIsland(){
        let spawnIslandWait = SKAction.wait(forDuration: 1)
        let spawnIslandAction = SKAction.run {
            let Island = Island.populate(at: nil)
            self.addChild(Island)
        }
        
        let spawnIslandSequence = SKAction.sequence([spawnIslandWait, spawnIslandAction])
        let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
        
        run(spawnIslandForever)
    }
}
