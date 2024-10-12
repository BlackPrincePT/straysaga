//
//  Button.swift
//  straysaga
//
//  Created by Petre Chkonia on 02.10.24.
//

import SpriteKit

class Button: SKSpriteNode {
    
    let icon: SKSpriteNode
    
    init(iconNamed: String) {
        self.icon = SKSpriteNode(imageNamed: iconNamed)
        
        let background = SKTexture(imageNamed: "button_background")
        
        super.init(texture: background, color: .clear, size: CGSize(width: 51, height: 51))
        
        zPosition = Layer.ui.rawValue
        
        icon.alpha = 0.7
        icon.size = CGSize(width: 32, height: 32)
        icon.zPosition += 1
        
        addChild(icon)
        
        // Setting the initial alpha of only the background
        self.color = .black.withAlphaComponent(0.5)
        self.colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ActionButton: Button {
    
    private let cooldownLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
    
    var cooldown: Int = 0 {
        didSet {
            if cooldown == 0 {
                cooldownLabel.text = nil
                color = .black.withAlphaComponent(0.5)
                icon.alpha = 0.7
            } else {
                cooldownLabel.text = String(cooldown)
                color = .black.withAlphaComponent(0.3)
                icon.alpha = 0.5
            }
        }
    }
    
    override init(iconNamed: String) {
        super.init(iconNamed: iconNamed)
        
        cooldownLabel.zPosition += 1
        cooldownLabel.fontSize = 48
        cooldownLabel.fontColor = .red
        cooldownLabel.verticalAlignmentMode = .center
        cooldownLabel.horizontalAlignmentMode = .center
        addChild(cooldownLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
