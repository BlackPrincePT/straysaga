//
//  GameObjects+Location.swift
//  straysaga
//
//  Created by Petre Chkonia on 09.10.24.
//

import Foundation

enum LocationType: String {
    case forest
    case castle
    case cromlech
    case graveyard
}

enum Difficulty: String {
    case easy
    case hard
    case extreme
}

enum ItemType: String {
    
    // Forest
    case flower
    case ladybug
    case leaf
    case sapling
    case mushroom
    
    // Castle
    case book
    case cup
    case scroll
    case potion
    case mirror
    
    // Cromlech
    case ring
    case artefact
    case gem
    case beaststone
    case fairy
    
    // Graveyard
    case skull
    case finger
    case spine
    case necklace
    case eyes
}

extension GameObject {
    
    static let firecaller = GameEntity(type: .woman_pyromancer, faction: .enemies, atk: 15, agi: 12, hp: 150, skills: [.fireball])
    static let robewitch = GameEntity(type: .cloak_witch, faction: .enemies, atk: 20, agi: 13, hp: 100, skills: [.spiral])
    
    static let archersamurai = GameEntity(type: .archer_samurai, faction: .enemies, atk: 10, agi: 10, hp: 300)
    
    // MARK: - Locations
    
    static func getEnemies(for location: LocationType, difficulty: Difficulty) -> [GameEntity] {
        switch location {
        case .forest:
            switch difficulty {
            case .easy: return [
                // Slimes
                [GameEntity(type: .green_slime, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .blue_slime, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .green_slime, faction: .enemies, atk: 10, agi: 5, hp: 150)],
                
                // Goblins
                [GameEntity(type: .ringblade_goblin, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .dagger_goblin, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .spear_goblin, faction: .enemies, atk: 10, agi: 5, hp: 150)]
            ].randomElement()!
            case .hard: return [
                // Ninjas
//                [GameEntity(type: .kunoichi, faction: .enemies, atk: 30, agi: 15, hp: 500),
//                 GameEntity(type: .ninja_peasant, faction: .enemies, atk: 20, agi: 10, hp: 300),
//                 GameEntity(type: .ninja_monk, faction: .enemies, atk: 20, agi: 10, hp: 300)],
                
                // Amazons (2x)
                [GameEntity(type: .shield_amazon, faction: .enemies, atk: 30, agi: 15, hp: 500),
                 GameEntity(type: .spear_amazon, faction: .enemies, atk: 20, agi: 10, hp: 300)],
            ].randomElement()!
            case .extreme: return [
                // Witch & Pyromancer
                [GameEntity(type: .blonde_witch, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .dagger_pyromancer, faction: .enemies, atk: 10, agi: 5, hp: 150)],
                
                // Witch & Dwarf $ Amazon
                [GameEntity(type: .elf_witch, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .mace_dwarf, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .sword_amazon, faction: .enemies, atk: 20, agi: 10, hp: 300)],
            ].randomElement()!
            }
        case .castle:
            switch difficulty {
            case .easy: return 
                // Slimes
                [robewitch]
            case .hard: return [
                // Ninjas
                [GameEntity(type: .kunoichi, faction: .enemies, atk: 30, agi: 15, hp: 500),
                 GameEntity(type: .ninja_peasant, faction: .enemies, atk: 20, agi: 10, hp: 300),
                 GameEntity(type: .ninja_monk, faction: .enemies, atk: 20, agi: 10, hp: 300)],
                
                // Amazons (2x)
                [GameEntity(type: .shield_amazon, faction: .enemies, atk: 30, agi: 15, hp: 500),
                 GameEntity(type: .spear_amazon, faction: .enemies, atk: 20, agi: 10, hp: 300)],
            ].randomElement()!
            case .extreme: return [
                // Witch & Pyromancer
                [GameEntity(type: .blonde_witch, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .dagger_pyromancer, faction: .enemies, atk: 10, agi: 5, hp: 150)],
                
                // Witch & Dwarf $ Amazon
                [GameEntity(type: .elf_witch, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .mace_dwarf, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .sword_amazon, faction: .enemies, atk: 20, agi: 10, hp: 300)],
            ].randomElement()!
            }
        case .cromlech:
            switch difficulty {
            case .easy: return [
                // Slimes
                [GameEntity(type: .red_slime, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .blue_slime, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .green_slime, faction: .enemies, atk: 10, agi: 5, hp: 150)],
                
                // Goblins
                [GameEntity(type: .ringblade_goblin, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .dagger_goblin, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .spear_goblin, faction: .enemies, atk: 10, agi: 5, hp: 150)]
            ].randomElement()!
            case .hard: return [
                // Ninjas
                [GameEntity(type: .kunoichi, faction: .enemies, atk: 30, agi: 15, hp: 500),
                 GameEntity(type: .ninja_peasant, faction: .enemies, atk: 20, agi: 10, hp: 300),
                 GameEntity(type: .ninja_monk, faction: .enemies, atk: 20, agi: 10, hp: 300)],
                
                // Amazons (2x)
                [GameEntity(type: .shield_amazon, faction: .enemies, atk: 30, agi: 15, hp: 500),
                 GameEntity(type: .spear_amazon, faction: .enemies, atk: 20, agi: 10, hp: 300)],
            ].randomElement()!
            case .extreme: return [
                // Witch & Pyromancer
                [GameEntity(type: .blonde_witch, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .dagger_pyromancer, faction: .enemies, atk: 10, agi: 5, hp: 150)],
                
                // Witch & Dwarf $ Amazon
                [GameEntity(type: .elf_witch, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .mace_dwarf, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .sword_amazon, faction: .enemies, atk: 20, agi: 10, hp: 300)],
            ].randomElement()!
            }
        case .graveyard:
            switch difficulty {
            case .easy: return [
                // Slimes
                [GameEntity(type: .red_slime, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .blue_slime, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .green_slime, faction: .enemies, atk: 10, agi: 5, hp: 150)],
                
                // Goblins
                [GameEntity(type: .ringblade_goblin, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .dagger_goblin, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .spear_goblin, faction: .enemies, atk: 10, agi: 5, hp: 150)]
            ].randomElement()!
            case .hard: return [
                // Ninjas
                [GameEntity(type: .kunoichi, faction: .enemies, atk: 30, agi: 15, hp: 500),
                 GameEntity(type: .ninja_peasant, faction: .enemies, atk: 20, agi: 10, hp: 300),
                 GameEntity(type: .ninja_monk, faction: .enemies, atk: 20, agi: 10, hp: 300)],
                
                // Amazons (2x)
                [GameEntity(type: .shield_amazon, faction: .enemies, atk: 30, agi: 15, hp: 500),
                 GameEntity(type: .spear_amazon, faction: .enemies, atk: 20, agi: 10, hp: 300)],
            ].randomElement()!
            case .extreme: return [
                // Witch & Pyromancer
                [GameEntity(type: .blonde_witch, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .dagger_pyromancer, faction: .enemies, atk: 10, agi: 5, hp: 150)],
                
                // Witch & Dwarf $ Amazon
                [GameEntity(type: .elf_witch, faction: .enemies, atk: 15, agi: 10, hp: 250),
                 GameEntity(type: .mace_dwarf, faction: .enemies, atk: 10, agi: 5, hp: 150),
                 GameEntity(type: .sword_amazon, faction: .enemies, atk: 20, agi: 10, hp: 300)],
            ].randomElement()!
            }
        }
    }
    
