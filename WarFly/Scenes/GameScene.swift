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
    
    var backgroundMusic: SKAudioNode!
    
    fileprivate let screenSize = UIScreen.main.bounds.size
    fileprivate var player: PlayerPlane!
    fileprivate let hud = HUD()
    fileprivate var lives = 3 {
        didSet {
            switch lives {
            case 3:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = false
            case 2:
                hud.life1.isHidden = false
                hud.life2.isHidden = false
                hud.life3.isHidden = true
            case 1:
                hud.life1.isHidden = false
                hud.life2.isHidden = true
                hud.life3.isHidden = true
            default:
                break
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        gameSettings.loadGameSettings()
        
        if gameSettings.isMusic && backgroundMusic == nil{
            if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
        }
        
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
        enumerateChildNodes(withName: "bluePowerUp") { node, stop in
            if node.position.y <= -100 {
                node.removeFromParent()
            }
        }
        enumerateChildNodes(withName: "greenPowerUp") { node, stop in
            if node.position.y <= -100 {
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
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion")
        let contactPoint = contact.contactPoint
        explosion?.position = contactPoint
        explosion?.zPosition = 25
        let waitForExplotionAction = SKAction.wait(forDuration: 1.0)
        
        let contactCategory: BitMaskCategory = [contact.bodyA.category, contact.bodyB.category]
        
        switch contactCategory {
            
        case [.enemy, .player]:  print("player vs enemy")
            
            if contact.bodyA.node?.name == "sprite" {
                if contact.bodyA.node?.parent != nil {
                    contact.bodyA.node?.removeFromParent()
                    lives -= 1
                }
            } else {
                if contact.bodyB.node?.parent != nil {
                    contact.bodyB.node?.removeFromParent()
                    lives -= 1
                }
            }
            addChild(explosion!)
            self.run(waitForExplotionAction) { explosion?.removeFromParent() }
            
            if lives == 0 {
                
                gameSettings.currentScore = hud.score
                gameSettings.saveScores()
                
                let gameOverScene = GameOverScene(size: self.size)
                let transition = SKTransition.doorsCloseVertical(withDuration: 1.0)
                gameOverScene.scaleMode = .aspectFill
                self.scene!.view?.presentScene(gameOverScene, transition: transition)
            }
            
        case [.powerUp, .player]:  print("player vs powerUp")
            
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                if contact.bodyA.node?.name == "greenPowerUp" {
                    contact.bodyA.node?.removeFromParent()
                    lives = 3
                    player.greenPowerUp()
                } else {
                    if contact.bodyB.node?.name == "greenPowerUp" {
                        contact.bodyB.node?.removeFromParent()
                        lives = 3
                        player.greenPowerUp()
                    }
                }
                
                if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil {
                    if contact.bodyA.node?.name == "bluePowerUp"{
                        contact.bodyB.node?.removeFromParent()
                        player.bluePowerUp()
                        print("BLUE")
                    } else {
                        if contact.bodyB.node?.name == "greenPowerUp" {
                            contact.bodyB.node?.removeFromParent()
                            player.bluePowerUp()
                            print("BLUE")
                        }
                    }
                }
            }
            
            
        case [.enemy, .shot]:  print("shot vs enemy")
            
            if contact.bodyA.node?.parent != nil && contact.bodyB.node?.parent != nil{
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
                hud.score += 5
                if gameSettings.isSound{
                    self.run(SKAction.playSoundFileNamed("hitSound", waitForCompletion: false))
                }
                addChild(explosion!)
                self.run(waitForExplotionAction) { explosion?.removeFromParent() }
            }
            
        default: preconditionFailure("Unable to defect collision category")
        }
        
        
        func didEnd(_ contact: SKPhysicsContact) {
            
        }
    }
}
