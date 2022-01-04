//
//  Enemy.swift
//  WarFly
//
//  Created by Даниил Франк on 31.12.2021.
//

import SpriteKit

class Enemy: SKSpriteNode {

    var enemyTexture: SKTexture!
    static var textureAtlas: SKTextureAtlas?
    
    init(enemyTexture: SKTexture){
        let texture = enemyTexture
        super.init(texture: texture, color: .clear, size: CGSize(width: 221, height: 204))
        self.xScale = 0.5
        self.yScale = -0.5
        self.zPosition = 20
        self.name = "sprite"
        
        self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.enemy
        self.physicsBody?.collisionBitMask = BitMaskCategory.player | BitMaskCategory.shot
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player | BitMaskCategory.shot
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flySpiral(){
        
        let screen = UIScreen.main.bounds
        
        let timeHorizontal: Double = 2
        let timeVertical: Double = 5
        
        let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)
        moveLeft.timingMode = .easeInEaseOut
        let moveRight = SKAction.moveTo(x: screen.width - 50, duration: timeHorizontal)
        moveRight.timingMode = .easeInEaseOut
        
        let randomNumber = Int(arc4random_uniform(2))
        let asideMovementSequense = randomNumber == EnemyDirection.right.rawValue
        ? SKAction.sequence([moveLeft, moveRight]) : SKAction.sequence([ moveRight, moveLeft])
        
        let foreverAsideMovements = SKAction.repeatForever(asideMovementSequense)
        let forwardMovement = SKAction.moveTo(y: -105, duration: timeVertical)
        let groupedMovements = SKAction.group([foreverAsideMovements, forwardMovement])
        self.run(groupedMovements)
    }
}

enum EnemyDirection: Int {
    case left = 0
    case right = 1
}