    static let easyForestDrops: [(ItemType, Double)] = [(.leaf, 0.70), (.sapling, 0.50), (.flower, 0.30)]
    static let hardForestDrops: [(ItemType, Double)] = [(.leaf, 0.80), (.sapling, 0.60), (.flower, 0.40), (.ladybug, 0.20)]
    static let extremeForestDrops: [(ItemType, Double)] = [(.leaf, 0.90), (.sapling, 0.70), (.flower, 0.50), (.ladybug, 0.30), (.mushroom, 0.10)]
    
    static let easyCastleDrops: [(ItemType, Double)] = [(.book, 0.70), (.scroll, 0.50), (.potion, 0.30)]
    static let hardCastleDrops: [(ItemType, Double)] = [(.book, 0.80), (.scroll, 0.60), (.potion, 0.40), (.cup, 0.20)]
    static let extremeCastleDrops: [(ItemType, Double)] = [(.book, 0.90), (.scroll, 0.70), (.potion, 0.50), (.cup, 0.30), (.mirror, 0.10)]
    
    static let easyCromlechDrops: [(ItemType, Double)] = [(.artefact, 0.70), (.gem, 0.50), (.ring, 0.30)]
    static let hardCromlechDrops: [(ItemType, Double)] = [(.artefact, 0.80), (.gem, 0.60), (.ring, 0.40), (.beaststone, 0.20)]
    static let extremeCromlechDrops: [(ItemType, Double)] = [(.artefact, 0.90), (.gem, 0.70), (.ring, 0.50), (.beaststone, 0.30), (.fairy, 0.10)]
    
    static let easyGraveyardDrops: [(ItemType, Double)] = [(.skull, 0.70), (.spine, 0.50), (.finger, 0.30)]
    static let hardGraveyardDrops: [(ItemType, Double)] = [(.skull, 0.80), (.spine, 0.60), (.finger, 0.40), (.eyes, 0.20)]
    static let extremeGraveyardDrops: [(ItemType, Double)] = [(.skull, 0.90), (.spine, 0.70), (.finger, 0.50), (.necklace, 0.30), (.eyes, 0.10)]
    
    static let locationMap: [LocationType: [Difficulty: Location]] = [
        .forest: [
            .easy: Location(type: .forest, difficulty: .easy, drops: easyForestDrops, gold: 50...150, xp: 100...300),
            .hard: Location(type: .forest, difficulty: .hard, drops: hardForestDrops, gold: 100...250, xp: 300...500),
            .extreme: Location(type: .forest, difficulty: .extreme, drops: extremeForestDrops, gold: 200...800, xp: 500...600)
        ],
        .castle: [
            .easy: Location(type: .castle, difficulty: .easy, drops: easyCastleDrops, gold: 700...1300, xp: 300...500),
            .hard: Location(type: .castle, difficulty: .hard, drops: hardCastleDrops, gold: 1200...1800, xp: 500...700),
            .extreme: Location(type: .castle, difficulty: .extreme, drops: extremeCastleDrops, gold: 1700...2300, xp: 700...900)
        ],
        .cromlech: [
            .easy: Location(type: .cromlech, difficulty: .easy, drops: easyCromlechDrops, gold: 2200...2800, xp: 900...1100),
            .hard: Location(type: .cromlech, difficulty: .hard, drops: hardCromlechDrops, gold: 2700...3300, xp: 1100...1300),
            .extreme: Location(type: .cromlech, difficulty: .extreme, drops: extremeCromlechDrops, gold: 3200...3800, xp: 1300...1500)
        ],
        .graveyard: [
            .easy: Location(type: .graveyard, difficulty: .easy, drops: easyGraveyardDrops, gold: 3700...4300, xp: 1500...1700),
            .hard: Location(type: .graveyard, difficulty: .hard, drops: hardGraveyardDrops, gold: 4200...5800, xp: 1700...1900),
            .extreme: Location(type: .graveyard, difficulty: .extreme, drops: extremeGraveyardDrops, gold: 5700...6300, xp: 1900...2100)
        ]
    ]
}
