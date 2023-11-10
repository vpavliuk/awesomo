//
//  Sequence+KeyPathSorting.swift
//  Domain
//
//  Created by Vova on 06.11.2023.
//

extension Sequence {

   public func sorted<Value>(
      by keyPath: KeyPath<Element, Value>,
      using valuesAreInIncreasingOrder: (Value, Value) throws -> Bool
   ) rethrows -> [Element] {
      try sorted {
         try valuesAreInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
      }
   }

   public func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
      sorted(by: keyPath, using: <=)
   }
}
