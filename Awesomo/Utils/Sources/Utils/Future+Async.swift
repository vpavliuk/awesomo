//
//  Future+Async.swift
//
//
//  Created by Vova on 29.01.2024.
//

import Combine

public extension Future {
   convenience init(operation: @escaping () async -> Output) {
      self.init { promise in
         Task {
            let output = await operation()
            promise(.success(output))
         }
      }
   }
}
