//
//  MenuScene.swift
//  WarFly
//
//  Created by Даниил Франк on 04.01.2022.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        if !Assets.shared.isLoaded{
            Assets.shared.prelodAtlases()
            }
        
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        let header = SKSpriteNode(imageNamed: "header1")
        header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        self.addChild(header)
        
        let titles = ["play", "options", "best"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(title: title, backgroundName: "button_background")
            button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
            button.name = title
            button.label.name = title
            addChild(button)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let locaion = touches.first!.location(in: self)
        let node = self.atPoint(locaion)
        
        if node.name == "play" {
            let transition = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
    }
}