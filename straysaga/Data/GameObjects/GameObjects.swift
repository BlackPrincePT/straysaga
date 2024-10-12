//
//  GameObjects.swift
//  straysaga
//
//  Created by Petre Chkonia on 18.09.24.
//

import SpriteKit

enum Layer: CGFloat {
    case background = 0.0
    case entity = 10.0
    case activeEntity = 20.0
    case skill = 30.0
    case ui = 40.0
    case overlay = 50.0
}

enum GameObjectType: String, CaseIterable {
    
    // Amazon
    case shield_amazon
    case spear_amazon
    case sword_amazon
    
    // Dwarf
    case axe_dwarf
    case hammer_dwarf
    case mace_dwarf
    
    // Gladiator
    case armor_gladiator
    case basic_gladiator
    case helmet_gladiator
    
    // Goblin
    case dagger_goblin
    case ringblade_goblin
    case spear_goblin
    
    // Golem
    case copper_golem
    case lava_golem
    case stone_golem
    
    // Gorgon
    case green_gorgon
    case purple_gorgon
    case white_gorgon
    
    // Hellhound
    case single_hellhound
    case double_hellhound
    case triple_hellhound
    
    // Knight
    case red_knight
    case silver_knight
    case white_knight
    
    // Ninja
    case kunoichi
    case ninja_peasant
    case ninja_monk
    
    // Orc
    case brown_orc
    case green_orc
    case woman_orc
    
    // Pyromancer
    case dagger_pyromancer
    case monk_pyromancer
    case woman_pyromancer
    
    // Samurai
    case archer_samurai
    case basic_samurai
    case commander_samurai
    
    // Skeleton
    case archer_skeleton
    case spearman_skeleton
    case warrior_skeleton
    
    // Slime
    case blue_slime
    case green_slime
    case red_slime
    
    // Werewolf
    case black_werewolf
    case red_werewolf
    case white_werewolf
    
    // Witch
    case blonde_witch
    case cloak_witch
    case elf_witch
    
    // Wizard
    case lightning_mage
    case teacher
    case wanderer
    
    // Yokai
    case karasu_tengu
    case kitsune
    case yamabushi_tengu
    
    // Pets
    case dragon
    case lizard
    case fox
    
    /* ------------------ Properties ------------------ */
    
    var basicAttackPhaseCount: Int {
        switch self {
        case .dragon:
            return 1
        case .spear_amazon, .sword_amazon, .shield_amazon:
            return 2
        default:
            return 3
        }
    }
    
    var availableActions: [ActionType] {
        switch self {
        case .teacher:
            return [.attack, .flame_jet, .elixir, .comet]
        case .spear_amazon:
            return [.attack, .spear]
        default:
            return [.attack]
        }
    }
    
    var canCastSpell: Bool {
        switch self {
        case .teacher:
            true
        default:
            false
        }
    }
    
    var canShootSpell: Bool {
        switch self {
        case .teacher:
            true
        default:
            false
        }
    }
}

enum ActionType: String, CaseIterable {
    // Actions
    case attack
    case special_attack
    case flame_jet
    case elixir
    
    case arrow
    case spear

    /* ------------------ Skills ------------------ */
    
    // Fire
    case circle_explosion
    case explosion
    case fire_flower
    case fire_pillar
    case fire_shield
    case fireball
    case long_fire
    case magma_geyser
    case nuclear_explosion
    case phoenix
    case short_fire
    case sun_strike
    
    // Water
    case ice_snowflake
    case ice_spike
    case kraken
    case snowflake
    case water_explosion
    case water_geyser
    case water_hurricane
    case water_shield
    case water_splash
    case waterball
    
    // Lightning
    case blue_lightning
    case gold_lightning
    case tesla_ball
    
    // Wind
    case tornado
    case wind_spiral
    
    // Earth
    case spikes
    case long_spikes
    
    // Dark
    case comet
    case skull
    case spiral
    
    // Other
    case circle_gas_explosion
    case smoke_ghost
    case smoke_skull
    
    /* ------------------ Properties ------------------ */
    
