//
//  TextItem.swift
//  AimyboxUILib
//
//  Created by Vladislav Popovich on 23.12.2019.
//  Copyright © Just Ai. All rights reserved.
//

import Foundation
import Aimybox

public extension AimyboxViewModel {
    
    class TextItem: AimyboxViewModelItem {
        
        public let type: AimyboxViewModelItemType
        
        public let rowCount: Int
        
        public let text: String
        
        public init(text reply: TextReply) {
            self.rowCount = 1
            self.type = .text
            self.text = reply.text
        }
        
        public init(_ text: String) {
            self.rowCount = 1
            self.type = .text
            self.text = text
        }
    }
}
