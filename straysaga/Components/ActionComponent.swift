//
//  SpecialAttackComponent.swift
//  straysaga
//
//  Created by Petre Chkonia on 30.09.24.
//

import SpriteKit
import GameplayKit

class ActionComponent: GKComponent {
    
    private var visualEffectsMap = [ActionType: Animation]()
    
    private lazy var animationsMap: [ActionType: Animation] = {
        
        var tempAnimationsMap = [ActionType: Animation] ()
        
        guard
            let gameEntity = entity as? GameEntity else { return tempAnimationsMap }
        
        for actionType in gameEntity.type.availableActions {
            
            guard actionType != .attack else {
                var textures = [SKTexture]()
                for phase in 1...gameEntity.type.basicAttackPhaseCount {
                    textures += SKTexture.loadTextures(sheet: "\(gameEntity.type)_attack_\(phase)")
                }
                tempAnimationsMap[.attack] = Animation(textures: textures)
                continue
            }
            
            guard actionType.category.delivery != .cast && actionType.category.delivery != .shoot else {
                guard actionType.sortOrder != -1 else { continue }
                
                let visualEffectSettings = Animation(textures: SKTexture.loadTextures(sheet: "\(gameEntity.type)_\(actionType)"))
                visualEffectsMap[actionType] = visualEffectSettings
                
                let animationSettings = Animation(textures: SKTexture.loadTextures(sheet: "\(gameEntity.type)_\(actionType.category.delivery)"))
                tempAnimationsMap[actionType] = animationSettings
                continue
            }
            let animationSettings = Animation(textures: SKTexture.loadTextures(sheet: "\(gameEntity.type)_\(actionType)"))
            tempAnimationsMap[actionType] = animationSettings
        }
        
        return tempAnimationsMap
    }()
    
    private lazy var castSpellAnimation: Animation? = {
        guard
            let gameEntity = entity as? GameEntity,
            gameEntity.type.canCastSpell else { return nil }
        
        return Animation(textures: SKTexture.loadTextures(sheet: "\(gameEntity.type)_cast_spell"))
    }()
    
    private lazy var shootSpellAnimation: Animation? = {
        guard
            let gameEntity = entity as? GameEntity,
            gameEntity.type.canShootSpell else { return nil }
        
        return Animation(textures: SKTexture.loadTextures(sheet: "\(gameEntity.type)_shoot_spell"))
    }()
    
    var actions: [(type: ActionType, cooldown: Int)]
    var skills: [(type: ActionType, cooldown: Int)]
    
