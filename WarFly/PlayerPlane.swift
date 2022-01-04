//
//  PlayerPlane.swift
//  WarFly
//
//  Created by Даниил Франк on 27.12.2021.
//

import SpriteKit
import CoreMotion

class PlayerPlane: SKSpriteNode {
    
    let motionManager = CMMotionManager()
    let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    var leftTextureArrayAnimation = [SKTexture]()
    var rightTextureArrayAnimation = [SKTexture]()
    var forwardTextureArrayAnimation = [SKTexture]()
    var xAcceleration: CGFloat = 0
    var moveDirection: TurnDirection = .none
    var stillTurning = false
    let animationSpriteStrides = [(13,1,-1),(13,26,1),(13,13,1)]

    
    
    static func populate(at point: CGPoint) -> PlayerPlane {
        let texture = Assets.shared.playerPlaneAtlas
        let playerPlaneTexture = texture.textureNamed("airplane_3ver2_13")
        let playerPlane = PlayerPlane(texture: playerPlaneTexture)
        playerPlane.setScale(0.5)
        playerPlane.position = point
        playerPlane.zPosition = 40
        
        return playerPlane
    }
    
        func performFly() {
        preloadTexture()
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {[unowned self] (data, error) in
            if let data = data {
                let acceleration = data.acceleration
                self.xAcceleration = CGFloat(acceleration.x ) * 0.7 + self.xAcceleration * 0.3
            }
        }
        let planeWaitAnimation = SKAction.wait(forDuration: 1.0)
        let planeDirectionCheckAction = SKAction.run { [unowned self] in
            self.movementDirectionCheck()
        }
        let planeSequense = SKAction.sequence([planeWaitAnimation, planeDirectionCheckAction])
        let planeSequenseForever = SKAction.repeatForever(planeSequense)
        self.run(planeSequenseForever)
        }
    
    
    func checkPosition() {
        self.position.x += xAcceleration * 50
        
        if self.position.x < -70 {
            self.position.x = screenSize.width + 70
        } else if self.position.x > screenSize.width + 70{
            self.position.x = -70
        }
    }
    
    fileprivate func preloadArray(_stride:(Int, Int, Int), callback: @escaping ([SKTexture])->()){
        var array = [SKTexture]()
        
        for i in stride(from: _stride.0, through: _stride.1, by: _stride.2) {
            let number = String(format: "%02d", i)
            let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
            array.append(texture)
        }
        
        SKTexture.preload(array) {
            print("preload is done")
            callback(array)
        }
    }
    
    fileprivate func preloadTexture() {
        for i in 0...2 {
            self.preloadArray(_stride: animationSpriteStrides[i], callback: {[unowned self] array in
                switch i {
                case 0: self.leftTextureArrayAnimation = array
                case 1: self.rightTextureArrayAnimation = array
                case 2: self.forwardTextureArrayAnimation = array
                default: break
                }
            })
        }
    }

    fileprivate func movementDirectionCheck() {
    
        if xAcceleration > 0.02, moveDirection != .right, stillTurning == false {
            stillTurning = true
            moveDirection = .right
            turnPlane(direction: .right)
        } else if xAcceleration < -0.02, moveDirection != .left, stillTurning == false {
            stillTurning = true
            moveDirection = .left
            turnPlane(direction: .left)
        } else if stillTurning == false {
            turnPlane(direction: .none)
        }
    }
    
    fileprivate func turnPlane(direction: TurnDirection){
        var array = [SKTexture]()
        
        if direction == .right {
            array = rightTextureArrayAnimation
        } else if direction == .left {
            array = leftTextureArrayAnimation
        } else {
            array = forwardTextureArrayAnimation
        }
        
        let forwardAction = SKAction.animate(with: array, timePerFrame: 0.05, resize: true, restore: false)
        let backwardAction = SKAction.animate(with: array.reversed(), timePerFrame: 0.05, resize: true, restore: false)
        let sequenceAction = SKAction.sequence([forwardAction, backwardAction])
        self.run(sequenceAction) { [unowned self] in
            self.stillTurning = false
        }
    }
}

enum TurnDirection {
    case right
    case left
    case none
}
