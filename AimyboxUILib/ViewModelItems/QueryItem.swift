//
//  QueryItem.swift
//  AimyboxUILib
//
//  Created by Vladislav Popovich on 23.12.2019.
//  Copyright © 2019 NSI. All rights reserved.
//

import AimyboxCore

public extension AimyboxViewModel {

    class QueryItem: AimyboxViewModelItem {
        
        public let type: AimyboxViewModelItemType
        
        public let rowCount: Int
        
        public var text: String
        
        public init(text query: String) {
            self.rowCount = 1
            self.type = .query
            self.text = query
        }
    }
}
