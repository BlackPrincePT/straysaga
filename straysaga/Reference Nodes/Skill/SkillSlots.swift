//
//  SkillSlots.swift
//  straysaga
//
//  Created by Petre Chkonia on 18.09.24.
//

import SpriteKit

class SkillSlots: SKReferenceNode {
    
    private var base: SKNode!
    
    var slots = [SKNode]()
    
    convenience init() {
        self.init(fileNamed: "SkillSlots")
        
        zPosition = Layer.ui.rawValue
        
        // Set up inner base shape
        base = childNode(withName: "//skill_slots")
        
        for i in 1...4 {
            let slot = base.childNode(withName: "skill_slot_\(i)")! // <- Force Unwrapped !!!
            slots.append(slot)
        }
    }
    
    override init(fileNamed fileName: String?) {
        super.init(fileNamed: fileName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SkillIcon: SKSpriteNode {
    
    var cooldown: Int = 0 {
        didSet {
            if cooldown == 0 {
                shader = nil
                cooldownLabel.text = nil
            } else {
                shader = blackAndWhiteShader
                cooldownLabel.text = String(cooldown)
            }
        }
    }
    
    private let cooldownLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
    
    private let blackAndWhiteShader = SKShader(source:
    """
    void main() {
        vec4 color = texture2D(u_texture, v_tex_coord);
        float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
        gl_FragColor = vec4(vec3(gray), color.a);
    }
    """
    )
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        
        super.init(texture: texture, color: .clear, size: CGSize(width: 64, height: 64))
        
        zPosition += 1
        
        cooldownLabel.zPosition += 1
        cooldownLabel.fontSize = 64
        cooldownLabel.fontColor = .red
        cooldownLabel.verticalAlignmentMode = .center
        cooldownLabel.horizontalAlignmentMode = .center
        addChild(cooldownLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
