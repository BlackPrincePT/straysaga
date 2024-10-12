//
//  GameScene.swift
//  straysaga
//
//  Created by Petre Chkonia on 17.09.24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let battleStateMachine = GKStateMachine(states: [IdleState(), InProgressState()])
    let battleModeStateMachine = GKStateMachine(states: [ManualPlayingState(), AutoPlayingState()])
    
    var darkOverlay: SKSpriteNode
    
    let location: Location
    
    var actionButtons = [ActionButton]()
    let skillSlots = SkillSlots()
    
    let autoButton = Button(iconNamed: "icon_auto")
    let settingsButton = Button(iconNamed: "icon_quit")
    
    let selectedTargetHighlight = SKSpriteNode(imageNamed: "target_highlight")
    var selectedTargetNode: SKNode? {
        didSet {
            selectedTargetHighlight.removeFromParent()
            selectedTargetNode?.addChild(selectedTargetHighlight)
        }
    }
    
    var activeEntity: GameEntity? {
        didSet {
            
            actionButtons.forEach { $0.removeFromParent() }
            actionButtons.removeAll()
            
            skillSlots.slots.forEach({ $0.removeAllChildren() })
            
            guard
                let actionComponent = activeEntity?.component(ofType: ActionComponent.self) else { return }
            
            
            for (index, (actionType, cooldown)) in actionComponent.actions.enumerated() {

                let actionButton = ActionButton(iconNamed: "icon_\(actionType.category.delivery)_\(actionType.category.type)")
                actionButton.position = CGPoint(x: viewLeft + 3 * margin + CGFloat(64 * index), y: viewBottom + 48)
                addChild(actionButton)
                
                actionButtons.append(actionButton)

                actionButton.cooldown = cooldown
            }
            
            for (index, (skillType, cooldown)) in actionComponent.skills.enumerated() {
                
                guard index < skillSlots.slots.count else { return }
                
                let icon = SkillIcon(imageNamed: "\(skillType)_icon")
                      
                skillSlots.slots[index].addChild(icon)
                
                icon.cooldown = cooldown
            }
        }
    }
    
    let battleground: SKSpriteNode
    var entities: [GameEntity]
    
    init(location: Location, allies: [GameEntity]) {
        
        self.location = location
        
        self.battleground = SKSpriteNode(texture: location.battleground)
        
        self.darkOverlay = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.95), size: battleground.size)
        
        self.battleground.setScale(0.5)
        self.entities = allies + GameObject.getEnemies(for: location.type, difficulty: location.difficulty)
        
        super.init(size: battleground.size)
        
        
        
        scaleMode = .aspectFill
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        //State Machine
        battleStateMachine.enter(IdleState.self)
        battleModeStateMachine.enter(ManualPlayingState.self)
        
        //Setup
        setupUI()
        setupTargetHighlight()
        setupEntities()
        
        //Start Battle
        advanceTurns()
    }
    
    func advanceTurns() {
        
        if !entities.contains(where: { $0.faction == .enemies && $0.component(ofType: HealthComponent.self) != nil }) {
            
            // TODO: - Game Over Code
            print("-Victory-")
            
            let drops = location.loot()
            
            for drop in drops {
                GameData.shared.items[drop.key.rawValue, default: 0] += drop.value
            }
            
            darkOverlay.alpha = 1
            darkOverlay.zPosition = Layer.overlay.rawValue
            addChild(darkOverlay)
            
            let victoryLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
            victoryLabel.text = "Victory"
            victoryLabel.position = CGPoint(x: 0, y: 92)
            victoryLabel.zPosition += 1
            victoryLabel.fontSize = 128
            victoryLabel.fontColor = .green
            victoryLabel.verticalAlignmentMode = .center
            victoryLabel.horizontalAlignmentMode = .center
            
            let dropsBanner = DropsBanner()
            dropsBanner.position = CGPoint(x: viewRight - insets.right - 64 - dropsBanner.size.width, y: 0)
            darkOverlay.addChild(dropsBanner)
            
            dropsBanner.itemTypes = Array(drops.keys)
            
            let continueLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
            continueLabel.text = "Tap anywhere to continue"
            continueLabel.position = CGPoint(x: 0, y: -128)
            continueLabel.zPosition += 1
            continueLabel.fontSize = 24
            continueLabel.fontColor = .white
            continueLabel.verticalAlignmentMode = .center
            continueLabel.horizontalAlignmentMode = .center
            
            let goldXPLabel = GoldXPLabel()
            goldXPLabel.position = CGPoint(x: 0, y: -32)
            goldXPLabel.gold = String(location.gold.upperBound)
            goldXPLabel.xp = String(location.xp.upperBound)
            
            darkOverlay.addChild(victoryLabel)
            darkOverlay.addChild(continueLabel)
            darkOverlay.addChild(goldXPLabel)
            
            return
        } else if !entities.contains(where: { $0.faction == .allies && $0.component(ofType: HealthComponent.self) != nil }) {
            
            // TODO: - Game Over Code
            print("-Defeat-")
            
            darkOverlay.alpha = 1
            darkOverlay.zPosition = Layer.overlay.rawValue
            addChild(darkOverlay)
            
            let defeatLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
            defeatLabel.text = "Defeat"
            defeatLabel.position = CGPoint(x: 0, y: 92)
            defeatLabel.zPosition += 1
            defeatLabel.fontSize = 128
            defeatLabel.fontColor = .red
            defeatLabel.verticalAlignmentMode = .center
            defeatLabel.horizontalAlignmentMode = .center
            
            let continueLabel = SKLabelNode(fontNamed: "Straight pixel gothic")
            continueLabel.text = "Tap anywhere to continue"
            continueLabel.position = CGPoint(x: 0, y: -128)
            continueLabel.zPosition += 1
            continueLabel.fontSize = 24
            continueLabel.fontColor = .white
            continueLabel.verticalAlignmentMode = .center
            continueLabel.horizontalAlignmentMode = .center
            
            darkOverlay.addChild(defeatLabel)
            darkOverlay.addChild(continueLabel)
            
            return
        }
        
        repeat {
            var battleParticipantEntities = entities.compactMap({ $0.component(ofType: TurnComponent.self) })
            
            for battleParticipant in battleParticipantEntities {
                
                battleParticipant.turnProgress += (battleParticipant.entity as! GameEntity).agility // <- Force Unwrapped !!!
                
            }
            
            battleParticipantEntities.sort(by: { $0.turnProgress > $1.turnProgress })
            
            
            if let highestTurnProgressParticipant = battleParticipantEntities.first,
               highestTurnProgressParticipant.turnProgress >= 100 {
                
                highestTurnProgressParticipant.turnStatus = true
                
                break
            }
            
        } while true
    }
    
    // MARK: - Setup Code Starts Here
    
    let margin: CGFloat = 16.0
    
    lazy var alliesPositions: [CGPoint] = [
        CGPoint(x: viewLeft + size.width * 0.25, y: -128),
        CGPoint(x: viewLeft + size.width * 0.25 - 128, y: -128 + 64),
        CGPoint(x: viewLeft + size.width * 0.25 - 128, y: -128 - 64)
    ]
    
    lazy var enemiesPositions: [CGPoint] = [
        CGPoint(x: viewRight - size.width * 0.25, y: -128),
        CGPoint(x: viewRight - size.width * 0.25 + 128, y: -128 + 64),
        CGPoint(x: viewRight - size.width * 0.25 + 128, y: -128 - 64)
    ]
    
    private lazy var allyPetPosition: CGPoint = CGPoint(x: viewLeft + size.width * 0.25 - 64, y: -128)
    private lazy var enemyPetPosition: CGPoint = CGPoint(x: viewRight - size.width * 0.25 + 64, y: -128)
    
    private func setupUI() {
        battleground.setScale(0.5)
        battleground.zPosition = Layer.background.rawValue
        addChild(battleground)
        
        skillSlots.position = CGPoint(x: viewRight - margin - 148.0, y: viewTop - margin - 40.0)
        addChild(skillSlots)
        
        autoButton.position = CGPoint(x: viewRight - 3 * margin, y: viewBottom + 3 * margin)
        addChild(autoButton)
        
        settingsButton.position = CGPoint(x: viewLeft + 3 * margin, y: viewTop - 3 * margin)
        settingsButton.icon.color = .red
        addChild(settingsButton)
    }
    
    private func setupTargetHighlight() {
        
        selectedTargetHighlight.position = CGPoint(x: 0, y: 120)
        selectedTargetHighlight.zPosition += 1
        
        let moveUp = SKAction.moveTo(y: 121, duration: 0.75)
        let moveDown = SKAction.moveTo(y: 119, duration: 0.75)
        let moveUpAndDown = SKAction.sequence([moveUp, moveDown])
        let moveUpAndDownForever = SKAction.repeatForever(moveUpAndDown)
        
        selectedTargetHighlight.run(moveUpAndDownForever)
    }
    
    private func setupEntities() {
        var allyPositionIndex = 0
        var enemyPositionIndex = 0
        
        for entity in entities {
            guard let renderComponent = entity.component(ofType: RenderComponent.self) else { return }
            
            if !GameObject.petList.contains(entity.type) {
                switch entity.faction {
                case .allies:
                    renderComponent.componentNode.position = alliesPositions[allyPositionIndex]
                    allyPositionIndex += 1
                case .enemies:
                    renderComponent.componentNode.position = enemiesPositions[enemyPositionIndex]
                    enemyPositionIndex += 1
                }
            } else {
                renderComponent.componentNode.position = entity.faction == .allies ? allyPetPosition : enemyPetPosition
            }
            
            addChild(renderComponent.componentNode)
        }
    }
    
    //MARK: - TOUCH HANDLING
    
    /* ################################################################ */
    /*                    TOUCH HANDLERS STARTS HERE                    */
    /* ################################################################ */
    
    private func triggerSkill(pos: CGPoint) {
        for (index, slot) in skillSlots.slots.enumerated() {
            let convertPoint = skillSlots.convert(pos, from: self)
            
            if slot.contains(convertPoint) {
                guard
                    let activeEntity = activeEntity,
                    let targetNode = selectedTargetNode,
                    let actionComponent = activeEntity.component(ofType: ActionComponent.self) else { return }
                
                if index < actionComponent.skills.count {
                    let (skillType, cooldown) = actionComponent.skills[index]
                    
                    if cooldown == 0 {
                        battleStateMachine.enter(InProgressState.self)
                        actionComponent.performAction(of: skillType, on: targetNode)
                    }
                }
            }
        }
    }
    
    private func triggerAction(pos: CGPoint) {
        for (index, button) in actionButtons.enumerated() {
            if button.contains(pos) {
                guard
                    let activeEntity = activeEntity,
                    let targetNode = selectedTargetNode,
                    let actionComponent = activeEntity.component(ofType: ActionComponent.self) else { return }
                
                let (actionType, cooldown) = actionComponent.actions[index]
                
                if cooldown == 0 {
                    battleStateMachine.enter(InProgressState.self)
                    actionComponent.performAction(of: actionType, on: targetNode)
                }
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        guard darkOverlay.parent == nil else {
            let sceneToMoveTo = MainMenuScene(size: size)
            let transition = SKTransition.fade(withDuration: 0.5)
            
            self.view?.presentScene(sceneToMoveTo, transition: transition)
            
            return
        }
        
        if settingsButton.contains(pos) {
            if settingsButton.icon.colorBlendFactor == 0 {
                settingsButton.icon.colorBlendFactor = 1
            } else {
                let sceneToMoveTo = MainMenuScene(size: size)
                let transition = SKTransition.fade(withDuration: 0.5)
                
                self.view?.presentScene(sceneToMoveTo, transition: transition)
            }
        } else {
            settingsButton.icon.colorBlendFactor = 0
        }
        
        if autoButton.contains(pos) {
            switch battleModeStateMachine.currentState {
            case is AutoPlayingState:
                battleModeStateMachine.enter(ManualPlayingState.self)
                
                autoButton.icon.zRotation = 0
                
            case is ManualPlayingState:
                battleModeStateMachine.enter(AutoPlayingState.self)
                
                if battleStateMachine.currentState is IdleState,
                   let activeEntity = entities.first(where: { $0.component(ofType: TurnComponent.self)?.turnStatus == true}) {
                    
                    activeEntity.component(ofType: TurnComponent.self)?.turnStatus = true
                }
            default:
                break
            }
        }
        
        guard
            battleStateMachine.currentState is IdleState,
            battleModeStateMachine.currentState is ManualPlayingState,
            
            // Needs to be reviewed !!!
            entities.contains(where: { $0.faction == .allies && $0.component(ofType: TurnComponent.self)?.turnStatus == true })
        else { return }
        
        if skillSlots.contains(pos) {
            triggerSkill(pos: pos)
        } else if actionButtons.contains(where: { $0.contains(pos) }) {
            triggerAction(pos: pos)
            
        } else {
            for node in nodes(at: pos) {
                if let entity = node.entity as? GameEntity,
                   entity.faction == .enemies,
                   !GameObject.petList.contains(entity.type) {
                    selectedTargetNode = node
                }
            }
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
    
    override func update(_ currentTime: TimeInterval) {
        if battleModeStateMachine.currentState is AutoPlayingState {
            autoButton.icon.zRotation += 0.016
        }
    }
}
