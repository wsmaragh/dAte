//
//  ConfigurationHelper.swift
//  RecreateDemoCells
//
//  Created by C4Q on 4/4/18.
//  Copyright © 2018 Glo. All rights reserved.
//

import Foundation

internal func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}
