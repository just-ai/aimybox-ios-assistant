//
//  ButtonsItem.swift
//  AimyboxUILib
//
//  Created by Vladislav Popovich on 23.12.2019.
//  Copyright © 2019 NSI. All rights reserved.
//

import Foundation
import AimyboxCore

public extension AimyboxViewModel {
    
    class ButtonsItem: AimyboxViewModelItem {
        
        public let type: AimyboxViewModelItemType
        
        public let rowCount: Int
        
        public let buttons: [Button]
        
        public let onButtonTap: (Button)->()
        
        public init(buttons reply: ButtonsReply, onButtonTap: @escaping (Button)->() = { button in print(String(describing: button.text)) }) {
            self.rowCount = 1
            self.type = .buttons
            self.buttons = reply.buttons
            self.onButtonTap = onButtonTap
        }
    }
}
