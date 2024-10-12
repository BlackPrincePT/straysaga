//
//  EffectComponent.swift
//  straysaga
//
//  Created by Petre Chkonia on 05.10.24.
//

import GameplayKit

class EffectComponent: GKComponent {
    
    var effects: [EffectType: Int]
    
    init(effects: [EffectType: Int] = [:]) {
        self.effects = effects
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyEffects() {
        
        guard let ownerEntity = entity as? GameEntity else { return }
        
        // Apply effects where duration is not zero
        for (effectType, duration) in effects where duration != 0 {
            if let applyEffectTo = GameObject.effectMap[effectType] {
                applyEffectTo(ownerEntity)
            }
        }
        
        Task {
            // Handle text animations and reduce the effect duration
            for (effectType, duration) in effects where duration != 0 {
                await componentNode.textAnimation(text: "\(effectType)(\(duration))", color: .white)
                
                effects[effectType] = duration - 1
            }
        }
    }
    
}

