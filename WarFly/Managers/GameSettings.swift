//
//  GameSettings.swift
//  WarFly
//
//  Created by Даниил Франк on 10.01.2022.
//

import UIKit

class GameSettings: NSObject {
    
    let ud = UserDefaults.standard
    
    var isMusic = true
    var isSound = true
    
    let musicKey = "music"
    let soundKey = "sound"
    
    var hightscore: [Int] = []
    var currentScore = 0
    let hightscoreKey = "highscore"
    
    override init(){
        super.init()
        loadGameSettings()
        loadScores()
    }
    
    func saveScores(){
        hightscore.append(currentScore)
        hightscore = Array(hightscore.sorted{ $0 > $1 }.prefix(3))
        
        ud.set(hightscore, forKey: hightscoreKey)
        ud.synchronize()
    }
    
    func loadScores(){
        guard ud.value(forKey: hightscoreKey) != nil else { return }
        hightscore = ud.array(forKey: hightscoreKey) as! [Int]
    }
    
    func saveGameSettings(){
        ud.set(isMusic, forKey: musicKey)
        ud.set(isSound, forKey: soundKey)
    }
    
    func loadGameSettings(){
        guard ud.value(forKey: musicKey) != nil && ud.value(forKey: soundKey) != nil else { return }
        isMusic = ud.bool(forKey: musicKey)
        isSound = ud.bool(forKey: soundKey)
    }
}
