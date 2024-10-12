//
//  BattleStates.swift
//  straysaga
//
//  Created by Petre Chkonia on 28.09.24.
//

import GameplayKit

class InProgressState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == InProgressState.self || stateClass == IdleState.self
    }
}

class IdleState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == InProgressState.self || stateClass == IdleState.self
    }
}

class ManualPlayingState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == AutoPlayingState.self
    }
}

class AutoPlayingState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ManualPlayingState.self
    }
}
