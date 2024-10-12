//
//  TurnComponent.swift
//  straysaga
//
//  Created by Petre Chkonia on 28.09.24.
//

import SpriteKit
import GameplayKit

class TurnComponent: GKComponent {
    
    var turnProgress: Int = 0
    
    var turnStatus: Bool = false {
        didSet {
            guard
                let ownerEntity = entity as? GameEntity,
                let scene = componentNode.scene as? GameScene else { return }
            
            scene.selectedTargetHighlight.removeFromParent()
            
            if turnStatus && scene.battleStateMachine.currentState is IdleState {
                if let activityComponent = ownerEntity.component(ofType: ActionComponent.self) {
                    
                    activityComponent.reduceAllCooldowns(for: &activityComponent.actions)
                    activityComponent.reduceAllCooldowns(for: &activityComponent.skills)
                }
                
                if let effectComponent = ownerEntity.component(ofType: EffectComponent.self) {
                    effectComponent.applyEffects()
                }
            }
            
            if turnStatus, scene.battleStateMachine.currentState is IdleState {
                
                switch ownerEntity.faction {
                case .allies:
                    
                    if scene.battleModeStateMachine.currentState is AutoPlayingState {
                        
                        scene.battleStateMachine.enter(InProgressState.self)
                        
                        removeActivityButtons()
                        
                        automaticActivity()
                    }
                    
                    if scene.battleModeStateMachine.currentState is ManualPlayingState {
                        if !GameObject.petList.contains(ownerEntity.type) {
                            scene.activeEntity = ownerEntity
                            
                            addActivityButtons()
                            
                            determineTarget()
                        } else {
                            scene.battleStateMachine.enter(InProgressState.self)
                            
                            removeActivityButtons()
                            
                            automaticActivity()
                        }
                    }
                case .enemies:
                    scene.battleStateMachine.enter(InProgressState.self)
                    
                    removeActivityButtons()
                    
                    automaticActivity()
                    
                }
            } else {
                
                usleep(250_000)
                
                DispatchQueue.main.async {
                    scene.battleStateMachine.enter(IdleState.self)
                    
                    self.turnProgress -= 100
                    scene.activeEntity = nil
                    scene.advanceTurns()
                }
            }
        }
    }
    
    private func determineTarget() {
        guard
            let scene = componentNode.scene as? GameScene else { return }
        
        if let selectedEntity = scene.selectedTargetNode?.entity as? GameEntity, scene.entities.contains(selectedEntity) {
            scene.selectedTargetNode?.addChild(scene.selectedTargetHighlight)
        } else {
            if let targetEntity = scene.entities.sorted(by: { $0.health < $1.health })
                .first(where: { $0.faction == .enemies && !GameObject.petList.contains($0.type) }),
               let targetNode = targetEntity.component(ofType: RenderComponent.self)?.spriteNode {
                
                scene.selectedTargetNode = targetNode
                
            } else {
                scene.selectedTargetNode = nil
            }
        }
    }
    
    private func automaticActivity() {
        guard
            let ownerEntity = entity as? GameEntity,
            let scene = componentNode.scene as? GameScene,
            let targetEntity = scene.entities.sorted(by: { $0.health < $1.health })
                .first(where: { $0.faction != ownerEntity.faction && !GameObject.petList.contains($0.type) }),
            let targetNode = targetEntity.component(ofType: RenderComponent.self)?.spriteNode,
            let activityComponent = ownerEntity.component(ofType: ActionComponent.self) else {
            print("Couldn't trigger automatic activity")
            return
        }
        
        if let randomSkillType = activityComponent.skills.filter({ $0.cooldown == 0 }).randomElement()?.type {
            
            activityComponent.performAction(of: randomSkillType, on: targetNode)
            
        } else if let randomActionType = activityComponent.actions.filter({ $0.cooldown == 0 }).randomElement()?.type {
            print(randomActionType)
            activityComponent.performAction(of: randomActionType, on: targetNode)
        }
    }
    
    // MARK: - Add & Remove Activity Buttons
    
    private func addActivityButtons() {
        guard
            let scene = componentNode.scene as? GameScene else { return }
        
        scene.actionButtons.forEach {
            if $0.parent == nil {
                scene.addChild($0)
            }
        }
        
        if scene.skillSlots.parent == nil  {
            scene.addChild(scene.skillSlots)
        }
    }
    
    private func removeActivityButtons() {
        guard
            let scene = componentNode.scene as? GameScene else { return }
        
        scene.actionButtons.forEach { $0.removeFromParent() }
        
        scene.skillSlots.removeFromParent()
    }
    
}
