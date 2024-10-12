//
//  Location.swift
//  straysaga
//
//  Created by Petre Chkonia on 06.10.24.
//

import SpriteKit

class Location {
    let type: LocationType
    let difficulty: Difficulty
    
    let battleground: SKTexture
    
    let drops: [(type: ItemType, rate: Double)]
    
    let gold: ClosedRange<Int>
    let xp: ClosedRange<Int>
    
    func loot() -> [ItemType: Int] {
        
        var loot: [ItemType: Int] = [:]
        
        for (type, rate) in drops {
            let randomDouble = Double.random(in: 0...1)
            if rate >= randomDouble {
                loot[type] = 1
            }
        }
        
        return loot
    }
    
    init(type: LocationType, difficulty: Difficulty,
         drops: [(ItemType, Double)], gold: ClosedRange<Int>, xp: ClosedRange<Int>) {
        
        self.battleground = SKTexture(imageNamed: "battleground_\(type)")
        
        self.type = type
        self.difficulty = difficulty
        
        self.drops = drops
        self.gold = gold
        self.xp = xp
    }
}
