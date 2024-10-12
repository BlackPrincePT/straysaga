//
//  BattleScene.swift
//  straysaga
//
//  Created by Petre Chkonia on 06.10.24.
//

import SpriteKit

class BattleScene: SKScene {
    
    var darkOverlay: SKSpriteNode
    
    let goldXPLabel: GoldXPLabel = GoldXPLabel()
    let dropsBanner: DropsBanner = DropsBanner()
    
    let battleground = SKSpriteNode(imageNamed: "battleground_\(LocationType.forest)")
    var currentLocationType: LocationType = .forest {
        didSet {
            guard let locationArray = GameObject.locationMap[currentLocationType]?.values else { return }
            
            battleground.texture = locationArray.first?.battleground
            
            dropsBanner.itemTypes.removeAll()
             
            for location in locationArray {
                location.drops.forEach { if !dropsBanner.itemTypes.contains($0.type) { dropsBanner.itemTypes.append($0.type) }}
            }
            
            var minGold = Int.max
            var maxGold = Int.min
            var minXP = Int.max
            var maxXP = Int.min

            for location in locationArray {
                minGold = min(minGold, location.gold.lowerBound)
                maxGold = max(maxGold, location.gold.upperBound)
                
                minXP = min(minXP, location.xp.lowerBound)
                maxXP = max(maxXP, location.xp.upperBound)
            }
            
            goldXPLabel.gold = "\(minGold)...\(maxGold)"
            goldXPLabel.xp = "\(minXP)...\(maxXP)"
        }
    }
    
    let menuButtonTitles = ["Forest", "Castle", "Cromlech", "Graveyard"]
    let difficultyButtonTitles = ["Easy", "Hard", "Extreme"]
    
    let fadeShader = SKShader(source: """
    void main() {
        // Get the texture coordinate
        vec2 uv = v_tex_coord;
        
        // Sample the texture color
        vec4 color = texture2D(u_texture, uv);
        
        // Calculate the distance from the center (0.5, 0.5)
        float dist = distance(uv, vec2(0.5, 0.5));
        
        // Define the fade range
        float fadeStart = 0.4; // Start fading at 40% from the center
        float fadeEnd = 0.5;   // Fully faded at 50% from the center
        
        // Compute the fade factor using smoothstep for smooth transition
        float fade = smoothstep(fadeStart, fadeEnd, dist);
        
        // Adjust the alpha based on the fade factor
        float newAlpha = color.a * (1.0 - fade);
        
        // Optionally, set RGB to zero as it fades to avoid color artifacts
        vec3 newRGB = color.rgb * (1.0 - fade);
        
        // Set the final color with updated RGB and alpha
        gl_FragColor = vec4(newRGB, newAlpha);
    }
""")
    
    let margin: CGFloat = 32.0
    
