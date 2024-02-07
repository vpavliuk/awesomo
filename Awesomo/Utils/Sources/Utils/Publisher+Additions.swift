//
//  Publisher+Additions.swift
//
//
//  Created by Vova on 30.01.2024.
//

import Combine

public extension Publisher {
   func asOptional() -> some Publisher<Output?, Failure> { map { $0 as Output? } }

   func concatenate(_ other: some Publisher<Output, Failure>) -> some Publisher<Output, Failure> {
      Publishers.Concatenate(prefix: self, suffix: other)
   }
}
