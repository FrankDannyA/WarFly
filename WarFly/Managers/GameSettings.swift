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
    
    override init(){
        super.init()
            loadGameSettings()
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
