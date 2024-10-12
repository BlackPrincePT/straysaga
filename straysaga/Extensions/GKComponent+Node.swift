//
//  GKComponent+Node.swift
//  straysaga
//
//  Created by Petre Chkonia on 18.09.24.
//

import GameplayKit

extension GKComponent {
    
    var componentNode: SKNode {
        
        if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
            return node
            
        }  else if let node = entity?.component(ofType: RenderComponent.self)?.spriteNode {
            return node
        }
        
        return SKNode()
    }
}
