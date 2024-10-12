//
//  Action.swift
//  straysaga
//
//  Created by Petre Chkonia on 03.10.24.
//

import SpriteKit

struct Action {
    let type: ActionType
    
    let multiplier: Int
    let cooldown: Int
    
    var effectType: EffectType?
    var effectDuration: Int?
    
    init(type: ActionType, multiplier: Int, cooldown: Int, effectType: EffectType? = nil, effectDuration: Int? = nil) {
        
        self.type = type
        
        self.multiplier = multiplier
        self.cooldown = cooldown
        
        self.effectType = effectType
        self.effectDuration = effectDuration
    }
}
