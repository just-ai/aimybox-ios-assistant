//
//  AimyboxViewModelItem.swift
//  AimyboxUILib
//
//  Created by Vladislav Popovich on 23.12.2019.
//  Copyright © 2019 NSI. All rights reserved.
//

import Foundation

public enum AimyboxViewModelItemType {
    case text
    case query
    case buttons
    case image
}

public protocol AimyboxViewModelItem {
    var type: AimyboxViewModelItemType { get }
    var rowCount: Int { get }
}
