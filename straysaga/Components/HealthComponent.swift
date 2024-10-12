//
//  HealthComponent.swift
//  straysaga
//
//  Created by Petre Chkonia on 21.09.24.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {
    
    private let healthMeter = HealthBar()
    
    private var hurtAnimationSettings: Animation!
    private var deadAnimationSettings: Animation!
    
    override func didAddToEntity() {
        guard
            let gameEntity = entity as? GameEntity else { return }
        
        hurtAnimationSettings = Animation(textures: SKTexture.loadTextures(sheet: "\(gameEntity.type)_hurt"))
        deadAnimationSettings = Animation(textures: SKTexture.loadTextures(sheet: "\(gameEntity.type)_dead"))
        
        healthMeter.xScale = componentNode.xScale
        healthMeter.position = CGPoint(x: 0, y: 100)
        healthMeter.zPosition += 1
        
        componentNode.addChild(healthMeter)
        
        updateHealthBar()
    }
    
    func updateHealth(amount: Int, byEffect: Bool = false) async {
        guard
            let gameEntity = entity as? GameEntity else { return }
        
        gameEntity.health += amount
        updateHealthBar()
        
        Task {
            if !byEffect {
                await componentNode.textAnimation(text: "\(amount)", color: amount > 0 ? .green : .red)
            }
        }
        
        if amount < 0 {
            if gameEntity.health == 0 {
                
                DispatchQueue.main.async {
                    if let scene = self.componentNode.scene as? GameScene {
                        scene.entities.removeAll(where: { $0 == gameEntity })
                    }
                }
                
                await componentNode.removeAllActions()
                await componentNode.runAnimation(with: deadAnimationSettings)
                await componentNode.removeFromParent()
            } else if !byEffect {
                await componentNode.runAnimation(with: hurtAnimationSettings)
            }
        }
    }
    
    private func updateHealthBar() {
        guard
            let gameEntity = entity as? GameEntity else { return }
        
        let hpElements = [healthMeter.corner2, healthMeter.bar, healthMeter.corner1]
        let hpPercentage: Double = max(0, min(1, Double(gameEntity.health) / Double(gameEntity.maxHealth)))
        let hpFullBarMaxWidth = 111.0
        
        for i in 0...2 {
            hpElements[i]?.isHidden = (i == 0 && hpPercentage != 1.0) || (i != 1 && hpPercentage == 0)
        }
        
        let newWidth = hpPercentage * hpFullBarMaxWidth
        hpElements[1]?.size.width = newWidth
    }
    
}
