//
//  IdType.swift
//  Utils
//
//  Created by Volodymyr Pavliuk on 18.07.2021.
//  Copyright © 2021 Volodymyr Pavliuk. All rights reserved.
//

public protocol IdType: Hashable {
   associatedtype Value
   init(value: Value)
}
