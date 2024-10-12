//
//  MainMenuScene.swift
//  straysaga
//
//  Created by Petre Chkonia on 05.10.24.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    let menuButtonTitles = ["Battle", "Academy", "Talent", "Settings"]
    
    let margin: CGFloat = 16.0
    
    override func didMove(to view: SKView) {
        
        // Set the scale mode to scale to fit the window
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Background
        let background = SKSpriteNode(imageNamed: "background_menu")
        background.zPosition = Layer.background.rawValue
        addChild(background)
        
        for (index, buttonTitle) in menuButtonTitles.enumerated() {
            let button = SKLabelNode(fontNamed: "Straight pixel gothic")
            button.position = CGPoint(x: viewLeft + insets.left + margin, y: CGFloat(9 - index * 6) * margin)
            button.text = buttonTitle
            button.zPosition = Layer.ui.rawValue
            button.fontSize = 64
            button.fontColor = buttonTitle == "Battle" ? .orange : .white
            button.verticalAlignmentMode = .center
            button.horizontalAlignmentMode = .left
            button.name = buttonTitle
            addChild(button)
        }
    }
    
    //MARK: - TOUCH HANDLING
    
    /* ################################################################ */
    /*                    TOUCH HANDLERS STARTS HERE                    */
    /* ################################################################ */
    
    func touchDown(atPoint pos : CGPoint) {
        switch atPoint(pos).name {
        case "Battle":
            let sceneToMoveTo = BattleScene(size: size)
            let transition = SKTransition.fade(withDuration: 0.5)
            
            self.view?.presentScene(sceneToMoveTo, transition: transition)
        case "Academy":
            print("Academy")
        case "Talent":
            print("Talent")
        case "Settings":
            print("Settings")
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
