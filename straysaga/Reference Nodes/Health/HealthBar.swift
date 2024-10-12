//
//  HealthBar.swift
//  straysaga
//
//  Created by Petre Chkonia on 21.09.24.
//

import SpriteKit

class HealthBar: SKReferenceNode {
    
    private var base: SKNode!
    
    var corner1: SKSpriteNode!
    var bar: SKSpriteNode!
    var corner2: SKSpriteNode!
    
    convenience init() {
        self.init(fileNamed: "HealthBar")
        
        // Set up inner base shape
        base = childNode(withName: "//health_bar")
        base.setScale(0.5)
        
        corner1 = childNode(withName: "//health_bar_corner_1") as? SKSpriteNode
        bar = childNode(withName: "//health_bar_full") as? SKSpriteNode
        corner2 = childNode(withName: "//health_bar_corner_2") as? SKSpriteNode
    }
    
    override init(fileNamed fileName: String?) {
        super.init(fileNamed: fileName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
