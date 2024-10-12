//
//  RenderComponent.swift
//  straysaga
//
//  Created by Petre Chkonia on 20.09.24.
//

import SpriteKit
import GameplayKit

class RenderComponent: GKComponent {
    
    lazy var spriteNode: SKSpriteNode? = {
        entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode
    }()
    
    override func didAddToEntity() {
        guard
            let gameEntity = entity as? GameEntity else { return }
        
        let idleAnimationTextures = SKTexture.loadTextures(sheet: "\(gameEntity.type)_idle")
        
        spriteNode = SKSpriteNode(texture: idleAnimationTextures.first)
        
        spriteNode?.entity = entity
        spriteNode?.zPosition = Layer.entity.rawValue
        spriteNode?.anchorPoint = CGPoint(x: 0.5, y: 0)
        spriteNode?.xScale = (gameEntity.faction == .allies) ? 1 : -1
        spriteNode?.setShadow(with: idleAnimationTextures.first, inAir: GameObject.petList.contains(gameEntity.type))
        
        let idleAnimation = SKAction.animate(with: idleAnimationTextures, timePerFrame: 0.1)
        
        let idleForever = SKAction.repeatForever(idleAnimation)
        let shadowIdleForever = SKAction.run { self.componentNode.shadow?.run(idleForever) }
        let actionGroup = SKAction.group([idleForever, shadowIdleForever])
        
        componentNode.run(actionGroup)
    }
}
