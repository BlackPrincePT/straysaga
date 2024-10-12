//
//  SKScene+ViewProperties.swift
//  straysaga
//
//  Created by Petre Chkonia on 18.09.24.
//

import SpriteKit

extension SKScene {
    
    var viewTop: CGFloat {
        return convertPoint(fromView: CGPoint(x: 0.0, y: 0.0)).y
    }
    
    var viewBottom: CGFloat {
        guard let view = view else { return 0.0 }
        return convertPoint(fromView: CGPoint(x: 0.0, y: view.bounds.size.height)).y
    }
    
    var viewLeft: CGFloat {
        return convertPoint(fromView: CGPoint(x: 0.0, y: 0.0)).x
    }
    
    var viewRight: CGFloat {
        guard let view = view else { return 0.0 }
        return convertPoint(fromView: CGPoint(x: view.bounds.size.width, y: 0.0)).x
    }
    
    var insets: UIEdgeInsets {
        return UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
    }
}
