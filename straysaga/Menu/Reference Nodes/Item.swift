//
//  Item.swift
//  straysaga
//
//  Created by Petre Chkonia on 06.10.24.
//

import SpriteKit

class Item: SKSpriteNode {
    
    let type: ItemType
    
    init(type: ItemType) {
        
        self.type = type
        
        let texture = SKTexture(imageNamed: "\(type)_item")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        zPosition = Layer.ui.rawValue + 1
        
        let shadow = SKSpriteNode(texture: texture)
        shadow.position = CGPoint(x: 3, y: -3)
        shadow.zPosition = -1
        shadow.color = .black
        shadow.colorBlendFactor = 1.0
        shadow.alpha = 0.25
        addChild(shadow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