    var sortOrder: Int {
        switch self {
        case .attack:
            return 0
        case .special_attack:
            return 1
        case .flame_jet:
            return 2
        case .arrow:
            return 3
        case .spear:
            return 4
        case .elixir:
            return 5
        default:
            return -1
        }
    }
    
    enum Category {
        case melee
        case shoot
        case cast
        case buff
        
        case physical
        case magical
    }
    
    var category: (delivery: Category, type: Category) {
        switch self {
            
        case .attack, .special_attack:
            return (.melee, .physical)
            
        case .flame_jet:
            return (.melee, .magical)

        case .elixir:
            return (.buff, .physical)
            
        case .arrow, .spear:
            return (.shoot, .physical)
            
        case .fireball, .long_fire, .short_fire, .phoenix, .waterball,
                .tesla_ball, .ice_spike, .kraken, .gold_lightning,
                .blue_lightning, .water_splash, .snowflake, .tornado, .comet, .wind_spiral:
            return (.shoot, .magical)

        case .circle_explosion, .explosion, .fire_flower, .fire_pillar,
                .magma_geyser, .nuclear_explosion, .sun_strike,
                .ice_snowflake, .water_explosion,
                .water_geyser, .water_hurricane, .spikes, .long_spikes, .skull, .spiral, .circle_gas_explosion,
                .smoke_ghost, .smoke_skull, .fire_shield, .water_shield:
            return (.cast, .magical)
        }
    }
}

enum EffectType {
    case stun
    case slow
    case burn
}

struct GameObject {
    
    /* ------------------ Basic Actions Start Here ------------------ */
    
    static private let basicAttack = Action(type: .attack, multiplier: 1, cooldown: 1)
    static private let specialAttack = Action(type: .special_attack, multiplier: 2, cooldown: 3)
    static private let flameJet = Action(type: .flame_jet, multiplier: 2, cooldown: 3)
    static private let elexir = Action(type: .elixir, multiplier: 3, cooldown: 5)
    
    static private let arrow = Action(type: .arrow, multiplier: 2, cooldown: 3)
    static private let spear = Action(type: .spear, multiplier: 2, cooldown: 3)
    
    /* ------------------ Basic Actions End Here ------------------ */
    
    /* ------------------ Skill Actions Start Here ------------------ */
    
    // Fire
    static private let circleExplosion = Action(type: .circle_explosion, multiplier: 3, cooldown: 6)
    static private let explosion = Action(type: .explosion, multiplier: 3, cooldown: 6)
    static private let fireFlower = Action(type: .fire_flower, multiplier: 3, cooldown: 6)
    static private let firePillar = Action(type: .fire_pillar, multiplier: 3, cooldown: 6)
    static private let fireShield = Action(type: .fire_shield, multiplier: 3, cooldown: 6)
    static private let fireball = Action(type: .fireball, multiplier: 3, cooldown: 6)
    static private let longFire = Action(type: .long_fire, multiplier: 3, cooldown: 6)
    static private let magmaGeyser = Action(type: .magma_geyser, multiplier: 3, cooldown: 6)
    static private let nuclearExplosion = Action(type: .nuclear_explosion, multiplier: 3, cooldown: 6)
    static private let phoenix = Action(type: .phoenix, multiplier: 3, cooldown: 6)
    static private let shortFire = Action(type: .short_fire, multiplier: 3, cooldown: 6)
    static private let sunStrike = Action(type: .sun_strike, multiplier: 3, cooldown: 6)
    
    // Water
    static private let iceSnowflake = Action(type: .ice_snowflake, multiplier: 3, cooldown: 6)
    static private let iceSpike = Action(type: .ice_spike, multiplier: 3, cooldown: 6)
    static private let kraken = Action(type: .kraken, multiplier: 3, cooldown: 6)
    static private let snowflake = Action(type: .snowflake, multiplier: 3, cooldown: 6)
    static private let waterExplosion = Action(type: .water_explosion, multiplier: 3, cooldown: 6)
    static private let waterGeyser = Action(type: .water_geyser, multiplier: 3, cooldown: 6)
    static private let waterHurricane = Action(type: .water_hurricane, multiplier: 3, cooldown: 6)
    static private let waterShield = Action(type: .water_shield, multiplier: 3, cooldown: 6)
    static private let waterSplash = Action(type: .water_splash, multiplier: 3, cooldown: 6)
    static private let waterball = Action(type: .waterball, multiplier: 3, cooldown: 6)
    
