//
//  GameEntity.swift
//  straysaga
//
//  Created by Petre Chkonia on 20.09.24.
//

import GameplayKit

class GameEntity: GKEntity {
    
    let type: GameObjectType
    let faction: Faction
    
    // MARK: - Stats
    
    var maxAttack: Int
    
    private var _attack: Int
    var attack: Int {
        get {
            return _attack
        }
        set {
            _attack = max(newValue, 0)
        }
    }
    
    var maxAgility: Int
    
    private var _agility: Int
    var agility: Int {
        get {
            return _agility
        }
        set {
            _agility = max(newValue, 0)
        }
    }
    
    var maxHealth: Int
    
    private var _health: Int
    var health: Int {
        get {
            return _health
        }
        set {
            _health = min(max(newValue, 0), maxHealth)
        }
    }
    
    // MARK: - init
    
    init(type: GameObjectType, faction: Faction,
         atk: Int, agi: Int, hp: Int, actions: [ActionType]? = nil, skills: [ActionType] = []) {
        
        self.type = type
        self.faction = faction
        
        self.maxAttack = atk
        self._attack = atk
        
        self.maxAgility = agi
        self._agility = agi
        
        self.maxHealth = hp
        self._health = hp
               
        super.init()
        
        // Render Component
        addComponent(RenderComponent())
        
        // Turn Component
        addComponent(TurnComponent())
        
        // Effect Component
        addComponent(EffectComponent())
        
        // Action Component
        addComponent(ActionComponent(actions: actions ?? type.availableActions, skills: skills))
        
        if !GameObject.petList.contains(type) {
            addComponent(HealthComponent())
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - GameEntity + Faction

extension GameEntity {
    enum Faction {
        case allies
        case enemies
    }
}
