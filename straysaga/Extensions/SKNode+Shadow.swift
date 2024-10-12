//
//  SKNode+Shadow.swift
//  straysaga
//
//  Created by Petre Chkonia on 09.10.24.
//

import SpriteKit

extension SKNode {
    
    var shadow: SKSpriteNode? {
        return childNode(withName: "shadow") as? SKSpriteNode
    }
}

extension SKSpriteNode {
    
    func setShadow(with texture: SKTexture?, inAir: Bool) {
        
        // Remove existing shadow if any
        childNode(withName: "shadow")?.removeFromParent()
        
        let shadow = SKSpriteNode(texture: texture)
        shadow.position = CGPoint(x: 0, y: inAir ? (anchorPoint.y == 0 ? size.height / 5 : -size.height / 2) : 0)
        shadow.yScale = -0.5
        shadow.anchorPoint = anchorPoint
        shadow.zPosition = -1
        shadow.color = .black
        shadow.colorBlendFactor = 1.0
        shadow.alpha = 0.35
        shadow.name = "shadow"
        addChild(shadow)
    }
}