    init(actions: [ActionType], skills: [ActionType]) {
        self.actions = actions.sorted(by: { $0.sortOrder < $1.sortOrder }).map { ($0, 0) }
        self.skills = skills.map { ($0, 0) }
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performAction(of type: ActionType, on target: SKNode) {
        
        let actionSettings = GameObject.forActionType(type)
        
        updateCooldown(for: &actions, matching: actionSettings.type, with: actionSettings.cooldown)
        updateCooldown(for: &skills, matching: actionSettings.type, with: actionSettings.cooldown)
        
        if let effectType = actionSettings.effectType, let effectDuration = actionSettings.effectDuration,
           let effectComponent = target.entity?.component(ofType: EffectComponent.self) {
            effectComponent.effects[effectType] = effectDuration
        }
        
        switch actionSettings.type.category.delivery {
        case .melee:
            melee(actionSettings: actionSettings, on: target)
        case .cast:
            cast(actionSettings: actionSettings, on: target)
        case .shoot:
            shoot(actionSettings: actionSettings, on: target)
        case .buff:
            buff(actionSettings: actionSettings)
        default:
            print(actionSettings.type.category.delivery, "Can't be a delivery!")
            return
        }
    }
    
    private func updateCooldown(for list: inout [(type: ActionType, cooldown: Int)], matching type: ActionType, with cooldown: Int) {
        for index in list.indices where list[index].type == type {
            list[index].cooldown = cooldown
        }
    }
    
    func reduceAllCooldowns(for list: inout [(type: ActionType, cooldown: Int)]) {
        for index in list.indices where list[index].cooldown > 0 {
            list[index].cooldown -= 1
        }
    }
    
    //MARK: - DELIVERY FUNCTIONS START HERE
    
    /* ################################################################ */
    /*                   DELIVERY FUNCTIONS START HERE                  */
    /* ################################################################ */
    
    private func melee(actionSettings: Action, on target: SKNode) {
        guard
            let gameEntity = entity as? GameEntity else { return }
        
        guard
            let animationSettings = animationsMap[actionSettings.type] else {
            print("Couldn't find 'melee' animation!")
            return
        }
        
        guard
            let targetEntity = target.entity?.component(ofType: HealthComponent.self) else {
            print("target doesn't have a 'HealthComponent'")
            return
        }
        
        let initialPos = componentNode.position
        
        let targetPosX = target.position.x + (target.xScale * 64)
        let targetPosY = target.position.y
        
        let teleportAction = SKAction.move(to: CGPoint(x: targetPosX, y: targetPosY), duration: 0)
        let teleportBack = SKAction.move(to: initialPos, duration: 0)
        
        componentNode.run(teleportAction)
        
        Task {
            
            usleep(250_000)

            await componentNode.runAnimation(with: animationSettings)

            await targetEntity.updateHealth(amount: -gameEntity.attack * actionSettings.multiplier)
            
            usleep(250_000)
            
            await componentNode.run(teleportBack)
            
            entity?.component(ofType: TurnComponent.self)?.turnStatus = false
        }
    }
    
    private func cast(actionSettings: Action, on target: SKNode) {
        guard
            let gameEntity = entity as? GameEntity else { return }
        
        guard
            let animationSettings = animationsMap[actionSettings.type] ?? shootSpellAnimation else {
            print("Couldn't find 'cast' animation!")
            return
        }
        
        guard
            let visualEffectSettings = GameObject.visualEffectsMap[actionSettings.type] ?? visualEffectsMap[actionSettings.type] else {
            print("Couldn't find 'cast' visual effect!")
            return
        }
        
        guard
            let targetEntity = target.entity?.component(ofType: HealthComponent.self) else {
            print("target doesn't have a 'HealthComponent'")
            return
        }
        
        let body = SKSpriteNode(texture: visualEffectSettings.textures.first)
        body.position = CGPoint(x: target.position.x, y: target.position.y + 32)
        body.zPosition = Layer.skill.rawValue
        body.xScale = gameEntity.faction == .allies ? 1 : -1
        
        let textures = visualEffectSettings.textures
        let timePerFrame = visualEffectSettings.timePerFrame
        let animation = SKAction.animate(with: textures, timePerFrame: timePerFrame)
        
        let animationGroup = SKAction.group([animation ,SKAction.run { body.shadow?.run(animation) }])
        
        let bodySequence = SKAction.sequence([animationGroup, SKAction.removeFromParent()])
        
        Task {
            await componentNode.runAnimation(with: animationSettings)
            
            await componentNode.scene?.addChild(body)
            
            await body.run(bodySequence)
            
            await targetEntity.updateHealth(amount: -gameEntity.attack * actionSettings.multiplier)
            
            entity?.component(ofType: TurnComponent.self)?.turnStatus = false
        }
    }
    
    private func shoot(actionSettings: Action, on target: SKNode) {
        guard
            let gameEntity = entity as? GameEntity else { return }
        
        guard
            let animationSettings = animationsMap[actionSettings.type] ?? shootSpellAnimation else {
            print("Couldn't find 'shoot' animation!")
            return
        }
        
        guard
            let visualEffectSettings = GameObject.visualEffectsMap[actionSettings.type] ?? visualEffectsMap[actionSettings.type] else {
            print("Couldn't find 'shoot' visual effect!")
            return
        }
        
        guard
            let targetEntity = target.entity?.component(ofType: HealthComponent.self) else {
            print("target doesn't have a 'HealthComponent'")
            return
        }
        
        let body = SKSpriteNode(texture: visualEffectSettings.textures.first)
        
        body.position = CGPoint(x: componentNode.position.x, y: componentNode.position.y + 48)
        body.zPosition = Layer.skill.rawValue
        body.xScale = gameEntity.faction == .allies ? 1 : -1
        body.setShadow(with: visualEffectSettings.textures.first, inAir: true)
        
        let textures = visualEffectSettings.textures
        let timePerFrame = visualEffectSettings.timePerFrame
        let animation = SKAction.animate(with: textures, timePerFrame: timePerFrame)
        
        let moveDuration: TimeInterval = animation.duration * 0.7
        let moveToTarget = SKAction.move(to: CGPoint(x: target.position.x, y: target.position.y + 48), duration: moveDuration)
        
        let bodySequence = SKAction.sequence([SKAction.group([animation, SKAction.run { body.shadow?.run(animation) }, moveToTarget]), SKAction.removeFromParent()])
        
        Task {
            await componentNode.runAnimation(with: animationSettings)
            
            await componentNode.scene?.addChild(body)
            
            await body.run(bodySequence)
            
            await targetEntity.updateHealth(amount: -gameEntity.attack * actionSettings.multiplier)
            
            entity?.component(ofType: TurnComponent.self)?.turnStatus = false
        }
    }
    
    private func buff(actionSettings: Action) {
        guard
            let gameEntity = entity as? GameEntity,
            let scene = componentNode.scene as? GameScene else { return }
        
        // Determine the target position based on the faction
        let targetPosition = gameEntity.faction == .allies ? scene.alliesPositions[0] : scene.enemiesPositions[0]
        
        let targetEntity = scene.entities.first { entity in
            
            // Check if the entity's sprite position matches the target position
            let entityPosition = entity.component(ofType: RenderComponent.self)?.spriteNode?.position
            let positionMatches = (entityPosition == targetPosition)
            
            // Ensure the activity type is not elixir
            let isNotElixir = actionSettings.type != .elixir
            
            // Return true if both conditions are met
            return positionMatches && isNotElixir
        } ?? gameEntity
        
        guard
            let animationSettings = animationsMap[actionSettings.type] ?? shootSpellAnimation else {
            print("Couldn't find 'buff' animation!")
            return
        }

        guard
            let targetHealthComponent = targetEntity.component(ofType: HealthComponent.self) else {
            print("target doesn't have a 'HealthComponent'")
            return
        }
        
        Task {
            await componentNode.runAnimation(with: animationSettings)
            
            await targetHealthComponent.updateHealth(amount: gameEntity.attack * actionSettings.multiplier)
            
            entity?.component(ofType: TurnComponent.self)?.turnStatus = false
        }
    }
}
