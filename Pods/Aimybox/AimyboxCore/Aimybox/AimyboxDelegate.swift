//
//  Utils.swift
//  AimyboxCore
//
//  Created by Vladyslav Popovych on 30.11.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import Foundation

public
protocol AimyboxDelegate: SpeechToTextDelegate, TextToSpeechDelegate, DialogAPIDelegate {
    /**
    Called before new state is set. Optional.
    */
    func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: AimyboxState, to newState: AimyboxState)

}

/**
All methods listed here are optional for delegates to implement.
*/
public
extension AimyboxDelegate {

    func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: AimyboxState, to newState: AimyboxState) {}

}
