//
//  Publisher+Additions.swift
//
//
//  Created by Vova on 30.01.2024.
//

import Combine

public extension Publisher {
   func asOptional() -> some Publisher<Output?, Failure> { map { $0 as Output? } }
}
