//
//  GoldXPLabel.swift
//  straysaga
//
//  Created by Petre Chkonia on 06.10.24.
//

import SpriteKit

class GoldXPLabel: SKNode {
    
    private let goldLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
    private let xpLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
    
    var gold: String = " ... "{
        didSet {
            goldLabel.text = "Gold: \(gold)"
        }
    }
    
    var xp: String = " ... "{
        didSet {
            xpLabel.text = "XP: \(xp)"
        }
    }

    override init() {
        super.init()
        
        goldLabel.position = CGPoint(x: 0, y: 32)
        goldLabel.zPosition = Layer.ui.rawValue
        goldLabel.fontSize = 48
        goldLabel.fontColor = .yellow
        goldLabel.verticalAlignmentMode = .center
        goldLabel.horizontalAlignmentMode = .center
        addChild(goldLabel)
        
        xpLabel.position = CGPoint(x: 0, y: -32)
        xpLabel.zPosition = Layer.ui.rawValue
        xpLabel.fontSize = 48
        xpLabel.fontColor = .cyan
        xpLabel.verticalAlignmentMode = .center
        xpLabel.horizontalAlignmentMode = .center
        addChild(xpLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
