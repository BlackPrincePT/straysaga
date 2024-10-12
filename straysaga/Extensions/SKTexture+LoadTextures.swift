//
//  SKTexture+LoadTextures.swift
//  straysaga
//
//  Created by Petre Chkonia on 17.09.24.
//

import SpriteKit

extension SKTexture {
    
    static func loadTextures(atlas: String, prefix: String, startsAt: Int = 1) -> [SKTexture] {
        
        var textureArray = [SKTexture]()
        
        let textureAtlas = SKTextureAtlas(named: atlas)
        
        for i in startsAt...textureAtlas.textureNames.count {
            
            let textureName = "\(prefix)\(i)"
            
            let temp = textureAtlas.textureNamed(textureName)
            
            textureArray.append(temp)
        }
        
        return textureArray
    }
    
    static func loadTextures(sheet: String) -> [SKTexture] {
        
        var textureArray = [SKTexture]()
        
        let textureSheet = SKTexture(imageNamed: sheet)
        
        let frameCount: CGFloat = textureSheet.size().width / textureSheet.size().height
        
        let frameWidth = 1.0 / frameCount
        
        for x in 0..<Int(frameCount) {
            let texture = SKTexture(rect: CGRect(x: CGFloat(x) * frameWidth, y: 0, width: frameWidth, height: 1.0),
                                    in: textureSheet)
            
            textureArray.append(texture)
        }
        
        
        return textureArray
    }
}