    override init(size: CGSize) {
        self.darkOverlay = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.95), size: size)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        // Set the scale mode to scale to fit the window
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        currentLocationType = .forest
        
        // Background
        let background = SKSpriteNode(imageNamed: "background_menu")
        background.zPosition = Layer.background.rawValue
        addChild(background)
        
        darkOverlay.zPosition = Layer.overlay.rawValue
        darkOverlay.alpha = 0
        addChild(darkOverlay)
        
        let esc = SKLabelNode(fontNamed: "Straight pixel gothic")
        esc.position = CGPoint(x: viewRight - margin, y: viewTop - insets.top - margin)
        esc.zPosition = Layer.ui.rawValue
        esc.text = "><"
        esc.fontSize = 64
        esc.fontColor = .red
        esc.verticalAlignmentMode = .top
        esc.horizontalAlignmentMode = .right
        esc.name = "Back"
        addChild(esc)
        
        for (index, buttonTitle) in menuButtonTitles.enumerated() {
            let button = SKLabelNode(fontNamed: "Straight pixel gothic")
            button.position = CGPoint(x: viewLeft + insets.left + margin, y: 144 - CGFloat(index) * 96)
            button.zPosition = Layer.ui.rawValue
            button.text = buttonTitle
            button.fontSize = 64
            button.fontColor = buttonTitle.lowercased() == currentLocationType.rawValue ? .white : .darkGray
            button.verticalAlignmentMode = .center
            button.horizontalAlignmentMode = .left
            button.name = buttonTitle
            addChild(button)
        }
        
        battleground.position = CGPoint(x: 0, y: 96)
        battleground.zPosition = Layer.background.rawValue + 1
        battleground.setScale(0.2)
        battleground.shader = fadeShader
        addChild(battleground)
        
        dropsBanner.position = CGPoint(x: viewRight - insets.right - margin - dropsBanner.size.width, y: 48)
        dropsBanner.zPosition = Layer.background.rawValue + 1
        addChild(dropsBanner)
        
        let battleLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
        battleLabel.position = CGPoint(x: viewRight - insets.right - margin - dropsBanner.size.width, y: -144)
        battleLabel.text = "Battle"
        battleLabel.zPosition = Layer.ui.rawValue
        battleLabel.fontSize = 48
        battleLabel.fontColor = .red
        battleLabel.verticalAlignmentMode = .center
        battleLabel.horizontalAlignmentMode = .center
        battleLabel.name = "ToBattle"
        addChild(battleLabel)
        
        goldXPLabel.position = CGPoint(x: 0, y: -96)
        addChild(goldXPLabel)
    }
    
    //MARK: - TOUCH HANDLING
    
    /* ################################################################ */
    /*                    TOUCH HANDLERS STARTS HERE                    */
    /* ################################################################ */
    
    private func toBattle() {
        for (index, buttonTitle) in difficultyButtonTitles.enumerated() {
            let button = SKLabelNode(fontNamed: "Straight pixel gothic")
            button.position = CGPoint(x: 224 * CGFloat(index - 1), y: 0)
            button.text = buttonTitle
            button.zPosition = Layer.overlay.rawValue + 1
            button.fontSize = 64
            button.fontColor = switch buttonTitle { case "Hard": .red; case "Extreme": .orange; default: .green }
            button.verticalAlignmentMode = .center
            button.horizontalAlignmentMode = .center
            button.name = buttonTitle
            addChild(button)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        guard darkOverlay.alpha == 0 else {
            if let nodeName = atPoint(pos).name, difficultyButtonTitles.contains(nodeName),
               let difficulty = Difficulty(rawValue: nodeName.lowercased()),
               let location = GameObject.locationMap[currentLocationType]?[difficulty] {
                
                // TODO: Update Here
                let teacher = GameEntity(type: .teacher, faction: .allies, atk: 20, agi: 15, hp: 1000, skills: [.fire_flower, .fireball, .nuclear_explosion, .magma_geyser])
                let pet = GameEntity(type: .dragon, faction: .allies, atk: 5, agi: 13, hp: 100)
                
                let sceneToMoveTo = GameScene(location: location, allies: [teacher, pet])
                let transition = SKTransition.fade(withDuration: 0.5)
                
                self.view?.presentScene(sceneToMoveTo, transition: transition)
            } else {
                difficultyButtonTitles.forEach { childNode(withName: $0)?.removeFromParent() }
                darkOverlay.alpha = 0
            }
            return
        }
        
        if let node = atPoint(pos) as? SKLabelNode, let nodeName = node.name, menuButtonTitles.contains(nodeName),
           let locationType = LocationType(rawValue: nodeName.lowercased()) {
            
            node.fontColor = .white
            
            for menuButtonTitle in menuButtonTitles where menuButtonTitle != nodeName {
                let button = childNode(withName: menuButtonTitle) as? SKLabelNode
                button?.fontColor = .darkGray
            }
            
            currentLocationType = locationType
        }
        
        switch atPoint(pos).name {
        case "Back":
            let sceneToMoveTo = MainMenuScene(size: size)
            let transition = SKTransition.fade(withDuration: 0.5)
            
            self.view?.presentScene(sceneToMoveTo, transition: transition)
        case "ToBattle":
            darkOverlay.alpha = 1
            toBattle()
        default:
            break
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