    // Lightning
    static private let blueLightning = Action(type: .blue_lightning, multiplier: 3, cooldown: 6)
    static private let goldLightning = Action(type: .gold_lightning, multiplier: 3, cooldown: 6)
    static private let teslaBall = Action(type: .tesla_ball, multiplier: 3, cooldown: 6)
    
    // Wind
    static private let tornado = Action(type: .tornado, multiplier: 3, cooldown: 6)
    static private let windSpiral = Action(type: .wind_spiral, multiplier: 3, cooldown: 6)
    
    // Earth
    static private let spikes = Action(type: .spikes, multiplier: 3, cooldown: 6)
    static private let longSpikes = Action(type: .long_spikes, multiplier: 3, cooldown: 6)
    
    // Dark
    static private let comet = Action(type: .comet, multiplier: 3, cooldown: 6)
    static private let skull = Action(type: .skull, multiplier: 3, cooldown: 6)
    static private let spiral = Action(type: .spiral, multiplier: 3, cooldown: 6)
    
    // Other
    static private let circleGasExplosion = Action(type: .circle_gas_explosion, multiplier: 3, cooldown: 6)
    static private let smokeGhost = Action(type: .smoke_ghost, multiplier: 3, cooldown: 6)
    static private let smokeSkull = Action(type: .smoke_skull, multiplier: 3, cooldown: 6)
    
    /* ------------------ Skill Actions End Here ------------------ */
    
    static var visualEffectsMap: [ActionType: Animation] = {
        var animations = [ActionType: Animation]()
        
        for action in ActionType.allCases where action.sortOrder == -1 {
            let animation = Animation(textures: SKTexture.loadTextures(atlas: action.rawValue, prefix: "\(action.rawValue)_"))
            animations[action] = animation
        }
        
        return animations
    }()
    
    static func forActionType(_ type: ActionType) -> Action {
        switch type {
            
            // Basic
        case .attack: basicAttack
        case .special_attack: specialAttack
        case .flame_jet: flameJet
        case .elixir: elexir
            
        case .arrow: arrow
        case .spear: spear
            
            // Fire
        case .circle_explosion: circleExplosion
        case .explosion: explosion
        case .fire_flower: fireFlower
        case .fire_pillar: firePillar
        case .fire_shield: fireShield
        case .fireball: fireball
        case .long_fire: longFire
        case .magma_geyser: magmaGeyser
        case .nuclear_explosion: nuclearExplosion
        case .phoenix: phoenix
        case .short_fire: shortFire
        case .sun_strike: sunStrike
            
            // Water
        case .ice_snowflake:iceSnowflake
        case .ice_spike: iceSpike
        case .kraken: kraken
        case .snowflake: snowflake
        case .water_explosion: waterExplosion
        case .water_geyser: waterGeyser
        case .water_hurricane: waterHurricane
        case .water_shield: waterShield
        case .water_splash: waterSplash
        case .waterball: waterball
            
            // Lightning
        case .blue_lightning: blueLightning
        case .gold_lightning: goldLightning
        case .tesla_ball:teslaBall
            
            // Wind
        case .tornado: tornado
        case .wind_spiral: windSpiral
            
            // Earth
        case .spikes: spikes
        case .long_spikes: longSpikes
            
            // Dark
        case .comet: comet
        case .skull: skull
        case .spiral: spiral
            
            // Other
        case .circle_gas_explosion: circleGasExplosion
        case .smoke_ghost: smokeGhost
        case .smoke_skull: smokeSkull
        }
    }
    
    static let effectMap: [EffectType: (_ target: GameEntity) -> Void] = [
        .stun: { target in
            guard let turnComponent = target.component(ofType: TurnComponent.self) else { return }
            
            turnComponent.turnStatus = false
        },
        .burn: { target in
            guard let healthComponent = target.component(ofType: HealthComponent.self) else { return }
            
            Task {
                await healthComponent.updateHealth(amount: -target.maxHealth / 25, byEffect: true)
            }
        }
    ]
    
    static let petList: [GameObjectType] = [.dragon, .lizard, .fox]
}
