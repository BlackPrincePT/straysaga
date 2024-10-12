//
//  SKNode+RunAnimation.swift
//  straysaga
//
//  Created by Petre Chkonia on 24.09.24.
//

import SpriteKit
import GameplayKit

struct Animation {
    
    let textures: [SKTexture]
    var timePerFrame: TimeInterval
    
    init(textures: [SKTexture], timePerFrame: TimeInterval = TimeInterval( 1.0 / 10.0 )) {
        self.textures = textures
        self.timePerFrame = timePerFrame
    }
}

// MARK: - EXTENSION CODE STARTS HERE

extension SKNode {
    
    func runAnimation(with settings: Animation) async {
        
        let textures = settings.textures
        let timePerFrame = settings.timePerFrame
        let animationAction = SKAction.animate(with: textures, timePerFrame: timePerFrame)
        
        // Group the actions so they run simultaneously
        let groupAction = SKAction.group([animationAction, SKAction.run { self.shadow?.run(animationAction) }])
        
        await run(groupAction)
    }
}

extension SKNode {
    
    func textAnimation(text: String, color: SKColor) async {
        let statusDescription = SKLabelNode(fontNamed: "Straight pixel gothic")
        statusDescription.text = text
        statusDescription.fontColor = color
        statusDescription.fontSize = 32
        statusDescription.xScale = xScale
        statusDescription.position = CGPoint(x: 0, y: 120)
        statusDescription.zPosition = 100
        
        addChild(statusDescription)

        let moveUp = SKAction.moveTo(y: 130, duration: 0.5)
        let removeSelf = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([moveUp, removeSelf])
        
        await statusDescription.run(sequence)
    }
}
