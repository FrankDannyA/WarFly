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


class GameScene: ParentScene {
    
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate var player: PlayerPlane!
    fileprivate let hud = HUD()
    
    override func didMove(to view: SKView) {
        
        guard sceneManager.gameScene == nil else { return }
        
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        
        configurateStarsScene()
        spawnCloud()
        spawnIsland()
        player.performFly()
        spawnPowerUp()
        spawnEnemies()
        createHUD()
        
}
    
    fileprivate func createHUD() {
        addChild(hud)
        hud.configureUI(screenSize: screenSize)
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
    
    fileprivate func playerFire(){
        let shot = YellowShot()
        shot.position = self.player.position
        shot.startMovement()
        self.addChild(shot)
    }
    
    fileprivate func spawnEnemy(){
        let enemyTextureAtlas1 = Assets.shared.enemy_1Atlas
        let enemyTextureAtlas2 = Assets.shared.enemy_2Atlas 
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
        let spawnAction = SKAction.run {  [unowned self] in
            let randomNumber = Int(arc4random_uniform(2))
            let powerUp = randomNumber == 1 ? BluePowerUp() : GreenPowerUp()
            let randomXposition = arc4random_uniform(UInt32(self.size.width - 30))
            
            powerUp.position = CGPoint(x: CGFloat(randomXposition), y: (self.size.height + 100))
            powerUp.startMovement()
            self.addChild(powerUp)
        }
        
        let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
        let waitAction = SKAction.wait(forDuration: randomTimeSpawn)
        
        self.run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])))
        
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
    
    override func didSimulatePhysics(){
        player.checkPosition()
        
        enumerateChildNodes(withName: "sprite") { node, stop in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "shotSprite") { node, stop in
            if node.position.y >= self.size.height + 100 {
                node.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let locaion = touches.first!.location(in: self)
        let node = self.atPoint(locaion)
        
        if node.name == "pause" {
            let transition = SKTransition.doorway(withDuration: 1.0)
            let pauseScene = PauseScene(size: self.size)
            pauseScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(pauseScene, transition: transition)
        } else {
            playerFire()
        }
    }
}


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        
        switch contactCategory {
        case [.enemy, .player]:  print("player vs enemy")
        case [.powerUp, .player]:  print("player vs powerUp")
        case [.enemy, .shot]:  print("shot vs enemy")
        default: preconditionFailure("Unable to defect collision category")
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
