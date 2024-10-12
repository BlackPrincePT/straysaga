//
//  DropsBanner.swift
//  straysaga
//
//  Created by Petre Chkonia on 06.10.24.
//

import SpriteKit

class DropsBanner: SKSpriteNode {
    
    var itemTypes = [ItemType]() {
        didSet {
            for child in children {
                if child is Item {
                    child.removeFromParent()
                }
            }
            
            for (index, itemType) in itemTypes.enumerated() {
                let item = Item(type: itemType)
                item.position = CGPoint(x: 0, y: 60 - CGFloat(index) * 40)
                addChild(item)
            }
        }
    }
    
    init() {
        let texture = SKTexture(imageNamed: "drops_banner")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        zPosition = Layer.background.rawValue + 1
        
        let dropsLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
        dropsLabel.position = CGPoint(x: 0, y: size.height / 2 - 40)
        dropsLabel.zPosition += 1
        dropsLabel.text = "Drops:"
        dropsLabel.fontColor = .darkGray
        dropsLabel.fontSize = 48
        dropsLabel.verticalAlignmentMode = .center
        dropsLabel.horizontalAlignmentMode = .center
        addChild(dropsLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
